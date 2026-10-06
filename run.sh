#!/bin/bash
set -e

pip install -r requirements.txt

PYTHONPATH="." python -u sastvd/scripts/getgraphs.py bigvul --sess --workers 32
PYTHONPATH="." python -u sastvd/scripts/dbize.py --dsname bigvul
PYTHONPATH="." python -u sastvd/scripts/dbize_graphs.py --dsname bigvul
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --dsname bigvul --workers 32 --no-cache --stage 1
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py  --dsname bigvul --workers 32 --no-cache --stage 2
PYTHONPATH="." python -u sastvd/scripts/dbize_absdf.py --dsname bigvul
PYTHONPATH="." python code_gnn/main_cli.py fit --config configs/config_bigvul.yaml --config configs/config_ggnn.yaml --trainer.accelerator gpu --seed_everything 1 --trainer.devices 1

PYTHONPATH="." python -u sastvd/scripts/getgraphs.py ffmpeg_qemu --sess --workers 32
PYTHONPATH="." python -u sastvd/scripts/dbize.py --dsname ffmpeg_qemu
PYTHONPATH="." python -u sastvd/scripts/dbize_graphs.py --dsname ffmpeg_qemu
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --dsname ffmpeg_qemu --workers 32 --no-cache --stage 1
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py  --dsname ffmpeg_qemu --workers 32 --no-cache --stage 2
PYTHONPATH="." python -u sastvd/scripts/dbize_absdf.py --dsname ffmpeg_qemu
PYTHONPATH="." python code_gnn/main_cli.py fit --config configs/config_ffmpeg_qemu.yaml --config configs/config_ggnn.yaml --trainer.accelerator gpu --seed_everything 1 --trainer.devices 1
PYTHONPATH="." python -u code_gnn/plot_embeddings.py checkpoints/ffmpeg_qemu_seed1/best-val-f1.ckpt --dsname ffmpeg_qemu --partition test --device cuda:0 --output plots/DeepDFA_ffmpeg_qemu_best_f1 --no-show