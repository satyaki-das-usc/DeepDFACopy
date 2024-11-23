#!/bin/bash

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