################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/aead.c \
../Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/constants.c \
../Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/hash.c \
../Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/interleave.c \
../Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/permutations.c \
../Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/printstate.c 

C_DEPS += \
./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/aead.d \
./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/constants.d \
./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/hash.d \
./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/interleave.d \
./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/permutations.d \
./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/printstate.d 

OBJS += \
./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/aead.o \
./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/constants.o \
./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/hash.o \
./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/interleave.o \
./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/permutations.o \
./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/printstate.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/%.o Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/%.su Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/%.cyclo: ../Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/%.c Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_aead_hash-2f-asconaeadxof128-2f-bi32

clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_aead_hash-2f-asconaeadxof128-2f-bi32:
	-$(RM) ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/aead.cyclo ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/aead.d ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/aead.o ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/aead.su ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/constants.cyclo ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/constants.d ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/constants.o ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/constants.su ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/hash.cyclo ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/hash.d ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/hash.o ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/hash.su ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/interleave.cyclo ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/interleave.d ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/interleave.o ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/interleave.su ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/permutations.cyclo ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/permutations.d ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/permutations.o ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/permutations.su ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/printstate.cyclo ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/printstate.d ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/printstate.o ./Core/Src/ascon-c/crypto_aead_hash/asconaeadxof128/bi32/printstate.su

.PHONY: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_aead_hash-2f-asconaeadxof128-2f-bi32

