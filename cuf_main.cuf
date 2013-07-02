program main
  integer, parameter :: N = 2**20
  ! Allocate X and Y only on the device
  real, device, dimension(N) :: X, Y
  integer :: i
  real :: tmp

  ! CUDA Fortran will automatically convert these to run on the device
  X(:) = 1.0
  Y(:) = 0.0

  !$acc kernels deviceptr(x,y)
  y(:) = y(:) + 2.0*x(:)
  !$acc end kernels

  ! Copy the first element back from Y for correctness checking
  tmp = y(1)
  print *, tmp
end program
