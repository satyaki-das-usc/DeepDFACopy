#!/bin/bash

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