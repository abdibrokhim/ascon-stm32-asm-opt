################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_UPPER_SRCS += \
../Core/Src/armv6m_lowsize/permutations.S 

OBJS += \
./Core/Src/armv6m_lowsize/permutations.o 

S_UPPER_DEPS += \
./Core/Src/armv6m_lowsize/permutations.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/armv6m_lowsize/%.o: ../Core/Src/armv6m_lowsize/%.S Core/Src/armv6m_lowsize/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m3 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@" "$<"

clean: clean-Core-2f-Src-2f-armv6m_lowsize

clean-Core-2f-Src-2f-armv6m_lowsize:
	-$(RM) ./Core/Src/armv6m_lowsize/permutations.d ./Core/Src/armv6m_lowsize/permutations.o

.PHONY: clean-Core-2f-Src-2f-armv6m_lowsize

