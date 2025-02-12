################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/hash.c \
../Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/permutations.c \
../Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/printstate.c 

C_DEPS += \
./Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/hash.d \
./Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/permutations.d \
./Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/printstate.d 

OBJS += \
./Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/hash.o \
./Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/permutations.o \
./Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/printstate.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/%.o Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/%.su Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/%.cyclo: ../Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/%.c Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_hash-2f-asconxof128-2f-opt32_lowsize

clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_hash-2f-asconxof128-2f-opt32_lowsize:
	-$(RM) ./Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/hash.cyclo ./Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/hash.d ./Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/hash.o ./Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/hash.su ./Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/permutations.cyclo ./Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/permutations.d ./Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/permutations.o ./Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/permutations.su ./Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/printstate.cyclo ./Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/printstate.d ./Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/printstate.o ./Core/Src/ascon-c/crypto_hash/asconxof128/opt32_lowsize/printstate.su

.PHONY: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_hash-2f-asconxof128-2f-opt32_lowsize

