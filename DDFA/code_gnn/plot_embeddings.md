# DeepDFA Graph Embedding Visualization

Run `plot_embeddings.py` from the `DDFA` directory in the same environment and
code checkout used to train the checkpoint (including its compatibility fixes).
Only load checkpoints you trust. The script imports the existing model and
dataset classes; it does not train, change the checkpoint, or rerun preprocessing.

```bash
cd /workspace/DeepDFACopy/DDFA
PYTHONPATH="." python -u code_gnn/plot_embeddings.py \
  lightning_logs/version_0/checkpoints/YOUR_CHECKPOINT.ckpt \
  --dsname ffmpeg_qemu \
  --partition test \
  --device cpu \
  --output plots/DeepDFA_ffmpeg_qemu \
  --no-show
```

Use `--device cuda:0` for a working PyTorch/DGL GPU installation. Optional
`--max-samples 2000` caps extraction before the plotting half-sample; at least
62 retained graphs are needed. This cap does not limit memory used by the existing
dataset loader, which loads graph/feature artifacts before selecting examples.
Silhouette scoring can be slow for large samples.

The checkpoint's data module metadata supplies the feature specification, split
scheme, data split seed, and sample mode. Model hyperparameters supply the encoder
architecture and whether all four abstract-dataflow features are concatenated.
For older checkpoints without data module metadata, supply `--dsname`; the
fallback split is `fixed`, data split seed is 0, and sample mode is off. Override
these with `--split`, `--split-seed`, or `--sample` to match training. Sample mode
requires `--partition all` because the repository bypasses partitioning in that
mode. `--seed` controls visualization sampling, not the saved train/test split.

The prepared Parquet, split manifest, dataset registration, validity cache,
per-function node-file presence checks, `nodes.csv`, `graphs.bin`, and matching
node-feature CSVs are required exactly as for training. Do not rebuild feature
vocabularies or change splits for the visualization. The source CSV alone is not
enough. Use the checkpoint's dataset unless intentionally evaluating another
dataset with the same feature vocabulary.

The script strictly restores the complete model, then switches its existing
`encoder_mode` on. This returns the attention-pooled graph vector immediately
before `output_layer`, not classifier logits or probabilities. Labels match
training: the maximum `_VULN` value across each graph's nodes.

The visualization follows the supplied DeepWuKong procedure:

- Extract one graph at a time, then randomly retain half for plotting.
- Use `TSNE(n_components=2, init="pca", random_state=0)` (default perplexity 30).
- Normalize each coordinate dimension to `[0, 1]`; both axes use these limits.
- Use an 11.7 by 8.27 inch Seaborn-styled figure, black `o` for label 0 and
  `plt.cm.Set1(0)` red `+` for label 1, bold size-9 text, and a blank title.
- Compute true-label Euclidean silhouette scores before and after projection.

Unlike the reference's unseeded half-split, half-sampling uses `--seed` (default
7) for reproducibility. It remains unstratified. DGL replaces PyTorch Geometric
only for model-specific graph loading; NumPy, PyTorch, scikit-learn, Matplotlib,
Seaborn and tqdm retain their roles. Defaults may vary across library versions.

Outputs use the `--output` prefix:

- `-embeddings.npz`: all extracted vectors, labels, graph IDs and run metadata.
- `-tsne-features.json`: `[coordinates, labels]` for the plotted half.
- `-tsne-ids.json`: graph IDs aligned with those coordinates.
- `-silhouette.json`: scores and sampled class counts.
- `.pdf`: the plot.

Neither silhouette nor visual cluster separation is prediction accuracy.
t-SNE and per-axis normalization alter distances, so the projected score is not
equivalent to the original-embedding score.
