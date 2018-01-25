#!/bin/bash

module unload PrgEnv-intel
module load PrgEnv-gnu
module load gcc/6.3.0

module load python
source activate thorstendl-horovod

#add this to library path:
modulebase=$(dirname $(module show tensorflow/intel-head 2>&1 | grep PATH |awk '{print $3}'))
export PYTHONPATH=${modulebase}/lib/python2.7/site-packages:${PYTHONPATH}

rm -rf horovod_build
cp -r horovod_src horovod_build

cd horovod_build

function show_mpi {
    CC -craype-verbose 2>/dev/null
    return 0
}

#set compile flags
export CRAYPE_LINK_TYPE=dynamic
export CC=CC
export CXX=CC
export HOROVOD_MPICXX_SHOW="CC -craype-verbose"

#build
python setup.py build

#install
python setup.py install
