program main
  use cublas
  integer, parameter :: N = 2**20
  real, dimension(N) :: X, Y

  X(:) = 1.0
  Y(:) = 0.0

  !$acc data copy(y) copyin(x)
  !$acc host_data use_device(x,y)
  call cublassaxpy(N, 2.0, x, 1, y, 1)
  !$acc end host_data
  !$acc end data

  print *, y(1)
end program
