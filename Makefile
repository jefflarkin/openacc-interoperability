CXX=pgCC
CXXFLAGS=-fast -acc -ta=nvidia -Minfo=accel
CC=pgcc
CFLAGS=-fast -acc -ta=nvidia -Minfo=accel
CUDAC=nvcc
CUDAFLAGS=
FC=pgfortran
FFLAGS=-fast -acc -ta=nvidia -Minfo=accel
LDFLAGS=-Mcuda

EXES=cuda_main cuf_main cuf_openacc_main openacc_c_main openacc_cublas

all: $(EXES)

openacc_cublas: openacc_cublas.o
	$(FC) -o $@ $(CFLAGS) $^ $(LDFLAGS) -lcublas

openacc_c_main: saxpy_cuda.o openacc_c_main.o
	$(CC) -o $@ $(CFLAGS) $^ $(LDFLAGS)

cuda_main: saxpy_openacc_c.o cuda_main.o
	$(CC) -o $@ $(CFLAGS) $^ $(LDFLAGS)

cuf_main: cuf_main.o
	$(FC) -o $@ $(FFLAGS) $^ $(LDFLAGS)

cuf_openacc_main: kernels.o openacc_main.o
	$(FC) -o $@ $(FFLAGS) $^ $(LDFLAGS)

thrust: saxpy_openacc_c.o thrust.o
	$(CXX) -o $@ $(CXXFLAGS) $^ $(LDFLAGS) -lstdc++

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
	rm -rf *.o $(EXES)
