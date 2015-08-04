extern "C"
__device__ 
float saxpy_dev(float a, float x, float y)
{
  return a * x + y;
}
