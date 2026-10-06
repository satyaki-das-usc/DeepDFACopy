"""Plot graph embeddings from a trusted DeepDFA GGNN checkpoint.

Run from DDFA with PYTHONPATH="." in the environment used for training.
Uses the existing prepared dataset, split manifest, graphs and node features.
"""

import argparse
import json
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
import torch
from sklearn import config_context
from sklearn.manifold import TSNE
from sklearn.metrics import silhouette_score
from sklearn.model_selection import train_test_split
from tqdm import tqdm


def calculate_silhouette(features, labels):
    """Bound distance-chunk memory, not total RAM or quadratic runtime."""
    n_labels = len(np.unique(labels))
    if not 2 <= n_labels < len(labels):
        return {"score": None,
                "reason": "Requires between 2 and n_samples - 1 distinct labels"}
    if not np.isfinite(features).all():
        return {"score": None, "reason": "Features contain non-finite values"}
    with config_context(working_memory=128):
        score = silhouette_score(features, labels, metric="euclidean")
    return {"score": float(score), "reason": None}


def plot_embedding(features, labels, graph_ids, output, seed, show=True):
    """Match the supplied half-sample, projection, colors and [0, 1] axes."""
    sns.set(rc={"figure.figsize": (11.7, 8.27)})
    selected, _ = train_test_split(
        np.arange(len(features)), test_size=0.5, random_state=seed
    )
    X, Y = features[selected], labels[selected]
    if len(X) <= 30 or X.shape[1] < 2:
        raise ValueError("t-SNE requires over 30 sampled rows and at least 2 features")
    if not np.isfinite(X).all():
        raise ValueError("Embeddings contain non-finite values")

    print("Calculating original-embedding silhouette score...")
    original_score = calculate_silhouette(X, Y)
    print("Fitting TSNE!")
    X = TSNE(n_components=2, init="pca", random_state=0).fit_transform(X)
    x_min, x_max = np.min(X, axis=0), np.max(X, axis=0)
    span = x_max - x_min
    if not np.isfinite(X).all() or np.any(span == 0):
        raise ValueError("Cannot normalize non-finite or constant t-SNE coordinates")
    X = (X - x_min) / span

    with open(str(output) + "-tsne-features.json", "w", encoding="utf-8") as f:
        json.dump([X.tolist(), Y.tolist()], f, allow_nan=False)
    with open(str(output) + "-tsne-ids.json", "w", encoding="utf-8") as f:
        json.dump(graph_ids[selected].tolist(), f)
    scores = {
        "metric": "euclidean",
        "labels": "ground_truth",
        "n_samples": len(Y),
        "sampling_seed": seed,
        "tsne_random_state": 0,
        "class_counts": {str(int(label)): int(np.sum(Y == label))
                         for label in np.unique(Y)},
        "original_embeddings": original_score,
        "normalized_tsne": calculate_silhouette(X, Y),
    }
    with open(str(output) + "-silhouette.json", "w", encoding="utf-8") as f:
        json.dump(scores, f, indent=2, allow_nan=False)
    for space in ("original_embeddings", "normalized_tsne"):
        print(f"Silhouette ({space}): {scores[space]}")

    fig, ax = plt.subplots()
    for point, label in zip(X, Y):
        ax.text(point[0], point[1], "o" if label == 0 else "+",
                color="black" if label == 0 else plt.cm.Set1(0),
                fontdict={"weight": "bold", "size": 9})
    # Text artists do not autoscale axes in the original script either.
    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    ax.set_title("")
    fig.savefig(str(output) + ".pdf")
    if show:
        plt.show()
    plt.close(fig)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("checkpoint", help="Trusted training .ckpt file")
    parser.add_argument("--dsname", help="Defaults to checkpoint's data module metadata")
    parser.add_argument("--partition", choices=["train", "val", "test", "all"],
                        default="test")
    parser.add_argument("--split", help="Override saved split scheme, normally fixed")
    parser.add_argument("--split-seed", type=int, help="Override saved data split seed")
    parser.add_argument("--sample", action="store_true", default=None,
                        help="Use _sample artifacts; requires --partition all")
    parser.add_argument("--output", default="plots/DeepDFA")
    parser.add_argument("--max-samples", type=int, default=None,
                        help="Cap graphs before the plotting half-sample")
    parser.add_argument("--seed", type=int, default=7)
    parser.add_argument("--device", default="cpu", help="cpu or cuda:0")
    parser.add_argument("--no-show", action="store_true", help="Save PDF without opening a window")
    args = parser.parse_args()
    if args.max_samples is not None and args.max_samples < 62:
        parser.error("--max-samples must be at least 62 for perplexity 30")

    # Import the actual model, including any compatibility fixes used to train it.
    import dgl
    from code_gnn.models.flow_gnn.ggnn import FlowGNNGGNNModule
    from sastvd.linevd.dataset import BigVulDatasetLineVD

    torch.manual_seed(args.seed)
    dgl.seed(args.seed)
    # Checkpoints may contain pickled configuration; load only trusted files.
    checkpoint = torch.load(args.checkpoint, map_location="cpu", weights_only=False)
    hparams = dict(checkpoint["hyper_parameters"])
    data = dict(checkpoint.get("datamodule_hyper_parameters", {}))
    dsname = args.dsname or data.get("dsname")
    if not dsname:
        parser.error("Checkpoint has no dataset name; supply --dsname")
    if hparams.get("label_style", "graph") != "graph":
        parser.error("This visualization requires a graph-classification checkpoint")
    if hparams.get("encoder_mode", False):
        parser.error("Expected a full training checkpoint, not an encoder-only checkpoint")

    # Load classifier weights too, then bypass it using the model's own forward.
    model = FlowGNNGGNNModule(**hparams)
    model.load_state_dict(checkpoint["state_dict"], strict=True)
    model.hparams.encoder_mode = True
    model.to(args.device).eval()
    del checkpoint

    sample_mode = data.get("sample_mode", False) if args.sample is None else args.sample
    if sample_mode and args.partition != "all":
        parser.error("Sample mode bypasses dataset partitioning; use --partition all")
    feat = data.get("feat", hparams.get("feat"))
    if feat is None:
        parser.error("Checkpoint is missing the feature specification")
    dataset = BigVulDatasetLineVD(
        dsname=dsname,
        partition=args.partition,
        feat=feat,
        gtype=data.get("gtype", "cfg"),
        label_style="graph",
        concat_all_absdf=hparams.get("concat_all_absdf", False),
        split=args.split or data.get("split", "fixed"),
        seed=args.split_seed if args.split_seed is not None else data.get("seed", 0),
        sample_mode=sample_mode,
        sample=data.get("sample", -1),
        undersample=None,
        oversample=None,
    )
    indices = np.arange(len(dataset))
    if args.max_samples is not None and len(indices) > args.max_samples:
        indices = np.random.default_rng(args.seed).choice(
            indices, size=args.max_samples, replace=False
        )
    if len(indices) < 62:
        parser.error("At least 62 retained graphs are required for the half-sample t-SNE")

    features, labels, graph_ids = [], [], []
    with torch.inference_mode():
        for index in tqdm(indices, desc="Extracting graph embeddings"):
            graph_id, graph, extrafeats = dataset[int(index)]
            if graph.num_nodes() == 0:
                raise ValueError(f"Cannot embed an empty graph: {graph_id}")
            # Match BaseModule.get_label(): graph label is max node vulnerability.
            node_labels = graph.ndata["_VULN"]
            if not torch.all((node_labels == 0) | (node_labels == 1)).item():
                raise ValueError(f"Invalid node labels in graph {graph_id}")
            labels.append(int(node_labels.max().item()))
            batch = dgl.batch([graph]).to(args.device)
            embedding = model(batch, extrafeats)
            if embedding.ndim != 2 or embedding.shape[0] != 1:
                raise ValueError(f"Expected one graph embedding, got {embedding.shape}")
            features.append(embedding.cpu().numpy().copy()[0])
            graph_ids.append(int(graph_id))
            del batch, embedding

    features, labels = np.asarray(features), np.asarray(labels)
    graph_ids = np.asarray(graph_ids)
    if not np.isfinite(features).all():
        raise ValueError("Extracted embeddings contain non-finite values")
    output = Path(args.output)
    output.parent.mkdir(parents=True, exist_ok=True)
    np.savez_compressed(str(output) + "-embeddings.npz", features=features,
                        labels=labels, graph_ids=graph_ids, dataset=dsname,
                        partition=args.partition, checkpoint=str(args.checkpoint))
    print(f"Extracted {features.shape[0]} embeddings of dimension {features.shape[1]}")
    plot_embedding(features, labels, graph_ids, output, args.seed, show=not args.no_show)
    print(f"Saved embeddings, coordinates, IDs, scores and PDF under {output.parent}")


if __name__ == "__main__":
    main()
