#!/bin/bash
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --mem 16G
#SBATCH --time=1-00:00:00
#SBATCH --output=logs/absdf.log
#SBATCH --error=logs/absdf.log
#SBATCH --job-name="absdf"

source activate.sh

set -e

PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --workers 8 --no-cache --stage 1 --sample $@
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --dsname sard --workers 8 --no-cache --stage 1 --sample $@
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --workers 16 --no-cache --stage 1
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --dsname sard --workers 8 --no-cache --stage 1

PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --dsname devign --workers 24 --no-cache --stage 1

PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --workers 8 --no-cache --stage 2 --sample $@
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py  --dsname sard --workers 8 --no-cache --stage 2 --sample $@
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --workers 16 --no-cache --stage 2 $@
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --workers 8 --cache --stage 2 --sample $@
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py  --dsname sard --workers 8 --cache --stage 2 --sample $@
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py  --dsname sard --workers 8 --cache --stage 2


PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py  --dsname devign --workers 24 --cache --stage 2


PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --workers 24 --cache --stage 2 $@
