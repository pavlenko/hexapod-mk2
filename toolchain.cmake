SET(CMAKE_SYSTEM_NAME Generic)
SET(CMAKE_SYSTEM_VERSION 1)

# Check toolchain
if (NOT AVR_TOOLCHAIN_ROOT_PATH)
    message(FATAL_ERROR "Please add set(AVR_TOOLCHAIN_ROOT_PATH \"<absolute path to toolchain root>\") in your CMakeLists.txt")
endif (NOT AVR_TOOLCHAIN_ROOT_PATH)

# Check MCU defined
if (NOT AVR_MCU)
    message(FATAL_ERROR "Please add set(AVR_MCU \"<mcu name for compiler>\") in your CMakeLists.txt")
endif (NOT AVR_MCU)

set(AVR_GNUCC     ${AVR_TOOLCHAIN_ROOT_PATH}/bin/avr-gcc)
set(AVR_GNUCXX    ${AVR_TOOLCHAIN_ROOT_PATH}/bin/avr-g++)
set(AVR_OBJCOPY   ${AVR_TOOLCHAIN_ROOT_PATH}/bin/avr-objcopy)
set(AVR_SIZE_TOOL ${AVR_TOOLCHAIN_ROOT_PATH}/bin/avr-size)
set(AVR_OBJDUMP   ${AVR_TOOLCHAIN_ROOT_PATH}/bin/avr-objdump)

set(AVR_SIZE_ARGS -C;--mcu=${AVR_MCU})

set(CMAKE_C_COMPILER ${AVR_GNUCC})
set(CMAKE_C_COMPILER_ID_RUN TRUE)
set(CMAKE_C_COMPILER_ID "AVR/GNU C Compiler")
set(CMAKE_C_COMPILER_FORCED TRUE)
set(CMAKE_COMPILER_IS_GNUCC 1)

set(CMAKE_CXX_COMPILER ${AVR_GNUCXX})
set(CMAKE_CXX_COMPILER_ID_RUN TRUE)
set(CMAKE_CXX_COMPILER_ID "AVR/GNU C++ Compiler")
set(CMAKE_CXX_COMPILER_FORCED TRUE)
set(CMAKE_COMPILER_IS_GNUCXX 1)

# set file names
set(elf_file    ${CMAKE_PROJECT_NAME}--flash.elf)
set(hex_file    ${CMAKE_PROJECT_NAME}--flash.hex)
set(map_file    ${CMAKE_PROJECT_NAME}--flash.map)
set(eeprom_file ${CMAKE_PROJECT_NAME}--eeprom.hex)

#set(CMAKE_SYSTEM_INCLUDE_PATH "${AVR_TOOLCHAIN_ROOT_PATH}/avr/include")
#set(CMAKE_SYSTEM_LIBRARY_PATH "${AVR_TOOLCHAIN_ROOT_PATH}/avr/lib")

add_executable(${elf_file} EXCLUDE_FROM_ALL main.cpp)

set_target_properties(
    ${elf_file}
    PROPERTIES
        COMPILE_FLAGS "-mmcu=${AVR_MCU}"
        LINK_FLAGS "-mmcu=${AVR_MCU} -Wl,--gc-sections -mrelax -Wl,-Map,${map_file}"
)

add_custom_command(
    OUTPUT ${hex_file}
    COMMAND
        ${AVR_OBJCOPY} -j .text -j .data -O ihex ${elf_file} ${hex_file}
    COMMAND
        ${AVR_SIZE_TOOL} ${AVR_SIZE_ARGS} ${elf_file}
    DEPENDS ${elf_file}
)

# TODO configure compiler based on comments below
# AVR/GNU C Compiler
# ./%.o: .././%.c
# @echo Building file: $<
# @echo Invoking: AVR/GNU C Compiler
# $(QUOTE)$(AVR_APP_PATH)avr-gcc.exe$(QUOTE) -funsigned-char -funsigned-bitfields -O0 -fpack-struct -fshort-enums -g2 -Wall -c -std=gnu99  -mmcu=atmega16a   -MD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
# @echo Finished building: $<

# AVR/GNU Assembler
#ifneq ($(MAKECMDGOALS),clean)
#ifneq ($(strip $(C_DEPS)),)
#-include $(C_DEPS)
#endif
#endif

# All Target
#all: $(OUTPUT_FILE_PATH) $(ADDITIONAL_DEPENDENCIES)

# AVR/GNU C/C++ Linker
#$(OUTPUT_FILE_PATH): $(OBJS) $(USER_OBJS) $(OUTPUT_FILE_DEP)
#@echo Building target: $@
#@echo Invoking: AVR/GNU C/C++ Linker
#$(QUOTE)$(AVR_APP_PATH)avr-gcc.exe$(QUOTE)  -mmcu=atmega16a  -Wl,-Map=$(MAP_FILE_PATH_AS_ARGS) -o$(OUTPUT_FILE_PATH_AS_ARGS) $(OBJS_AS_ARGS) $(USER_OBJS) $(LIBS)
#@echo Finished building target: $@



#$(HEX_FLASH_FILE_PATH): $(OUTPUT_FILE_PATH)
#$(QUOTE)$(AVR_APP_PATH)avr-objcopy.exe$(QUOTE) -O ihex -R .eeprom -R .fuse -R .lock -R .signature  $(QUOTE)$<$(QUOTE) $(QUOTE)$@$(QUOTE)

#$(HEX_EEPROM_FILE_PATH): $(OUTPUT_FILE_PATH)
#-$(QUOTE)$(AVR_APP_PATH)avr-objcopy.exe$(QUOTE) -j .eeprom --set-section-flags=.eeprom=alloc,load --change-section-lma .eeprom=0 --no-change-warnings -O ihex $(QUOTE)$<$(QUOTE) $(QUOTE)$@$(QUOTE) || exit 0

#$(LSS_FILE_PATH): $(OUTPUT_FILE_PATH)
#$(QUOTE)$(AVR_APP_PATH)avr-objdump.exe$(QUOTE) -h -S $(QUOTE)$<$(QUOTE) > $(QUOTE)$@$(QUOTE)

#size: $(OUTPUT_FILE_PATH)
#@$(QUOTE)$(AVR_APP_PATH)avr-size.exe$(QUOTE) -C --mcu=atmega16a $(OUTPUT_FILE_PATH_AS_ARGS)


# Other Targets
#clean:
#-$(RM) $(OBJS_AS_ARGS)$(C_DEPS_AS_ARGS) $(EXECUTABLES) $(LIB_AS_ARGS) $(HEX_FLASH_FILE_PATH_AS_ARGS) $(HEX_EEPROM_FILE_PATH_AS_ARGS) $(LSS_FILE_PATH_AS_ARGS) $(MAP_FILE_PATH_AS_ARGS)
