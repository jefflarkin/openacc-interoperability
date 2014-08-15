#include <openacc.h>

void map(float * restrict harr, float * restrict darr, int size)
{
  acc_map_data(harr, darr, size);
}
void saxpy(int n, float a, float * restrict x, float * restrict y)
{
  #pragma acc kernels present(x,y)
  {
    for(int i=0; i<n; i++)
    {
      y[i] += a*x[i];
    }
  }
}
void set(int n, float val, float * restrict arr)
{
#pragma acc kernels present(arr)
  {
    for(int i=0; i<n; i++)
    {
      arr[i] = val;
    }
  }
}
