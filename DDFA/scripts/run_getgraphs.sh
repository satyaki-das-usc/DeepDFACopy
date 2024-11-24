#!/bin/bash
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --time=1-00:00:00
#SBATCH --mem=32GB
#SBATCH --array=0-99%10
#SBATCH --err="logs/getgraphs_%A_%a.out"
#SBATCH --output="logs/getgraphs_%A_%a.out"
#SBATCH --job-name="getgraphs"

source activate.sh

if [ ! -z "$SLURM_ARRAY_TASK_ID"]
then
    jan="--job_array_number $SLURM_ARRAY_TASK_ID"
else
    jan=""
fi

# Start singularity instance
python -u sastvd/scripts/getgraphs.py bigvul --sess $jan --num_jobs 100 --overwrite $@

PYTHONPATH="." python -u sastvd/scripts/getgraphs.py bigvul --sess --workers 24
PYTHONPATH="." python -u sastvd/scripts/getgraphs.py sard --sess --workers 24

PYTHONPATH="." python -u sastvd/scripts/getgraphs.py devign --sess --workers 24

PYTHONPATH="." python -u sastvd/scripts/getgraphs.py sard --sess --file_only --sample
PYTHONPATH="." python -u sastvd/scripts/getgraphs.py sard --sess --sample


PYTHONPATH="." python -u sastvd/scripts/getgraphs.py incorr_calc_buff_size --sess
PYTHONPATH="." python -u sastvd/scripts/getgraphs.py buff_access_src_size --sess
PYTHONPATH="." python -u sastvd/scripts/getgraphs.py off_by_one --sess
PYTHONPATH="." python -u sastvd/scripts/getgraphs.py buff_overread --sess
PYTHONPATH="." python -u sastvd/scripts/getgraphs.py double_free --sess
PYTHONPATH="." python -u sastvd/scripts/getgraphs.py use_after_free --sess
PYTHONPATH="." python -u sastvd/scripts/getgraphs.py buff_underwrite --sess
PYTHONPATH="." python -u sastvd/scripts/getgraphs.py buff_underread --sess
PYTHONPATH="." python -u sastvd/scripts/getgraphs.py sensi_read --sess
PYTHONPATH="." python -u sastvd/scripts/getgraphs.py sensi_write --sess
