#!/bin/bash

# Use cudatoolkit from conda (see pytorch-dev.yaml).  If you have it installed
# system-wide (e.g. in qgpu) and want to use it, point CUDA_PATH and
# CMAKE_CUDA_COMPILER to the correct folder.
export CUDA_PATH=$CONDA_PREFIX
export CUDA_HOME=$CUDA_PATH

# Note: targets/x86_64-linux is added because of the use of deprecated
# find_package(CUDA).  Usually `cuda_runtime.h` is found in CUDA_HOME and
# find_package(CUDA) expects that.  However with conda, cuda headers are in
# $CUDA_HOME/targets/x86_64-linux/include instead of $CUDA_HOME/include to avoid
# clobbering the top level directory with names like mma.h.  The new way
# (`enable_languages(CUDA)`) knows about this, but pytorch uses both mechanisms.
export CUDA_INC_PATH="$CUDA_PATH/targets/x86_64-linux/include"
