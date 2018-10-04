SET(CMAKE_SYSTEM_NAME Generic)
SET(CMAKE_SYSTEM_VERSION 1)

# Check toolchain
if (NOT AVR_TOOLCHAIN_ROOT_PATH)
    message(FATAL_ERROR "Please add set(AVR_TOOLCHAIN_ROOT_PATH \"<path to toolchain root>\") in your CMakeLists.txt")
endif (NOT AVR_TOOLCHAIN_ROOT_PATH)

set(CMAKE_C_COMPILER ${AVR_TOOLCHAIN_ROOT_PATH}/bin/avr-gcc)
set(CMAKE_CXX_COMPILER ${AVR_TOOLCHAIN_ROOT_PATH}/bin/avr-g++)

#TODO add toolchain include directories