ckpt_path="$1"
shift
ckpt_dir=$(ls -td lightning_logs/* | tac | tail -n1)/checkpoints
ckpt=$(ls $ckpt_dir/performance-*.ckpt)
ckpt=$(ls $(ls -td lightning_logs/* | tac | tail -n1)/checkpoints/performance-*.ckpt)
PYTHONPATH="." python code_gnn/main_cli.py test --config configs/config_bigvul.yaml --config configs/config_ggnn.yaml --trainer.accelerator cpu --data.sample_mode True --verbose true --ckpt_path bigvul_sample.ckpt
PYTHONPATH="." python code_gnn/main_cli.py test --config configs/config_sard.yaml --config configs/config_ggnn.yaml --trainer.accelerator cpu --data.sample_mode True --verbose true --ckpt_path sard_sample.ckpt



PYTHONPATH="." python code_gnn/main_cli.py test --config configs/config_double_free.yaml --config configs/config_ggnn.yaml --trainer.accelerator cpu --ckpt_path sard_sample.ckpt
