################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/bi32/constants.c \
../Core/Src/bi32/interleave.c 

C_DEPS += \
./Core/Src/bi32/constants.d \
./Core/Src/bi32/interleave.d 

OBJS += \
./Core/Src/bi32/constants.o \
./Core/Src/bi32/interleave.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/bi32/%.o Core/Src/bi32/%.su Core/Src/bi32/%.cyclo: ../Core/Src/bi32/%.c Core/Src/bi32/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-bi32

clean-Core-2f-Src-2f-bi32:
	-$(RM) ./Core/Src/bi32/constants.cyclo ./Core/Src/bi32/constants.d ./Core/Src/bi32/constants.o ./Core/Src/bi32/constants.su ./Core/Src/bi32/interleave.cyclo ./Core/Src/bi32/interleave.d ./Core/Src/bi32/interleave.o ./Core/Src/bi32/interleave.su

.PHONY: clean-Core-2f-Src-2f-bi32

