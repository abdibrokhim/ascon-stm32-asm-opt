################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/avx512/aead.c \
../Core/Src/avx512/hash.c 

C_DEPS += \
./Core/Src/avx512/aead.d \
./Core/Src/avx512/hash.d 

OBJS += \
./Core/Src/avx512/aead.o \
./Core/Src/avx512/hash.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/avx512/%.o Core/Src/avx512/%.su Core/Src/avx512/%.cyclo: ../Core/Src/avx512/%.c Core/Src/avx512/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-avx512

clean-Core-2f-Src-2f-avx512:
	-$(RM) ./Core/Src/avx512/aead.cyclo ./Core/Src/avx512/aead.d ./Core/Src/avx512/aead.o ./Core/Src/avx512/aead.su ./Core/Src/avx512/hash.cyclo ./Core/Src/avx512/hash.d ./Core/Src/avx512/hash.o ./Core/Src/avx512/hash.su

.PHONY: clean-Core-2f-Src-2f-avx512

