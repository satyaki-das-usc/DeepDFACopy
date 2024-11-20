#!/bin/bash
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --mem 16G
#SBATCH --time=1-00:00:00
#SBATCH --output=logs/dbize.log
#SBATCH --error=logs/dbize.log
#SBATCH --job-name="dbize"

source activate.sh

set -e

python -u sastvd/scripts/dbize.py $@
PYTHONPATH="." python -u sastvd/scripts/dbize.py --sample
PYTHONPATH="." python -u sastvd/scripts/dbize.py --dsname sard --sample
python -u sastvd/scripts/dbize_graphs.py $@
PYTHONPATH="." python -u sastvd/scripts/dbize_graphs.py --sample
PYTHONPATH="." python -u sastvd/scripts/dbize_graphs.py --dsname sard --sample
