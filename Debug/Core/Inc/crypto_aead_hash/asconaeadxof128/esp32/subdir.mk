################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/core.c \
../Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/decrypt.c \
../Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/encrypt.c \
../Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/hash.c \
../Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/permutations.c \
../Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/printstate.c 

C_DEPS += \
./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/core.d \
./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/decrypt.d \
./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/encrypt.d \
./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/hash.d \
./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/permutations.d \
./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/printstate.d 

OBJS += \
./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/core.o \
./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/decrypt.o \
./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/encrypt.o \
./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/hash.o \
./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/permutations.o \
./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/printstate.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/%.o Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/%.su Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/%.cyclo: ../Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/%.c Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Inc-2f-crypto_aead_hash-2f-asconaeadxof128-2f-esp32

clean-Core-2f-Inc-2f-crypto_aead_hash-2f-asconaeadxof128-2f-esp32:
	-$(RM) ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/core.cyclo ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/core.d ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/core.o ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/core.su ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/decrypt.cyclo ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/decrypt.d ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/decrypt.o ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/decrypt.su ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/encrypt.cyclo ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/encrypt.d ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/encrypt.o ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/encrypt.su ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/hash.cyclo ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/hash.d ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/hash.o ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/hash.su ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/permutations.cyclo ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/permutations.d ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/permutations.o ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/permutations.su ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/printstate.cyclo ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/printstate.d ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/printstate.o ./Core/Inc/crypto_aead_hash/asconaeadxof128/esp32/printstate.su

.PHONY: clean-Core-2f-Inc-2f-crypto_aead_hash-2f-asconaeadxof128-2f-esp32

