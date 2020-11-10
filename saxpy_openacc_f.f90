module saxpy_mod
  contains
  subroutine saxpy(n, a, x, y)
    integer :: n
    real    :: a, x(:), y(:)
    !$acc parallel loop deviceptr(x,y)
    y(:) = y(:) + a * x(:)
    !$acc end parallel
  end subroutine
end module
