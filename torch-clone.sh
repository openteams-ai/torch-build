#!/bin/bash
set -e

mkdir -p ${PYTORCH_BUILD_DIRECTORY:=~/git$PYTORCH_BUILD_SUFFIX}
pushd $PYTORCH_BUILD_DIRECTORY

# PyTorch
git clone --recurse-submodules --jobs=8 "git@github.com:${PYTORCH_GIT_USER:=pytorch}/pytorch.git"
if [ "$PYTORCH_GIT_USER" != "pytorch" ]; then
  pushd pytorch
  git remote add upstream git@github.com:pytorch/pytorch.git
  popd
fi

# Domain Libraries
PKGS=(data vision audio)
for pkg in ${PKGS[@]}; do
  org="pytorch"
  if [ "pkg" = "data" ]; then
    org="meta-pytorch"
  fi
  git clone "git@github.com:${org}/${pkg}.git" "torch-${pkg}"
done

# torch/benchmark
# torchbenchmark needs to have this name and be in this folder, otherwise
# benchmarks/dynamo/torchbench.py won't find it
git clone --recurse-submodules --jobs=8 git@github.com:pytorch/benchmark.git "torchbenchmark"

popd
