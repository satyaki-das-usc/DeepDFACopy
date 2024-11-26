OUTPUT_DIR="storage/output"

if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR"
fi

PYTHONPATH="." python code_gnn/main_cli.py test --config configs/config_sard.yaml --config configs/config_ggnn.yaml --ckpt_path sard.ckpt
mv pred_mapping.csv $OUTPUT_DIR/sard_pred_mapping.csv
PYTHONPATH="." python code_gnn/main_cli.py test --config configs/config_incorr_calc_buff_size.yaml --config configs/config_ggnn.yaml --ckpt_path sard.ckpt
mv pred_mapping.csv $OUTPUT_DIR/incorr_calc_buff_size_pred_mapping.csv
PYTHONPATH="." python code_gnn/main_cli.py test --config configs/config_buff_access_src_size.yaml --config configs/config_ggnn.yaml --ckpt_path sard.ckpt
mv pred_mapping.csv $OUTPUT_DIR/buff_access_src_size_pred_mapping.csv
PYTHONPATH="." python code_gnn/main_cli.py test --config configs/config_off_by_one.yaml --config configs/config_ggnn.yaml --ckpt_path sard.ckpt
mv pred_mapping.csv $OUTPUT_DIR/off_by_one_pred_mapping.csv
PYTHONPATH="." python code_gnn/main_cli.py test --config configs/config_buff_overread.yaml --config configs/config_ggnn.yaml --ckpt_path sard.ckpt
mv pred_mapping.csv $OUTPUT_DIR/buff_overread_pred_mapping.csv
PYTHONPATH="." python code_gnn/main_cli.py test --config configs/config_double_free.yaml --config configs/config_ggnn.yaml --ckpt_path sard.ckpt
mv pred_mapping.csv $OUTPUT_DIR/double_free_pred_mapping.csv
PYTHONPATH="." python code_gnn/main_cli.py test --config configs/config_use_after_free.yaml --config configs/config_ggnn.yaml --ckpt_path sard.ckpt
mv pred_mapping.csv $OUTPUT_DIR/use_after_free_pred_mapping.csv
PYTHONPATH="." python code_gnn/main_cli.py test --config configs/config_buff_underwrite.yaml --config configs/config_ggnn.yaml --ckpt_path sard.ckpt
mv pred_mapping.csv $OUTPUT_DIR/buff_underwrite_pred_mapping.csv
PYTHONPATH="." python code_gnn/main_cli.py test --config configs/config_buff_underread.yaml --config configs/config_ggnn.yaml --ckpt_path sard.ckpt
mv pred_mapping.csv $OUTPUT_DIR/buff_underread_pred_mapping.csv
PYTHONPATH="." python code_gnn/main_cli.py test --config configs/config_sensi_read.yaml --config configs/config_ggnn.yaml --ckpt_path sard.ckpt
mv pred_mapping.csv $OUTPUT_DIR/sensi_read_pred_mapping.csv
PYTHONPATH="." python code_gnn/main_cli.py test --config configs/config_sensi_write.yaml --config configs/config_ggnn.yaml --ckpt_path sard.ckpt
mv pred_mapping.csv $OUTPUT_DIR/sensi_write_pred_mapping.csv
PYTHONPATH="." python code_gnn/main_cli.py test --config configs/config_node_set.yaml --config configs/config_ggnn.yaml --ckpt_path sard.ckpt
mv pred_mapping.csv $OUTPUT_DIR/node_set_pred_mapping.csv
PYTHONPATH="." python code_gnn/main_cli.py test --config configs/config_edge_set.yaml --config configs/config_ggnn.yaml --ckpt_path sard.ckpt
mv pred_mapping.csv $OUTPUT_DIR/edge_set_pred_mapping.csv