################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/ascon-c/src/lowsize/aead.c \
../Core/Src/ascon-c/src/lowsize/crypto_aead.c \
../Core/Src/ascon-c/src/lowsize/update.c 

C_DEPS += \
./Core/Src/ascon-c/src/lowsize/aead.d \
./Core/Src/ascon-c/src/lowsize/crypto_aead.d \
./Core/Src/ascon-c/src/lowsize/update.d 

OBJS += \
./Core/Src/ascon-c/src/lowsize/aead.o \
./Core/Src/ascon-c/src/lowsize/crypto_aead.o \
./Core/Src/ascon-c/src/lowsize/update.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/ascon-c/src/lowsize/%.o Core/Src/ascon-c/src/lowsize/%.su Core/Src/ascon-c/src/lowsize/%.cyclo: ../Core/Src/ascon-c/src/lowsize/%.c Core/Src/ascon-c/src/lowsize/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-ascon-2d-c-2f-src-2f-lowsize

clean-Core-2f-Src-2f-ascon-2d-c-2f-src-2f-lowsize:
	-$(RM) ./Core/Src/ascon-c/src/lowsize/aead.cyclo ./Core/Src/ascon-c/src/lowsize/aead.d ./Core/Src/ascon-c/src/lowsize/aead.o ./Core/Src/ascon-c/src/lowsize/aead.su ./Core/Src/ascon-c/src/lowsize/crypto_aead.cyclo ./Core/Src/ascon-c/src/lowsize/crypto_aead.d ./Core/Src/ascon-c/src/lowsize/crypto_aead.o ./Core/Src/ascon-c/src/lowsize/crypto_aead.su ./Core/Src/ascon-c/src/lowsize/update.cyclo ./Core/Src/ascon-c/src/lowsize/update.d ./Core/Src/ascon-c/src/lowsize/update.o ./Core/Src/ascon-c/src/lowsize/update.su

.PHONY: clean-Core-2f-Src-2f-ascon-2d-c-2f-src-2f-lowsize

