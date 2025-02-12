################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Inc/crypto_auth/asconmacv13/armv7m/permutations.c \
../Core/Inc/crypto_auth/asconmacv13/armv7m/prf.c \
../Core/Inc/crypto_auth/asconmacv13/armv7m/printstate.c 

C_DEPS += \
./Core/Inc/crypto_auth/asconmacv13/armv7m/permutations.d \
./Core/Inc/crypto_auth/asconmacv13/armv7m/prf.d \
./Core/Inc/crypto_auth/asconmacv13/armv7m/printstate.d 

OBJS += \
./Core/Inc/crypto_auth/asconmacv13/armv7m/permutations.o \
./Core/Inc/crypto_auth/asconmacv13/armv7m/prf.o \
./Core/Inc/crypto_auth/asconmacv13/armv7m/printstate.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Inc/crypto_auth/asconmacv13/armv7m/%.o Core/Inc/crypto_auth/asconmacv13/armv7m/%.su Core/Inc/crypto_auth/asconmacv13/armv7m/%.cyclo: ../Core/Inc/crypto_auth/asconmacv13/armv7m/%.c Core/Inc/crypto_auth/asconmacv13/armv7m/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Inc-2f-crypto_auth-2f-asconmacv13-2f-armv7m

clean-Core-2f-Inc-2f-crypto_auth-2f-asconmacv13-2f-armv7m:
	-$(RM) ./Core/Inc/crypto_auth/asconmacv13/armv7m/permutations.cyclo ./Core/Inc/crypto_auth/asconmacv13/armv7m/permutations.d ./Core/Inc/crypto_auth/asconmacv13/armv7m/permutations.o ./Core/Inc/crypto_auth/asconmacv13/armv7m/permutations.su ./Core/Inc/crypto_auth/asconmacv13/armv7m/prf.cyclo ./Core/Inc/crypto_auth/asconmacv13/armv7m/prf.d ./Core/Inc/crypto_auth/asconmacv13/armv7m/prf.o ./Core/Inc/crypto_auth/asconmacv13/armv7m/prf.su ./Core/Inc/crypto_auth/asconmacv13/armv7m/printstate.cyclo ./Core/Inc/crypto_auth/asconmacv13/armv7m/printstate.d ./Core/Inc/crypto_auth/asconmacv13/armv7m/printstate.o ./Core/Inc/crypto_auth/asconmacv13/armv7m/printstate.su

.PHONY: clean-Core-2f-Inc-2f-crypto_auth-2f-asconmacv13-2f-armv7m

