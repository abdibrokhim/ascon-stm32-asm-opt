# Code Optimization for STM32F103/STM32F407 Discovery Boards – Time and Memory Analysis

## Abstract

This thesis investigates effective optimization strategies for ARM microcontrollers, focusing specifically on the STM32F103 and STM32F407 Discovery Boards, which are widely used in Internet of Things (IoT) applications. The research comprises three primary experiments: firstly, optimizing a fundamental bubble sort algorithm using both C and assembly, secondly, improving the performance of the ASCON lightweight cryptographic algorithm, and thirdly, enhancing the efficiency of the GOST 28147-89 cryptographic standard.

Experimentation revealed significant performance improvements across all three studies. Compiler and code-level optimizations yielded substantial reductions in execution time and memory footprint, demonstrating the tangible benefits of targeted optimizations. In particular, the optimized implementation of ASCON achieved an 11.11% performance improvement, while optimizations of the GOST algorithm nearly halved the execution time, providing approximately 49.13% faster performance than the original.

This research confirms that carefully selected compiler flags, inline assembly, and targeted memory management optimizations substantially enhance the efficiency of ARM microcontrollers, making them better suited for resource-constrained IoT environments.