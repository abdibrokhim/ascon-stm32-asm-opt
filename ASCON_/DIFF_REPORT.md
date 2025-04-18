[source: https://grok.com/share/bGVnYWN5_2c99d2ec-cf74-4dbc-9c7c-b8eda7dc8bb8]

### Key Points
- The optimized ASCON implementation (version 4) for STM32 microcontrollers is likely faster due to bit-interleaving, interleaved operations, and efficient constant loading.
- These changes seem to improve performance by leveraging the ARM Cortex-M architecture, reducing execution time by approximately 32%.
- The optimizations balance speed and resource constraints, making them suitable for IoT applications, though they may increase code complexity.
- No evidence suggests these changes compromise ASCON’s security, as they are implementation-level enhancements.

### What Changed?
The optimized version 4 of the ASCON algorithm introduces several key modifications compared to the original. It likely uses **bit-interleaving**, a technique that reorganizes the state’s bits to process multiple bits simultaneously on 32-bit processors. It also interleaves operations on the low and high halves of the state in the assembly code, allowing the processor to execute independent instructions concurrently. Additionally, it loads 16-bit round constants at once, reducing the number of load instructions compared to the original’s byte-by-byte approach.

### Why Were These Changes Made?
These modifications aim to boost performance on STM32 microcontrollers, which are commonly used in IoT devices with limited resources. By optimizing for the ARM Cortex-M architecture, the changes reduce pipeline stalls and maximize instruction-level parallelism, making the algorithm faster and more efficient for constrained environments.

### How Did It Influence Performance?
Testing shows that version 4 completes 20,000 iterations in 10.57 seconds, compared to 15.63 seconds for the original, suggesting a 32% speed improvement. This enhancement makes the algorithm more suitable for real-time IoT applications where quick cryptographic operations are critical.

### Insights for Your Thesis
For a thesis, you can highlight how these optimizations demonstrate the importance of architecture-specific tuning in lightweight cryptography. Discussing trade-offs, such as potential increases in code size or complexity, can add depth. You might also explore how these techniques could apply to other algorithms or devices, emphasizing ASCON’s role in secure IoT systems.

---



# Detailed Analysis of ASCON Implementation Optimizations for STM32 Microcontrollers

This report provides a comprehensive analysis of the differences between the original and optimized (version 4) implementations of the ASCON Lightweight Cryptography algorithm, tailored for STM32 microcontrollers. It addresses what changed, why these changes were made, their impact on performance, and additional insights relevant for a thesis on lightweight cryptography in IoT applications.

## Background on ASCON
ASCON is a family of authenticated encryption with associated data (AEAD) and hashing algorithms, selected as the primary lightweight cryptography standard by NIST in 2023 ([ASCON Specification](https://ascon.iaik.tugraz.at/files/asconv12-nist.pdf)). Designed for resource-constrained devices, it uses a 320-bit state organized into five 64-bit words, processed through a sponge-based permutation with bitwise Boolean operations (AND, NOT, XOR) and rotations. Its efficiency on platforms ranging from 8-bit to 64-bit makes it ideal for IoT scenarios, where devices like STM32 microcontrollers are prevalent.

## Overview of Provided Implementations
The user provided two ASCON implementations:
- **Original (Version 1):** A 32-bit size-optimized implementation (`opt32_lowsize`) in pure C, taking 15.63 seconds for 20,000 iterations.
- **Optimized (Version 4):** A 32-bit bit-interleaved, speed-optimized implementation (`bi32_armv7m_small`) for ARMv7-M, ARMv8, and ARMv9, using C and inline assembly, taking 10.57 seconds for the same test.

The experimental results also mention intermediate versions (2 and 3), but only versions 1 and 4 are detailed with code. The focus is on comparing these two, with version 4 being the most optimized.

## Detailed Changes from Original to Optimized Version

### 1. Bit-Interleaving Technique
The optimized version 4 employs **bit-interleaving**, a technique that reorganizes the bits of the 320-bit state to enable efficient bitsliced computations on 32-bit processors. In ASCON, the permutation includes a 5-bit S-box applied to state columns. Bit-interleaving rearranges bits so that multiple S-box operations can be performed simultaneously using 32-bit word-level instructions, reducing the number of operations needed ([Journal of Cryptology: Ascon v1.2](https://link.springer.com/article/10.1007/s00145-021-09398-9)).

In the original implementation, the state is likely processed as five 64-bit words, each split into two 32-bit parts (low and high halves) for 32-bit processors. The optimized version may represent the state as ten 32-bit words, with even and odd bits separated, allowing parallel processing of multiple bits. While the provided assembly code still operates on 32-bit words, the bit-interleaving is likely handled in the state representation or data loading, as indicated by the `bi32_armv7m_small` label.

### 2. Interleaved Operations in Assembly
The `ROUND_LOOP` function in version 4 interleaves operations on the low and high halves of the state, unlike the original, which processes the low half fully before the high half. For example:

- **Original:**
  ```c
  "eor %[x0_l], %[x0_l], %[x4_l]\n\t" // Low: x0 ^= x4
  // ... other low-half operations ...
  "eor %[x0_h], %[x0_h], %[x4_h]\n\t" // High: x0 ^= x4
  ```

- **Optimized (Version 4):**
  ```c
  "eor %[x0_l], %[x0_l], %[x4_l]\n\t" // Low: x0 ^= x4
  "eor %[x0_h], %[x0_h], %[x4_h]\n\t" // High: x0 ^= x4
  ```

This interleaving reduces pipeline stalls in the ARM Cortex-M’s 3-stage pipeline by allowing independent instructions to execute concurrently, enhancing instruction-level parallelism.

### 3. Efficient Loading of Round Constants
The optimized version loads 16-bit round constants in a single instruction, extracting high and low bytes using `ubfx` and `and` instructions, compared to the original’s two separate byte loads:

- **Original:**
  ```c
  "ldrb %[tmp1], [%[C]], #1\n\t" // Load one byte
  ```

- **Optimized (Version 4):**
  ```c
  "ldrh %[tmp1], [%[C]], #2\n\t" // Load 16-bit constant
  "ubfx %[tmp0], %[tmp1], #8, #8\n\t" // Extract high byte
  "and %[tmp1], %[tmp1], #0xFF\n\t" // Extract low byte
  ```

This reduces the number of memory access instructions, which can have higher latency, improving overall performance.

## Reasons for Changes
The optimizations were made to enhance performance on STM32 microcontrollers, typically based on ARM Cortex-M cores (e.g., Cortex-M4 for STM32F4 series, supporting ARMv7-M). The goals were:

- **Maximize Speed:** Bit-interleaving and interleaved operations exploit the Cortex-M’s architecture to process data faster, critical for real-time IoT applications.
- **Architecture-Specific Tuning:** The changes leverage the Cortex-M’s pipeline and instruction set, such as efficient bit-manipulation instructions (`ubfx`), to reduce execution time.
- **IoT Suitability:** ASCON’s design targets resource-constrained devices, and these optimizations ensure it meets the performance needs of IoT systems with limited processing power.

## Impact on Performance
The experimental results demonstrate significant performance improvements:

| Implementation                | Time (seconds) | Speedup vs. Original |
|-------------------------------|----------------|----------------------|
| Original (opt32_lowsize)      | 15.63          | -                    |
| Optimized v4 (bi32_armv7m_small) | 10.57       | 32.4%                |

The optimized version 4 is approximately 32.4% faster, calculated as `(15.63 - 10.57) / 15.63 ≈ 0.324`. This speedup is attributed to the combined effect of bit-interleaving, interleaved operations, and efficient constant loading, which reduce the number of cycles per permutation round.

Note: The user’s claim of a 9.11% speedup appears inconsistent with the provided times. The calculation `(15.63 - 10.57) / 15.63` yields 32.4%, suggesting a possible error in the reported percentage. The 3.81% speedup between versions 3 (10.83 seconds) and 4 (10.57 seconds) is also inconsistent, as `(10.83 - 10.57) / 10.83 ≈ 0.024` yields a 2.4% improvement. For the thesis, it’s recommended to verify these figures or clarify the calculation method.

## Additional Insights for Thesis

### Trade-offs
- **Code Complexity:** The optimized implementation is more complex due to bit-interleaving and custom assembly, potentially increasing development and maintenance efforts.
- **Code Size:** While version 4 is labeled “small,” bit-interleaving and inline assembly may increase code size compared to the original. The GitHub repository ([ASCON C Implementation](https://github.com/ascon/ascon-c)) shows code sizes for ARMv7-M implementations, with `bi32_armv7m_small` at 1090 bytes for Ascon-AEAD128, compared to 1162 bytes for `armv6m_lowsize`, indicating a trade-off between speed and size.
- **Portability:** The optimized version is tailored for ARMv7-M and later, reducing portability to other architectures compared to the original’s more generic approach.

### Security Considerations
The optimizations are implementation-level changes and do not alter ASCON’s cryptographic properties. ASCON’s design includes natural side-channel resistance due to its low-degree S-box, and bit-interleaving does not introduce new vulnerabilities if implemented correctly ([Journal of Cryptology: Ascon v1.2](https://link.springer.com/article/10.1007/s00145-021-09398-9)). However, the thesis should note the importance of verifying the assembly code to prevent implementation errors that could lead to side-channel leaks.

### Applicability to Other Algorithms
The techniques used in version 4 are broadly applicable:
- **Bit-Interleaving:** Useful for other lightweight ciphers (e.g., PRESENT, SIMON) on 32-bit platforms to enable bitsliced implementations ([Bit Twiddling Hacks](https://graphics.stanford.edu/~seander/bithacks.html)).
- **Instruction Scheduling:** Interleaving operations to reduce pipeline stalls can optimize any algorithm with parallelizable computations.
- **Efficient Data Loading:** Loading larger data chunks can benefit algorithms with frequent constant accesses.

### Relevance to IoT
ASCON’s selection as NIST’s lightweight cryptography standard underscores its importance for IoT. The optimizations in version 4 align with IoT requirements for fast, efficient cryptography on devices like STM32 microcontrollers, enabling secure communication in smart homes, wearables, and industrial sensors.

### Future Research Directions
- **Benchmarking Across STM32 Variants:** Test version 4 on different STM32 series (e.g., STM32F0 with Cortex-M0 vs. STM32F4 with Cortex-M4) to assess performance variations.
- **Energy Efficiency:** Measure power consumption, as IoT devices prioritize battery life. The GitHub repository suggests ASCON’s hardware implementations are energy-efficient, and software optimizations may yield similar benefits.
- **Comparison with Other Ciphers:** Compare ASCON’s optimized performance with other NIST candidates (e.g., Grain-128AEAD) on STM32 to highlight its advantages.

## Conclusion
The optimized ASCON implementation (version 4) significantly enhances performance on STM32 microcontrollers through bit-interleaving, interleaved operations, and efficient constant loading. These changes reduce execution time by approximately 32%, making ASCON more suitable for IoT applications. For a thesis, discussing these optimizations, their trade-offs, and their broader applicability will provide valuable insights into lightweight cryptography for resource-constrained environments.

## Key Citations
- [ASCON v1.2 Specification Document](https://ascon.iaik.tugraz.at/files/asconv12-nist.pdf)
- [ASCON C Implementation Repository](https://github.com/ascon/ascon-c)
- [Bit Twiddling Hacks for Optimization](https://graphics.stanford.edu/~seander/bithacks.html)
- [Journal of Cryptology: Ascon v1.2 Analysis](https://link.springer.com/article/10.1007/s00145-021-09398-9)
- [ASCON Implementations Overview](https://ascon.iaik.tugraz.at/implementations.html)
- [ASCON Masked Software Implementations](https://github.com/ascon/simpleserial-ascon)
- [ASCON Specification Details](https://ascon.iaik.tugraz.at/specification.html)
- [Efficient ASCON Implementations Review](https://www.mdpi.com/2674-0729/4/2/15)
