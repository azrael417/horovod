#!/bin/bash

module unload PrgEnv-intel
module load PrgEnv-gnu
module load gcc/6.3.0

module load python
source activate thorstendl-edison-2.7

#add this to library path:

rm -rf horovod_build
cp -r horovod_src horovod_build_edison

cd horovod_build_edison

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
