################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/ascon-c/crypto_hash/asconhash256/opt64/hash.c \
../Core/Src/ascon-c/crypto_hash/asconhash256/opt64/permutations.c \
../Core/Src/ascon-c/crypto_hash/asconhash256/opt64/printstate.c 

C_DEPS += \
./Core/Src/ascon-c/crypto_hash/asconhash256/opt64/hash.d \
./Core/Src/ascon-c/crypto_hash/asconhash256/opt64/permutations.d \
./Core/Src/ascon-c/crypto_hash/asconhash256/opt64/printstate.d 

OBJS += \
./Core/Src/ascon-c/crypto_hash/asconhash256/opt64/hash.o \
./Core/Src/ascon-c/crypto_hash/asconhash256/opt64/permutations.o \
./Core/Src/ascon-c/crypto_hash/asconhash256/opt64/printstate.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/ascon-c/crypto_hash/asconhash256/opt64/%.o Core/Src/ascon-c/crypto_hash/asconhash256/opt64/%.su Core/Src/ascon-c/crypto_hash/asconhash256/opt64/%.cyclo: ../Core/Src/ascon-c/crypto_hash/asconhash256/opt64/%.c Core/Src/ascon-c/crypto_hash/asconhash256/opt64/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_hash-2f-asconhash256-2f-opt64

clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_hash-2f-asconhash256-2f-opt64:
	-$(RM) ./Core/Src/ascon-c/crypto_hash/asconhash256/opt64/hash.cyclo ./Core/Src/ascon-c/crypto_hash/asconhash256/opt64/hash.d ./Core/Src/ascon-c/crypto_hash/asconhash256/opt64/hash.o ./Core/Src/ascon-c/crypto_hash/asconhash256/opt64/hash.su ./Core/Src/ascon-c/crypto_hash/asconhash256/opt64/permutations.cyclo ./Core/Src/ascon-c/crypto_hash/asconhash256/opt64/permutations.d ./Core/Src/ascon-c/crypto_hash/asconhash256/opt64/permutations.o ./Core/Src/ascon-c/crypto_hash/asconhash256/opt64/permutations.su ./Core/Src/ascon-c/crypto_hash/asconhash256/opt64/printstate.cyclo ./Core/Src/ascon-c/crypto_hash/asconhash256/opt64/printstate.d ./Core/Src/ascon-c/crypto_hash/asconhash256/opt64/printstate.o ./Core/Src/ascon-c/crypto_hash/asconhash256/opt64/printstate.su

.PHONY: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_hash-2f-asconhash256-2f-opt64

