################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/ascon-c/crypto_aead/asconaead128/esp32/core.c \
../Core/Src/ascon-c/crypto_aead/asconaead128/esp32/decrypt.c \
../Core/Src/ascon-c/crypto_aead/asconaead128/esp32/encrypt.c \
../Core/Src/ascon-c/crypto_aead/asconaead128/esp32/permutations.c \
../Core/Src/ascon-c/crypto_aead/asconaead128/esp32/printstate.c 

C_DEPS += \
./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/core.d \
./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/decrypt.d \
./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/encrypt.d \
./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/permutations.d \
./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/printstate.d 

OBJS += \
./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/core.o \
./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/decrypt.o \
./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/encrypt.o \
./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/permutations.o \
./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/printstate.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/ascon-c/crypto_aead/asconaead128/esp32/%.o Core/Src/ascon-c/crypto_aead/asconaead128/esp32/%.su Core/Src/ascon-c/crypto_aead/asconaead128/esp32/%.cyclo: ../Core/Src/ascon-c/crypto_aead/asconaead128/esp32/%.c Core/Src/ascon-c/crypto_aead/asconaead128/esp32/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_aead-2f-asconaead128-2f-esp32

clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_aead-2f-asconaead128-2f-esp32:
	-$(RM) ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/core.cyclo ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/core.d ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/core.o ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/core.su ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/decrypt.cyclo ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/decrypt.d ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/decrypt.o ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/decrypt.su ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/encrypt.cyclo ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/encrypt.d ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/encrypt.o ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/encrypt.su ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/permutations.cyclo ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/permutations.d ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/permutations.o ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/permutations.su ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/printstate.cyclo ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/printstate.d ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/printstate.o ./Core/Src/ascon-c/crypto_aead/asconaead128/esp32/printstate.su

.PHONY: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_aead-2f-asconaead128-2f-esp32

