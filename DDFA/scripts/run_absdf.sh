#!/bin/bash
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --mem 16G
#SBATCH --time=1-00:00:00
#SBATCH --output=logs/dbize.log
#SBATCH --error=logs/dbize.log
#SBATCH --job-name="dbize"

source activate.sh

python -u sastvd/scripts/dbize_absdf.py $@
PYTHONPATH="." python -u sastvd/scripts/dbize_absdf.py --sample
PYTHONPATH="." python -u sastvd/scripts/dbize_absdf.py --dsname sard --sample
PYTHONPATH="." python -u sastvd/scripts/dbize_absdf.py --dsname sard

PYTHONPATH="." python -u sastvd/scripts/dbize_absdf.py --dsname devign

PYTHONPATH="." python -u sastvd/scripts/dbize_absdf.py