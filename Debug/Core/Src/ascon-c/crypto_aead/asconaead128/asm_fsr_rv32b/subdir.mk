################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_UPPER_SRCS += \
../Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/ascon.S 

C_SRCS += \
../Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/decrypt.c \
../Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/encrypt.c 

C_DEPS += \
./Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/decrypt.d \
./Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/encrypt.d 

OBJS += \
./Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/ascon.o \
./Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/decrypt.o \
./Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/encrypt.o 

S_UPPER_DEPS += \
./Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/ascon.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/%.o: ../Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/%.S Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m3 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@" "$<"
Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/%.o Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/%.su Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/%.cyclo: ../Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/%.c Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_aead-2f-asconaead128-2f-asm_fsr_rv32b

clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_aead-2f-asconaead128-2f-asm_fsr_rv32b:
	-$(RM) ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/ascon.d ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/ascon.o ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/decrypt.cyclo ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/decrypt.d ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/decrypt.o ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/decrypt.su ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/encrypt.cyclo ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/encrypt.d ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/encrypt.o ./Core/Src/ascon-c/crypto_aead/asconaead128/asm_fsr_rv32b/encrypt.su

.PHONY: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_aead-2f-asconaead128-2f-asm_fsr_rv32b

