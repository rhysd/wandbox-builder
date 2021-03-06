#!/bin/bash

if [ $# -lt 1 ]; then
  echo "$0 <build>"
  exit 0
fi

. $(cd $(dirname $0); pwd)/init.sh

set -e
set +x

BUILD=$1
BASE_DIR=$BASE_DIR/$BUILD

function already_installed() {
  build=$1
  if [ "$build" = "boost" ]; then
    version=$2
    compiler=$3
    compiler_version=$4
    test -d /opt/wandbox/boost-$version/$compiler-$compiler_version
  else
    version=$2
    test -d /opt/wandbox/${build}-$version
  fi
}

cat VERSIONS | while read line; do
  if [ "$line" != "" ]; then
    if already_installed $BUILD $line; then
      echo "already installed $BUILD $line"
    else
      run_with_log 1 ./install.sh $line
    fi
  fi
done
