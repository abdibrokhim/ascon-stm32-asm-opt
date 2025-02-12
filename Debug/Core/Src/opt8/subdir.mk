################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/opt8/aead.c \
../Core/Src/opt8/hash.c \
../Core/Src/opt8/prf.c \
../Core/Src/opt8/prfs.c 

C_DEPS += \
./Core/Src/opt8/aead.d \
./Core/Src/opt8/hash.d \
./Core/Src/opt8/prf.d \
./Core/Src/opt8/prfs.d 

OBJS += \
./Core/Src/opt8/aead.o \
./Core/Src/opt8/hash.o \
./Core/Src/opt8/prf.o \
./Core/Src/opt8/prfs.o 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/opt8/%.o Core/Src/opt8/%.su Core/Src/opt8/%.cyclo: ../Core/Src/opt8/%.c Core/Src/opt8/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O3 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-opt8

clean-Core-2f-Src-2f-opt8:
	-$(RM) ./Core/Src/opt8/aead.cyclo ./Core/Src/opt8/aead.d ./Core/Src/opt8/aead.o ./Core/Src/opt8/aead.su ./Core/Src/opt8/hash.cyclo ./Core/Src/opt8/hash.d ./Core/Src/opt8/hash.o ./Core/Src/opt8/hash.su ./Core/Src/opt8/prf.cyclo ./Core/Src/opt8/prf.d ./Core/Src/opt8/prf.o ./Core/Src/opt8/prf.su ./Core/Src/opt8/prfs.cyclo ./Core/Src/opt8/prfs.d ./Core/Src/opt8/prfs.o ./Core/Src/opt8/prfs.su

.PHONY: clean-Core-2f-Src-2f-opt8

