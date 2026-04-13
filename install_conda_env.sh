#!/usr/bin/env bash
# Run from repo root. Requires `conda` on PATH (e.g. Miniconda installed and shell configured).
set -euo pipefail

eval "$(conda shell.bash hook)"

ENV_NAME="medsam2"
if ! conda env list | awk '{print $1}' | grep -qx "${ENV_NAME}"; then
  conda create -n "${ENV_NAME}" python=3.12 -y
fi
conda activate "${ENV_NAME}"

conda install pytorch torchvision pytorch-cuda=12.4 -c pytorch -c nvidia -y
# MKL 2025.x breaks PyTorch CPU lib (undefined symbol iJIT_NotifyEvent); pin until PyTorch/MKL align.
conda install "mkl<2025" -y
pip install -e .
pip install -r requirements.txt
python download_models.py
