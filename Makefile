CXX=pgCC
CXXFLAGS=-fast -acc -ta=nvidia -Minfo=accel
CC=pgcc
CFLAGS=-fast -acc -ta=nvidia -Minfo=accel
CUDAC=nvcc
CUDAFLAGS=
FC=pgfortran
FFLAGS=-fast -acc -ta=nvidia -Minfo=accel
LDFLAGS=-Mcuda 

EXES: cuf_main thrust

cuf_main: cuf_main.f90
	$(FC) -o $@ $(FFLAGS) $^ $(LDFLAGS)

cuf_openacc_main: saxpy_openacc_f.f90 openacc_main.f90
	$(FC) -o $@ $(FFLAGS) $^ $(LDFLAGS)

thrust: saxpy_openacc_c.o thrust.o
	$(CXX) -o $@ $(CXXFLAGS) $^ $(LDFLAGS) -lstdc++
	
.SUFFIXES:
.SUFFIXES: .c .o .f90 .cu .cpp
.c.o:
	$(CC) $(CFLAGS) -c $<
.cpp.o:
	$(CXX) $(CXXFLAGS) -c $<
.f90.o:
	$(FC) $(FFLAGS) -c $<
.cu.o:
	$(CUDAC) $(CUDAFLAGS) -c $<
.PHONY: clean
clean:
	rm -rf *.o $(EXES)
