################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_UPPER_SRCS += \
../Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/permutations.S 

C_SRCS += \
../Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/hash.c \
../Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/printstate.c 

C_DEPS += \
./Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/hash.d \
./Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/printstate.d 

OBJS += \
./Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/hash.o \
./Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/permutations.o \
./Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/printstate.o 

S_UPPER_DEPS += \
./Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/permutations.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/%.o Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/%.su Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/%.cyclo: ../Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/%.c Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/%.o: ../Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/%.S Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m3 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@" "$<"

clean: clean-Core-2f-Inc-2f-crypto_hash-2f-asconxof128-2f-armv6m_lowsize

clean-Core-2f-Inc-2f-crypto_hash-2f-asconxof128-2f-armv6m_lowsize:
	-$(RM) ./Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/hash.cyclo ./Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/hash.d ./Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/hash.o ./Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/hash.su ./Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/permutations.d ./Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/permutations.o ./Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/printstate.cyclo ./Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/printstate.d ./Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/printstate.o ./Core/Inc/crypto_hash/asconxof128/armv6m_lowsize/printstate.su

.PHONY: clean-Core-2f-Inc-2f-crypto_hash-2f-asconxof128-2f-armv6m_lowsize

