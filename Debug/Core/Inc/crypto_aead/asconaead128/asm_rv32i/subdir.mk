################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_UPPER_SRCS += \
../Core/Inc/crypto_aead/asconaead128/asm_rv32i/ascon.S 

C_SRCS += \
../Core/Inc/crypto_aead/asconaead128/asm_rv32i/decrypt.c \
../Core/Inc/crypto_aead/asconaead128/asm_rv32i/encrypt.c 

C_DEPS += \
./Core/Inc/crypto_aead/asconaead128/asm_rv32i/decrypt.d \
./Core/Inc/crypto_aead/asconaead128/asm_rv32i/encrypt.d 

OBJS += \
./Core/Inc/crypto_aead/asconaead128/asm_rv32i/ascon.o \
./Core/Inc/crypto_aead/asconaead128/asm_rv32i/decrypt.o \
./Core/Inc/crypto_aead/asconaead128/asm_rv32i/encrypt.o 

S_UPPER_DEPS += \
./Core/Inc/crypto_aead/asconaead128/asm_rv32i/ascon.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Inc/crypto_aead/asconaead128/asm_rv32i/%.o: ../Core/Inc/crypto_aead/asconaead128/asm_rv32i/%.S Core/Inc/crypto_aead/asconaead128/asm_rv32i/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m3 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@" "$<"
Core/Inc/crypto_aead/asconaead128/asm_rv32i/%.o Core/Inc/crypto_aead/asconaead128/asm_rv32i/%.su Core/Inc/crypto_aead/asconaead128/asm_rv32i/%.cyclo: ../Core/Inc/crypto_aead/asconaead128/asm_rv32i/%.c Core/Inc/crypto_aead/asconaead128/asm_rv32i/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Inc-2f-crypto_aead-2f-asconaead128-2f-asm_rv32i

clean-Core-2f-Inc-2f-crypto_aead-2f-asconaead128-2f-asm_rv32i:
	-$(RM) ./Core/Inc/crypto_aead/asconaead128/asm_rv32i/ascon.d ./Core/Inc/crypto_aead/asconaead128/asm_rv32i/ascon.o ./Core/Inc/crypto_aead/asconaead128/asm_rv32i/decrypt.cyclo ./Core/Inc/crypto_aead/asconaead128/asm_rv32i/decrypt.d ./Core/Inc/crypto_aead/asconaead128/asm_rv32i/decrypt.o ./Core/Inc/crypto_aead/asconaead128/asm_rv32i/decrypt.su ./Core/Inc/crypto_aead/asconaead128/asm_rv32i/encrypt.cyclo ./Core/Inc/crypto_aead/asconaead128/asm_rv32i/encrypt.d ./Core/Inc/crypto_aead/asconaead128/asm_rv32i/encrypt.o ./Core/Inc/crypto_aead/asconaead128/asm_rv32i/encrypt.su

.PHONY: clean-Core-2f-Inc-2f-crypto_aead-2f-asconaead128-2f-asm_rv32i

