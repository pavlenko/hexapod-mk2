SET(CMAKE_SYSTEM_NAME Generic)
SET(CMAKE_SYSTEM_VERSION 1)

# Check toolchain
if (NOT AVR_TOOLCHAIN_ROOT_PATH)
    message(FATAL_ERROR "Please add set(AVR_TOOLCHAIN_ROOT_PATH \"<absolute path to toolchain root>\") in your CMakeLists.txt")
endif (NOT AVR_TOOLCHAIN_ROOT_PATH)

set(AVR_GNUCC     ${AVR_TOOLCHAIN_ROOT_PATH}/bin/avr-gcc)
set(AVR_GNUCXX    ${AVR_TOOLCHAIN_ROOT_PATH}/bin/avr-g++)
set(AVR_OBJCOPY   ${AVR_TOOLCHAIN_ROOT_PATH}/bin/avr-objcopy)
set(AVR_SIZE_TOOL ${AVR_TOOLCHAIN_ROOT_PATH}/bin/avr-size)
set(AVR_OBJDUMP   ${AVR_TOOLCHAIN_ROOT_PATH}/bin/avr-objdump)

set(CMAKE_C_COMPILER ${AVR_GNUCC})
set(CMAKE_C_COMPILER_ID_RUN TRUE)
set(CMAKE_C_COMPILER_ID "GNU")
set(CMAKE_C_COMPILER_FORCED TRUE)
set(CMAKE_COMPILER_IS_GNUCC 1)

set(CMAKE_CXX_COMPILER ${AVR_GNUCXX})
set(CMAKE_CXX_COMPILER_ID_RUN TRUE)
set(CMAKE_CXX_COMPILER_ID "GNU")
set(CMAKE_CXX_COMPILER_FORCED TRUE)
set(CMAKE_COMPILER_IS_GNUCXX 1)

set(CMAKE_EXE_LINKER_FLAGS_INIT "-specs=nosys.specs")
set(CMAKE_EXE_LINKER_FLAGS "-specs=nosys.specs")

# set file names
set(elf_file    ${CMAKE_PROJECT_NAME}--flash.elf)
set(hex_file    ${CMAKE_PROJECT_NAME}--flash.hex)
set(map_file    ${CMAKE_PROJECT_NAME}--flash.map)
set(eeprom_file ${CMAKE_PROJECT_NAME}--eeprom.hex)

#set(CMAKE_SYSTEM_INCLUDE_PATH "${AVR_TOOLCHAIN_ROOT_PATH}/avr/include")
#set(CMAKE_SYSTEM_LIBRARY_PATH "${AVR_TOOLCHAIN_ROOT_PATH}/avr/lib")

add_executable(${elf_file} EXCLUDE_FROM_ALL main.cpp)

add_custom_command(
    OUTPUT ${hex_file}
    COMMAND
    ${AVR_OBJCOPY} -j .text -j .data -O ihex ${elf_file} ${hex_file}
    COMMAND
    ${AVR_SIZE_TOOL} ${AVR_SIZE_ARGS} ${elf_file}
    DEPENDS ${elf_file}
)

add_custom_target(
    build_${CMAKE_PROJECT_NAME}
    ALL
    DEPENDS ${hex_file} ${eeprom_file}
)

set_target_properties(
    build_${CMAKE_PROJECT_NAME}
    PROPERTIES
    OUTPUT_NAME "${elf_file}"
)