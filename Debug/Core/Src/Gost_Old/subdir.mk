################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/Gost_Old/gost_exp.c 

C_DEPS += \
./Core/Src/Gost_Old/gost_exp.d 

OBJS += \
./Core/Src/Gost_Old/gost_exp.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/Gost_Old/%.o Core/Src/Gost_Old/%.su Core/Src/Gost_Old/%.cyclo: ../Core/Src/Gost_Old/%.c Core/Src/Gost_Old/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-Gost_Old

clean-Core-2f-Src-2f-Gost_Old:
	-$(RM) ./Core/Src/Gost_Old/gost_exp.cyclo ./Core/Src/Gost_Old/gost_exp.d ./Core/Src/Gost_Old/gost_exp.o ./Core/Src/Gost_Old/gost_exp.su

.PHONY: clean-Core-2f-Src-2f-Gost_Old

