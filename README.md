Stupid OpenACC (Interoperability) Tricks
========================================
Author: Jeff Larkin <jlarkin@nvidia.com>

This repository demonstrates interoperability between OpenACC and various other GPU programming models. An OpenACC-enabled compiler is required. The default makefile has been written for PGI and tested with PGI 14.7, although most if not all examples will work with earlier versions.

If building with the Cray Compiler Environment the makefile will detect this and adjust compiler flags and targets accordingly. Some targets rely on PGI CUDA Fortran features, these targets will be disabled when building with CCE.

Build Instructions:
-------------------
$ make 

Examples
--------
* cuda\_main - calling OpenACC from CUDA C
* openacc\_c\_main - Calling CUDA from OpenACC in C
* openacc\_c\_cublas - Calling CUBLAS from OpenACC in C
* thrust - Mixing OpenACC and Thrust in C++
* cuda\_map - Using OpenACC acc\_map\_data with CUDA in C
* cuf\_main - Calling OpenACC from CUDA Fortran
* cuf\_openacc\_main - Calling CUDA Fortran from OpenACC
* openacc\_cublas - Calling CUBLAS from OpenACC in CUDA Fortran
* acc\_malloc - Same as cuda\_main, but using the OpenACC API
