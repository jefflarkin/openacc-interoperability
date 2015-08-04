#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <cuda_runtime.h>

extern void saxpy(int,float,float*,float*,cudaStream_t);

int main(int argc, char **argv)
{
  float *x, *y, tmp;
  int n = 1<<20, i;
  cudaStream_t stream;

  x = (float*)malloc(n*sizeof(float));
  y = (float*)malloc(n*sizeof(float));

  stream = (cudaStream_t) acc_get_cuda_stream(1);

  #pragma acc data create(x[0:n],y[0:n])
  {
    #pragma acc kernels async(1)
    {
      for( i = 0; i < n; i++)
      {
        x[i] = 1.0f;
        y[i] = 0.0f;
      }
    }
      
    #pragma acc host_data use_device(x,y)
    {
      saxpy(n, 2.0, x, y, stream);
    }

    #pragma acc update self(y[0:n]) async(1)
    #pragma acc wait(1)
  }

  fprintf(stdout, "y[0] = %f\n",y[0]);
  return 0;
}
