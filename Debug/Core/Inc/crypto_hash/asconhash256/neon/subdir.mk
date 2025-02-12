################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Inc/crypto_hash/asconhash256/neon/hash.c \
../Core/Inc/crypto_hash/asconhash256/neon/printstate.c 

C_DEPS += \
./Core/Inc/crypto_hash/asconhash256/neon/hash.d \
./Core/Inc/crypto_hash/asconhash256/neon/printstate.d 

OBJS += \
./Core/Inc/crypto_hash/asconhash256/neon/hash.o \
./Core/Inc/crypto_hash/asconhash256/neon/printstate.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Inc/crypto_hash/asconhash256/neon/%.o Core/Inc/crypto_hash/asconhash256/neon/%.su Core/Inc/crypto_hash/asconhash256/neon/%.cyclo: ../Core/Inc/crypto_hash/asconhash256/neon/%.c Core/Inc/crypto_hash/asconhash256/neon/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Inc-2f-crypto_hash-2f-asconhash256-2f-neon

clean-Core-2f-Inc-2f-crypto_hash-2f-asconhash256-2f-neon:
	-$(RM) ./Core/Inc/crypto_hash/asconhash256/neon/hash.cyclo ./Core/Inc/crypto_hash/asconhash256/neon/hash.d ./Core/Inc/crypto_hash/asconhash256/neon/hash.o ./Core/Inc/crypto_hash/asconhash256/neon/hash.su ./Core/Inc/crypto_hash/asconhash256/neon/printstate.cyclo ./Core/Inc/crypto_hash/asconhash256/neon/printstate.d ./Core/Inc/crypto_hash/asconhash256/neon/printstate.o ./Core/Inc/crypto_hash/asconhash256/neon/printstate.su

.PHONY: clean-Core-2f-Inc-2f-crypto_hash-2f-asconhash256-2f-neon

