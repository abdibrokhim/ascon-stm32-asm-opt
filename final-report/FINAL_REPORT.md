# Code Optimization for STM32F103/STM32F407 Discovery Boards – Time and Memory Analysis

## Abstract

This thesis investigates effective optimization strategies for ARM microcontrollers, focusing specifically on the STM32F103 and STM32F407 Discovery Boards, which are widely used in Internet of Things (IoT) applications. The research comprises three primary experiments: firstly, optimizing a fundamental bubble sort algorithm using both C and assembly, secondly, improving the performance of the ASCON lightweight cryptographic algorithm, and thirdly, enhancing the efficiency of the GOST 28147-89 cryptographic standard.

Experimentation revealed significant performance improvements across all three studies. Compiler and code-level optimizations yielded substantial reductions in execution time and memory footprint, demonstrating the tangible benefits of targeted optimizations. In particular, the optimized implementation of ASCON achieved an 11.11% performance improvement, while optimizations of the GOST algorithm nearly halved the execution time, providing approximately 49.13% faster performance than the original.

This research confirms that carefully selected compiler flags, inline assembly, and targeted memory management optimizations substantially enhance the efficiency of ARM microcontrollers, making them better suited for resource-constrained IoT environments.

---

## Introduction

---

## Literature Review

### Performance-Oriented Programming for Embedded Systems

### ARM Technology

### Using C

### Using Assembly

### Result verification

### ASCON: Lightweight Cryptography

### Research Focus & Goals

---

## Methods

### STM32F4 Code Optimization Approach

### Memory Footprint Optimization

### Isolated Optimization

### Optimization Combinations

### Identify space-wasting code

### ASCON Implementation Details

#### Key Algorithmic Details

#### The Code Structure in the Transcript


---

## Results


---

## Discussion

---

## Conclusion

---

## References

[1] Bakos, J. D. (2023). Embedded systems: ARM programming and optimization. Elsevier.

[2] Meltem Sönmez Turan. (2024). NIST SP 800-232 (initial public draft): "Ascon-based Lightweight Cryptography Standards for Constrained Devices: Authenticated Encryption, Hash, and Extendable Output Functions".

---

## Appendices