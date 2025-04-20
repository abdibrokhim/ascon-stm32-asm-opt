# Code Optimization for STM32F103/STM32F407 Discovery Boards – Time and Memory Analysis

## Introduction

## 2.1 Research Context and Motivation

Embedded systems play a crucial role in modern technological applications, particularly in fields where efficiency and reliability are paramount, such as Internet of Things (IoT) devices, automotive systems, medical equipment, and secure communications. Performance optimization, encompassing execution speed and memory management, is particularly critical for these systems due to their resource-constrained environments. Optimized code ensures not only the efficient operation of embedded devices but also extends battery life, reduces production costs, and enhances user experience through responsive and robust performance.

Within the wide range of embedded platforms, ARM microcontrollers stand out due to their popularity, energy efficiency, cost-effectiveness, and extensive support from both industry and academia. Specifically, STM32F103 and STM32F407 Discovery Boards have emerged as compelling platforms for optimization research. These boards feature ARM Cortex-M processors, widely employed in various real-world IoT applications, including environmental monitoring sensors, wearable health devices, home automation systems, and security-critical applications requiring lightweight cryptographic implementations.

The continuous expansion of IoT devices and embedded systems, combined with increasing demands for performance, security, and energy efficiency, motivates the exploration of effective optimization strategies. This thesis addresses this critical area by examining and improving code optimization techniques specifically tailored for ARM microcontrollers.

## 2.2 Objectives and Research Questions

The primary goal of this thesis is to explore, identify, and validate the most effective optimization strategies for ARM microcontrollers, particularly for STM32F103 and STM32F407 discovery boards. This goal is pursued through practical experimentation with common computational tasks and cryptographic algorithms widely utilized in embedded systems.

To accomplish this objective, our research addresses the following key questions:

1. What level of performance gain can be achieved by optimizing fundamental algorithms (e.g., sorting algorithms) using compiler optimizations and assembly programming on ARM Cortex-M microcontrollers?
2. How do targeted optimizations in cryptographic algorithms, such as ASCON and GOST 28147-89, specifically influence the runtime and memory footprint in resource-constrained environments?
3. What combination of compiler-level and code-level optimization techniques yields the greatest improvements in terms of execution speed and memory efficiency?

The measurable outcomes include precise metrics such as runtime reduction, memory savings, and comparative performance gains against unoptimized baseline implementations.

## 2.3 Overview of Optimization Experiments

Our research includes three carefully selected optimization experiments, each targeting different aspects of embedded systems performance and complexity, and each progressively advancing from a basic algorithmic concept to sophisticated cryptographic applications.

### 2.3.1 Bubble Sort (C vs. Assembly)

In our first experiment, we examined a fundamental sorting algorithm—bubble sort—as a baseline case study due to its simplicity and ease of analysis. We implemented the algorithm in both high-level C and low-level assembly language, highlighting practical benefits and trade-offs between manual and compiler-assisted optimization. Then we compared metrics such as execution time and memory footprint, providing insights into the overhead introduced by high-level programming languages and demonstrating the potential performance gains achievable through assembly-level fine-tuning.

### 2.3.2 ASCON AEAD (C & Inline Assembly)

Our second experiment focused on cryptographic optimization, specifically exploring ASCON, a lightweight authenticated encryption algorithm endorsed by NIST for IoT security applications. Given ASCON's critical role in ensuring data security in low-resource environments, we optimized it to balance robust security and performance constraints. Then we employed inline assembly techniques, pipeline optimizations, and efficient memory access patterns. We analyzed performance metrics like execution time and code size reduction, our results demonstrated clear practical improvements.

### 2.3.3 GOST 28147-89 (C & Inline Assembly)

In the third experiment, we optimized GOST 28147-89, a legacy cryptographic standard characterized by significantly different structural complexity compared to modern lightweight algorithms. The algorithm’s distinct S-box structures and extensive computational requirements provided a unique perspective on optimization challenges. We adopted various optimization strategies, including algorithmic restructuring, inline assembly implementation, and memory optimization through precomputed substitution tables. Then we evaluated metrics such as runtime performance gains, memory footprint, and the balance between computational complexity and algorithmic efficiency. Our results demonstrated significant performance improvements, validating the effectiveness of targeted optimizations in complex cryptographic contexts.

Through these experiments, our research provides comprehensive insight into effective optimization strategies, clearly illustrating how strategic code and compiler-level optimizations can significantly enhance performance and efficiency in embedded systems based on ARM microcontrollers.
