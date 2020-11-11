cmake_minimum_required(VERSION 3.1)
project(OpenACCInterop VERSION 1.0
                       DESCRIPTION "OpenACC Interoperability Examples"
                       LANGUAGES C CXX Fortran CUDA
                       HOMEPAGE_URL https://github.com/jefflarkin/openacc-interoperability)
include(CheckLanguage)
check_language(CUDA)
find_package(OpenACC REQUIRED)
#add_compile_options(${OpenACC_C_FLAGS})
#add_link_options(${OpenACC_C_FLAGS})
string(APPEND CMAKE_CXX_FLAGS "${OpenACC_CXX_FLAGS} -gpu=cc70")
string(APPEND CMAKE_C_FLAGS "${OpenACC_C_FLAGS} -gpu=cc70")
string(APPEND CMAKE_Fortran_FLAGS "${OpenACC_Fortran_FLAGS} -gpu=cc70")
enable_testing()

# Requires NVHPC cublas module
if(CMAKE_Fortran_COMPILER_ID STREQUAL "PGI")
  add_executable(openacc_cublas openacc_cublas.f90)
  target_link_options(openacc_cublas PUBLIC "-Mcuda")
  target_link_options(openacc_cublas PUBLIC "-Mcudalib=cublas")
  add_test(NAME openacc_cublas COMMAND openacc_c_cublas)

  #FIXME not building in right order, module missing
  #add_executable(cuf_openacc_main kernels.cuf openacc_main.f90)
  #add_test(NAME cuf_openacc_main COMMAND cuf_openacc_main)
  #target_link_options(cuf_openacc_main PUBLIC "-Mcuda")
  #target_link_options(cuf_openacc_main PUBLIC "-Mcudalib=cublas")
endif()
add_executable(openacc_c_cublas openacc_c_cublas.c)
target_link_libraries(openacc_c_cublas cublas)
add_test(NAME openacc_c_cublas COMMAND openacc_c_cublas)

add_executable(openacc_c_cublas_v2 openacc_c_cublas_v2.c)
target_link_libraries(openacc_c_cublas_v2 cublas)
add_test(NAME openacc_c_cublas_v2 COMMAND openacc_c_cublas)

#FIXME How to change to link via pgc++?
#add_executable(openacc_c_main saxpy_cuda.cu openacc_c_main.c)
#set_property(TARGET openacc_c_main PROPERTY CUDA_ARCHITECTURES 70)
##target_compile_options(openacc_c_main PUBLIC -fPIC)
#add_test(NAME openacc_c_main COMMAND openacc_c_main)

#FIXME How to change to link via pgc++?
#add_executable(cuda_main saxpy_openacc_c.c cuda_main.cu)
#set_property(TARGET cuda_main PROPERTY CUDA_ARCHITECTURES 70)
#target_compile_options(cuda_main PUBLIC -fPIC)
#add_test(NAME cuda_main COMMAND cuda_main)

#FIXME How to change to link via pgc++?
#add_executable(thrust saxpy_openacc_c.c thrust.cu)
#set_property(TARGET thrust PROPERTY CUDA_ARCHITECTURES 70)
#target_compile_options(thrust PUBLIC -fPIC)
#add_test(NAME thrust COMMAND thrust)

#FIXME How to change to link via pgc++?
#add_executable(cuda_map saxpy_openacc_c_mapped.c cuda_map.cu)
#set_property(TARGET cuda_map PROPERTY CUDA_ARCHITECTURES 70)
#target_compile_options(cuda_map PUBLIC -fPIC)
#add_test(NAME cuda_map COMMAND cuda_map)

add_executable(acc_malloc saxpy_openacc_c.c acc_malloc.c)
add_test(NAME acc_malloc COMMAND acc_malloc)

#FIXME Link Errors
#add_executable(openacc_cuda_device saxpy_cuda_device.cu openacc_cuda_device.cpp)
#set_property(TARGET openacc_cuda_device PROPERTY CUDA_ARCHITECTURES 70)
#set_property(TARGET openacc_cuda_device PROPERTY CUDA_SEPARABLE_COMPILATION ON)
#target_link_options(openacc_cuda_device PUBLIC "-Mcuda=rdc")
#add_test(NAME openacc_cuda_device COMMAND openacc_cuda_device)

#FIXME How to change to link via pgc++?
#add_executable(openacc_streams saxpy_cuda_async.cu openacc_streams.c)
#set_property(TARGET openacc_streams PROPERTY CUDA_ARCHITECTURES 70)
#target_compile_options(openacc_streams PUBLIC -fPIC)
#add_test(NAME openacc_streams COMMAND openacc_streams)
