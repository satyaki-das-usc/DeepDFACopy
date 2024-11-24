#!/bin/bash
#SBATCH -N 1
#SBATCH -n 12
#SBATCH --time=1-00:00:00
#SBATCH --mem=16GB
#SBATCH --err="logs/prepare.out"
#SBATCH --output="logs/prepare.out"
#SBATCH --job-name="prepare"

source activate.sh

# Start singularity instance
python -u sastvd/scripts/prepare.py --dataset bigvul --global_workers 12 $@
PYTHONPATH="." python -u sastvd/scripts/prepare.py --dataset bigvul --global_workers 12 --sample
PYTHONPATH="." python -u sastvd/scripts/prepare.py --dataset sard --global_workers 12 --sample

PYTHONPATH="." python -u sastvd/scripts/prepare.py --dataset devign --global_workers 12

PYTHONPATH="." python -u sastvd/scripts/prepare.py --dataset incorr_calc_buff_size --global_workers 12
PYTHONPATH="." python -u sastvd/scripts/prepare.py --dataset buff_access_src_size --global_workers 12
PYTHONPATH="." python -u sastvd/scripts/prepare.py --dataset off_by_one --global_workers 12
PYTHONPATH="." python -u sastvd/scripts/prepare.py --dataset buff_overread --global_workers 12
PYTHONPATH="." python -u sastvd/scripts/prepare.py --dataset double_free --global_workers 12
PYTHONPATH="." python -u sastvd/scripts/prepare.py --dataset use_after_free --global_workers 12
PYTHONPATH="." python -u sastvd/scripts/prepare.py --dataset buff_underwrite --global_workers 12
PYTHONPATH="." python -u sastvd/scripts/prepare.py --dataset buff_underread --global_workers 12
PYTHONPATH="." python -u sastvd/scripts/prepare.py --dataset sensi_read --global_workers 12
PYTHONPATH="." python -u sastvd/scripts/prepare.py --dataset sensi_write --global_workers 12

PYTHONPATH="." python -u sastvd/scripts/prepare.py --dataset node_set --global_workers 12
PYTHONPATH="." python -u sastvd/scripts/prepare.py --dataset edge_set --global_workers 12
