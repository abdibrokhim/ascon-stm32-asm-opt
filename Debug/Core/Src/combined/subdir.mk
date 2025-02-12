################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/combined/hash.c 

C_DEPS += \
./Core/Src/combined/hash.d 

OBJS += \
./Core/Src/combined/hash.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/combined/%.o Core/Src/combined/%.su Core/Src/combined/%.cyclo: ../Core/Src/combined/%.c Core/Src/combined/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-combined

clean-Core-2f-Src-2f-combined:
	-$(RM) ./Core/Src/combined/hash.cyclo ./Core/Src/combined/hash.d ./Core/Src/combined/hash.o ./Core/Src/combined/hash.su

.PHONY: clean-Core-2f-Src-2f-combined

