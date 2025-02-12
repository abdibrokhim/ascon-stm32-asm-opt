################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/permutations.c \
../Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/prfs.c \
../Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/printstate.c 

C_DEPS += \
./Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/permutations.d \
./Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/prfs.d \
./Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/printstate.d 

OBJS += \
./Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/permutations.o \
./Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/prfs.o \
./Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/printstate.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/%.o Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/%.su Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/%.cyclo: ../Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/%.c Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_auth-2f-asconprfsv13-2f-armv7m_small

clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_auth-2f-asconprfsv13-2f-armv7m_small:
	-$(RM) ./Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/permutations.cyclo ./Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/permutations.d ./Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/permutations.o ./Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/permutations.su ./Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/prfs.cyclo ./Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/prfs.d ./Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/prfs.o ./Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/prfs.su ./Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/printstate.cyclo ./Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/printstate.d ./Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/printstate.o ./Core/Src/ascon-c/crypto_auth/asconprfsv13/armv7m_small/printstate.su

.PHONY: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_auth-2f-asconprfsv13-2f-armv7m_small

