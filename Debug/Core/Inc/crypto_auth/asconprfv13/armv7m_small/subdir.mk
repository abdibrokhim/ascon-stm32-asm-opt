################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Inc/crypto_auth/asconprfv13/armv7m_small/permutations.c \
../Core/Inc/crypto_auth/asconprfv13/armv7m_small/prf.c \
../Core/Inc/crypto_auth/asconprfv13/armv7m_small/printstate.c 

C_DEPS += \
./Core/Inc/crypto_auth/asconprfv13/armv7m_small/permutations.d \
./Core/Inc/crypto_auth/asconprfv13/armv7m_small/prf.d \
./Core/Inc/crypto_auth/asconprfv13/armv7m_small/printstate.d 

OBJS += \
./Core/Inc/crypto_auth/asconprfv13/armv7m_small/permutations.o \
./Core/Inc/crypto_auth/asconprfv13/armv7m_small/prf.o \
./Core/Inc/crypto_auth/asconprfv13/armv7m_small/printstate.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Inc/crypto_auth/asconprfv13/armv7m_small/%.o Core/Inc/crypto_auth/asconprfv13/armv7m_small/%.su Core/Inc/crypto_auth/asconprfv13/armv7m_small/%.cyclo: ../Core/Inc/crypto_auth/asconprfv13/armv7m_small/%.c Core/Inc/crypto_auth/asconprfv13/armv7m_small/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Inc-2f-crypto_auth-2f-asconprfv13-2f-armv7m_small

clean-Core-2f-Inc-2f-crypto_auth-2f-asconprfv13-2f-armv7m_small:
	-$(RM) ./Core/Inc/crypto_auth/asconprfv13/armv7m_small/permutations.cyclo ./Core/Inc/crypto_auth/asconprfv13/armv7m_small/permutations.d ./Core/Inc/crypto_auth/asconprfv13/armv7m_small/permutations.o ./Core/Inc/crypto_auth/asconprfv13/armv7m_small/permutations.su ./Core/Inc/crypto_auth/asconprfv13/armv7m_small/prf.cyclo ./Core/Inc/crypto_auth/asconprfv13/armv7m_small/prf.d ./Core/Inc/crypto_auth/asconprfv13/armv7m_small/prf.o ./Core/Inc/crypto_auth/asconprfv13/armv7m_small/prf.su ./Core/Inc/crypto_auth/asconprfv13/armv7m_small/printstate.cyclo ./Core/Inc/crypto_auth/asconprfv13/armv7m_small/printstate.d ./Core/Inc/crypto_auth/asconprfv13/armv7m_small/printstate.o ./Core/Inc/crypto_auth/asconprfv13/armv7m_small/printstate.su

.PHONY: clean-Core-2f-Inc-2f-crypto_auth-2f-asconprfv13-2f-armv7m_small

