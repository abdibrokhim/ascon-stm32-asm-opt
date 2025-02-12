################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_UPPER_SRCS += \
../Core/Src/ascon-c/crypto_hash/asconhash256/avr/permutations.S 

C_SRCS += \
../Core/Src/ascon-c/crypto_hash/asconhash256/avr/hash.c \
../Core/Src/ascon-c/crypto_hash/asconhash256/avr/printstate.c 

C_DEPS += \
./Core/Src/ascon-c/crypto_hash/asconhash256/avr/hash.d \
./Core/Src/ascon-c/crypto_hash/asconhash256/avr/printstate.d 

OBJS += \
./Core/Src/ascon-c/crypto_hash/asconhash256/avr/hash.o \
./Core/Src/ascon-c/crypto_hash/asconhash256/avr/permutations.o \
./Core/Src/ascon-c/crypto_hash/asconhash256/avr/printstate.o 

S_UPPER_DEPS += \
./Core/Src/ascon-c/crypto_hash/asconhash256/avr/permutations.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/ascon-c/crypto_hash/asconhash256/avr/%.o Core/Src/ascon-c/crypto_hash/asconhash256/avr/%.su Core/Src/ascon-c/crypto_hash/asconhash256/avr/%.cyclo: ../Core/Src/ascon-c/crypto_hash/asconhash256/avr/%.c Core/Src/ascon-c/crypto_hash/asconhash256/avr/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
Core/Src/ascon-c/crypto_hash/asconhash256/avr/%.o: ../Core/Src/ascon-c/crypto_hash/asconhash256/avr/%.S Core/Src/ascon-c/crypto_hash/asconhash256/avr/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m3 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@" "$<"

clean: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_hash-2f-asconhash256-2f-avr

clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_hash-2f-asconhash256-2f-avr:
	-$(RM) ./Core/Src/ascon-c/crypto_hash/asconhash256/avr/hash.cyclo ./Core/Src/ascon-c/crypto_hash/asconhash256/avr/hash.d ./Core/Src/ascon-c/crypto_hash/asconhash256/avr/hash.o ./Core/Src/ascon-c/crypto_hash/asconhash256/avr/hash.su ./Core/Src/ascon-c/crypto_hash/asconhash256/avr/permutations.d ./Core/Src/ascon-c/crypto_hash/asconhash256/avr/permutations.o ./Core/Src/ascon-c/crypto_hash/asconhash256/avr/printstate.cyclo ./Core/Src/ascon-c/crypto_hash/asconhash256/avr/printstate.d ./Core/Src/ascon-c/crypto_hash/asconhash256/avr/printstate.o ./Core/Src/ascon-c/crypto_hash/asconhash256/avr/printstate.su

.PHONY: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_hash-2f-asconhash256-2f-avr

