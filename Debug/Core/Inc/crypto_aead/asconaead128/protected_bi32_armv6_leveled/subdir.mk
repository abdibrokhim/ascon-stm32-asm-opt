################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/aead.c \
../Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/constants.c \
../Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/crypto_aead.c \
../Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/crypto_aead_shared.c \
../Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/interleave.c \
../Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/permutations.c \
../Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/printstate.c \
../Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/shares.c 

C_DEPS += \
./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/aead.d \
./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/constants.d \
./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/crypto_aead.d \
./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/crypto_aead_shared.d \
./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/interleave.d \
./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/permutations.d \
./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/printstate.d \
./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/shares.d 

OBJS += \
./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/aead.o \
./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/constants.o \
./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/crypto_aead.o \
./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/crypto_aead_shared.o \
./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/interleave.o \
./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/permutations.o \
./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/printstate.o \
./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/shares.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/%.o Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/%.su Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/%.cyclo: ../Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/%.c Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Inc-2f-crypto_aead-2f-asconaead128-2f-protected_bi32_armv6_leveled

clean-Core-2f-Inc-2f-crypto_aead-2f-asconaead128-2f-protected_bi32_armv6_leveled:
	-$(RM) ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/aead.cyclo ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/aead.d ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/aead.o ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/aead.su ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/constants.cyclo ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/constants.d ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/constants.o ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/constants.su ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/crypto_aead.cyclo ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/crypto_aead.d ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/crypto_aead.o ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/crypto_aead.su ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/crypto_aead_shared.cyclo ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/crypto_aead_shared.d ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/crypto_aead_shared.o ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/crypto_aead_shared.su ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/interleave.cyclo ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/interleave.d ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/interleave.o ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/interleave.su ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/permutations.cyclo ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/permutations.d ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/permutations.o ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/permutations.su ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/printstate.cyclo ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/printstate.d ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/printstate.o ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/printstate.su ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/shares.cyclo ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/shares.d ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/shares.o ./Core/Inc/crypto_aead/asconaead128/protected_bi32_armv6_leveled/shares.su

.PHONY: clean-Core-2f-Inc-2f-crypto_aead-2f-asconaead128-2f-protected_bi32_armv6_leveled

