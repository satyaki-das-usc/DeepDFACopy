#!/bin/bash

PYTHONPATH="." python -u sastvd/scripts/dbize_absdf.py --dsname incorr_calc_buff_size
PYTHONPATH="." python -u sastvd/scripts/dbize_absdf.py --dsname buff_access_src_size
PYTHONPATH="." python -u sastvd/scripts/dbize_absdf.py --dsname off_by_one
PYTHONPATH="." python -u sastvd/scripts/dbize_absdf.py --dsname buff_overread
PYTHONPATH="." python -u sastvd/scripts/dbize_absdf.py --dsname double_free
PYTHONPATH="." python -u sastvd/scripts/dbize_absdf.py --dsname use_after_free
PYTHONPATH="." python -u sastvd/scripts/dbize_absdf.py --dsname buff_underwrite
PYTHONPATH="." python -u sastvd/scripts/dbize_absdf.py --dsname buff_underread
PYTHONPATH="." python -u sastvd/scripts/dbize_absdf.py --dsname sensi_read
PYTHONPATH="." python -u sastvd/scripts/dbize_absdf.py --dsname sensi_write