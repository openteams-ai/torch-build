#!/bin/bash

if command -v nproc >/dev/null 2>&1; then
  # We used to set this based on how many physical cores were in the CPU, but this
  # causes compilation failures in containers with nproc < CPU cores.  nproc / 2 is
  # usually a safe guess.
  export MAX_JOBS=${MAX_JOBS:-$(($(nproc) / 2))}
fi

# Compilation type - set to RelWithDebInfo if you need debug symbols.
export CMAKE_BUILD_TYPE=Release

# CUDA
if ! command -v nvidia-smi >/dev/null 2>&1; then
  export USE_CUDA=0
else
  export USE_CUDA=1
fi

# Currently we have no build envs that support ROCm, so disable it unconditionally to
# avoid issues compiling on desktops with AMD APUs.
export USE_ROCM=0

# Faster linking
if command -v ld.mold >/dev/null 2>&1; then
  export CMAKE_LINKER_TYPE=MOLD
elif command -v ld.lld >/dev/null 2>&1; then
  export CMAKE_LINKER_TYPE=LLD
else
  export CMAKE_LINKER_TYPE=DEFAULT
fi

# Faster recompilation
export CCACHE_SLOPPINESS=include_file_ctime,include_file_mtime,pch_defines,time_macros
export USE_PRECOMPILED_HEADERS=1
# Helps ccache still cache files between multiple worktrees
export USE_RELATIVE_PATHS=1

# Flags that mirror PyTorch defaults, but you may want to change
export USE_CUDNN=$USE_CUDA # CNNs
export USE_DISTRIBUTED=1 # distributed
export USE_FBGEMM=1 # GEMMs
export USE_KINETO=1 # profiler

# Don't build what we don't need
export BUILD_AOT_INDUCTOR_TEST=0 # C++ tests
export BUILD_TEST=0 # C++ tests
export USE_PYTORCH_QNNPACK=0 # mobile
export USE_XNNPACK=0 # mobile
# Disable these unless you are going to benchmark them
export USE_FLASH_ATTENTION=0
export USE_MEM_EFF_ATTENTION=0

# cmake from conda
export CMAKE_PREFIX_PATH=$CONDA_PREFIX

# ccache
export CMAKE_C_COMPILER_LAUNCHER=ccache
export CMAKE_CXX_COMPILER_LAUNCHER=ccache

if [[ $USE_CUDA -eq 1 ]]; then
  export CMAKE_CUDA_COMPILER=$CONDA_PREFIX/bin/nvcc
  export CMAKE_CUDA_COMPILER_LAUNCHER=ccache
fi
