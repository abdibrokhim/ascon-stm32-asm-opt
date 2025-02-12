################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Inc/crypto_aead/asconaead128/armv6m/aead.c \
../Core/Inc/crypto_aead/asconaead128/armv6m/permutations.c \
../Core/Inc/crypto_aead/asconaead128/armv6m/printstate.c 

C_DEPS += \
./Core/Inc/crypto_aead/asconaead128/armv6m/aead.d \
./Core/Inc/crypto_aead/asconaead128/armv6m/permutations.d \
./Core/Inc/crypto_aead/asconaead128/armv6m/printstate.d 

OBJS += \
./Core/Inc/crypto_aead/asconaead128/armv6m/aead.o \
./Core/Inc/crypto_aead/asconaead128/armv6m/permutations.o \
./Core/Inc/crypto_aead/asconaead128/armv6m/printstate.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Inc/crypto_aead/asconaead128/armv6m/%.o Core/Inc/crypto_aead/asconaead128/armv6m/%.su Core/Inc/crypto_aead/asconaead128/armv6m/%.cyclo: ../Core/Inc/crypto_aead/asconaead128/armv6m/%.c Core/Inc/crypto_aead/asconaead128/armv6m/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Inc-2f-crypto_aead-2f-asconaead128-2f-armv6m

clean-Core-2f-Inc-2f-crypto_aead-2f-asconaead128-2f-armv6m:
	-$(RM) ./Core/Inc/crypto_aead/asconaead128/armv6m/aead.cyclo ./Core/Inc/crypto_aead/asconaead128/armv6m/aead.d ./Core/Inc/crypto_aead/asconaead128/armv6m/aead.o ./Core/Inc/crypto_aead/asconaead128/armv6m/aead.su ./Core/Inc/crypto_aead/asconaead128/armv6m/permutations.cyclo ./Core/Inc/crypto_aead/asconaead128/armv6m/permutations.d ./Core/Inc/crypto_aead/asconaead128/armv6m/permutations.o ./Core/Inc/crypto_aead/asconaead128/armv6m/permutations.su ./Core/Inc/crypto_aead/asconaead128/armv6m/printstate.cyclo ./Core/Inc/crypto_aead/asconaead128/armv6m/printstate.d ./Core/Inc/crypto_aead/asconaead128/armv6m/printstate.o ./Core/Inc/crypto_aead/asconaead128/armv6m/printstate.su

.PHONY: clean-Core-2f-Inc-2f-crypto_aead-2f-asconaead128-2f-armv6m

