#!/usr/bin/env bash

BASE_DIR=${BASE_DIR:-$(dirname "$(readlink -f "$0")")}
BASE_DIR=${BASE_DIR%/}

echo "Using base directory $BASE_DIR"
ls -d $BASE_DIR/*/ | while read dir; do
  (
    echo "Stepping into $dir"
    cd $dir
    git fetch --all -p
  )
done
