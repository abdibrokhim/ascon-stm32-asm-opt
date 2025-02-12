################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Inc/crypto_auth/asconprfsv13/bi8/constants.c \
../Core/Inc/crypto_auth/asconprfsv13/bi8/interleave.c \
../Core/Inc/crypto_auth/asconprfsv13/bi8/permutations.c \
../Core/Inc/crypto_auth/asconprfsv13/bi8/prfs.c \
../Core/Inc/crypto_auth/asconprfsv13/bi8/printstate.c 

C_DEPS += \
./Core/Inc/crypto_auth/asconprfsv13/bi8/constants.d \
./Core/Inc/crypto_auth/asconprfsv13/bi8/interleave.d \
./Core/Inc/crypto_auth/asconprfsv13/bi8/permutations.d \
./Core/Inc/crypto_auth/asconprfsv13/bi8/prfs.d \
./Core/Inc/crypto_auth/asconprfsv13/bi8/printstate.d 

OBJS += \
./Core/Inc/crypto_auth/asconprfsv13/bi8/constants.o \
./Core/Inc/crypto_auth/asconprfsv13/bi8/interleave.o \
./Core/Inc/crypto_auth/asconprfsv13/bi8/permutations.o \
./Core/Inc/crypto_auth/asconprfsv13/bi8/prfs.o \
./Core/Inc/crypto_auth/asconprfsv13/bi8/printstate.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Inc/crypto_auth/asconprfsv13/bi8/%.o Core/Inc/crypto_auth/asconprfsv13/bi8/%.su Core/Inc/crypto_auth/asconprfsv13/bi8/%.cyclo: ../Core/Inc/crypto_auth/asconprfsv13/bi8/%.c Core/Inc/crypto_auth/asconprfsv13/bi8/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Inc-2f-crypto_auth-2f-asconprfsv13-2f-bi8

clean-Core-2f-Inc-2f-crypto_auth-2f-asconprfsv13-2f-bi8:
	-$(RM) ./Core/Inc/crypto_auth/asconprfsv13/bi8/constants.cyclo ./Core/Inc/crypto_auth/asconprfsv13/bi8/constants.d ./Core/Inc/crypto_auth/asconprfsv13/bi8/constants.o ./Core/Inc/crypto_auth/asconprfsv13/bi8/constants.su ./Core/Inc/crypto_auth/asconprfsv13/bi8/interleave.cyclo ./Core/Inc/crypto_auth/asconprfsv13/bi8/interleave.d ./Core/Inc/crypto_auth/asconprfsv13/bi8/interleave.o ./Core/Inc/crypto_auth/asconprfsv13/bi8/interleave.su ./Core/Inc/crypto_auth/asconprfsv13/bi8/permutations.cyclo ./Core/Inc/crypto_auth/asconprfsv13/bi8/permutations.d ./Core/Inc/crypto_auth/asconprfsv13/bi8/permutations.o ./Core/Inc/crypto_auth/asconprfsv13/bi8/permutations.su ./Core/Inc/crypto_auth/asconprfsv13/bi8/prfs.cyclo ./Core/Inc/crypto_auth/asconprfsv13/bi8/prfs.d ./Core/Inc/crypto_auth/asconprfsv13/bi8/prfs.o ./Core/Inc/crypto_auth/asconprfsv13/bi8/prfs.su ./Core/Inc/crypto_auth/asconprfsv13/bi8/printstate.cyclo ./Core/Inc/crypto_auth/asconprfsv13/bi8/printstate.d ./Core/Inc/crypto_auth/asconprfsv13/bi8/printstate.o ./Core/Inc/crypto_auth/asconprfsv13/bi8/printstate.su

.PHONY: clean-Core-2f-Inc-2f-crypto_auth-2f-asconprfsv13-2f-bi8

