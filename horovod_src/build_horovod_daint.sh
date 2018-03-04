#!/bin/bash

module unload PrgEnv-intel
module unload PrgEnv-cray
module load PrgEnv-gnu
module load gcc/5.3.0
module load cudatoolkit/8.0.61_2.4.3-6.0.4.0_3.1__gb475d12

source activate tensorflow

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
export HOROVOD_CUDA_HOME=${CUDATOOLKIT_HOME}
export HOROVOD_CUDA_INCLUDE=${CUDATOOLKIT_HOME}/include
export HOROVOD_CUDA_LIB=${CUDATOOLKIT_HOME}/lib64
export HOROVOD_NCCL_HOME=/scratch/snx3000/tkurth/src/nccl
export HOROVOD_GPU_ALLREDUCE=NCCL
#danger, try at your own risk
export HOROVOD_GPU_ALLGATHER=MPI 
export HOROVOD_GPU_BROADCAST=MPI

#build
python setup.py build

#install
python setup.py install
