Stupid OpenACC (Interoperability) Tricks
========================================
Author: Jeff Larkin <jlarkin@nvidia.com>

This repository demonstrates interoperability between OpenACC and various other GPU programming models. An OpenACC-enabled compiler is required. The default makefile has been written for PGI and tested with PGI 13.6.

If building with the Cray Compiler Environment the makefile will detect this and adjust compiler flags and targets accordingly. Some targets rely on PGI CUDA Fortran features, these targets will be disabled when building with CCE.

Build Instructions:
-------------------
$ make 
