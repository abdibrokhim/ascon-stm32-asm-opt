################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Inc/crypto_auth/asconprfsv13/ref/prfs.c \
../Core/Inc/crypto_auth/asconprfsv13/ref/printstate.c 

C_DEPS += \
./Core/Inc/crypto_auth/asconprfsv13/ref/prfs.d \
./Core/Inc/crypto_auth/asconprfsv13/ref/printstate.d 

OBJS += \
./Core/Inc/crypto_auth/asconprfsv13/ref/prfs.o \
./Core/Inc/crypto_auth/asconprfsv13/ref/printstate.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Inc/crypto_auth/asconprfsv13/ref/%.o Core/Inc/crypto_auth/asconprfsv13/ref/%.su Core/Inc/crypto_auth/asconprfsv13/ref/%.cyclo: ../Core/Inc/crypto_auth/asconprfsv13/ref/%.c Core/Inc/crypto_auth/asconprfsv13/ref/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Inc-2f-crypto_auth-2f-asconprfsv13-2f-ref

clean-Core-2f-Inc-2f-crypto_auth-2f-asconprfsv13-2f-ref:
	-$(RM) ./Core/Inc/crypto_auth/asconprfsv13/ref/prfs.cyclo ./Core/Inc/crypto_auth/asconprfsv13/ref/prfs.d ./Core/Inc/crypto_auth/asconprfsv13/ref/prfs.o ./Core/Inc/crypto_auth/asconprfsv13/ref/prfs.su ./Core/Inc/crypto_auth/asconprfsv13/ref/printstate.cyclo ./Core/Inc/crypto_auth/asconprfsv13/ref/printstate.d ./Core/Inc/crypto_auth/asconprfsv13/ref/printstate.o ./Core/Inc/crypto_auth/asconprfsv13/ref/printstate.su

.PHONY: clean-Core-2f-Inc-2f-crypto_auth-2f-asconprfsv13-2f-ref

