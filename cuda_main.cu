#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <cuda_runtime.h>

extern "C" void saxpy(int,float,float*,float*);
extern "C" void set(int,float,float*);

int main(int argc, char **argv)
{
  float *x, *y, tmp;
  int n = 1<<20;

  cudaMalloc((void**)&x,(size_t)n*sizeof(float));
  cudaMalloc((void**)&y,(size_t)n*sizeof(float));

  set(n,1.0f,x);
  set(n,0.0f,y);

  saxpy(n, 2.0, x, y);
  cudaMemcpy(&tmp,y,(size_t)sizeof(float),cudaMemcpyDeviceToHost);
  printf("%f\n",tmp);
  return 0;
}
