################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Inc/aead.c \
../Core/Inc/hash.c \
../Core/Inc/permutations.c \
../Core/Inc/prf.c \
../Core/Inc/prfs.c \
../Core/Inc/printstate.c 

C_DEPS += \
./Core/Inc/aead.d \
./Core/Inc/hash.d \
./Core/Inc/permutations.d \
./Core/Inc/prf.d \
./Core/Inc/prfs.d \
./Core/Inc/printstate.d 

OBJS += \
./Core/Inc/aead.o \
./Core/Inc/hash.o \
./Core/Inc/permutations.o \
./Core/Inc/prf.o \
./Core/Inc/prfs.o \
./Core/Inc/printstate.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Inc/%.o Core/Inc/%.su Core/Inc/%.cyclo: ../Core/Inc/%.c Core/Inc/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Inc

clean-Core-2f-Inc:
	-$(RM) ./Core/Inc/aead.cyclo ./Core/Inc/aead.d ./Core/Inc/aead.o ./Core/Inc/aead.su ./Core/Inc/hash.cyclo ./Core/Inc/hash.d ./Core/Inc/hash.o ./Core/Inc/hash.su ./Core/Inc/permutations.cyclo ./Core/Inc/permutations.d ./Core/Inc/permutations.o ./Core/Inc/permutations.su ./Core/Inc/prf.cyclo ./Core/Inc/prf.d ./Core/Inc/prf.o ./Core/Inc/prf.su ./Core/Inc/prfs.cyclo ./Core/Inc/prfs.d ./Core/Inc/prfs.o ./Core/Inc/prfs.su ./Core/Inc/printstate.cyclo ./Core/Inc/printstate.d ./Core/Inc/printstate.o ./Core/Inc/printstate.su

.PHONY: clean-Core-2f-Inc

