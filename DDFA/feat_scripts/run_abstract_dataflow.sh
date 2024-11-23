#!/bin/bash

PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --dsname incorr_calc_buff_size --workers 8 --no-cache --stage 1
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --dsname buff_access_src_size --workers 8 --no-cache --stage 1
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --dsname off_by_one --workers 8 --no-cache --stage 1
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --dsname buff_overread --workers 8 --no-cache --stage 1
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --dsname double_free --workers 8 --no-cache --stage 1
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --dsname use_after_free --workers 8 --no-cache --stage 1
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --dsname buff_underwrite --workers 8 --no-cache --stage 1
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --dsname buff_underread --workers 8 --no-cache --stage 1
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --dsname sensi_read --workers 8 --no-cache --stage 1
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py --dsname sensi_write --workers 8 --no-cache --stage 1


PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py  --dsname incorr_calc_buff_size --workers 8 --cache --stage 2
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py  --dsname buff_access_src_size --workers 8 --cache --stage 2
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py  --dsname off_by_one --workers 8 --cache --stage 2
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py  --dsname buff_overread --workers 8 --cache --stage 2
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py  --dsname double_free --workers 8 --cache --stage 2
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py  --dsname use_after_free --workers 8 --cache --stage 2
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py  --dsname buff_underwrite --workers 8 --cache --stage 2
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py  --dsname buff_underread --workers 8 --cache --stage 2
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py  --dsname sensi_read --workers 8 --cache --stage 2
PYTHONPATH="." python -u sastvd/scripts/abstract_dataflow_full.py  --dsname sensi_write --workers 8 --cache --stage 2