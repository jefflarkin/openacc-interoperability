subroutine saxpy(n, a, x, y)
  integer :: n
  real    :: a, x(:), y(:)
  !$acc parallel deviceptr(x,y)
  y(:) = y(:) + a * x(:)
  !$acc end parallel
end subroutine
