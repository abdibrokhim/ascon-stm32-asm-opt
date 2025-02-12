################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_UPPER_SRCS += \
../Core/Src/avr/permutations.S 

C_SRCS += \
../Core/Src/avr/aead.c \
../Core/Src/avr/hash.c \
../Core/Src/avr/prf.c \
../Core/Src/avr/prfs.c 

C_DEPS += \
./Core/Src/avr/aead.d \
./Core/Src/avr/hash.d \
./Core/Src/avr/prf.d \
./Core/Src/avr/prfs.d 

OBJS += \
./Core/Src/avr/aead.o \
./Core/Src/avr/hash.o \
./Core/Src/avr/permutations.o \
./Core/Src/avr/prf.o \
./Core/Src/avr/prfs.o 

S_UPPER_DEPS += \
./Core/Src/avr/permutations.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/avr/%.o Core/Src/avr/%.su Core/Src/avr/%.cyclo: ../Core/Src/avr/%.c Core/Src/avr/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Core/Src/avr/%.o: ../Core/Src/avr/%.S Core/Src/avr/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m3 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@" "$<"

clean: clean-Core-2f-Src-2f-avr

clean-Core-2f-Src-2f-avr:
	-$(RM) ./Core/Src/avr/aead.cyclo ./Core/Src/avr/aead.d ./Core/Src/avr/aead.o ./Core/Src/avr/aead.su ./Core/Src/avr/hash.cyclo ./Core/Src/avr/hash.d ./Core/Src/avr/hash.o ./Core/Src/avr/hash.su ./Core/Src/avr/permutations.d ./Core/Src/avr/permutations.o ./Core/Src/avr/prf.cyclo ./Core/Src/avr/prf.d ./Core/Src/avr/prf.o ./Core/Src/avr/prf.su ./Core/Src/avr/prfs.cyclo ./Core/Src/avr/prfs.d ./Core/Src/avr/prfs.o ./Core/Src/avr/prfs.su

.PHONY: clean-Core-2f-Src-2f-avr

