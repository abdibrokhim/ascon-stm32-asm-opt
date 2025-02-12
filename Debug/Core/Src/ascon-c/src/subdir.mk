################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/ascon-c/src/aead.c \
../Core/Src/ascon-c/src/hash.c \
../Core/Src/ascon-c/src/permutations.c \
../Core/Src/ascon-c/src/prf.c \
../Core/Src/ascon-c/src/prfs.c \
../Core/Src/ascon-c/src/printstate.c 

C_DEPS += \
./Core/Src/ascon-c/src/aead.d \
./Core/Src/ascon-c/src/hash.d \
./Core/Src/ascon-c/src/permutations.d \
./Core/Src/ascon-c/src/prf.d \
./Core/Src/ascon-c/src/prfs.d \
./Core/Src/ascon-c/src/printstate.d 

OBJS += \
./Core/Src/ascon-c/src/aead.o \
./Core/Src/ascon-c/src/hash.o \
./Core/Src/ascon-c/src/permutations.o \
./Core/Src/ascon-c/src/prf.o \
./Core/Src/ascon-c/src/prfs.o \
./Core/Src/ascon-c/src/printstate.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/ascon-c/src/%.o Core/Src/ascon-c/src/%.su Core/Src/ascon-c/src/%.cyclo: ../Core/Src/ascon-c/src/%.c Core/Src/ascon-c/src/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-ascon-2d-c-2f-src

clean-Core-2f-Src-2f-ascon-2d-c-2f-src:
	-$(RM) ./Core/Src/ascon-c/src/aead.cyclo ./Core/Src/ascon-c/src/aead.d ./Core/Src/ascon-c/src/aead.o ./Core/Src/ascon-c/src/aead.su ./Core/Src/ascon-c/src/hash.cyclo ./Core/Src/ascon-c/src/hash.d ./Core/Src/ascon-c/src/hash.o ./Core/Src/ascon-c/src/hash.su ./Core/Src/ascon-c/src/permutations.cyclo ./Core/Src/ascon-c/src/permutations.d ./Core/Src/ascon-c/src/permutations.o ./Core/Src/ascon-c/src/permutations.su ./Core/Src/ascon-c/src/prf.cyclo ./Core/Src/ascon-c/src/prf.d ./Core/Src/ascon-c/src/prf.o ./Core/Src/ascon-c/src/prf.su ./Core/Src/ascon-c/src/prfs.cyclo ./Core/Src/ascon-c/src/prfs.d ./Core/Src/ascon-c/src/prfs.o ./Core/Src/ascon-c/src/prfs.su ./Core/Src/ascon-c/src/printstate.cyclo ./Core/Src/ascon-c/src/printstate.d ./Core/Src/ascon-c/src/printstate.o ./Core/Src/ascon-c/src/printstate.su

.PHONY: clean-Core-2f-Src-2f-ascon-2d-c-2f-src

