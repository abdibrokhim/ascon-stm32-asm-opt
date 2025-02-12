################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_UPPER_SRCS += \
../Core/Inc/crypto_aead/asconaead128/avr/permutations.S 

C_SRCS += \
../Core/Inc/crypto_aead/asconaead128/avr/aead.c \
../Core/Inc/crypto_aead/asconaead128/avr/printstate.c 

C_DEPS += \
./Core/Inc/crypto_aead/asconaead128/avr/aead.d \
./Core/Inc/crypto_aead/asconaead128/avr/printstate.d 

OBJS += \
./Core/Inc/crypto_aead/asconaead128/avr/aead.o \
./Core/Inc/crypto_aead/asconaead128/avr/permutations.o \
./Core/Inc/crypto_aead/asconaead128/avr/printstate.o 

S_UPPER_DEPS += \
./Core/Inc/crypto_aead/asconaead128/avr/permutations.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Inc/crypto_aead/asconaead128/avr/%.o Core/Inc/crypto_aead/asconaead128/avr/%.su Core/Inc/crypto_aead/asconaead128/avr/%.cyclo: ../Core/Inc/crypto_aead/asconaead128/avr/%.c Core/Inc/crypto_aead/asconaead128/avr/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Core/Inc/crypto_aead/asconaead128/avr/%.o: ../Core/Inc/crypto_aead/asconaead128/avr/%.S Core/Inc/crypto_aead/asconaead128/avr/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m3 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@" "$<"

clean: clean-Core-2f-Inc-2f-crypto_aead-2f-asconaead128-2f-avr

clean-Core-2f-Inc-2f-crypto_aead-2f-asconaead128-2f-avr:
	-$(RM) ./Core/Inc/crypto_aead/asconaead128/avr/aead.cyclo ./Core/Inc/crypto_aead/asconaead128/avr/aead.d ./Core/Inc/crypto_aead/asconaead128/avr/aead.o ./Core/Inc/crypto_aead/asconaead128/avr/aead.su ./Core/Inc/crypto_aead/asconaead128/avr/permutations.d ./Core/Inc/crypto_aead/asconaead128/avr/permutations.o ./Core/Inc/crypto_aead/asconaead128/avr/printstate.cyclo ./Core/Inc/crypto_aead/asconaead128/avr/printstate.d ./Core/Inc/crypto_aead/asconaead128/avr/printstate.o ./Core/Inc/crypto_aead/asconaead128/avr/printstate.su

.PHONY: clean-Core-2f-Inc-2f-crypto_aead-2f-asconaead128-2f-avr

