program main
  use cublas
  implicit none
  integer, parameter :: N = 2**20
  real, dimension(N) :: X, Y
  real:: nrm2
  type(cublasHandle) :: h
  integer :: istat
  
  istat = cublasCreate(h)
  if (istat .ne. CUBLAS_STATUS_SUCCESS) print *,istat

  !$acc data create(x,y)
  !$acc kernels
  X(:) = 1.0
  Y(:) = 0.0
  !$acc end kernels

  !$acc host_data use_device(x,y)
  call cublassaxpy(N, 2.0, x, 1, y, 1)
  istat = cublasSnrm2_v2(h, N, x, 1, nrm2)
  if (istat .ne. CUBLAS_STATUS_SUCCESS) print *,istat
  !$acc end host_data
  
  !$acc update self(y)
  !$acc end data

  istat = cublasDestroy(h)
  print *, y(1)
  print*,nrm2
end program


