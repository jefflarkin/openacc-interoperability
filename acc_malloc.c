#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <openacc.h>

void saxpy(int,float,float*,float*);
void set(int,float,float*);

int main(int argc, char **argv)
{
  float *x, *y, tmp;
  int n = 1<<20;

  x = acc_malloc((size_t)n*sizeof(float));
  y = acc_malloc((size_t)n*sizeof(float));

  set(n,1.0f,x);
  set(n,0.0f,y);

  saxpy(n, 2.0, x, y);
  acc_memcpy_from_device(&tmp,y,(size_t)sizeof(float));
  acc_free(x);
  acc_free(y);
  printf("%f\n",tmp);
  return 0;
}
