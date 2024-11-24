import argparse
import json
import sastvd as svd
import sastvd.helpers.datasets as svdd
import sastvd.helpers.evaluate as ivde


def bigvul():
    """Run preperation scripts for BigVul dataset."""
    print(svdd.bigvul(sample=args.sample))
    ivde.get_dep_add_lines_bigvul("bigvul", sample=args.sample)
    # svdglove.generate_glove("bigvul", sample=args.sample)
    # svdd2v.generate_d2v("bigvul", sample=args.sample)
    print("success")


def devign():
    raise NotImplementedError
    print(svdd.devign(sample=args.sample))
    ivde.get_dep_add_lines("devign", sample=args.sample)
    svdglove.generate_glove("devign", sample=args.sample)
    svdd2v.generate_d2v("devign", sample=args.sample)
    print("success")

def sard():
    print(svdd.sard(sample=args.sample))
    # ivde.get_dep_add_lines("sard", sample=args.sample)
    # svdglove.generate_glove("devign", sample=args.sample)
    # svdd2v.generate_d2v("devign", sample=args.sample)
    print("success")

def feat(feat_name):
    print(svdd.feat(feat_name, sample=args.sample))
    # ivde.get_dep_add_lines("sard", sample=args.sample)
    # svdglove.generate_glove("devign", sample=args.sample)
    # svdd2v.generate_d2v("devign", sample=args.sample)
    print("success")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Prepare master dataframe")
    parser.add_argument("--sample", action="store_true", help="Extract a sample only")
    parser.add_argument("--global_workers", type=int, help="Number of workers to use")
    parser.add_argument("--dataset")
    args = parser.parse_args()

    if args.global_workers is not None:
        svd.DFMP_WORKERS = args.global_workers

    with open(svd.external_dir() / "feature_list.json", "r") as rfi:
        feature_list = json.load(rfi)
    if args.dataset == "bigvul":
        bigvul()
    elif args.dataset == "devign":
        devign()
    elif args.dataset == "sard":
        sard()
    elif args.dataset in feature_list["VF"] + feature_list["GSF"]:
        feat(args.dataset)
