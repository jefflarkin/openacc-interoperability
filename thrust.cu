#include <stdio.h>
#include <stdlib.h>
#include <thrust/device_vector.h>
#include <thrust/device_ptr.h>

extern "C" void saxpy(int,float,float*,float*);

int main(int argc, char **argv)
{
  int N = 1<<20;
  thrust::host_vector<float> x(N), y(N);
  for(int i=0; i<N; i++)
  {
    x[i] = 1.0f;
    y[i] = 0.0f;
  }

  thrust::device_vector<float> d_x = x;
  thrust::device_vector<float> d_y = y;

  saxpy(N,2.0,d_x.data().get(),d_y.data().get());

  y = d_y;
  printf("%f\n",y[0]);
  return 0;
}
