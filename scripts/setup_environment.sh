#!/bin/bash
set -e

conda env create -f environment.yml
conda activate deepdfa
export LD_LIBRARY_PATH="$CONDA_PREFIX/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$CONDA_PREFIX/lib"
export PYTHONPATH="$PWD/DDFA:$PYTHONPATH"

conda env create -f environment.yml

conda create -n deepdfa python=3.10 pip==23.2.1 cudatoolkit=11.8 notebook ipython
conda activate deepdfa

export TMPDIR=/media/satyaki/160f047a-dacc-449d-9208-a75717e899a1/pip_tmp
export TMPDIR=/media/satyaki/22cce3a2-7e84-4401-9b92-07e2fbeec556/pip_tmp

pip install --cache-dir /media/satyaki/160f047a-dacc-449d-9208-a75717e899a1/pip_cache -r requirements.txt
pip install --cache-dir /media/satyaki/22cce3a2-7e84-4401-9b92-07e2fbeec556/pip_cache -r requirements.txt

pip install --cache-dir /media/satyaki/160f047a-dacc-449d-9208-a75717e899a1/pip_cache -r ../numpy.txt
pip install --cache-dir /media/satyaki/22cce3a2-7e84-4401-9b92-07e2fbeec556/pip_cache -r ../numpy.txt