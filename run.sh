#!/bin/bash
set -e

pip install -r requirements.txt

PYTHONPATH="." python -u sastvd/scripts/getgraphs.py bigvul --sess --workers 32
PYTHONPATH="." python -u sastvd/scripts/dbize.py --dsname bigvul
PYTHONPATH="." python -u sastvd/scripts/dbize_graphs.py --dsname bigvul
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --dsname bigvul --workers 32 --no-cache --stage 1
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py  --dsname bigvul --workers 32 --no-cache --stage 2
PYTHONPATH="." python -u sastvd/scripts/dbize_absdf.py --dsname bigvul

PYTHONPATH="." python -u sastvd/scripts/getgraphs.py ffmpeg_qemu --sess --workers 32
PYTHONPATH="." python -u sastvd/scripts/dbize.py --dsname ffmpeg_qemu
PYTHONPATH="." python -u sastvd/scripts/dbize_graphs.py --dsname ffmpeg_qemu
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --dsname ffmpeg_qemu --workers 32 --no-cache --stage 1
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py  --dsname ffmpeg_qemu --workers 32 --no-cache --stage 2
PYTHONPATH="." python -u sastvd/scripts/dbize_absdf.py --dsname ffmpeg_qemu