#!/bin/bash
set -e

PKGS=(pytorch torch-data torch-vision torch-audio torchbenchmark)

pushd ${PYTORCH_BUILD_DIRECTORY:=~/git$PYTORCH_BUILD_SUFFIX}

for pkg in ${PKGS[@]}; do
  if [ ! -d $pkg ]; then
    echo "Directory $pkg does not exist. Please run torch-clone.sh first!"
    exit 1
  fi
done

for pkg in ${PKGS[@]}; do
  pushd ${pkg}
  git fetch origin --prune --jobs=8
  git checkout main
  git pull --rebase
  git submodule update --init --recursive --jobs=8
  popd
done

popd
