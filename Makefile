EXES=cuda_main openacc_c_main openacc_c_cublas openacc_c_cublas_v2 thrust cuda_map acc_malloc openacc_streams openacc_cuda_device

ifeq "$(PE_ENV)" "CRAY"
# Cray Compiler
CXX=CC
CXXFLAGS=-hlist=a
CC=cc
CFLAGS=-hlist=a
CUDAC=nvcc
CUDAFLAGS=
FC=ftn
FFLAGS=-ra
LDFLAGS=-L$(CUDA_HOME)/lib64 -lcudart
else
# PGI Compiler
EXES+=cuf_main cuf_openacc_main openacc_cublas  
CXX=nvc++
CXXFLAGS=-fast -acc -ta=nvidia:rdc -Minfo=accel
CC=nvc
CFLAGS=-fast -acc -ta=nvidia:rdc -Minfo=accel
CUDAC=nvcc
CUDAFLAGS=
FC=nvfortran
FFLAGS=-fast -acc -ta=nvidia -Minfo=accel
LDFLAGS=-Mcuda #-L$(CUDA_HOME)/lib64 -lcudart
endif

all: $(EXES)

openacc_cublas: openacc_cublas.o
	$(FC) -o $@ $(CFLAGS) $^ $(LDFLAGS) -Mcudalib=cublas

openacc_c_cublas: openacc_c_cublas.o
	$(CC) -o $@ $(CFLAGS) $^ $(LDFLAGS) -Mcudalib=cublas

openacc_c_cublas_v2: openacc_c_cublas_v2.o
	$(CC) -o $@ $(CFLAGS) $^ $(LDFLAGS) -Mcudalib=cublas

openacc_c_main: saxpy_cuda.o openacc_c_main.o
	$(CC) -o $@ $(CFLAGS) $^ $(LDFLAGS)

cuda_main: saxpy_openacc_c.o cuda_main.o
	$(CXX) -o $@ $(CFLAGS) $^ $(LDFLAGS)

cuf_main: cuf_main.o
	$(FC) -o $@ $(FFLAGS) $^ $(LDFLAGS) -Mcuda

cuf_openacc_main: kernels.o openacc_main.o
	$(FC) -o $@ $(FFLAGS) $^ $(LDFLAGS) -Mcuda

thrust: saxpy_openacc_c.o thrust.o
	$(CXX) -o $@ $(CXXFLAGS) $^ $(LDFLAGS) -lstdc++

cuda_map: saxpy_openacc_c_mapped.o cuda_map.o
	$(CXX) -o $@ $(CXXFLAGS) $^ $(LDFLAGS)

acc_malloc: saxpy_openacc_c.o acc_malloc.o
	$(CC) -o $@ $(CXXFLAGS) $^ $(LDFLAGS)

openacc_cuda_device: saxpy_cuda_device.o openacc_cuda_device.o
	$(CXX) -o $@ $(CXXFLAGS) $^ $(LDFLAGS)

saxpy_cuda_device.o: saxpy_cuda_device.cu
	$(CUDAC) $(CUDAFLAGS) -rdc true -c $<
	
openacc_streams: saxpy_cuda_async.o openacc_streams.o
	$(CC) -o $@ $(CXXFLAGS) $^ $(LDFLAGS)

.SUFFIXES:
.SUFFIXES: .c .o .f90 .cu .cpp .cuf
.c.o:
	$(CC) $(CFLAGS) -c $<
.cpp.o:
	$(CXX) $(CXXFLAGS) -c $<
.f90.o:
	$(FC) $(FFLAGS) -c $<
.cuf.o:
	$(FC) $(FFLAGS) -c $<
.cu.o:
	$(CUDAC) $(CUDAFLAGS) -c $<
.PHONY: clean
clean:
	rm -rf *.o *.ptx *.cub *.lst *.mod $(EXES)
