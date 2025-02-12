################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/constants.c \
../Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/interleave.c \
../Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/permutations.c \
../Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/prf.c \
../Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/printstate.c 

C_DEPS += \
./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/constants.d \
./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/interleave.d \
./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/permutations.d \
./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/prf.d \
./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/printstate.d 

OBJS += \
./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/constants.o \
./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/interleave.o \
./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/permutations.o \
./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/prf.o \
./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/printstate.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/%.o Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/%.su Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/%.cyclo: ../Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/%.c Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_auth-2f-asconmacv13-2f-bi32_lowreg

clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_auth-2f-asconmacv13-2f-bi32_lowreg:
	-$(RM) ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/constants.cyclo ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/constants.d ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/constants.o ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/constants.su ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/interleave.cyclo ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/interleave.d ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/interleave.o ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/interleave.su ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/permutations.cyclo ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/permutations.d ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/permutations.o ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/permutations.su ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/prf.cyclo ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/prf.d ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/prf.o ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/prf.su ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/printstate.cyclo ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/printstate.d ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/printstate.o ./Core/Src/ascon-c/crypto_auth/asconmacv13/bi32_lowreg/printstate.su

.PHONY: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_auth-2f-asconmacv13-2f-bi32_lowreg

