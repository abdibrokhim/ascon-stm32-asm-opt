################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/constants.c \
../Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/hash.c \
../Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/interleave.c \
../Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/permutations.c \
../Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/printstate.c 

C_DEPS += \
./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/constants.d \
./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/hash.d \
./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/interleave.d \
./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/permutations.d \
./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/printstate.d 

OBJS += \
./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/constants.o \
./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/hash.o \
./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/interleave.o \
./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/permutations.o \
./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/printstate.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/%.o Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/%.su Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/%.cyclo: ../Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/%.c Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_hash-2f-asconhash256-2f-bi32_armv6m

clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_hash-2f-asconhash256-2f-bi32_armv6m:
	-$(RM) ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/constants.cyclo ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/constants.d ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/constants.o ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/constants.su ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/hash.cyclo ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/hash.d ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/hash.o ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/hash.su ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/interleave.cyclo ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/interleave.d ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/interleave.o ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/interleave.su ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/permutations.cyclo ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/permutations.d ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/permutations.o ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/permutations.su ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/printstate.cyclo ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/printstate.d ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/printstate.o ./Core/Src/ascon-c/crypto_hash/asconhash256/bi32_armv6m/printstate.su

.PHONY: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_hash-2f-asconhash256-2f-bi32_armv6m

