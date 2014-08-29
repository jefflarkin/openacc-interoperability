#include <stdio.h>
#include <stdlib.h>
#include <thrust/device_vector.h>
#include <thrust/device_ptr.h>

extern "C" void saxpy(int,float,float*,float*);

int main(int argc, char **argv)
{
  int N = 1<<20;
  thrust::host_vector<float> y(N);

  thrust::device_vector<float> d_x(N);
  thrust::device_vector<float> d_y(N);

  thrust::fill(d_x.begin(),d_x.end(), 1.0f);
  thrust::fill(d_y.begin(),d_y.end(), 0.0f);

  saxpy(N,2.0,thrust::raw_pointer_cast(d_x.data()),thrust::raw_pointer_cast(d_y.data()));

  y = d_y;
  printf("%f\n",y[0]);
  return 0;
}
