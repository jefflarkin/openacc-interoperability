#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <cuda_runtime.h>

extern "C" void saxpy(int,float,float*,float*);
extern "C" void set(int,float,float*);
extern "C" void map(float*, float*, int);

int main(int argc, char **argv)
{
  float *x, *y, *dx, *dy, tmp;
  int n = 1<<20;

  x = (float*) malloc(n*sizeof(float));
  y = (float*) malloc(n*sizeof(float));
  cudaMalloc((void**)&dx,(size_t)n*sizeof(float));
  cudaMalloc((void**)&dy,(size_t)n*sizeof(float));

  map(x, dx, n*sizeof(float));
  map(y, dy, n*sizeof(float));

  set(n,1.0f,x);
  set(n,0.0f,y);

  saxpy(n, 2.0, x, y);
  cudaMemcpy(&tmp,dy,(size_t)sizeof(float),cudaMemcpyDeviceToHost);
  printf("%f\n",tmp);
  return 0;
}
