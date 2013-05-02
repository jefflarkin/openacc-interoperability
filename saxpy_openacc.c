void saxpy(int n, float a, float * restrict x, float * restrict y)
{
  #pragma acc kernels deviceptr(x[0:n],y[0:n])
  {
    for(int i=0; i<n; i++)
    {
      y[i] += 2.0*x[i];
    }
  }
}
