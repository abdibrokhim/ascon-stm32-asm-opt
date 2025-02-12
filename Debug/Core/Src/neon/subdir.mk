################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/neon/aead.c 

C_DEPS += \
./Core/Src/neon/aead.d 

OBJS += \
./Core/Src/neon/aead.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/neon/%.o Core/Src/neon/%.su Core/Src/neon/%.cyclo: ../Core/Src/neon/%.c Core/Src/neon/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-neon

clean-Core-2f-Src-2f-neon:
	-$(RM) ./Core/Src/neon/aead.cyclo ./Core/Src/neon/aead.d ./Core/Src/neon/aead.o ./Core/Src/neon/aead.su

.PHONY: clean-Core-2f-Src-2f-neon

