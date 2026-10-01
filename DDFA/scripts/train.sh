python code_gnn/main_cli.py fit --config configs/config_bigvul.yaml --config configs/config_ggnn.yaml $@
PYTHONPATH="." python code_gnn/main_cli.py fit --config configs/config_bigvul.yaml --config configs/config_ggnn.yaml --trainer.accelerator cpu --seed_everything 1 --data.sample_mode True
PYTHONPATH="." python code_gnn/main_cli.py fit --config configs/config_sard.yaml --config configs/config_ggnn.yaml --trainer.accelerator cpu --seed_everything 1

PYTHONPATH="." python code_gnn/main_cli.py fit --config configs/config_bigvul.yaml --config configs/config_ggnn.yaml --trainer.accelerator gpu --seed_everything 1 --trainer.devices 1
PYTHONPATH="." python code_gnn/main_cli.py fit --config configs/config_ffmpeg_qemu.yaml --config configs/config_ggnn.yaml --trainer.accelerator gpu --seed_everything 1 --trainer.devices 1
PYTHONPATH="." python code_gnn/main_cli.py fit --config configs/config_reposvul.yaml --config configs/config_ggnn.yaml --trainer.accelerator gpu --seed_everything 1 --trainer.devices 1
