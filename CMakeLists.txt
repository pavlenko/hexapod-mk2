cmake_minimum_required(VERSION 3.9)

project(hexapod-mk2)

### TOOLCHAIN SETUP START ##############################################################################################

# You must set configuration vars here

set(AVR_TOOLCHAIN_ROOT_PATH ${CMAKE_CURRENT_LIST_DIR}/toolchain)

include(./toolchain.cmake)
### TOOLCHAIN SETUP END ################################################################################################

set(CMAKE_CXX_STANDARD 11)

# add any additional library include dirs your project needs here
include_directories(
)

# use this target for a quick compile-only check of your CPP files
# add more source (CPP) files here when you add them to the sketch
add_executable(hexapod-mk2 main.cpp)

set_target_properties(hexapod-mk2 PROPERTIES LINKER_LANGUAGE CXX)

# use the following two targets for building and uploading sketches from clion.
# select "verify" for just building, select "upload" for building and uploading.
# make sure you have selected the correct board and port in the arduino IDE before building this target!
# instead, you can also use --board and --port arguments here. for the m0, --board arduino:samd:mzero_bl
# see https://github.com/arduino/Arduino/blob/master/build/shared/manpage.adoc for arduino cmd options
#add_custom_target(upload ALL ${ARDUINO_CMD} --upload --preserve-temp-files --verbose blink.ino WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
#add_custom_target(verify ALL ${ARDUINO_CMD} --verify --preserve-temp-files --verbose blink.ino WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
