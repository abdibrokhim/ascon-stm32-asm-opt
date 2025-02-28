################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../Core/Inc/gost28147_89/gost.cpp \
../Core/Inc/gost28147_89/test.cpp 

OBJS += \
./Core/Inc/gost28147_89/gost.o \
./Core/Inc/gost28147_89/test.o 

CPP_DEPS += \
./Core/Inc/gost28147_89/gost.d \
./Core/Inc/gost28147_89/test.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Inc/gost28147_89/%.o Core/Inc/gost28147_89/%.su Core/Inc/gost28147_89/%.cyclo: ../Core/Inc/gost28147_89/%.cpp Core/Inc/gost28147_89/subdir.mk
	arm-none-eabi-g++ "$<" -mcpu=cortex-m3 -std=gnu++14 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -fno-exceptions -fno-rtti -fno-use-cxa-atexit -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Inc-2f-gost28147_89

clean-Core-2f-Inc-2f-gost28147_89:
	-$(RM) ./Core/Inc/gost28147_89/gost.cyclo ./Core/Inc/gost28147_89/gost.d ./Core/Inc/gost28147_89/gost.o ./Core/Inc/gost28147_89/gost.su ./Core/Inc/gost28147_89/test.cyclo ./Core/Inc/gost28147_89/test.d ./Core/Inc/gost28147_89/test.o ./Core/Inc/gost28147_89/test.su

.PHONY: clean-Core-2f-Inc-2f-gost28147_89

