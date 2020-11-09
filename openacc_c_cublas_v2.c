#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "cublas_v2.h"

int main(int argc, char **argv)
{
  float *x, *y, tmp;
  int n = 2000, i;
  cublasStatus_t stat = CUBLAS_STATUS_SUCCESS;

  x = (float*)malloc(n*sizeof(float));
  y = (float*)malloc(n*sizeof(float));

  #pragma acc enter data create(x[0:n]) create(y[0:n])
      
      cublasHandle_t handle;
      stat = cublasCreate(&handle);
      if ( CUBLAS_STATUS_SUCCESS != stat ) {
        printf("CUBLAS initialization failed\n");
      }

    #pragma acc kernels
    {
      for( i = 0; i < n; i++)
      {
        x[i] = 1.0f;
        y[i] = 0.0f;
      }
    }

    #pragma acc host_data use_device(x,y)
    {
        const float alpha = 2.0f;
        stat = cublasSaxpy(handle, n, &alpha, x, 1, y, 1);
        if (stat != CUBLAS_STATUS_SUCCESS) {
            printf("cublasSaxpy failed\n");
        } 
        stat = cublasSnrm2(handle, n, x, 1, &tmp); 
        if (stat != CUBLAS_STATUS_SUCCESS) {
            printf("cublasSnrm2 failed\n");
        }
    }
    
    cublasDestroy(handle);
  
#pragma acc exit data copyout(x[0:n]) copyout(y[0:n]) 

  fprintf(stdout, "y[0] = %f\n",y[0]);
  fprintf(stdout, "x[0] = %f\n",x[0]);
  fprintf(stdout, "norm2(x) = %f\n",tmp);
  return 0;
}

