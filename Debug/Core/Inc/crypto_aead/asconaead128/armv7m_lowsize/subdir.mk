################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/aead.c \
../Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/crypto_aead.c \
../Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/permutations.c \
../Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/printstate.c \
../Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/update.c 

C_DEPS += \
./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/aead.d \
./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/crypto_aead.d \
./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/permutations.d \
./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/printstate.d \
./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/update.d 

OBJS += \
./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/aead.o \
./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/crypto_aead.o \
./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/permutations.o \
./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/printstate.o \
./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/update.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/%.o Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/%.su Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/%.cyclo: ../Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/%.c Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Inc-2f-crypto_aead-2f-asconaead128-2f-armv7m_lowsize

clean-Core-2f-Inc-2f-crypto_aead-2f-asconaead128-2f-armv7m_lowsize:
	-$(RM) ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/aead.cyclo ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/aead.d ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/aead.o ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/aead.su ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/crypto_aead.cyclo ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/crypto_aead.d ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/crypto_aead.o ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/crypto_aead.su ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/permutations.cyclo ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/permutations.d ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/permutations.o ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/permutations.su ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/printstate.cyclo ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/printstate.d ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/printstate.o ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/printstate.su ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/update.cyclo ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/update.d ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/update.o ./Core/Inc/crypto_aead/asconaead128/armv7m_lowsize/update.su

.PHONY: clean-Core-2f-Inc-2f-crypto_aead-2f-asconaead128-2f-armv7m_lowsize

