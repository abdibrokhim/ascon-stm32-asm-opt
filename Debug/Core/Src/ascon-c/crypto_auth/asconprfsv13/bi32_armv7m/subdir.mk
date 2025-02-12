################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/constants.c \
../Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/interleave.c \
../Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/permutations.c \
../Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/prfs.c \
../Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/printstate.c 

C_DEPS += \
./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/constants.d \
./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/interleave.d \
./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/permutations.d \
./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/prfs.d \
./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/printstate.d 

OBJS += \
./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/constants.o \
./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/interleave.o \
./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/permutations.o \
./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/prfs.o \
./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/printstate.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/%.o Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/%.su Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/%.cyclo: ../Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/%.c Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_auth-2f-asconprfsv13-2f-bi32_armv7m

clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_auth-2f-asconprfsv13-2f-bi32_armv7m:
	-$(RM) ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/constants.cyclo ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/constants.d ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/constants.o ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/constants.su ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/interleave.cyclo ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/interleave.d ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/interleave.o ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/interleave.su ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/permutations.cyclo ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/permutations.d ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/permutations.o ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/permutations.su ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/prfs.cyclo ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/prfs.d ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/prfs.o ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/prfs.su ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/printstate.cyclo ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/printstate.d ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/printstate.o ./Core/Src/ascon-c/crypto_auth/asconprfsv13/bi32_armv7m/printstate.su

.PHONY: clean-Core-2f-Src-2f-ascon-2d-c-2f-crypto_auth-2f-asconprfsv13-2f-bi32_armv7m

