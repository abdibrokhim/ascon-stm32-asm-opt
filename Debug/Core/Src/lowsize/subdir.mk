################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/lowsize/aead.c \
../Core/Src/lowsize/crypto_aead.c \
../Core/Src/lowsize/update.c 

C_DEPS += \
./Core/Src/lowsize/aead.d \
./Core/Src/lowsize/crypto_aead.d \
./Core/Src/lowsize/update.d 

OBJS += \
./Core/Src/lowsize/aead.o \
./Core/Src/lowsize/crypto_aead.o \
./Core/Src/lowsize/update.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/lowsize/%.o Core/Src/lowsize/%.su Core/Src/lowsize/%.cyclo: ../Core/Src/lowsize/%.c Core/Src/lowsize/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-lowsize

clean-Core-2f-Src-2f-lowsize:
	-$(RM) ./Core/Src/lowsize/aead.cyclo ./Core/Src/lowsize/aead.d ./Core/Src/lowsize/aead.o ./Core/Src/lowsize/aead.su ./Core/Src/lowsize/crypto_aead.cyclo ./Core/Src/lowsize/crypto_aead.d ./Core/Src/lowsize/crypto_aead.o ./Core/Src/lowsize/crypto_aead.su ./Core/Src/lowsize/update.cyclo ./Core/Src/lowsize/update.d ./Core/Src/lowsize/update.o ./Core/Src/lowsize/update.su

.PHONY: clean-Core-2f-Src-2f-lowsize

