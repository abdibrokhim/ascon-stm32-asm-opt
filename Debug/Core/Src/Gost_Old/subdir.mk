################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../Core/Src/Gost_Old/gost_old.cpp 

OBJS += \
./Core/Src/Gost_Old/gost_old.o 

CPP_DEPS += \
./Core/Src/Gost_Old/gost_old.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/Gost_Old/%.o Core/Src/Gost_Old/%.su Core/Src/Gost_Old/%.cyclo: ../Core/Src/Gost_Old/%.cpp Core/Src/Gost_Old/subdir.mk
	arm-none-eabi-g++ "$<" -mcpu=cortex-m3 -std=gnu++14 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -fno-exceptions -fno-rtti -fno-use-cxa-atexit -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-Gost_Old

clean-Core-2f-Src-2f-Gost_Old:
	-$(RM) ./Core/Src/Gost_Old/gost_old.cyclo ./Core/Src/Gost_Old/gost_old.d ./Core/Src/Gost_Old/gost_old.o ./Core/Src/Gost_Old/gost_old.su

.PHONY: clean-Core-2f-Src-2f-Gost_Old

