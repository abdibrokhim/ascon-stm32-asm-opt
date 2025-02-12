################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_UPPER_SRCS += \
../Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/ascon.S 

C_SRCS += \
../Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/decrypt.c \
../Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/encrypt.c 

C_DEPS += \
./Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/decrypt.d \
./Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/encrypt.d 

OBJS += \
./Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/ascon.o \
./Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/decrypt.o \
./Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/encrypt.o 

S_UPPER_DEPS += \
./Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/ascon.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/%.o: ../Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/%.S Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m3 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@" "$<"
Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/%.o Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/%.su Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/%.cyclo: ../Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/%.c Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_aead-2f-asconaead128-2f-asm_esp32

clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_aead-2f-asconaead128-2f-asm_esp32:
	-$(RM) ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/ascon.d ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/ascon.o ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/decrypt.cyclo ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/decrypt.d ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/decrypt.o ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/decrypt.su ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/encrypt.cyclo ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/encrypt.d ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/encrypt.o ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_esp32/encrypt.su

.PHONY: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_aead-2f-asconaead128-2f-asm_esp32

