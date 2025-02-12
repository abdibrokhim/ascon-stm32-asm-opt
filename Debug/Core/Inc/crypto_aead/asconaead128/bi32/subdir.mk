################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Inc/crypto_aead/asconaead128/bi32/aead.c \
../Core/Inc/crypto_aead/asconaead128/bi32/constants.c \
../Core/Inc/crypto_aead/asconaead128/bi32/interleave.c \
../Core/Inc/crypto_aead/asconaead128/bi32/permutations.c \
../Core/Inc/crypto_aead/asconaead128/bi32/printstate.c 

C_DEPS += \
./Core/Inc/crypto_aead/asconaead128/bi32/aead.d \
./Core/Inc/crypto_aead/asconaead128/bi32/constants.d \
./Core/Inc/crypto_aead/asconaead128/bi32/interleave.d \
./Core/Inc/crypto_aead/asconaead128/bi32/permutations.d \
./Core/Inc/crypto_aead/asconaead128/bi32/printstate.d 

OBJS += \
./Core/Inc/crypto_aead/asconaead128/bi32/aead.o \
./Core/Inc/crypto_aead/asconaead128/bi32/constants.o \
./Core/Inc/crypto_aead/asconaead128/bi32/interleave.o \
./Core/Inc/crypto_aead/asconaead128/bi32/permutations.o \
./Core/Inc/crypto_aead/asconaead128/bi32/printstate.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Inc/crypto_aead/asconaead128/bi32/%.o Core/Inc/crypto_aead/asconaead128/bi32/%.su Core/Inc/crypto_aead/asconaead128/bi32/%.cyclo: ../Core/Inc/crypto_aead/asconaead128/bi32/%.c Core/Inc/crypto_aead/asconaead128/bi32/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Inc-2f-crypto_aead-2f-asconaead128-2f-bi32

clean-Core-2f-Inc-2f-crypto_aead-2f-asconaead128-2f-bi32:
	-$(RM) ./Core/Inc/crypto_aead/asconaead128/bi32/aead.cyclo ./Core/Inc/crypto_aead/asconaead128/bi32/aead.d ./Core/Inc/crypto_aead/asconaead128/bi32/aead.o ./Core/Inc/crypto_aead/asconaead128/bi32/aead.su ./Core/Inc/crypto_aead/asconaead128/bi32/constants.cyclo ./Core/Inc/crypto_aead/asconaead128/bi32/constants.d ./Core/Inc/crypto_aead/asconaead128/bi32/constants.o ./Core/Inc/crypto_aead/asconaead128/bi32/constants.su ./Core/Inc/crypto_aead/asconaead128/bi32/interleave.cyclo ./Core/Inc/crypto_aead/asconaead128/bi32/interleave.d ./Core/Inc/crypto_aead/asconaead128/bi32/interleave.o ./Core/Inc/crypto_aead/asconaead128/bi32/interleave.su ./Core/Inc/crypto_aead/asconaead128/bi32/permutations.cyclo ./Core/Inc/crypto_aead/asconaead128/bi32/permutations.d ./Core/Inc/crypto_aead/asconaead128/bi32/permutations.o ./Core/Inc/crypto_aead/asconaead128/bi32/permutations.su ./Core/Inc/crypto_aead/asconaead128/bi32/printstate.cyclo ./Core/Inc/crypto_aead/asconaead128/bi32/printstate.d ./Core/Inc/crypto_aead/asconaead128/bi32/printstate.o ./Core/Inc/crypto_aead/asconaead128/bi32/printstate.su

.PHONY: clean-Core-2f-Inc-2f-crypto_aead-2f-asconaead128-2f-bi32

