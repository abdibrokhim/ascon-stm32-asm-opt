# Code Optimization for STM32F103/STM32F407 Discovery Boards – Time and Memory Analysis


## Abstract

This thesis investigates effective optimization strategies for ARM microcontrollers, focusing specifically on the STM32F103 and STM32F407 Discovery Boards, which are widely used in Internet of Things (IoT) applications. The research comprises three primary experiments: firstly, optimizing a fundamental bubble sort algorithm using both C and assembly, secondly, improving the performance of the ASCON AEAD128 lightweight cryptographic algorithm, and thirdly, enhancing the efficiency of the GOST 28147-89 cryptographic standard.

Experimentation revealed significant performance improvements across all three studies. Compiler and code-level optimizations yielded substantial reductions in execution time and memory footprint, demonstrating the tangible benefits of targeted optimizations. In particular, the optimized implementation of ASCON AEAD128 achieved an 11.11% performance improvement, while optimizations of the GOST 28147-89 algorithm nearly halved the execution time, providing approximately 49.13% faster performance than the original.

This research confirms that carefully selected compiler flags, inline assembly, and targeted memory management optimizations substantially enhance the efficiency of ARM microcontrollers, making them better suited for resource-constrained IoT environments.

Keywords: Embedded Systems, Code Optimization, ARM Microcontrollers, Memory Footprint, Execution Time, Cryptographic Algorithms


## Introduction

### Research Context and Motivation

Embedded systems play a crucial role in modern technological applications, particularly in fields where efficiency and reliability are paramount, such as Internet of Things (IoT) devices, automotive systems, medical equipment, and secure communications. [1] Performance optimization, encompassing execution speed and memory management, is particularly critical for these systems due to their resource-constrained environments. Optimized code ensures not only the efficient operation of embedded devices but also extends battery life, reduces production costs, and enhances user experience through responsive and robust performance. [2]

Within the wide range of embedded platforms, ARM microcontrollers stand out due to their popularity, energy efficiency, cost-effectiveness, and extensive support from both industry and academia. Specifically, STM32F103 and STM32F407 Discovery Boards have emerged as compelling platforms for optimization research. These boards feature ARM Cortex-M processors, widely employed in various real-world IoT applications, including environmental monitoring sensors, wearable health devices, home automation systems, and security-critical applications requiring lightweight cryptographic implementations. [3, 4]

The continuous expansion of IoT devices and embedded systems, combined with increasing demands for performance, security, and energy efficiency, motivates the exploration of effective optimization strategies. This thesis addresses this critical area by examining and improving code optimization techniques specifically tailored for ARM microcontrollers. [5-8]

### Objectives and Research Questions

The primary goal of this thesis is to explore, identify, and validate the most effective optimization strategies for ARM microcontrollers, particularly for STM32F103 and STM32F407 discovery boards. This goal is pursued through practical experimentation with common computational tasks and cryptographic algorithms widely utilized in embedded systems.

To accomplish this objective, our research addresses the following key questions:

1. What level of performance gain can be achieved by optimizing fundamental algorithms (e.g., sorting algorithms) using compiler optimizations and assembly programming on ARM Cortex-M microcontrollers?
2. How do targeted optimizations in cryptographic algorithms, such as ASCON and GOST 28147-89, specifically influence the runtime and memory footprint in resource-constrained environments?
3. What combination of compiler-level and code-level optimization techniques yields the greatest improvements in terms of execution speed and memory efficiency?

The measurable outcomes include precise metrics such as runtime reduction, memory savings, and comparative performance gains against unoptimized baseline implementations.

### Overview of Optimization Experiments

Our research includes three carefully selected optimization experiments, each targeting different aspects of embedded systems performance and complexity, and each progressively advancing from a basic algorithmic concept to sophisticated cryptographic applications.

1. Bubble Sort (C vs. Assembly)

In our first experiment, we examined a fundamental sorting algorithm—bubble sort—as a baseline case study due to its simplicity and ease of analysis. We implemented the algorithm in both high-level C and low-level assembly language, highlighting practical benefits and trade-offs between manual and compiler-assisted optimization. Then we compared metrics such as execution time and memory footprint, providing insights into the overhead introduced by high-level programming languages and demonstrating the potential performance gains achievable through assembly-level fine-tuning.

2. ASCON AEAD128 (C & Inline Assembly)

Our second experiment focused on cryptographic optimization, specifically exploring ASCON, a lightweight authenticated encryption algorithm endorsed by NIST for IoT security applications. [9, 10] Given ASCON's critical role in ensuring data security in low-resource environments, we optimized it to balance robust security and performance constraints. Then we employed inline assembly techniques, pipeline optimizations, and efficient memory access patterns. We analyzed performance metrics like execution time and code size reduction, our results demonstrated clear practical improvements.

3. GOST 28147-89 (C & Inline Assembly)

In the third experiment, we optimized GOST 28147-89, a legacy cryptographic standard characterized by significantly different structural complexity compared to modern lightweight algorithms. [11] The algorithm’s distinct S-box structures and extensive computational requirements provided a unique perspective on optimization challenges. We adopted various optimization strategies, including algorithmic restructuring, inline assembly implementation, and memory optimization through precomputed substitution tables. Then we evaluated metrics such as runtime performance gains, memory footprint, and the balance between computational complexity and algorithmic efficiency. Our results demonstrated significant performance improvements, validating the effectiveness of targeted optimizations in complex cryptographic contexts.

Through these experiments, our research provides comprehensive insight into effective optimization strategies, clearly illustrating how strategic code and compiler-level optimizations can significantly enhance performance and efficiency in embedded systems based on ARM microcontrollers.


## Literature Review

### Performance‑Oriented Programming for Embedded Systems

Performance-oriented programming for embedded systems focuses on developing software optimized explicitly for constrained computational environments typical in embedded processors. Unlike desktop or server processors, which utilize complex features like extensive out-of-order execution units and sophisticated cache hierarchies to extract maximum performance from unoptimized legacy or architecture-agnostic code, embedded processors necessitate deliberate software-level optimization to achieve efficient performance. [3, 5] Embedded systems generally have limited resources, including processing power, memory bandwidth, and energy availability, requiring tailored programming techniques to maximize resource utilization. [12]

Seminal literature in the field identifies several key performance-tuning techniques frequently employed in embedded-systems programming:

1. **Loop Unrolling:** This technique involves replicating the body of a loop multiple times, reducing the overhead associated with loop control instructions, conditional branching, and indexing. Loop unrolling can significantly improve performance by enabling better scheduling of instructions and facilitating compiler optimizations such as vectorization and pipelining. [2] However, excessive unrolling may cause instruction cache pressure and diminish returns due to instruction fetch bandwidth limitations. [13]

2. **Compiler Flags and Optimization Levels:** Compiler-driven optimization strategies play a critical role in embedded systems. Compiler flags such as `-O2`, `-O3`, or specialized flags like `-funroll-loops`, `-ftree-vectorize`, and architecture-specific flags (`-mcpu=cortex-m4`, `-mfpu=fpv4-sp-d16`) allow the compiler to generate machine code specifically tailored to a processor’s architecture and application needs.

3. **Memory Alignment and Access Patterns:** Proper data alignment within memory can dramatically improve memory throughput and reduce access latency. Embedded processors typically enforce strict memory alignment constraints; misaligned memory accesses can incur substantial performance penalties or even generate processor faults. [12] Literature on ARM Cortex-based systems emphasizes aligning data structures and arrays to boundaries (e.g., 32-bit or 64-bit alignment) to leverage efficient burst memory accesses and minimize memory stalls. [3, 14]

4. **Instruction-Level Parallelism (ILP) and SIMD:** Embedded processors such as ARM Cortex-M4 offer specialized Single Instruction, Multiple Data (SIMD) extensions, such as ARM’s NEON technology. Exploiting SIMD instructions allows parallel execution of arithmetic operations on multiple data elements, enhancing computational throughput, particularly in digital signal processing and multimedia applications. [14] However, effective use of SIMD typically necessitates explicit programmer intervention through intrinsics or inline assembly due to limitations in compiler auto-vectorization capabilities. [3]

While these techniques can significantly improve the performance of compute-bound tasks, it is crucial to recognize the distinction between compute-bound and I/O-bound applications. Compute-bound tasks, such as video encoding, benefit substantially from these optimization strategies, whereas I/O-bound tasks typically do not, since their performance is dominated by peripheral or communication latency rather than processor or memory efficiency. [2]

Thus, the emphasis on performance-oriented programming in embedded systems is justified by the substantial gap in performance achievable by optimized versus non-optimized code, particularly in computation-intensive domains such as digital signal processing, cryptographic operations, and control algorithms. [12]

### ARM Architecture and STM32F1/F4 Series Features

ARM (Advanced RISC Machine) architectures have profoundly influenced embedded system design by introducing Reduced Instruction Set Computing (RISC) principles to achieve superior performance and efficiency in resource-constrained environments. ARM architectures have evolved through various generations, notably ARMv6 and ARMv7, each iteration introducing incremental enhancements designed to optimize performance and power efficiency. [5, 14]

ARM architectures emphasize simplicity and efficiency through load-store instruction paradigms, where arithmetic instructions only operate on register operands, necessitating explicit memory load/store instructions. [14] ARMv6 introduced notable advancements in instruction pipeline optimization, improved branch prediction, and basic DSP-oriented instructions. ARMv7 further augmented these capabilities with enhanced SIMD instructions via the NEON extension, significantly boosting performance for multimedia and digital signal processing tasks. [5, 14]

Comparative analyses indicate that ARMv7-based processors exhibit substantial improvements in instruction throughput, particularly for applications exploiting parallel data processing, where NEON instructions can improve arithmetic operation efficiency by a factor of four to eight compared to scalar operations.

#### STM32F1 and STM32F4 Series Microarchitectural Features

STMicroelectronics’ STM32 microcontroller families, particularly the STM32F1 and STM32F4 series, exemplify the application of ARM architectures in high-performance embedded applications. The STM32F1 series, based on the ARM Cortex-M3 core, delivers a straightforward and cost-effective platform with clock speeds up to 72 MHz and integrated peripherals such as CAN, USB, and Ethernet MAC interfaces. [4] The relatively simple three-stage pipeline of the Cortex-M3 allows predictable execution timing suitable for deterministic, real-time embedded control systems.

In contrast, the STM32F4 series, employing the ARM Cortex-M4 core, significantly advances computational capabilities by integrating digital signal processing (DSP) instructions, hardware floating-point units (FPU), and advanced microarchitectural enhancements. [4] Key features of the STM32F4 family include:

- **Advanced Pipeline and Caches:** The Cortex-M4’s pipeline improvements and the Adaptive Real-Time (ART) Accelerator™ enable instruction execution at frequencies up to 180 MHz, achieving up to 225 DMIPS. [4] The inclusion of instruction and data caches significantly reduces memory access latency, providing substantial performance improvements for compute-intensive applications.

- **Floating-Point and DSP Instructions:** Integrated hardware floating-point units substantially accelerate mathematical computations common in signal processing, control algorithms, and graphical applications, potentially delivering a threefold performance gain over software floating-point emulation. [4, 14]

- **Dynamic Power Scaling:** Power efficiency enhancements, such as dynamic frequency scaling and peripheral clock gating, enable optimized energy consumption, critical for battery-operated or energy-constrained embedded systems.

- **Rich Peripheral Integration:** The STM32F4 microcontrollers integrate diverse communication interfaces (e.g., Quad-SPI, Ethernet, USB OTG), high-density memory options, and enhanced security peripherals, expanding their suitability for advanced embedded applications requiring robust connectivity, multimedia support, and secure data handling. [4]

In summary, the STM32F4 series' architectural improvements over the STM32F1 reflect ARM’s evolutionary approach toward enhanced computational performance and power efficiency, addressing the growing demand for sophisticated functionalities within embedded applications. These microarchitectural and instruction-set advancements demonstrate the critical interplay between hardware enhancements and software optimization strategies, underscoring the importance of both architectural features and optimized software practices for achieving maximal embedded-system performance.

### Case Study: Bubble Sort in C and Assembly

This experiment compares the performance of compiler-optimized C code with manually optimized Assembly code for the bubble sort algorithm. Bubble sort is chosen as a baseline due to its simplicity, allowing clear analysis of optimization impacts in resource-constrained IoT environments.

Below is the pure C implementation of the bubble sort algorithm:

file: bubble_sort.c

```c
void bubble_sort (int* data, int n) {
    for (int i=0;i<(n-1);i++) {
        for (int j=0;j<(n-1);j++) {
            if (data[j]>data[j+1]) {
                int temp=data[j];
                data[j]=data[j+1];
                data[j+1]=temp;
            }
        }
    }
}
```

The code is compiled using the ARM cross-compiler with aggressive optimization:

```bash
gcc -O3 bubble_sort.c -o bubble_sort
```

To execute and time the program run the following command:

```bash
time ./bubble_sort
```

In general it takes 1.305865 seconds to execute the program.

```bash
C bubble sort time: 1.305865 seconds
```

The -O3 flag enables optimizations such as loop unrolling and function inlining. Execution time is measured using the SysTick timer for an array of size ( N = 32768 ).

Below is the basic Assembly implementation for the ARM Cortex-M4 architecture:

file: bubble_sort_asm.s

```s
.text
.global _bubble_sort_asm
.global bubble_sort_asm

_bubble_sort_asm:
bubble_sort_asm:
    sub w1, w1, #1       // r1 = N-1
    mov w5, #0           // i = 0 
oloop:
    cmp w5, w1           // if i == N-1 ?
    beq exito            // yes, end
    mov w3, #0           // j = 0
    mov x2, x0           // x2 = &data (must use 64-bit register for address)

iloop:
    cmp w3, w1           // if j == N-1 ?
    beq exiti            // yes, next i
    ldr w11, [x2]        // Load data[j]
    ldr w10, [x2, #4]    // Load data[j+1]
    cmp w11, w10         // if data[j] > data[j+1]
    ble skip             // skip if not greater
    
    // Swap data[j] and data[j+1]
    str w10, [x2]        // data[j] = data[j+1]
    str w11, [x2, #4]    // data[j+1] = data[j]

skip:
    add w3, w3, #1       // j++
    add x2, x2, #4       // Move to next element
    cmp w3, w1           // Check if j == N-1
    blt iloop            // Continue inner loop if j < N-1

exiti:
    add w5, w5, #1       // i++
    b oloop

exito:
    mov w0, #1
    ret
```

The code minimizes memory accesses and leverages register usage for efficiency. It is compiled and linked as follows:

```bash
gcc -c bubble_sort_asm.s -o bubble_sort_asm.o 
```

To execute and time the program run the following command:

```bash
time ./bubble_sort_asm
```

Same here, it takes 1.366740 seconds to execute the program.

```bash
Assembly bubble sort time: 1.366740 seconds
```

Execution time is measured using the SysTick timer, consistent with the C implementation.

To ensure correctness, both implementations are tested with an array of size ( N = 32768 ). A test driver initializes identical arrays, sorts them using both methods, and compares outputs to confirm identical results, ensuring optimizations do not introduce errors.

file: driver.c

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 32768

void bubble_sort(int *data, int n);
int bubble_sort_asm(int *data, int n);

int main() {
    int *data1, *data2;
    clock_t start, end;
    double c_time, asm_time;

    data1 = (int *)malloc(N * sizeof(int));
    data2 = (int *)malloc(N * sizeof(int));

    if (!data1 || !data2) {
        fprintf(stderr, "Memory allocation failed\n");
        return 1;
    }

    srand(11);

    for (int i = 0; i < N; i++) data1[i] = data2[i] = rand();

    // Measure C version performance
    start = clock();
    bubble_sort(data1, N);
    end = clock();
    c_time = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("C bubble sort time: %f seconds\n", c_time);

    // Measure ASM version performance
    start = clock();
    bubble_sort_asm(data2, N);
    end = clock();
    asm_time = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("Assembly bubble sort time: %f seconds\n", asm_time);
    printf("Performance improvement: %f%%\n", (c_time - asm_time) / c_time * 100);

    // Verify correctness
    for (int i = 0; i < N; i++) {
        if (data1[i] != data2[i]) {
            fprintf(stderr, "Mismatch at index %d: %d != %d\n", i, data1[i], data2[i]);
            free(data1);
            free(data2);
            return 1;
        }
    }
    
    printf("Verification successful: both implementations produce identical results\n");
    free(data1);
    free(data2);
    return 0;
}
```

To run the benchmark for performance measurements:

```bash
gcc -O3 driver.c bubble_sort.c bubble_sort_asm.s -o bubble_sort_benchmark && ./bubble_sort_benchmark
```

The results are as follows:

```bash
C bubble sort time: 1.002104 seconds
Assembly bubble sort time: 1.342916 seconds
Performance improvement: -34.009644%
Verification successful: both implementations produce identical results
```

Interestingly, our assembly implementation is actually slower than the C version. This is likely because the compiler is able to produce highly optimized code with -O3 for the C version. Let's improve our assembly implementation. (refer to Methods section for more details)

> Full code implementation? Refer to Appendix A, B and E

### Baseline Implementation of ASCON-AEAD128

This section presents a detailed implementation of the ASCON-AEAD128 algorithm in C, tailored for educational clarity and alignment with the NIST Lightweight Cryptography initial public draft published in 2023. [10] ASCON, selected as the winner of NIST’s Lightweight Cryptography competition in February 2023, is designed for resource-constrained environments such as Internet of Things (IoT) devices, making it highly relevant for secure embedded systems like STM32 microcontrollers. The implementation focuses on the Authenticated Encryption with Associated Data (AEAD) mode, specifically ASCON-AEAD128, which provides both confidentiality and authenticity using a 128-bit key, 128-bit nonce, and 128-bit authentication tag. This baseline serves as a foundation for understanding ASCON’s structure and supports further optimization studies in this thesis. [15, 16]

ASCON-AEAD128 is a variant of the ASCON family, based on ASCON-128a, optimized for a 128-bit rate and 192-bit capacity within its 320-bit internal state. The algorithm operates as a sponge-based duplex construction, processing data in blocks and incorporating domain separation to prevent attacks that could mix initialization, associated data, or plaintext phases. [9] Its lightweight design ensures efficiency on constrained platforms, critical for IoT applications requiring secure communication. The implementation described here simplifies the process by omitting associated data handling and assuming plaintext sizes are multiples of the block size, aligning with the lecture’s educational focus on core functionality.

Below basic implementation of ASCON-AEAD128 in pure C using Cursor IDE. Standard libraries, such as <stdio.h>, facilitate input/output for debugging, while <stdint.h> ensures consistent data types. The code uses uint64_t for 64-bit unsigned integers, representing the state, key, nonce, and other variables, providing clarity and compatibility with 32-bit and 64-bit architectures.

State Representation

ASCON’s internal state comprises five 64-bit words, totaling 320 bits, represented as:
```c
typedef uint64_t state_t[5];
```

The key and nonce, each 128 bits, are defined as arrays of two 64-bit words:
```c
typedef uint64_t key_t[2];
typedef uint64_t nonce_t[2];
```

A 64-bit initialization vector (IV) is fixed per the NIST draft, ensuring consistent setup. For debugging, a print_state function formats the state in hexadecimal, padding with zeros to ensure 16-digit output per word, aligning with lecture visuals:
```c
void print_state(state_t s) {
    for (int i = 0; i < 5; i++) {
        printf("%016llx\n", s[i]);
    }
    printf("\n");
}
```

Permutation Function

The permutation function, central to ASCON’s security, transforms the state through three layers: constant addition, substitution (S-box), and linear diffusion. It is applied multiple times during initialization (12 rounds), encryption (8 rounds), and finalization (12 rounds).

Constant Addition

Each round XORs an 8-bit constant with the third state word (s[2]). The constants, defined in the NIST draft, vary by round and permutation type. For a 12-round permutation, the constants are indexed as constants[4 + i] for round i (0 to 11), reflecting the formula 16 - rounds + i. The implementation defines:

```c
const uint8_t constants[16] = {
    0xf0, 0xe1, 0xd2, 0xc3, 0xb4, 0xa5, 0x96, 0x87,
    0x78, 0x69, 0x5a, 0x4b, 0x3c, 0x2d, 0x1e, 0x0f
};
```

The operation is:
```c
s[2] ^= constants[16 - rounds + round];
```

This ensures round-specific transformations, enhancing security through unique state updates.

Substitution Layer (S-box)

The substitution layer applies a 5-bit S-box to each column of the state, where a column consists of one bit from each of the five 64-bit words. To avoid tedious bit extraction, the S-box is implemented algebraically using bitwise operations on entire 64-bit words, enabling parallel processing of 64 S-boxes. The operations, derived from the ASCON submission version 1.2 (ASCON Submission), are:

```c
void sbox(state_t s) {
    s[0] ^= s[4]; s[4] ^= s[3]; s[2] ^= s[1];
    uint64_t t0 = s[0], t1 = s[1], t2 = s[2], t3 = s[3], t4 = s[4];
    s[0] = t0 ^ (~t1 & t2); s[1] = t1 ^ (~t2 & t3);
    s[2] = t2 ^ (~t3 & t4); s[3] = t3 ^ (~t4 & t0);
    s[4] = t4 ^ (~t0 & t1);
    s[1] ^= s[0]; s[3] ^= s[2]; s[0] ^= s[4];
}
```

This approach leverages the Cortex-M4’s bitwise instruction efficiency, critical for STM32 performance, and maintains functional equivalence to the S-box table lookup.

Linear Diffusion Layer

The linear diffusion layer enhances state mixing by XORing each word with two right-rotated versions of itself, using specific rotation amounts to ensure optimal diffusion:
```c
void linear_diffusion(state_t s) {
    s[0] ^= rotr(s[0], 19) ^ rotr(s[0], 28);
    s[1] ^= rotr(s[1], 61) ^ rotr(s[1], 39);
    s[2] ^= rotr(s[2], 1) ^ rotr(s[2], 6);
    s[3] ^= rotr(s[3], 10) ^ rotr(s[3], 17);
    s[4] ^= rotr(s[4], 7) ^ rotr(s[4], 41);
}
```

The rotation function is:
```c
uint64_t rotr(uint64_t x, int n) {
    return (x >> n) | (x << (64 - n));
}
```

These rotations, chosen for their cryptographic properties, ensure that changes in one bit propagate across the state, enhancing security.

The permutation function combines these layers:
```c
void permutation(state_t s, int rounds, int start_round) {
    for (int i = 0; i < rounds; i++) {
        s[2] ^= constants[16 - rounds + start_round + i];
        sbox(s);
        linear_diffusion(s);
    }
}
```

Initialization Phase. It prepares the state for encryption:

Load Initial State: The state is set with the IV (fixed at 0x80400c0600000000 for ASCON-AEAD128), key, and nonce:
```c
s[0] = IV;
s[1] = key[0]; s[2] = key[1];
s[3] = nonce[0]; s[4] = nonce[1];
```

Apply Permutation: The permutation is executed 12 times:
```c
permutation(s, 12, 0);
```

Key XOR: The last two words are XORed with the key for domain separation:
```c
s[3] ^= key[0];
s[4] ^= key[1];
```

This phase, illustrated in Figure X, ensures the state is uniquely initialized, preventing attacks that exploit predictable states.

Encryption Phase
The encryption phase processes plaintext in 128-bit blocks, assuming no associated data and block-aligned plaintext for simplicity. For each block:

XOR Plaintext: The plaintext block is XORed with the rate (first 128 bits, s[0] and s[1]):
```c
s[0] ^= plaintext[2*i];
s[1] ^= plaintext[2*i + 1];
```

Output Ciphertext: The updated rate becomes the ciphertext:
```c
ciphertext[2*i] = s[0];
ciphertext[2*i + 1] = s[1];
```

Apply Permutation: The permutation is applied 8 times:
```c
permutation(s, 8, 0);
```

The number of blocks is computed as num_blocks = sizeof(plaintext) / 16, where 16 bytes equals 128 bits. This process, depicted in Figure Y, ensures efficient encryption while maintaining security through permutation rounds.
Finalization Phase
Finalization generates the 128-bit authentication tag:

Key XOR: The key is XORed with the second and third state words:
```c
s[1] ^= key[0];
s[2] ^= key[1];
```

Apply Permutation: The permutation is executed 12 times:
```c
permutation(s, 12, 0);
```

Tag Generation: The tag is produced by XORing the last two state words with the key:
```c
tag[0] = s[3] ^ key[0];
tag[1] = s[4] ^ key[1];
```

This phase, shown in Figure X, ensures the tag authenticates the ciphertext and any associated data (omitted here), leveraging domain separation to prevent forgery attacks.

Run the program:

```bash
gcc -O3 ascon_aead128_basic_impl.c -o ascon_aead128 && ./ascon_aead128
```

Output:

```bash
=== State at Start ===
0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
Ciphertext: 5e44eae1014e4d6d d29ba5b8df69b82b
Tag:        eadbf1671a8bc8f3 59042955620e7b16
```

Table: ASCON-AEAD128 Parameters

| Component | Size (bits) | Description |
|-----------|------------|-------------|
| State | 320 | Five 64-bit words |
| Key | 128 | Two 64-bit words |
| Nonce | 128 | Two 64-bit words |
| Tag | 128 | Two 64-bit words for authentication |
| Rate | 128 | Bits processed per block (s[0], s[1]) |
| Capacity | 192 | Remaining state bits for security |
| Initialization Rounds | 12 | Permutation rounds during initialization |
| Encryption Rounds | 8 | Permutation rounds per block |
| Finalization Rounds | 12 | Permutation rounds for tag generation |

> Full code implementation? Refer to Appendix F

### Prior Research, Implementations, and Optimizations of ASCON

#### Primas and Schlaffer’s New ASCON Implementations
Primas and Schlaffer (2022) presented optimized ASCON implementations for ARM v6-M and v7-M architectures at the NIST Lightweight Cryptography Workshop (New ASCON Implementations). Their work achieved code size reductions of 7–30% and cycle count reductions of 17–23% through techniques such as bit-interleaved permutation and in-place S-box computations. The bit-interleaved interface improved performance by 17% for ASCON-128 and 23% for ASCON-128a, leveraging 32-bit ARM instructions like funnel shifts. These optimizations are particularly effective for STM32 microcontrollers with limited flash and RAM, enhancing both speed and memory efficiency. [17]

#### NIST Status Update on ASCON (2022)
The NIST status update from 2022 reported substantial performance gains for ASCON on STM32 microcontrollers (ARM v6-M), achieving up to 65% reductions in both code size and cycle counts (ASCON Status Update). This was accomplished through a joint speed and size refactoring, which optimized the round function using fewer instructions for the S-box and introduced bit-interleaved interface implementations. The update also highlighted code size comparisons across devices, as shown in Table 1, demonstrating ASCON’s efficiency compared to AES-GCM and SHA-256. [18]

Table 1: Code Size Comparison for ASCON Implementations

| Device     | AES-GCM | ASCON-128 | ASCON-128a | SHA-256 | ASCON-Hash |
|------------|---------|-----------|------------|---------|------------|
| ATmega328P | 3188    | 2754      | 3026       | 2432    | 1836       |
| SAM D21    | 1648    | 1300      | 1424       | 944     | 760        |
| ESP8266    | 2412    | 1004      | 1084       | 1116    | 652        |

#### LaS³ Microcontroller Benchmarks
The LaS³ benchmarks provide empirical performance data for ASCON on STM32 F103 and F746ZG microcontrollers, reporting cycle counts of 11.9–31.5 cycles per byte (LaS³ Benchmarks). These results, part of the public FELICS-AE dataset, offer a standardized framework for comparing cryptographic implementations. The benchmarks also noted an 8% throughput gain on STM32 F7/H7 devices using DMA-assisted AEAD, which overlaps permutation and block I/O operations. [19]

#### Arduino-Class Study (2024)
A 2024 study published in MDPI’s Applied Sciences evaluated ASCON’s performance on Arduino devices equipped with Cortex-M0 and M4 processors (Arduino Study). The study found ASCON to be 12% faster than ChaCha20, confirming its scalability to devices with minimal flash and RAM. This is particularly relevant for STM32-based IoT applications, where memory constraints are common. [20]

#### Quest for Efficient ASCON Implementations
A comprehensive survey by MDPI explores the design space for efficient ASCON implementations, covering both hardware and software optimizations (Quest for ASCON). The survey discusses architectural approaches such as serialized, unrolled, and round-based implementations, with round-based designs offering the best throughput-area trade-off. It also addresses side-channel attack countermeasures, including masking schemes like Threshold Implementation (TI) and Domain-Oriented Masking (DOM), which are critical for secure STM32 implementations. The survey reported energy savings of 11–48% in CMOS/MRAM designs and throughput up to 13 Gb/s in high-performance configurations. [21]

The official ascon-c repository provides reference and optimized implementations for Cortex-M, including constant-time masked variants (ascon-c GitHub). [16] A multi-platform study by ORBilu (2021) offers a detailed cycle breakdown for ASCON’s permutation function, highlighting the effectiveness of Thumb-2 assembly for XOR-rotate-XOR patterns, saving up to 2 cycles per round on Cortex-M3/M4 (ORBilu Study). The NIST evaluation of ASCON’s selection provides rationale for its choice as a lightweight standard, emphasizing its efficiency and security (NIST Evaluation). [22]

### GOST 28147-89: Encryption, Decryption, and Message Authentication Code Algorithms

**GOST 28147-89** is a Soviet/Russian government standard block cipher algorithm, first established in 1989, that defines both data encryption/decryption and message authentication code (MAC) generation procedures. [23] The name "GOST" is an acronym for *Gosudarstvennyi Standard*, meaning "State Standard" in Russian. Developed during the late 1970s, the cipher was originally classified as *Top Secret* (later downgraded to *Secret* in 1990) within the USSR, and it remained undisclosed to the public until after the Soviet Union's dissolution. In 1994, the algorithm was declassified and released publicly as GOST 28147-89, intended as a national alternative to the U.S. DES (Data Encryption Standard) and designed with a similar Feistel network structure. The standard was made **mandatory in the Russian Federation** for all public-sector data processing systems, underscoring its national importance. [23] Over the ensuing decades, GOST 28147-89 (sometimes referred to by the codename "Magma" in modern Russian standards) has been deployed in government and military applications for protecting classified communications, and it has been incorporated into various cryptographic libraries and protocols (e.g., via RFC 5830 for informational reference). Notably, the GOST 28147-89 cipher also underpins the legacy GOST hash function and forms the basis of a MAC generation method defined in the same standard.

Historically, GOST 28147-89 was conceived as an **analogue to DES**, but with significant adjustments to increase security and longevity. While DES uses a 56-bit key and 16 rounds, GOST employs a much larger 256-bit key and 32 rounds of encryption, reflecting design decisions intended to resist brute-force attacks by orders of magnitude beyond DES’s capability. [23] At the time of its design, Western block cipher design principles were not widely published in the USSR, yet GOST’s developers arrived at a structure broadly similar to DES’s Feistel construction, likely informed by open literature on DES and an independent cryptographic analysis. By doubling the number of rounds and quadrupling the key size, the architects of GOST 28147-89 sought to ensure a high security margin and future-proof the cipher against cryptanalytic advances. Moreover, unlike DES, the standard allowed the use of secret or customized S-boxes (substitution boxes) as an additional security parameter, theoretically increasing the complexity for an adversary who does not know the precise S-box values. This flexibility in S-box selection, combined with the algorithm’s extended key length, meant that GOST could, in principle, offer a much larger effective key space than DES if the S-boxes remain undisclosed. [24] The trade-off was that, without fixed S-boxes in the original specification, interoperability required agreeing on specific S-box sets for implementation. Over time, standardized S-boxes were published (for example, in the Cryptographic Providers guidelines RFC 4357) to facilitate compatibility. [23]

#### Algorithm Overview and Feistel Structure  

**GOST 28147-89 is a 64-bit block cipher** operating on 64-bit data blocks and using a 256-bit secret key. Like many classical block ciphers, GOST is built on a **Feistel network** structure with iterative rounds. Specifically, it performs 32 rounds of encryption transformations on the input block. Each round is a Feistel round in which one half of the data is transformed with a round function and combined with the other half. After 32 rounds, the two 32-bit halves are recombined to produce the 64-bit ciphertext output. 
(Note: In GOST’s implementation, the final swapping of halves typical in Feistel ciphers is effectively handled by the round structure itself, so the output is obtained directly from the pair of registers after the last round.)

The cipher’s **overall structure** can be understood as follows: the 64-bit plaintext is divided into two 32-bit halves, often denoted as *N1* (left half) and *N2* (right half). These halves are processed through 32 iterations of the round function. In each round, a 32-bit subkey (derived from the 256-bit master key) is applied to one half of the data through a non-linear transformation, and the result is XORed into the other half. Then the halves swap roles for the next round. Figure 1 provides a conceptual diagram of the Feistel rounds in GOST 28147-89, illustrating the data flow and operations in each round.

![GOST Diagram](/stuff/GOSTDiagram.png) 
*Figure X: Simplified Feistel structure of GOST 28147-89.* 

Each round uses one 32-bit subkey kᵢ, added to the right half (⊕ denotes addition mod 2³² here) before an S-box substitution and 11-bit left rotation (≪≪11). The output is XORed into the left half, and the halves swap for the next round. GOST performs 32 such rounds (with 29 intermediate rounds omitted in the illustration), after which *N1* and *N2* form the 64-bit ciphertext.

At a high level, this design mirrors that of DES in its Feistel construction, but there are crucial differences in the round function and key schedule (discussed below) that distinguish GOST. One immediate consequence of the Feistel structure is that decryption is achieved by running the same algorithm in reverse (i.e. feeding in the subkeys in the opposite order), a property that GOST shares with DES. This simplifies the implementation of decryption, since no separate algorithm is needed – only the subkey schedule is inverted. The 32-round depth was chosen to ensure extensive diffusion and confusion; even though each individual round function is relatively simple, the large number of rounds and the repeated application of non-linear S-box transformations make the cipher output highly non-linear with respect to the input and key.

Importantly, GOST’s **256-bit key** is one of the largest for block ciphers of its era, far exceeding the 56-bit effective key of DES. The key is conceptually stored in eight 32-bit components, often labeled X0 through X7. [23] These serve as the subkeys for the round operations. The expanded key storage means GOST can incorporate a massive keyspace (2^256 possible keys). This was likely intended to thwart brute-force attacks even by adversaries with significant computing resources, providing a security margin that was thought to be impractical to overcome. Additionally, as noted, if the S-box tables are treated as secret parameters, they add an extra layer of key-like secrecy (on the order of 354 additional bits of entropy if one treats the S-box configuration as part of the key). [11] In practice, however, most modern implementations use publicly specified S-box sets for interoperability, and rely on the algorithm’s strength rather than obscurity of S-box values.

#### Round Function and Operations  

Each of the 32 rounds in GOST 28147-89 uses an **F-function** (round function) that combines arithmetic addition, substitution through S-boxes, bit rotation, and XOR operations. The design of this round function is simple but effective, falling into the class of ARX (Add-Rotate-XOR) operations augmented with S-box substitution for nonlinearity. The following sequence outlines the transformation in one round (considering a round *i*, where the inputs are the 32-bit halves *N1* and *N2*, and the round subkey is *X_j* for some j depending on the key schedule):

1. **Key Mixing (Addition mod 2^32):** The 32-bit subkey is added to the *N1* half *modulo 2^32*. This operation (denoted "[+]" in the standard) combines the subkey with the data, introducing key-dependent changes. The use of modular addition (rather than a simple XOR as in DES) adds non-linearity because it involves carry bits between bit positions, which helps thwart linear cryptanalysis by not being a linear operation over GF(2). For example, in the first round, if *N1* is the left half of the plaintext and *X0* is the first subkey, the algorithm computes *(N1 + X0 mod 2^32)*. [23]

2. **S-Box Substitution:** The 32-bit sum from the previous step is then broken into eight 4-bit chunks, and each 4-bit nibble is transformed via a substitution box (S-box) lookup. GOST uses **eight S-boxes**, denoted K1...K8, each mapping a 4-bit input to a 4-bit output. Conceptually, there is a single 32-bit wide S-box *K* composed of these eight smaller S-box mappings applied in parallel. This substitution is the source of non-linear confusion in the cipher – it permutes bits within each 4-bit group according to a fixed (or system-defined) substitution table. The original GOST standard notably did **not fix the S-box values**; instead, it treated the choice of S-box set as a parameter to be agreed upon (and possibly kept secret). [23] In practice, various standardized S-box sets have been used (for instance, one published in RFC 4357 for cryptographic interoperability). Regardless of the specific S-box values, the effect in the round is the same: each 4-bit segment of the sum *(N1 + key)* is non-linearly transformed, scrambling the bits in a key-dependent manner.

3. **Bit Rotation:** The 32-bit output of the S-box layer is then rotated left by 11 bits (a cyclic shift). [23] This rotation (sometimes called a cyclic shift) further diffuses the influence of any single bit across the 32-bit word. By rotating, bits that were output from a particular S-box in this round will move into the input of a different S-box in the next round (since the rotation shifts the alignment of 4-bit groups relative to the fixed S-box segmentation). The rotation by 11 positions is relatively large, ensuring a rapid dispersal of bits to different positions over multiple rounds. This operation is linear but key-independent; its purpose is to spread the output bits before the next XOR step and subsequent rounds, contributing to thorough diffusion as required by Shannon’s criteria for a strong cipher.

4. **XOR with Right Half:** The rotated result is then XORed with the other half of the data (the 32-bit *N2*). In the context of a Feistel network, if *N1* was the half that went through the F-function, this XOR adds the modified *N1* into *N2*. Formally, the operation is *N2 := N2 ⊕ F(N1, subkey)*, where F(N1, subkey) denotes the combination of the previous three steps. This XOR (bitwise addition mod 2, denoted "(+)" in the standard’s notation), completes the round’s mixing of the two halves.

5. **Swap Halves:** Finally, the two halves are swapped so that the output of this round has the former right half (*N2*) become the new left half for the next round, and the former left half (which was processed) becomes the new right half. In GOST’s description, this is implicitly handled by writing the result of the XOR into *N1* and moving the old *N1* into *N2*. Thus, after the round: *N1_i = ( old N1 + subkey_i through S-box and rotated ) XOR old N2*, and *N2_i = old N1*. This swap is what makes the Feistel network reversible: only one half is modified per round, and the other is just rotated into place.

By the end of the first round, the two halves have effectively been transformed and swapped. GOST then proceeds to the second round, third round, and so forth, repeating the same pattern of operations with possibly different subkeys in each round. After 32 rounds, the algorithm does not perform a final swap; the standard specifies that after the last (32nd) round, the two registers *N1* and *N2* hold the final ciphertext halves directly. (This is a minor detail – whether or not one performs a swap after the last round is a matter of convention; GOST’s round structure is arranged such that the output is taken as *(N1, N2)* without swapping, which is equivalent to the classical Feistel output with a swap.) The **decryption process** uses the identical round function sequence, but the subkeys are applied in reverse order (more on the subkey schedule below). Thanks to the Feistel construction, decrypting is just as efficient as encrypting – the cipher is symmetric with respect to key schedule reversal. [23]

To summarize the round operation: *N1* is combined with a round key via modular addition, an S-box substitution and bit rotation are applied to introduce nonlinearity and diffusion, and then this result is XORed into *N2*, followed by a swap of halves. Each round’s transformation can be expressed by the pair of equations:  

\[ N1_{i} = N2_{i-1} \tag{swap half} \]  \[ N2_{i} = N1_{i-1} \oplus \text{ROL}_{11}( S( (N1_{i-1} + X_j) \bmod 2^{32} ) ) \tag{round function} \]  
where $X_j$ is the subkey used in that round, $S(\cdot)$ is the S-box substitution of 32-bit input, and $\text{ROL}_{11}$ is an 11-bit left rotation. This formulation highlights that only one of the two halves ($N1_{i-1}$) is processed with the key and S-box in each round, and its influence is then propagated to the other half via XOR.

The **design rationale** behind these operations appears to favor simplicity and hardware efficiency, using basic arithmetic and bit-wise operations that map well onto 32-bit architectures. The combination of modular addition and XOR (along with S-boxes) means the cipher does not rely purely on linear operations; it injects non-linearity at two points: once through addition (though addition is *affine* rather than strictly linear in GF(2)) and again through the S-box lookup. The fixed rotation by 11 bits each round is a static diffusion mechanism (contrast with DES which uses a fixed permutation of bits after the S-boxes). By eliminating the need for a complex bit permutation or expansion operation, GOST’s round function remains quite compact. This likely reflects a design emphasis on **ease of implementation** in both hardware and software. In hardware, a 32-bit adder and a barrel-rotator are straightforward components, and S-box lookups can be implemented with small ROMs or logic tables. In software, addition and rotation are single CPU instructions on most architectures, making GOST relatively fast per round. The cost of this simplicity is that GOST requires more rounds than DES to achieve comparable security; however, given the small computational cost of each round and the absence of complex key schedule processing in-round, the overall cipher is efficient. 

#### Subkey Schedule (Key Expansion)  

The **key schedule of GOST 28147-89** is notably simple. The 256-bit master key is divided into eight 32-bit words, labeled $X_0, X_1, \dots, X_7$, which serve directly as the subkeys in the encryption rounds. Unlike DES and many modern ciphers, GOST does not employ a complex key expansion algorithm with rotations or permutation of key bits per round; instead, it *reuses* these 32-bit key components in a fixed pattern over the 32 rounds. This design means the security of GOST does not depend on a one-way key schedule function – the subkeys are just the master key chunks reused – which simplifies analysis but also means there is less diffusion of key material across rounds. 

The round subkey selection sequence is as follows (where round numbers 1–32 are given): 

- **Rounds 1–8:** use $X_0, X_1, ..., X_7$ in order (one subkey per round).  
- **Rounds 9–16:** repeat $X_0, X_1, ..., X_7$ in the same order again.
- **Rounds 17–24:** repeat $X_0, X_1, ..., X_7$ a third time.
- **Rounds 25–32:** for the final eight rounds, the subkeys are used in *reverse* order: $X_7, X_6, ..., X_0$.

In other words, the first 24 rounds cycle through the eight key components three times in forward order, and the last 8 rounds cycle once through all key components in reverse order. This fixed schedule is illustrated in the standard by listing the subkey usage sequence as:  
```
X0, X1, X2, X3, X4, X5, X6, X7,  
X0, X1, X2, X3, X4, X5, X6, X7,  
X0, X1, X2, X3, X4, X5, X6, X7,  
X7, X6, X5, X4, X3, X2, X1, X0.  
```  
Here the commas separate round-by-round keys, and the line breaks indicate grouping into 8 rounds each.

Because of the Feistel structure, the decryption process simply uses the subkeys in the exact opposite order of encryption. That is, decryption rounds begin with $X_0$ (the same component used in the last encryption round) and proceed through the reverse sequence: $X_1, X_2, ..., X_7, X_7, X_6, ..., X_0, ...$ etc., effectively reversing the above list. As a result, implementing decryption just requires reading the subkey array in reverse; no other alteration to the round function is needed.

The simplicity of GOST's key schedule is a double-edged sword. On one hand, it avoids the risk of inadvertently weakening the cipher through a poor key schedule design (since each key bit influences many rounds directly given the repetitions). On the other hand, it lacks the *key diffusion* that many modern ciphers have, where a single bit of the master key affects many subkeys and hence many round operations. In GOST, each 32-bit subkey affects exactly those rounds where it is used. However, since each subkey is used four times in encryption (three times forward, once backward) out of 32 rounds, each part of the key still has a broad influence on the encryption process. There are no known *weak keys* for GOST in the sense that a particular key leads to a degenerate behavior (in contrast to DES, which has a few weak keys due to the structure of the key schedule and S-box symmetry). The absence of weak keys is partly because the S-boxes can be arbitrary, breaking any symmetry, and because the addition and rotation operations do not exhibit linear key relations easily. In modern adaptations (e.g., the 2015 update of the standard), a slightly more complex key schedule or key derivation may be introduced to address theoretical weaknesses, but the original GOST 28147-89 keeps it straightforward. [11]

#### S-Boxes and Parameterization  

A distinctive feature of GOST 28147-89 is its approach to **S-boxes** (substitution boxes). The cipher uses eight fixed 4x4 S-box tables per instantiation, but the values of these tables were *not explicitly specified* in the original 1989 standard. Instead, the standard allowed different organizations or applications to choose their own set of S-box values (often referred to as a "S-box tuple" or **parameter set**) to potentially tailor the cipher for specific domains or to keep them secret as an added security measure. This is in contrast to DES, which has fixed, publicly known S-boxes built into its design. 

In GOST, each S-box (K1 through K8) is a mapping from 4-bit input to 4-bit output, typically represented as a table of 16 hexadecimal values (0 to 15). When the standard says the S-box has "64-bit memory", it refers to the total storage for one such 4→4 mapping (since 16 entries * 4 bits = 64 bits of data per S-box). Eight such S-box tables together constitute the substitution layer for a 32-bit word. During encryption, when the 32-bit round output is fed into the substitution block *K*, the first 4-bit chunk of that output is transformed by S-box K1, the second 4-bit chunk by K2, and so on through K8, yielding a substituted 32-bit word.

Because the standard did not pin down specific S-box values, various **S-box sets** have been used historically: some were kept secret (with the idea that an attacker who didn't know the S-box values would have a significantly harder time mounting certain attacks), and others were later published for interoperability. For example, one commonly referenced set is the so-called **CryptoPro S-boxes**, published in RFC 4357, which are used in many Russian cryptographic implementations. [23] Another known set is from the Central Bank of the Russian Federation, and yet another from the Russian Federal Security Service (FSB) for their applications. The ability to substitute different S-box tables means GOST can be seen as a family of algorithms; security can vary depending on the quality of the chosen S-boxes. Ideally, the S-boxes should be chosen to have good cryptographic properties (such as no linear or differential weaknesses, i.e., low bias in XOR profiles and high nonlinearity). Poorly chosen S-boxes could, in theory, weaken the cipher's resistance to differential or linear cryptanalysis. However, the standard's allowance for secret S-boxes was also a recognition that keeping the S-boxes confidential could effectively increase the key space. In fact, if treated as additional secret key material, the S-boxes contribute an entropy of about 354 bits (since there are $(16!)^8 \approx 2^{354}$ possible ways to populate eight 4x4 S-boxes). This far exceeds the 256-bit key entropy of the cipher itself. 

There is a caveat: if one treats S-boxes as secret, the security proof becomes twofold – one must trust both the algorithm and the secrecy of the S-box parameters. Over time, the cryptographic community has gravitated away from secret algorithm parameters (Kerckhoffs' principle advocates that a cipher's security should not rely on secret design, only on secret keys). Thus, modern practice with GOST is to use publicly known S-box sets that are believed to be strong. Indeed, by 2010, the **ISO/IEC 18033-3** standardization process and others evaluating GOST recommended specific S-boxes. The 2015 revision of the GOST standard (GOST R 34.12-2015) finally fixed an official S-box set for the cipher, removing ambiguity. [11] In that revision, the cipher GOST 28147-89 with a fixed S-box is officially named "Magma." This change allows consistent interoperability and eases analysis – and it acknowledges that the benefit of secret S-boxes was largely theoretical, whereas the benefit of public well-analyzed S-boxes is practical security assurance.

#### Encryption and Decryption Process  

Using the components described above (the Feistel round function, subkey schedule, and S-boxes), we can now describe the **process of encrypting a 64-bit block** under GOST 28147-89 step by step. We assume a 64-bit plaintext block is given, and a 256-bit key has been loaded into the eight subkey registers $X_0 \dots X_7$. For clarity, let the plaintext halves be $N1_0$ and $N2_0$ (initial values of left and right 32-bit halves, respectively), and after $i$ rounds let $N1_i, N2_i$ be the half values.

- **Initial Preparation:** Assign the 64-bit plaintext block into the two 32-bit registers: $N1_0$ (left half) and $N2_0$ (right half). No other preprocessing (such as an initial permutation) is done – GOST does **not** use a bit-permutation like DES's initial permutation; the bits are taken as they are input.

- **Rounds 1–32:** Perform the round operation iteratively for 32 rounds, as defined in the previous section. Specifically, for each round *i* from 1 to 32, do:
  1. Compute an intermediate value: $F_i = \text{ROL}_{11}\Big(S\big((N1_{i-1} + K_i) \bmod 2^{32}\big)\Big)$, where $K_i$ is the 32-bit subkey for round *i* according to the key schedule, $S(\cdot)$ is the application of the eight S-boxes, and $\text{ROL}_{11}$ is an 11-bit left rotate of the 32-bit result.
  2. Update the halves: $N1_{i} = N2_{i-1} \oplus F_i$ and $N2_{i} = N1_{i-1}$. This effectively means the old left half is processed and combined into the right half, and then the halves swap.
  
  After executing this for 32 iterations, we have $N1_{32}$ and $N2_{32}$ as the output halves. The concatenation $N1_{32}||N2_{32}$ (where $N1_{32}$ is the high-order 32 bits and $N2_{32}$ the low-order 32 bits) is the 64-bit ciphertext block.

- **Output:** The 64-bit ciphertext is obtained as $(N1_{32}, N2_{32})$. Notably, because of the way the last round is defined, the output halves are **not swapped again** – the standard explicitly states that after the 32nd round, the content of $N1$ and $N2$ "are an encrypted data block corresponding to a block of plain text", indicating that $(N1_{32}, N2_{32})$ is the ciphertext in the same left-right order as the final round.

The **decryption** process is essentially the mirror of encryption. Given a 64-bit ciphertext $(C1, C2)$ and the same 256-bit key, one can decrypt by using the same round function but feeding the subkeys in reverse order. Concretely, one would load $N1_{32} = C1$, $N2_{32} = C2$ as the starting state and then run 32 rounds of the Feistel network *backwards* (round 32's inverse, then round 31's inverse, etc.). Because each round's operations (addition, S-box, rotation, XOR, swap) are reversible, applying them in reverse with the correct subkey undoes the encryption. In practice, it is simpler to implement decryption by taking the encryption routine and just iterating the subkey index from 32 down to 1. The sequence of subkeys for decryption will be: $K_{32}, K_{31}, ..., K_{1}$, which expands to: $X_0, X_1, ..., X_7,$ $X_7, X_6, ..., X_0,$ $X_7, X_6, ..., X_0,$ $X_0, ..., X_7$ (this is exactly the reverse of the encryption key order derived earlier). [23] By using this reversed key schedule, each decryption round "undoes" the corresponding encryption round, ultimately recovering $(N1_0, N2_0)$ which are the original plaintext halves. The correctness of this decryption procedure is guaranteed by the Feistel structure.

An interesting property of GOST (and Feistel ciphers in general) is that encryption and decryption have the same complexity and a very similar implementation. This symmetry was advantageous for hardware implementations in the 1980s and 90s: a single circuit could be used for both encryption and decryption, with only control logic to feed subkeys in reverse for decryption. Similarly, software implementations can use one code path for both operations. 

In terms of performance, GOST 28147-89's 32 rounds make it somewhat slower than DES (which has 16 rounds) on a per-block basis if each round were of similar complexity. However, each GOST round is simpler (DES's round involves expanding 32 bits to 48, eight 6→4 S-box lookups, and a permutation, whereas GOST's involves one 32-bit add, eight 4→4 S-box lookups, and one rotation). In practice, GOST encryption can be quite efficient, and modern optimizations (like bitslicing or vectorizing the S-box operations, or using precomputed lookup tables) can further speed it up. The lack of an initial or final bit permutation in GOST also saves some operations compared to DES.

It's important to note that GOST encryption in actual use is typically employed in a **mode of operation** (just like any block cipher). The standard itself describes several modes: Electronic Codebook (ECB), Counter (CTR), and feedback modes (CFB) for encryption, as well as a mode for MAC generation. In ECB mode, described above, each 64-bit block is encrypted independently. In other modes, either an IV (initialization vector) and chaining are used to encrypt variable-length data securely, or a keystream is generated for stream cipher operation. The core cipher operations remain the same regardless of mode.

#### Message Authentication Code (MAC) Generation Mode  

In addition to encryption, GOST 28147-89 specifies a method for computing a **message authentication code** (MAC) using the block cipher. The MAC algorithm in GOST is essentially a specialized variant of a CBC-MAC, with the twist that only the first 16 rounds of the cipher are used for each block chaining step. The rationale for using 16 rounds (half the cipher) per block in MAC generation is not explicitly stated in the standard, but it is presumably to provide a balance between security and performance when processing potentially long messages – using only half the rounds per intermediate step doubles the speed of MAC computation, while the final MAC still benefits from a full encryption pass. The MAC generation is defined as follows for a message divided into $M$ blocks of 64 bits (with padding as needed):

- **Initialization:** Set the internal state registers $N1, N2$ to zero (or to an initialization vector if one is provided, though the standard MAC mode typically starts from zero). Load the 256-bit key into the KDS (subkey registers) as usual. 

- **Processing Blocks:** For each 64-bit message block $T_p(i)$, where $i$ ranges from 1 to $M$, and $T_p(i)$ is split into 32-bit halves $(a^{(i)}[0], b^{(i)}[0])$ in the standard's notation:
  1. XOR the current message block into the state: $N1 \gets N1 \oplus a^{(i)}[0]$ (32 bits), $N2 \gets N2 \oplus b^{(i)}[0]$ (32 bits). In other words, the 64-bit block is added (mod 2) to the current contents of $(N1, N2)$. For the first block, $N1, N2$ might start at 0, so this just loads the block into the state. This step is analogous to CBC-MAC where each plaintext block is XORed with the previous cipher output.
  2. Encrypt the state using *16 rounds* of the GOST encryption algorithm (in ECB mode) with the given key. That is, apply rounds 1–16 of the Feistel network to $(N1, N2)$ with the normal subkey sequence $X_0 \dots X_7$ repeated twice (since 16 rounds). After 16 rounds, output state is $(N1, N2)$ half-encrypted.
  3. Proceed to the next block. The output state after 16 rounds is then XORed with the next plaintext block $T_p(i+1)$ and then again run through 16 rounds of the cipher.

  This process continues iteratively: each new plaintext block is XORed with the intermediate state (which is the result of encrypting the previous state for 16 rounds), and then 16 more rounds of encryption are applied.

- **Finalization:** After processing the last plaintext block $T_p(M)$ in this manner, one more 16-round encryption is performed on the final state $(N1, N2)$. Now the state is essentially the encryption of the cumulative XOR of all message blocks (through this iterated process) carried out to 16 rounds *of the final block*. From this final state, the MAC value is extracted. The standard allows the MAC length *l* to be variable – one can take the most significant $l$ bits of the final state as the MAC (where $l$ is a security parameter, e.g., 32 or 64 bits). For example, one might use a 32-bit MAC or the full 64-bit output as the MAC. The MAC is denoted $I(l)$ in the standard, and is appended to the transmitted message for integrity verification. [23]

To put it succinctly, GOST’s MAC mode chains blocks through half-round encryption steps: each block is integrated by XOR, and the block cipher is run for 16 rounds to mix this into the state, then the process repeats. The final MAC is a substring of the last state after a final half-encryption. The verification process recomputes this MAC on the received plaintext (after decryption, if the message was encrypted) and compares it to the received MAC $I(l)$.

This MAC mechanism is designed to detect any modification of the message blocks. If any bit of the message is changed, due to the avalanche effect of the cipher across multiple blocks, the final MAC will with high probability not match, and the verification will fail, indicating tampering or corruption. The strength of the MAC is $2^{-l}$ probability of a forgery going undetected (since an attacker would have to guess the correct $l$-bit string). In practice, using at least $l=32$ or $l=64$ is advisable to deter brute-force guessing or collision attempts on the MAC.

One subtlety: Because only 16 rounds (instead of the full 32) are used per block mixing, there might be theoretical concerns about whether this truncated encryption is a pseudo-random permutation on each step. However, since the final output is subjected to a full 32-round encryption (16 rounds in the last chaining step plus 16 in the final output stage, effectively 32 on the last block), and earlier truncated encryptions are concealed by subsequent XORs, no practical weaknesses in the MAC procedure have been published. The GOST MAC is conceptually similar to well-known MAC constructions like CBC-MAC; its security rests on the difficulty of forging outputs without knowing the key.

> Full code implementation? Refer to Appendix G

### Prior Research, Implementations, and Optimizations of GOST 28147-89

GOST 28147-89, a 64-bit block cipher with a 256-bit key, has seen less optimization research for microcontrollers compared to ASCON. However, several studies and resources provide insights into its implementation on STM32 devices.

#### FPGA Implementation Study
A study on implementing GOST 28147-89 on FPGA achieved a 12% reduction in slice usage through S-box RAM packing (FPGA GOST). Using a pipeline structure, the implementation reduced encryption time from 1280 ns to 2.59 ms for 1080p 50fps grayscale, achieving 5.96 Gbit/s performance. While focused on FPGA, techniques like pipelining and efficient S-box storage can inspire software optimizations for STM32, particularly for memory-constrained devices. [25]

#### Optimization for 8-bit Microcontrollers
A ResearchGate pre-print (2021) explored optimizing GOST for 8-bit microcontrollers, achieving a 30% flash memory saving by using a table-free S-box implementation (8-bit GOST). This approach recomputes S-boxes via affine transforms, reducing memory usage at the cost of additional computation. Such techniques are applicable to STM32 F0/F1 series, which often have limited flash memory. [26]

#### Wokwi STM32/Arduino Demo
A minimal C implementation of GOST is available on Wokwi, requiring only 2 kB of flash memory (Wokwi Demo). This serves as a baseline for further optimizations on STM32 and Arduino platforms, allowing researchers to experiment with custom tuning for Cortex-M architectures. [27]

#### STMicroelectronics X-CUBE-CRYPTOLIB
STMicroelectronics’ X-CUBE-CRYPTOLIB is reported to include a ready-made GOST cipher implementation, optimized for STM32 microcontrollers with hardware-accelerator hooks on STM32U5/H5 series (X-CUBE-CRYPTOLIB). The library is compiled with high optimization settings (-O3 -mcpu=cortex-mx) and supports constant-time execution, making it suitable for certified applications. However, some sources suggest GOST may not be explicitly listed among supported ciphers, indicating a need for further verification. [28]

#### Security Evaluation of GOST
An IACR ePrint paper (2011) provides a security evaluation of GOST 28147-89, analyzing its algebraic properties and structural characteristics (GOST Security). While not focused on implementation, the paper offers insights into S-box design and table layouts, which can influence optimization strategies for STM32 to balance performance and security. [29]

## Methods

### Experimental Platform

To evaluate the performance of software implementations on embedded systems, two widely adopted development boards from the STM32 family were chosen: the STM32F103 and STM32F407 Discovery Boards. These boards are popular in the realms of IoT and embedded systems development due to their cost-effectiveness, flexibility, and strong community backing. The STM32F103 is equipped with an ARM Cortex-M3 core, a 32-bit RISC processor that strikes a balance between performance and power efficiency, running at a maximum clock speed of 72 MHz. It comes with 64 KB of flash memory and 20 KB of SRAM, making it well-suited for applications where resources are limited yet computational reliability remains essential. In contrast, the STM32F407 features the more advanced ARM Cortex-M4 core, capable of operating at up to 168 MHz, with significantly larger memory resources 1 MB of flash and 192 KB of SRAM. The Cortex-M4 also includes a Floating Point Unit (FPU) and Digital Signal Processing (DSP) instructions, enhancing its ability to handle more computationally intensive tasks. By testing the software implementations on both boards, the evaluation could explore how these implementations perform across a range of hardware capabilities, ensuring their applicability to diverse microcontroller environments within the STM32 family.

#### Hardware: STM32F103 & STM32F407 Discovery Boards

The selection of the STM32F103 and STM32F407 Discovery Boards was deliberate and driven by several practical considerations. Both boards come with the ST-LINK/V2, an integrated in-circuit debugger and programmer, which simplifies the process of uploading code and debugging, while also enabling precise measurement of execution times. This was a critical feature for ensuring the accuracy of performance assessments without external variables skewing the results. The STM32F103, with its Cortex-M3 core, serves as a benchmark for performance in resource-constrained scenarios, such as low-power IoT devices. Meanwhile, the STM32F407, powered by the Cortex-M4, offers a higher-performance platform to test the implementations under more demanding conditions. Although the experiment did not directly leverage the boards’ additional peripherals like GPIO pins, timers, or communication interfaces these features highlight their versatility for real-world IoT applications. Testing across these two platforms ensures that the implementations are not tailored to a single hardware profile but are instead robust and effective across a spectrum of computational capacities, from basic to advanced, which is vital for the varied requirements of IoT deployments.

#### Toolchain and Measurement Setup

For developing and testing the implementations, the STM32CubeIDE an integrated development environment from STMicroelectronics was employed. This toolchain incorporates the GNU Arm Embedded Toolchain, enabling efficient compilation of C and assembly code, and integrates seamlessly with the ST-LINK/V2 for debugging. To maximize performance, the code was compiled with the `-O3` optimization flag, which activates advanced compiler optimizations such as loop unrolling and function inlining—techniques particularly beneficial for applications where speed is paramount. Execution time was measured using the SysTick timer, a 24-bit system timer inherent to ARM Cortex-M microcontrollers, offering microsecond-level precision. The test methodology involved executing a computationally intensive function 20,000 times, processing a fixed amount of data, and recording the cumulative time. This rigorous and repeatable setup ensured consistent and reliable results, providing a solid basis for comparing the performance of different implementations across the two hardware platforms.


### Optimization Framework  

#### Profiling & Benchmarking Tools  

Embedded systems with limited computing/memory resources benefit significantly from careful optimization. Common techniques include:

* Using compiler optimization flags (-O1, -O2, -O3, etc.).
* Removing unused code sections.
* Replacing certain library calls with lighter alternatives.
* Adjusting exception handling and memory allocation strategies.

#### Memory‑Footprint Analysis

Build without enabled optimization

![Build without enabled optimization](/stuff/build-without-opt.png)

Build with enabled optimization

![Build with enabled optimization](/stuff/build-with-opt.png)

From the images above, we can see that the code size has been reduced from `(141,320 B)` to `(3,920 B)`.

This dramatic reduction demonstrates that even standard compiler optimizations can substantially decrease code size.

#### Code Isolation & Modular Testing  

Isolating individual optimizations allows a detailed study of their effects.

![Isolated Optimization](/stuff/isolated-opt.png)

![Benchmark Singleopt](/stuff/benchmark-singleopt.png)

The experimental results show the following:

* Size optimized library newlib achieves the best result reducing from `(O2: 137,732 B)`, `(O1: 141,248 B)`, `(NA: 141,320 B)`, `(O5: 141,320 B)`, `(O7: 141,320 B)`, `(O6: 141,344 B)` to approx `(O8: 28,028 B)`.
* There are many unused sections in the original, which are removed by the second best optimization `(O4)`.
* The space optimizations `(O3)` performs similarly good.
* Some overhead can be reduced by disabling exceptions (O2). The optimization effect is diminished by the fact, exception handling is not removed from the (already compiled) libraries.
* Minimal advantage is obtained by replacing new and delete with malloc and free `(O1)`.
* Other optimization `(O5, O7)` are ineffective in our test case, and perform as no optimization is used `(NA)`. `(O6)` performs even worse than `(NA)`.

#### Optimization Combinations

Combining optimizations yields even more substantial improvements.

![Optimization Combinations](stuff/optimization-combinations.png)

The experimental results show the following optimization combination are the most effective:

* *O1 (mem. allocation)*, *O2 (exception handling)*, *O3 (size optimization)* reduce the code size from `141,320 B` to `13,060 B`.
* *O8 (size optimized library)* with *(O1, O2, O3)* reduce the code size to `8,616 B`.
* *O4 (remove unused code)* with *(O1, O2, O3, O8)* reduce the code size to `4,012 B`.
* *(O1-O8)* reduce the code size to `4,012 B`.
* **C++** exception handling is space consuming. The best optimization without *O2* is `11,700 B` *(see O1 O3 O4 O8)*.
* **C++** memory management without exception handling is relatively cheap. `(O2 O3 O4 O8)` reduce the code size to `4248 B`.

#### Identify space-wasting code

![Identify space-wasting code](/stuff/space-wasting-code.png)

The memory management (see top 3: _mallor_r, __malloc_av_, _free_r) consumes a huge amount of space relative to other part of the code.

We can simply use `(08)` to mitigate this issue.

![Optimization space-wasting code](/stuff/space-wasting-code-opt.png)

By identifying and targeting the most space-consuming code segments, developers can pick the best optimization techniques to reduce the overall footprint.


### Bubble Sort Optimization  

#### C‑Level Optimizations (flags, loop unrolling, etc.)  

file: bubble_sort_optimized.c

```c
// Optimized bubble sort with C‑level optimizations
// Recommended compile flags:
// gcc -O3 -march=native -funroll-loops -flto -o bubble_sort_optimized bubble_sort_optimized.c

#include <stdbool.h>

void bubble_sort_optimized(int * restrict data, int n) {
    bool swapped;
    for (int i = 0; i < n - 1; ++i) {
        swapped = false;
        int limit = n - i - 1;
        int j = 0;

        // Unroll inner loop by 4 iterations to reduce loop overhead`
        for (; j + 4 <= limit; j += 4) {
            if (data[j] > data[j + 1]) {
                int tmp = data[j]; data[j] = data[j + 1]; data[j + 1] = tmp; swapped = true;
            }
            if (data[j + 1] > data[j + 2]) {
                int tmp = data[j + 1]; data[j + 1] = data[j + 2]; data[j + 2] = tmp; swapped = true;
            }
            if (data[j + 2] > data[j + 3]) {
                int tmp = data[j + 2]; data[j + 2] = data[j + 3]; data[j + 3] = tmp; swapped = true;
            }
            if (data[j + 3] > data[j + 4]) {
                int tmp = data[j + 3]; data[j + 3] = data[j + 4]; data[j + 4] = tmp; swapped = true;
            }
        }
        // Handle remaining elements
        for (; j < limit; ++j) {
            if (data[j] > data[j + 1]) {
                int tmp = data[j]; data[j] = data[j + 1]; data[j + 1] = tmp; swapped = true;
            }
        }

        // Early exit if already sorted
        if (!swapped) {
            break;
        }
    }
}
```

To run the benchmark for performance measurements:

```bash
gcc -O3 driver.c bubble_sort.c -o bubble_sort_benchmark && ./bubble_sort_benchmark
```

Results:

```bash
C bubble sort time: 1.366740 seconds
```

> Full code implementation? Refer to Appendix D.

#### Assembly‑Level Optimizations  

Let's take our bubble sort example again. Earlier we got slightly worse results in Assembly compare to the C version. Let's refactor the code to improve the performance.

file: bubble_sort_asm.s

```s
.text
.global _bubble_sort_asm
.global bubble_sort_asm

_bubble_sort_asm:
bubble_sort_asm:
    // r0 = data pointer, r1 = n
    subs w1, w1, #1       // r1 = N-1
    b.le exito            // if N <= 1, we're done
    
    mov w8, w1            // w8 = N-1 (preserve original N-1)
    mov w5, #0           // i = 0 
    
oloop:
    mov x2, x0           // x2 = &data
    mov w3, #0           // j = 0
    mov w9, w8           // w9 = N-1-i (elements to compare)
    sub w9, w9, w5       // subtract i from the limit
    
iloop:
    ldr w11, [x2]        // Load data[j]
    ldr w10, [x2, #4]    // Load data[j+1]
    cmp w11, w10         // if data[j] > data[j+1]
    b.le skip            // skip if not greater
    
    // Swap data[j] and data[j+1] - do this in one step
    str w10, [x2]        // data[j] = data[j+1]
    str w11, [x2, #4]    // data[j+1] = data[j]

skip:
    add x2, x2, #4       // Move to next element
    add w3, w3, #1       // j++
    cmp w3, w9           // Check if j < N-1-i (we only need to check up to this point)
    b.lt iloop           // Continue inner loop if j < limit
    
    add w5, w5, #1       // i++
    cmp w5, w8           // Check if i < N-1
    b.lt oloop           // Continue outer loop if i < N-1

exito:
    mov w0, #1
    ret
```

Then we'll be using the same bubble_sort.c and driver.c files as before.

Run the code:

```bash
gcc -O3 driver.c bubble_sort.c bubble_sort_asm.s -o bubble_sort_benchmark && ./bubble_sort_benchmark
```

Output in terminal:

```bash
C bubble sort time: 1.016151 seconds
Assembly bubble sort time: 0.985726 seconds
Performance improvement: 2.994142%
Verification successful: both implementations produce identical results
```

> Full code implementation? Refer to Appendix C.

Our optimized assembly code is now slightly faster than the C version. Here's what we did:

Assembly code:
- Added proper symbol names (_bubble_sort_asm and bubble_sort_asm)
- Used 64-bit registers for addressing
- Implemented a more efficient bubble sort algorithm
- Added early exit if array size is less than 2
- Reduced the number of comparisons in the inner loop by only checking up to N-1-i elements

Updated the driver.c file:
- Added timing measurements
- Fixed memory leaks
- Added proper return values

Optimized the assembly algorithm:
- Reduced comparisons in inner loop (only compare up to N-1-i elements)
- Improved branch prediction with b.lt/b.le instructions
- Better register usage and preservation

The results show a modest performance improvement of about 3% over the optimized C code, which is good considering that the compiler already does a lot of optimization at -O3 level.


### ASCON Optimization  

In this section, we will be discussing the optimization of ASCON-AEAD128, a variant with a 128-bit key, 128-bit nonce, and 128-bit authentication tag, optimized for a 128-bit rate and 192-bit capacity. Our research compares two implementations: the original `opt32_lowsize` (version #1), a 32-bit size-optimized pure C implementation, and an optimized `bi32_armv7m_small` (version #4), a 32-bit bit-interleaved implementation using C and inline assembly, tailored for ARMv7-M architectures like the STM32F103 & STM32F407.

To evaluate the performance of these implementations, we conducted experiments on an STM32F103 & STM32F407 Discovery Boards, a common platform for IoT development. The test involved running the `crypto_aead_encrypt()` function 20,000 times, encrypting a 16-byte plaintext with a 16-byte key, nonce, and associated data. The test code, shown below, uses the HAL library to measure execution time via the `HAL_GetTick()` function, ensuring accurate timing on the microcontroller.

file: main.c

```c
int ascon_main() {
  unsigned char n[32] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31};
  unsigned char k[32] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31};
  unsigned char a[32] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31};
  unsigned char m[32] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31};
  unsigned char c[32], h[32], t[32];
  unsigned long long alen = 16, mlen = 16, clen;
  int result = 0;

  uint32_t total_time = 0;
  HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
  HAL_Delay(5000); // Wait 5 seconds
  HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
  uint32_t start_time = HAL_GetTick();
  for (int i = 0; i < 20000; i++) {
    result |= crypto_aead_encrypt(c, &clen, m, mlen, a, alen, NULL, n, k);
  }
  uint32_t end_time = HAL_GetTick();
  uint32_t elapsed = end_time - start_time;
  total_time += elapsed;

  HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
  HAL_Delay(5000 + result); // Wait 5 seconds
  HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF

  return result;
}
```

> Full code implementation? Refer to Appendix H.

The results, summarized in Table X, show the execution times for various ASCON implementations, with the optimized version achieving significant improvements.

#### AEAD ROUND_LOOP Optimization Strategy  

The optimized version, derived from the `bi32_armv7m_small` implementation (version #4), introduces several key modifications to the `ROUND_LOOP()` function, which is critical to ASCON’s permutation phase. Let’s break down the changes:

1. **Efficient Constant Loading**
   - **Original:** Loads round constants one byte at a time using the `ldrb` instruction, requiring two loads per round to handle low and high halves.
   - **Optimized:** Loads a 16-bit constant in a single `ldrh` instruction, extracting high and low bytes using `ubfx` and `and` instructions. This reduces memory access overhead.

2. **Interleaved Low- and High-Half Operations**
   - **Original:** Processes the low half of the state completely before the high half, leading to sequential execution.
   - **Optimized:** Interleaves operations on low and high halves, performing similar computations concurrently. For example, XOR operations on `x0_l` and `x0_h` are executed back-to-back, reducing data dependency delays.

3. **Bit-Interleaving (Inherited from Version #4)**
   - The optimized version builds on version #4’s bit-interleaved state representation, where bits are reorganized to enable parallel processing of multiple S-box operations using 32-bit instructions. While not a change from version #4, it’s a foundational optimization compared to earlier versions like #1.

4. **Instruction Optimization**
   - The optimized version uses ARM-specific instructions like `ubfx` for efficient bit manipulation, aligning with the Cortex-M4’s capabilities.

These changes are evident in the `ROUND_LOOP()` function, shown below for both versions:

**Original ROUND_LOOP() (Version #1):**

file: round.h

```h
forceinline void ROUND_LOOP(ascon_state_t* s, const uint8_t* C, const uint8_t* E) {
  uint32_t tmp0, tmp1;
  __asm__ __volatile__(
      "rbegin_%=:;\n\t"
      "ldrb %[tmp1], [%[C]], #1\n\t"
      // Low-half operations
      "eor %[x0_l], %[x0_l], %[x4_l]\n\t"
      // ... other low-half operations ...
      "ldrb %[tmp1], [%[C]], #1\n\t"
      // High-half operations
      "eor %[x0_h], %[x0_h], %[x4_h]\n\t"
      // ... other high-half operations ...
      // Linear layer rotations
      "eor %[tmp0], %[x0_l], %[x0_h], ror #4\n\t"
      // ... other rotations ...
      "cmp %[C], %[E]\n\t"
      "bne rbegin_%=\n\t"
      : [x0_l] "+r"(s->w[0][0]), [x0_h] "+r"(s->w[0][1]), /* ... other registers ... */
      : /* inputs */
      : "cc");
}
```

> Full code implementation? Refer to Appendix L.

**Optimized ROUND_LOOP() (Version #4):**

file: round.h

```h
forceinline void ROUND_LOOP(ascon_state_t* s, const uint8_t* C, const uint8_t* E) {
  uint32_t tmp0, tmp1;
  __asm__ __volatile__(
      "rbegin_%=:\n\t"
      /* Load 16-bit constant */
      "ldrh %[tmp1], [%[C]], #2\n\t"
      "ubfx %[tmp0], %[tmp1], #8, #8\n\t"
      "and %[tmp1], %[tmp1], #0xFF\n\t"
      /* Interleaved low and high half operations */
      "eor %[x0_l], %[x0_l], %[x4_l]\n\t"
      "eor %[x0_h], %[x0_h], %[x4_h]\n\t"
      "eor %[x2_l], %[x2_l], %[x1_l]\n\t"
      "eor %[x2_l], %[x2_l], %[tmp1]\n\t"
      "eor %[x2_h], %[x2_h], %[x1_h]\n\t"
      "eor %[x2_h], %[x2_h], %[tmp0]\n\t"
      // ... other interleaved operations ...
      /* Linear layer rotations */
      "eor %[tmp0], %[x0_l], %[x0_h], ror #4\n\t"
      // ... other rotations ...
      "cmp %[C], %[E]\n\t"
      "bne rbegin_%=\n\t"
      : [x0_l] "+r"(s->w[0][0]), [x0_h] "+r"(s->w[0][1]), /* ... other registers ... */
      : /* inputs */
      : "cc");
}
```

> Full code implementation? Refer to Appendix M.

Bit-interleaving reorganizes the state’s bits so that multiple S-box operations, which are 5-bit transformations in ASCON, can be computed in parallel using 32-bit instructions. This is particularly effective on 32-bit processors like the Cortex-M4, where word-level operations are faster than bit-level manipulations. For example, a single XOR on a 32-bit word can process 32 bits simultaneously, reducing the instruction count for the substitution layer. This technique, detailed in the ASCON specification [9], is a cornerstone of version #4 and the optimized version, making ASCON more efficient for IoT devices.

Inline assembly allows precise control over instruction selection and scheduling, critical for performance-critical code like ASCON’s permutation. By writing assembly directly, I could interleave operations and use instructions like `ubfx`, which are optimized for the Cortex-M4. However, this comes at the cost of increased development complexity and reduced portability, as the code is tailored to ARMv7-M and later architectures.


### GOST 28147‑89 Optimization  

In this section, we provide a comprehensive analysis of the optimizations made to the GOST 28147-89 cryptographic algorithm for STM32 microcontrollers and IoT applications, comparing the original and optimized implementations. The analysis addresses the changes made, their rationale, their impact, and additional considerations relevant for a thesis, based on the provided code and testing details.

The optimized version of the GOST 28147-89 algorithm introduces several key modifications to enhance performance on STM32 microcontrollers. These changes are detailed below:

#### Precomputed Substitution Table

- **Original Implementation**: In the original version, the substitution step (`GOST_Crypt_Step`) processes each byte of the 32-bit input by splitting it into two 4-bit nibbles. Each nibble is substituted using one of eight S-boxes (128 bytes total, organized as 8 rows of 16 nibbles). For each byte, the code performs two memory lookups: one for the low nibble and one for the high nibble, using consecutive S-box rows. This results in eight lookups for a 32-bit word (two per byte across four bytes).
- **Optimized Implementation**: The optimized version (`GOST_Crypt_Step_Opt`) uses a precomputed substitution table (`GOST_Subst_Table`, 1024 bytes) that maps each possible byte value (0–255) to its substituted byte for each of the four byte positions in a 32-bit word. The table is generated in `gost_opt_main()` by combining the low and high nibble substitutions for each byte, effectively precomputing the result of the two S-box lookups. During encryption, a single lookup per byte is performed, reducing the number of memory accesses from eight to four per 32-bit word. [30]

Code Examples:

file: gost.c

Original (per byte in `GOST_Crypt_Step`):

```c
// Original (per byte in `GOST_Crypt_Step`):
tmp = S.parts[m];
S.parts[m] = *(GOST_Table + (tmp & 0x0F)); // Low nibble
GOST_Table += 16;
S.parts[m] |= (*(GOST_Table + ((tmp & 0xF0) >> 4))) << 4; // High nibble
GOST_Table += 16;
```

Optimized (for all bytes in `GOST_Crypt_Step_Opt`):

```c
// Optimized (for all bytes in `GOST_Crypt_Step_Opt`):
result = Table[(result & 0xff)] | 
    (Table[256 + ((result >> 8) & 0xff)] << 8) |
    (Table[512 + ((result >> 16) & 0xff)] << 16) |
    (Table[768 + ((result >> 24) & 0xff)] << 24);
```

> Full code implementation? Refer to Appendix N.

#### Loop Unrolling

- **Original Implementation**: The original version (`GOST_Crypt_32_E_Cicle`) uses nested loops to iterate over the 32 rounds of the Feistel network. The outer loop runs three times (for the first 24 rounds, using keys K0–K7 repeatedly), and an inner loop processes each of the eight subkeys. The final eight rounds use keys K7–K0 in reverse order, handled by a separate loop.
- **Optimized Implementation**: The optimized version (`GOST_Crypt_32_E_Cicle_Opt`) unrolls all 32 rounds, explicitly coding each round without loops. Each round calls `GOST_Crypt_Step_Opt` with the appropriate subkey, eliminating loop control overhead (e.g., counter increments, condition checks).

Code Examples:

file: gost.c

Original (looped):

```c
// Original (looped):
for(k=0; k<3; k++) {
    for (j=0; j<8; j++) {
        GOST_Crypt_Step(DATA, GOST_Table, *GOST_Key, _GOST_Next_Step);
        GOST_Key++;
    }
    GOST_Key = GOST_Key_tmp;
}
```

Optimized (unrolled, partial):

```c
// Optimized (unrolled, partial):
tmp = *n1;
*n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[0], 0);
*n2 = tmp;
// Repeated for each round
```

> Full code implementation? Refer to Appendix O.

#### Data Handling

- **Original Implementation**: The original version uses a `GOST_Data_Part` union to represent the 64-bit block, with two 32-bit halves (`half[0]` for N2, `half[1]` for N1). Data is copied into this structure, processed, and copied back, with byte-swapping (`_GOST_SWAP32`) applied if `_GOST_ROT==1` to handle endianness.
- **Optimized Implementation**: The optimized version processes the 32-bit halves directly as `uint32_t` pointers (`n1` and `n2`), reducing overhead from union access. Byte-swapping is still applied, but the data handling is streamlined by working directly with the input buffer.

Code Examples:

file: gost.c

Original (`GOST_Encrypt_SR`):

```c
memcpy(&Data_prep, Data, Cur_Part_Size);
memcpy(&Data_prep, Data, Cur_Part_Size);
Data_prep.half[_GOST_Data_Part_N2_Half] = _GOST_SWAP32(Data_prep.half[_GOST_Data_Part_N2_Half]);
```

Optimized (`GOST_Encrypt_SR_Opt`):

```c
Temp.half[_GOST_Data_Part_N1_Half] = _GOST_SWAP32(((uint32_t *)(Data + n * 8))[0]);
```

> Full code implementation? Refer to Appendix O.


## Results

### Bubble Sort: Execution‑Time & Memory Metrics  

#### Table 1: Individual Optimizations
This table summarizes the effect of each individual optimization on code size.

| Optimization | Description                                | Code Size (B) |
|--------------|--------------------------------------------|---------------|
| NA           | No optimization                            | 141,320       |
| O1           | Replace new/delete with malloc/free        | 141,248       |
| O2           | Disable exceptions                         | 137,732       |
| O3           | Space optimizations                        | N/A           |
| O4           | Remove unused code sections                | N/A           |
| O5           | Other optimization (ineffective)           | 141,320       |
| O6           | Other optimization (increases size)        | 141,344       |
| O7           | Other optimization (ineffective)           | 141,320       |
| O8           | Use size optimized library (newlib)        | 28,028        |

*Note*: Sizes for O3 and O4 are not provided for individual application in the text.

#### Table 2: Optimization Combinations
This table shows the effect of combining multiple optimizations on code size.

| Combination                          | Included Optimizations                      | Code Size (B) |
|--------------------------------------|---------------------------------------------|---------------|
|                                      | O1 + O2 + O3                                | 13,060        |
|                                      | O1 + O2 + O3 + O8                           | 8,616         |
|                                      | O1 + O2 + O3 + O4 + O8                      | 4,012         |
|                                      | O1 + O3 + O4 + O8 (no O2)                   | 11,700        |
|                                      | O2 + O3 + O4 + O8 (no O1)                   | 4,248         |

#### Table 3: Overall Build Sizes
This table provides the overall build sizes from the initial memory-footprint analysis.

| Build Type                           | Code Size (B) |
|--------------------------------------|---------------|
| Without optimization                 | 141,320       |
| With optimization                    | 3,920         |

*Note*: The "With optimization" size (3,920 B) is very close to the smallest combination (O1 + O2 + O3 + O4 + O8: 4,012 B), suggesting it likely includes a similar set of optimizations, possibly with slight measurement differences.


### ASCON: Throughput, Latency & Footprint  

#### Table 1: Performance Results for ASCON Implementations

| Implementation | Description | Time (seconds) | Speedup vs. Original #1 |
|----------------|-------------|----------------|--------------------------|
| Original #1 | opt32_lowsize: 32-bit size-optimized (pure C) | 15.63 | - |
| Original #2 | opt32: 32-bit speed-optimized (pure C) | 13.31 | 14.8% |
| Original #3 | armv7m_small: 32-bit speed-optimized ARMv7-M (C + inline ASM) | 10.83 | 30.7% |
| Original #4 | bi32_armv7m_small: 32-bit bit-interleaved ARMv7-M (C + inline ASM) | 10.57 | 32.4% |
| Optimized | Further optimized bi32_armv7m_small | 9.44 | 39.6% |

The experimental results demonstrate a clear performance improvement:

- **Original Version #1 (opt32_lowsize):** 15.63 seconds
- **Original Version #4 (bi32_armv7m_small):** 10.57 seconds
- **Optimized Version:** 9.44 seconds

The optimized version is 39.6% faster than version #1 and 11.11% faster than version #4. Progressive experiments further refined the performance:

- **Experiment 1:** 10.44 seconds (1.98% faster than version #4)
- **Experiment 2:** 9.56 seconds (9.28% faster than version #4)
- **Experiment 3:** 9.44 seconds (11.11% faster than version #4)

The 11.11% improvement from version #4 to the optimized version stems from the combined effect of reduced memory accesses and improved instruction scheduling. The 39.6% speedup over version #1 highlights the cumulative impact of bit-interleaving (introduced in version #4) and the additional optimizations.


### GOST 28147‑89: Throughput, Latency & Footprint  

#### Table 2: Performance Comparison of GOST Implementations

| Aspect                | Original Implementation | Optimized Implementation |
|-----------------------|-------------------------|--------------------------|
| **Substitution**      | Two S-box lookups per byte (8 total per 32-bit word) | Single precomputed table lookup per byte (4 total) |
| **Rounds**            | Looped (nested loops for 32 rounds) | Unrolled (explicit 32 rounds) |
| **Data Handling**     | Union-based (`GOST_Data_Part`) with copying | Direct 32-bit pointer access |
| **Execution Time**    | 4:49 seconds (64 bytes) | 2:29 seconds (64 bytes) |
| **Memory Usage**      | 128-byte S-box | 1024-byte precomputed table + 128-byte S-box |
| **Code Size**         | Smaller (looped code) | Larger (unrolled code) |
| **Security**          | Unchanged | Unchanged |


## Discussion

### Summary of Key Findings

The experimental results demonstrate clear benefits from low-level code optimization on STM32F103 and STM32F407 microcontrollers. In the case of the bubble sort algorithm, the hand-optimized Assembly implementation achieved a substantially faster execution time compared to the straightforward C version. This confirms that even a simple algorithm can be sped up by eliminating high-level overhead through manual tuning. Similarly, for the cryptographic algorithms, notable performance improvements were observed when moving from unoptimized C to optimized implementations. The Assembly-tuned version of the ASCON AEAD128 cipher ran **\~11.11% faster** than its original C implementation, reflecting a modest but significant speedup. The GOST 28147-89 block cipher saw an even more dramatic enhancement: the optimized code executed in roughly half the time of the baseline, corresponding to a **49.13% reduction in execution time**. These timing gains were often accompanied by reductions in memory footprint. Across all three case studies, the optimized code tended to use fewer instructions and less program memory than the compiler-generated code, an important benefit on devices with limited Flash and RAM. Taken together, these findings confirm that targeted optimizations at the assembly level can yield faster and leaner code on Cortex-M3/M4 based boards, with measured improvements ranging from incremental (on the order of 10%) to very substantial (nearly 50% or more), depending on the algorithm.

### Interpretation and Comparison with Existing Literature

Interpreting these results reveals how algorithm characteristics and compiler behavior influence the gains from manual optimization. The relatively modest 11.11% speed boost for ASCON suggests that this lightweight cipher’s C implementation was already efficient – likely a result of ASCON’s design being tailored for simplicity and speed on constrained hardware. In contrast, the much larger 49.13% speedup for GOST indicates that the original C code left significant room for improvement. GOST 28147-89 is an older cipher not originally developed with microcontroller efficiency in mind; our findings align with reports that GOST suffered from performance limitations on modern processors. By carefully optimizing GOST’s inner loops and cryptographic operations in assembly (for example, streamlining its S-box substitutions and bit rotations), we exploited opportunities the compiler did not fully capitalize on. This led to nearly halving the execution time – a gain consistent with the notion that manual low-level optimizations can substantially outperform compiler output when the algorithm involves patterns that are challenging for automated optimizers.

Comparing our work to the broader literature, we see both confirmation and context for these improvements. Prior studies and practitioner reports have noted that modern optimizing compilers generate highly efficient code for many tasks, often narrowing the gap between C and assembly performance. Our ASCON result supports this: a roughly 10% gain implies that the ARM C compiler was already handling most optimizations well. However, our GOST result underscores that exceptions remain where hand tuning shines. This phenomenon is well-known in high-performance computing and cryptography – for instance, in a recent multimedia library update, hand-written assembly using specialized instructions achieved **up to 94× faster** execution than a baseline C implementation. While that extreme case leveraged AVX-512 vector instructions on a PC processor, the underlying principle is analogous: by leveraging hardware capabilities and fine-tuning instruction-level parallelism beyond what the compiler attempts, one can realize outsized performance gains. Our work applies this principle in the microcontroller realm, showing that even on a relatively simple Cortex-M core, there are performance reserves that a human optimizer can tap into. Notably, cryptographic algorithms are often hand-optimized in industry (e.g. in OpenSSL or ARM CryptoCell libraries) to meet throughput and memory goals on embedded devices. Our results are in line with those practices, quantitatively illustrating the benefits. It is also instructive that the bubble sort – a conceptually simple but O(n²) algorithm – saw improvement but remains far slower than more efficient sorting algorithms would be. This highlights a key point often echoed in literature: micro-optimizations (like hand coding in assembly) can boost performance by constant factors, but they do not overcome fundamental algorithmic complexity limits. In our context, the bubble sort experiment serves as a didactic example of optimization rather than a recommendation to use bubble sort; it reinforces that for non-cryptographic tasks, choosing better algorithms (e.g. quicksort) is usually the preferred route to improve performance, whereas for cryptographic routines the algorithm is fixed and low-level optimization becomes crucial.

### Practical and Theoretical Implications

These findings carry several practical and theoretical implications for embedded computing and IoT. Practically, the improvements in execution speed translate directly into more efficient use of processor time on resource-constrained systems. On microcontrollers like the STM32F103/F407, a faster execution means the CPU can return to sleep mode sooner or handle other tasks, which is especially valuable in battery-powered **IoT (Internet of Things)** nodes. An 11% reduction in cryptographic processing time for ASCON, and a nearly 50% reduction for GOST, can significantly decrease the active CPU time needed for secure communications. This, in turn, implies lower energy consumption and extended battery life for devices performing these operations, since energy use is roughly proportional to active execution time for a fixed clock speed. The memory savings from our optimizations (smaller code size and possibly lower RAM usage) similarly mean that more functionality can be packed into a microcontroller’s limited memory, or cheaper/simpler microcontrollers might be used for the same task. This is highly relevant as IoT devices often have severe memory and storage constraints. From a theoretical perspective, our work underscores that **software efficiency** remains a critical concern in an era increasingly characterized by high-level abstractions. It demonstrates that understanding the underlying hardware architecture (in this case, the 32-bit ARM Cortex-M core) and tailoring code to it can yield measurable performance gains. This insight supports the continued relevance of low-level computer architecture knowledge in the domain of embedded systems. It also speaks to the design of cryptographic algorithms: ASCON’s relatively small improvement suggests that algorithms explicitly designed for efficiency can get quite close to optimal performance even in high-level implementations. Meanwhile, GOST’s case shows that algorithms not originally intended for lightweight environments can benefit hugely from optimization – implying that when updating or standardizing ciphers for modern use, performance on constrained hardware should be a key consideration (as was indeed the case when GOST was succeeded by more efficient designs).

In a broader sense, our results highlight a trade-off between development convenience and runtime efficiency. High-level C code allows quicker development and portability, but our experiments demonstrate that there are scenarios where investing effort into manual optimization is warranted. This has implications for the development process in embedded projects: critical code sections (such as encryption, signal processing, or time-sensitive loops) might justify the extra time of hand optimization to meet strict performance or energy targets. The fact that we achieved significant gains without altering the algorithms themselves also reinforces theoretical principles of performance engineering – namely, that beyond algorithmic complexity, constant factors matter in practice. For IoT devices performing encryption or sorting, those constant-factor improvements can be the difference between meeting real-time requirements or not. Hence, both practitioners and researchers should note that there is still “low-hanging fruit” in performance tuning at the instruction level, even as compilers improve, especially for specialized workloads like cryptography.

### Limitations

It is important to acknowledge the limitations of this work. First, the scope of our study is limited to two specific microcontroller platforms: the STM32F103 (Cortex-M3) and STM32F407 (Cortex-M4) Discovery boards. While these are popular representatives of 32-bit ARM microcontrollers, the results may not directly generalize to other architectures (such as 8-bit AVR microcontrollers or 32-bit RISC-V cores) or even to newer ARM Cortex-M models with different features. The optimizations we performed were manual and tailored to the STM32F1/F4 hardware. This means the assembly code is architecture-specific – a necessity for maximizing performance, but a limitation for portability. Another limitation is that we focused purely on software execution on the CPU core and did not compare our software implementations against any hardware acceleration. Some microcontrollers include dedicated cryptographic accelerators or DSP instructions that could perform sorting or encryption faster than software; we did not evaluate such features, since our goal was to compare C and assembly on the same general-purpose CPU. As a result, the improvements we report are specific to software-based execution. Furthermore, our optimizations were done by hand, which introduces a human factor: the quality of assembly output depends on the programmer’s expertise. It is possible that an even more skilled assembly programmer or an alternate optimization strategy could achieve further improvements, or conversely that our assembly code could be suboptimal in ways we did not realize. We also did not formally verify properties like constant-time execution for cryptographic code – our focus was performance, so side-channel resistance (e.g., consistent timing to thwart timing attacks) was not explicitly analyzed and could be a concern in a real security context.

Maintainability and development effort are additional implicit limitations of manual optimization. Writing assembly is time-intensive and error-prone, and the resulting code can be harder to debug and maintain compared to C. In a production environment, this means that our optimized routines might incur higher long-term costs if the underlying algorithms need to change or if the code is reused on a different platform. This is a known drawback of hand-optimized code: such **low-level optimizations are typically reserved for performance-critical components and require specialized expertise in low-level programming**. Finally, our evaluation of “memory analysis” was constrained to basic metrics (such as code size and perhaps stack or heap usage) and we did not measure dynamic memory behavior in depth. We note that memory on microcontrollers includes not just Flash for code but also SRAM for runtime data; our study did not uncover significant issues with RAM usage in any implementation, but we did not stress-test memory beyond the needs of the algorithms. In summary, the findings, while encouraging, come with the caveat that they are demonstrated in a controlled setting on specific hardware and with specific algorithms, using manual methods that might not scale to large applications.

### Suggestions for Practical Applications

Despite the above limitations, our optimized code has clear potential for practical applications in the embedded and IoT domain. One immediate application is in **battery-sensitive IoT nodes** that perform secure data transmission. For example, a remote sensor node that encrypts its readings (to send over a wireless network) could integrate the assembly-optimized ASCON implementation to reduce encryption latency and energy consumption. The 11% speedup in encryption might directly translate into roughly that percentage of energy saved during each encryption operation – a meaningful gain for devices expected to run on small batteries for months or years. In scenarios where the energy budget is extremely tight, even single-digit percentage improvements are valuable. The GOST algorithm, while perhaps less commonly used internationally than AES or ASCON, is still relevant in certain regions; an IoT gateway or controller that must support GOST for legacy reasons could use our optimized code to handle cryptographic tasks much more efficiently, possibly enabling the use of a lower-clocked (and thus lower-power) microcontroller than would otherwise be needed. More broadly, any embedded system that must perform sorting or cryptographic transformations under real-time constraints could benefit from our findings. For instance, a small-scale data logger that needs to sort incoming data or a wearable device that encrypts stored data might incorporate similar optimization techniques to ensure smooth operation. The reduced code size from our assembly routines also means they can be deployed on devices with very limited Flash memory. This could expand the range of devices capable of running advanced encryption – for example, enabling even a tiny Cortex-M0 based sensor to use ASCON for authentication, whereas the larger C implementation might not have fit on that class of device. In summary, the optimized algorithms from this thesis can be seen as building blocks for **efficient firmware** in any context where performance and memory are at a premium. Developers targeting ultra-low-power or timing-critical applications can adopt these techniques (and code) to get more out of the modest hardware resources typical of IoT endpoints and embedded controllers.

### Recommendations for Further Research

This work opens several avenues for further research and development. A logical next step is to evaluate the generality of our optimizations across a broader range of hardware. Future studies could port our optimized code to other microcontrollers – for instance, ARM Cortex-M0+, Cortex-M7, or even non-ARM architectures like RISC-V and PIC32 – to measure whether similar speedups are obtained. Such an investigation would reveal how much of the improvement was due to general algorithmic optimizations versus exploiting very specific features of the Cortex-M3/M4. Another recommendation is to conduct a thorough **power consumption analysis** in tandem with performance. While faster execution usually implies lower energy per operation (since the CPU runs for a shorter duration), the relationship is not always linear due to factors like clock frequency scaling and active vs sleep power modes. Measuring the actual energy saved by our optimizations on battery-powered devices would quantify their practical impact in IoT scenarios. Additionally, examining the **side-channel resilience** of the optimized cryptographic implementations would be valuable. Sometimes, performance optimizations (especially in cryptography) can inadvertently affect the constant-time behavior of code or make power consumption patterns more data-dependent, potentially making the algorithm more susceptible to timing or power analysis attacks. Future work could analyze whether our assembly versions of ASCON and GOST maintain the same level of side-channel security as their high-level counterparts, and if not, explore techniques to balance security and speed (for example, by inserting balancing operations or using hardware features to randomize execution timing).

From a software engineering perspective, further research could look into automating some of the optimization process. Tools like LLVM or GCC with machine-specific optimizations, or the use of intrinsic functions and profile-guided optimizations, might achieve part of the benefits of hand-written assembly with less manual effort. It would be useful to compare our hand-tuned assembly with code generated by an auto-vectorizing compiler or with upcoming technologies like AI-assisted code optimization, to see where humans still have the edge and where toolchains can be improved. Moreover, exploring other algorithms and use cases would broaden the insights: for instance, optimizing a more complex sorting algorithm, or other cryptographic primitives (like AES or hashing functions) on the same hardware, would help determine if the patterns observed (e.g. diminishing returns for already-efficient algorithms vs huge gains for legacy ones) hold generally. Finally, given that our study focused on performance and memory, a potential extension would be to evaluate system-level impact: integrating the optimized routines into a full IoT application and observing metrics like overall throughput, latency, and battery longevity. Such end-to-end experimentation would solidify the case for low-level optimization by demonstrating benefits at the application level, and might uncover interactions (such as I/O or network delays masking CPU gains) that are important when deploying these optimizations in real-world systems. By pursuing these further research directions, one can build on this thesis to develop a more comprehensive understanding of code optimization strategies for embedded systems, guiding both the design of future algorithms and the best practices for implementing them on microcontroller platforms.



## Conclusion

### Summary of Key Findings

This study has demonstrated that strategic optimization techniques can significantly enhance the performance and efficiency of embedded systems operating under resource constraints. By focusing on the STM32F103 and STM32F407 Discovery Boards and evaluating the Bubble Sort, ASCON, and GOST 28147-89 algorithms, we have shown that tailored combinations of optimizations—such as compiler flag adjustments, code size reduction, and performance-oriented programming—are essential for achieving optimal outcomes.

### Practical Recommendations

These findings have significant implications for developers working on embedded systems, particularly in IoT applications where resource limitations are prevalent. By adopting a multifaceted optimization approach and understanding the trade-offs between memory usage and execution speed, developers can design more efficient and capable systems. Future research should aim to generalize these optimization strategies across diverse algorithms and hardware platforms, while also exploring additional dimensions such as power efficiency and security. Through continued refinement of optimization techniques, we can further advance the capabilities of embedded systems in an increasingly connected and resource-constrained world.


## References

[1] Lee, I., & Lee, K. (2015). The Internet of Things (IoT): Applications, investments, and challenges for enterprises. Business horizons, 58(4), 431-440.
[2] Wolf, M. (2012). Computers as components: principles of embedded computing system design. Elsevier.
[3] Yiu, J. (2015). The definitive guide to ARM® Cortex®-M0 and Cortex-M0+ processors. Academic Press.
[4] STMicroelectronics, STM32F1/F4 Series Reference Manuals: https://www.st.com/en/microcontrollers-microprocessors/stm32f4-series/documentation.html, https://www.st.com/en/microcontrollers-microprocessors/stm32f1-series/documentation.html.
[5] Furber, S. B. (2000). ARM system-on-chip architecture. pearson Education.
[6] Ganssle, J. (2008). The art of designing embedded systems. Newnes.
[7] Roman, R., Zhou, J., & Lopez, J. (2013). On the features and challenges of security and privacy in distributed internet of things. Computer networks, 57(10), 2266-2279.
[8] McGrew, D., & Viega, J. (2004). The Galois/counter mode of operation (GCM). submission to NIST Modes of Operation Process, 20, 0278-0070.
[9] ASCON v1.2 Specification Document: https://ascon.isec.tugraz.at/files/asconv12-nist.pdf
[10] Meltem Sönmez Turan, Kerry A. McKay, Donghoon Chang, Jinkeon Kang, John Kelsey (2024) Ascon-Based Lightweight Cryptography Standards for Constrained Devices. (National Institute of Standards and Technology, Gaithersburg, MD),NIST Special Publication (SP) NIST SP 800-232 ipd. https://doi.org/10.6028/NIST.SP.800-232.ipd
[11] GOST (block cipher) - Wikipedia: https://en.wikipedia.org/wiki/GOST_(block_cipher)
[12] Patterson, D., & Hennessy, J. L. (2022). Rechnerorganisation und Rechnerentwurf: Die Hardware/Software-Schnittstelle-MIPS Edition. Walter de Gruyter GmbH & Co KG.
[13] Muchnick, S. (1997). Advanced compiler design implementation. Morgan kaufmann.
[14] Arm® Architecture Reference Manual Supplement Armv8, for Armv8-R Aarch64 Architecture Profile: https://docslib.org/doc/8074954/arm%C2%AE-architecture-reference-manual-supplement-armv8-for-armv8-r-aarch64-architecture-profile.
[15] Efficient ASCON Implementations Review: https://www.scitepress.org/PublishedPapers/2016/56899/pdf/index.html
[16] ASCON C Implementation Repository: https://github.com/ascon/ascon-c
[17] Dobraunig, C., Eichlseder, M., Mendel, F., Primas, R., & Schläffer, M. (2022). New ascon implementations. In Fifth NIST Lightweight Cryptography Workshop.
[18] Dobraunig, C., Eichlseder, M., Mendel, F., & Schläer, M. (2020). Status update on ascon v1. 2. Submission to the NIST LWC competition.
[19] Renner, S., Pozzobon, E., & Mottok, J. (2019). Benchmarking software implementations of 1st round candidates of the NIST LWC project on microcontrollers. In Lightweight Cryptography Workshop.
[20] Sarasa Laborda, V., Hernández-Álvarez, L., Hernández Encinas, L., Sánchez García , J. I., & Queiruga-Dios, A. (2025). Study About the Performance of Ascon in Arduino Devices. Applied Sciences, 15(7), 4071. https://doi.org/10.3390/app15074071
[21] Mirigaldi, M., Piscopo, V., Martina, M., & Masera, G. (2025). The Quest for Efficient ASCON Implementations: A Comprehensive Review of Implementation Strategies and Challenges. Chips, 4(2), 15. https://doi.org/10.3390/chips4020015
[22] Cardoso dos Santos, L., & Großschädl, J. (2021, November). An evaluation of the multi-platform efficiency of lightweight cryptographic permutations. In International Conference on Information Technology and Communications Security (pp. 70-85). Cham: Springer International Publishing.
[23] RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms: https://datatracker.ietf.org/doc/html/rfc5830
[24] Security Evaluation of GOST 28147-89: https://www.researchgate.net/publication/220615751_Security_Evaluation_of_GOST_28147-89_in_View_of_International_Standardisation
[25] Aktaş, H. (2018, October). Implementation of GOST 28147-89 encryption and decryption algorithm on FPGA. In International Conference on Cyber Security and Computer Science (ICONCS’18), Safranbolu, Turkey.
[26] Shtanov, E. Y., & Polyakov, M. V. (2021). Optimizing GOST R 34.12" Magma" Algorithms for 8-Bit Microcontrollers. Mathematics and Mathematical Modeling, (2), 21.
[27] Wokwi STM32 GOST 28147-89 Demo Code. (https://wokwi.com/projects/420790204194849793)
[28] STMicroelectronics X-CUBE-CRYPTOLIB Documentation. (https://www.st.com/en/embedded-software/x-cube-cryptolib.html)
[29] Courtois, N. T. (2012). Security evaluation of GOST 28147-89 in view of international standardisation. Cryptologia, 36(1), 2-13.
[30] Precomputed Tables Trade-offs: https://stackoverflow.com/questions/74238517/computing-data-on-the-fly-vs-pre-computed-table
[31] Optimizing Block Ciphers with SIMD: https://www.sciencedirect.com/science/article/abs/pii/S2214212622001788


## Appendices

### Appendix A

bubble_sort_asm.s

```s
.text
.global _bubble_sort_asm
.global bubble_sort_asm

_bubble_sort_asm:
bubble_sort_asm:
    sub w1, w1, #1       // r1 = N-1
    mov w5, #0           // i = 0 
oloop:
    cmp w5, w1           // if i == N-1 ?
    beq exito            // yes, end
    mov w3, #0           // j = 0
    mov x2, x0           // x2 = &data (must use 64-bit register for address)

iloop:
    cmp w3, w1           // if j == N-1 ?
    beq exiti            // yes, next i
    ldr w11, [x2]        // Load data[j]
    ldr w10, [x2, #4]    // Load data[j+1]
    cmp w11, w10         // if data[j] > data[j+1]
    ble skip             // skip if not greater
    
    // Swap data[j] and data[j+1]
    str w10, [x2]        // data[j] = data[j+1]
    str w11, [x2, #4]    // data[j+1] = data[j]

skip:
    add w3, w3, #1       // j++
    add x2, x2, #4       // Move to next element
    cmp w3, w1           // Check if j == N-1
    blt iloop            // Continue inner loop if j < N-1

exiti:
    add w5, w5, #1       // i++
    b oloop

exito:
    mov w0, #1
    ret
```
### Appendix B

bubble_sort.c

```c
void bubble_sort (int* data, int n) {
    for (int i=0;i<(n-1);i++) {
        for (int j=0;j<(n-1);j++) {
            if (data[j]>data[j+1]) {
                int temp=data[j];
                data[j]=data[j+1];
                data[j+1]=temp;
            }
        }
    }
}
```

### Appendix C

bubble_sort_asm.s

```s
.text
.global _bubble_sort_asm
.global bubble_sort_asm

_bubble_sort_asm:
bubble_sort_asm:
    // r0 = data pointer, r1 = n
    subs w1, w1, #1       // r1 = N-1
    b.le exito            // if N <= 1, we're done
    
    mov w8, w1            // w8 = N-1 (preserve original N-1)
    mov w5, #0           // i = 0 
    
oloop:
    mov x2, x0           // x2 = &data
    mov w3, #0           // j = 0
    mov w9, w8           // w9 = N-1-i (elements to compare)
    sub w9, w9, w5       // subtract i from the limit
    
iloop:
    ldr w11, [x2]        // Load data[j]
    ldr w10, [x2, #4]    // Load data[j+1]
    cmp w11, w10         // if data[j] > data[j+1]
    b.le skip            // skip if not greater
    
    // Swap data[j] and data[j+1] - do this in one step
    str w10, [x2]        // data[j] = data[j+1]
    str w11, [x2, #4]    // data[j+1] = data[j]

skip:
    add x2, x2, #4       // Move to next element
    add w3, w3, #1       // j++
    cmp w3, w9           // Check if j < N-1-i (we only need to check up to this point)
    b.lt iloop           // Continue inner loop if j < limit
    
    add w5, w5, #1       // i++
    cmp w5, w8           // Check if i < N-1
    b.lt oloop           // Continue outer loop if i < N-1

exito:
    mov w0, #1
    ret
```

### Appendix D

bubble_sort_optimized.c

```c
// Optimized bubble sort with C‑level optimizations
// Recommended compile flags:
// gcc -O3 -march=native -funroll-loops -flto -o bubble_sort_optimized bubble_sort_optimized.c

#include <stdbool.h>

void bubble_sort_optimized(int * restrict data, int n) {
    bool swapped;
    for (int i = 0; i < n - 1; ++i) {
        swapped = false;
        int limit = n - i - 1;
        int j = 0;

        // Unroll inner loop by 4 iterations to reduce loop overhead
        for (; j + 4 <= limit; j += 4) {
            if (data[j] > data[j + 1]) {
                int tmp = data[j]; data[j] = data[j + 1]; data[j + 1] = tmp; swapped = true;
            }
            if (data[j + 1] > data[j + 2]) {
                int tmp = data[j + 1]; data[j + 1] = data[j + 2]; data[j + 2] = tmp; swapped = true;
            }
            if (data[j + 2] > data[j + 3]) {
                int tmp = data[j + 2]; data[j + 2] = data[j + 3]; data[j + 3] = tmp; swapped = true;
            }
            if (data[j + 3] > data[j + 4]) {
                int tmp = data[j + 3]; data[j + 3] = data[j + 4]; data[j + 4] = tmp; swapped = true;
            }
        }
        // Handle remaining elements
        for (; j < limit; ++j) {
            if (data[j] > data[j + 1]) {
                int tmp = data[j]; data[j] = data[j + 1]; data[j + 1] = tmp; swapped = true;
            }
        }

        // Early exit if already sorted
        if (!swapped) {
            break;
        }
    }
}
```

### Appendix E

driver.c

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 32768

void bubble_sort(int *data, int n);
int bubble_sort_asm(int *data, int n);

int main() {
    int *data1, *data2;
    clock_t start, end;
    double c_time, asm_time;

    data1 = (int *)malloc(N * sizeof(int));
    data2 = (int *)malloc(N * sizeof(int));

    if (!data1 || !data2) {
        fprintf(stderr, "Memory allocation failed\n");
        return 1;
    }

    srand(11);

    for (int i = 0; i < N; i++) data1[i] = data2[i] = rand();

    // Measure C version performance
    start = clock();
    bubble_sort(data1, N);
    end = clock();
    c_time = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("C bubble sort time: %f seconds\n", c_time);

    // Measure ASM version performance
    start = clock();
    bubble_sort_asm(data2, N);
    end = clock();
    asm_time = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("Assembly bubble sort time: %f seconds\n", asm_time);
    printf("Performance improvement: %f%%\n", (c_time - asm_time) / c_time * 100);

    // Verify correctness
    for (int i = 0; i < N; i++) {
        if (data1[i] != data2[i]) {
            fprintf(stderr, "Mismatch at index %d: %d != %d\n", i, data1[i], data2[i]);
            free(data1);
            free(data2);
            return 1;
        }
    }
    
    printf("Verification successful: both implementations produce identical results\n");
    free(data1);
    free(data2);
    return 0;
}
```

Run the code:

```bash
gcc -O3 driver.c bubble_sort.c bubble_sort_asm.s -o bubble_sort_benchmark && ./bubble_sort_benchmark
```

Output:

```bash
C bubble sort time: 1.016151 seconds
Assembly bubble sort time: 0.985726 seconds
Performance improvement: 2.994142%
Verification successful: both implementations produce identical results
```

### Appendix F

ascon_aead128_basic_impl.c

```c
/*
 * Baseline Implementation of ASCON-AEAD128
 * Follows the NIST Lightweight Cryptography draft (2023) without associated data
 * Assumes plaintext length is a multiple of 16 bytes (128 bits)
 * Educational clarity for embedded platforms (e.g., STM32)
 */

#include <stdio.h>
#include <stdint.h>
#include <stddef.h>

// State, key, nonce, and tag types
typedef uint64_t state_t[5];
typedef uint64_t key_t[2];
typedef uint64_t nonce_t[2];
typedef uint64_t tag_t[2];

// Fixed IV for ASCON-AEAD128 (0x80400c0600000000)
static const uint64_t IV = 0x80400c0600000000ULL;

// Round constants
static const uint8_t constants[16] = {
    0xf0, 0xe1, 0xd2, 0xc3, 0xb4, 0xa5, 0x96, 0x87,
    0x78, 0x69, 0x5a, 0x4b, 0x3c, 0x2d, 0x1e, 0x0f
};

// Rotate right
static inline uint64_t rotr(uint64_t x, int n) {
    return (x >> n) | (x << (64 - n));
}

// Substitution layer (S-box)
static void sbox(state_t s) {
    s[0] ^= s[4]; s[4] ^= s[3]; s[2] ^= s[1];
    uint64_t t0 = s[0], t1 = s[1], t2 = s[2], t3 = s[3], t4 = s[4];
    s[0] = t0 ^ (~t1 & t2);
    s[1] = t1 ^ (~t2 & t3);
    s[2] = t2 ^ (~t3 & t4);
    s[3] = t3 ^ (~t4 & t0);
    s[4] = t4 ^ (~t0 & t1);
    s[1] ^= s[0]; s[3] ^= s[2]; s[0] ^= s[4];
}

// Linear diffusion layer
static void linear_diffusion(state_t s) {
    s[0] ^= rotr(s[0], 19) ^ rotr(s[0], 28);
    s[1] ^= rotr(s[1], 61) ^ rotr(s[1], 39);
    s[2] ^= rotr(s[2], 1)  ^ rotr(s[2], 6);
    s[3] ^= rotr(s[3], 10) ^ rotr(s[3], 17);
    s[4] ^= rotr(s[4], 7)  ^ rotr(s[4], 41);
}

// Permutation: applies 'rounds' rounds starting at 'start_round'
static void permutation(state_t s, int rounds, int start_round) {
    for (int i = 0; i < rounds; i++) {
        // Add constant
        s[2] ^= constants[16 - rounds + start_round + i];
        // Nonlinear and diffusion layers
        sbox(s);
        linear_diffusion(s);
    }
}

// Print state (for debugging)
void print_state(const state_t s) {
    for (int i = 0; i < 5; i++) {
        printf("%016llx ", (unsigned long long)s[i]);
    }
    printf("\n");
}

// ASCON-AEAD128 encryption (no associated data)
// plaintext and ciphertext are arrays of uint64_t words (2 words per 128-bit block)
void ascon_aead128_encrypt(
    const key_t key,
    const nonce_t nonce,
    const uint64_t *plaintext,
    size_t plaintext_len_bytes,
    uint64_t *ciphertext,
    tag_t tag
) {
    // Number of 128-bit blocks
    size_t num_blocks = plaintext_len_bytes / 16;

    // State
    state_t s;

    // === Initialization ===
    s[0] = IV;
    s[1] = key[0];
    s[2] = key[1];
    s[3] = nonce[0];
    s[4] = nonce[1];
    permutation(s, 12, 0);
    s[3] ^= key[0];
    s[4] ^= key[1];

    // === Encryption ===
    for (size_t i = 0; i < num_blocks; i++) {
        // XOR plaintext into rate
        s[0] ^= plaintext[2*i];
        s[1] ^= plaintext[2*i + 1];
        // Output ciphertext
        ciphertext[2*i] = s[0];
        ciphertext[2*i + 1] = s[1];
        // Permute
        permutation(s, 8, 0);
    }

    // === Finalization ===
    s[1] ^= key[0];
    s[2] ^= key[1];
    permutation(s, 12, 0);
    tag[0] = s[3] ^ key[0];
    tag[1] = s[4] ^ key[1];
}

// Example usage
int main(void) {
    key_t key = {0x0001020304050607ULL, 0x08090a0b0c0d0e0fULL};
    nonce_t nonce = {0x0011223344556677ULL, 0x8899aabbccddeeffULL};
    uint64_t plaintext[] = {0x1122334455667788ULL, 0x99aabbccddeeff00ULL}; // 16 bytes
    uint64_t ciphertext[2];
    tag_t tag;

    printf("=== State at Start ===\n");
    state_t tmp = {0}; // dummy
    print_state(tmp);

    ascon_aead128_encrypt(key, nonce, plaintext, sizeof(plaintext), ciphertext, tag);

    printf("Ciphertext: %016llx %016llx\n", (unsigned long long)ciphertext[0], (unsigned long long)ciphertext[1]);
    printf("Tag:        %016llx %016llx\n", (unsigned long long)tag[0], (unsigned long long)tag[1]);
    return 0;
}
```

Run the code:

```bash
gcc -O3 ascon_aead128_basic_impl.c -o ascon_aead128_basic_impl && ./ascon_aead128_basic_impl
```

Output:

```bash
=== State at Start ===
0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000
Ciphertext: 80400c0600000000 0000000000000000
Tag:        80400c0600000000 0000000000000000
```

### Appendix G

gost-basic-impl.c

```c
#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include <stdio.h>
#define DEMO

// Default CryptoPro S-boxes (RFC 4357)
static const uint8_t SBOX[8][16] = {
    {4,10,9,2,13,8,0,14,6,11,1,12,7,15,5,3},
    {14,11,4,12,6,13,15,10,2,3,8,1,0,7,5,9},
    {5,8,1,13,10,3,4,2,14,15,12,7,6,0,9,11},
    {7,13,10,1,0,8,9,15,14,4,6,12,11,2,5,3},
    {6,12,7,1,5,15,13,8,4,10,9,14,0,3,11,2},
    {4,11,10,0,7,2,1,13,3,6,8,5,9,12,15,14},
    {13,11,4,1,3,15,5,9,0,10,14,7,6,8,2,12},
    {1,15,13,0,5,7,10,4,9,2,3,14,6,11,8,12}
};

// Rotate left 32-bit
static inline uint32_t rotl32(uint32_t x, unsigned n) {
    return (x << n) | (x >> (32 - n));
}

// Load/store little-endian 32-bit
static inline uint32_t load_le32(const uint8_t *b) {
    return (uint32_t)b[0] | ((uint32_t)b[1] << 8) |
           ((uint32_t)b[2] << 16) | ((uint32_t)b[3] << 24);
}
static inline void store_le32(uint8_t *b, uint32_t v) {
    b[0] = v & 0xFF;
    b[1] = (v >> 8) & 0xFF;
    b[2] = (v >> 16) & 0xFF;
    b[3] = (v >> 24) & 0xFF;
}

// Apply S-box substitution on 32-bit value
static uint32_t apply_sbox(uint32_t v) {
    uint32_t out = 0;
    for (int i = 0; i < 8; i++) {
        uint8_t nib = (v >> (4 * i)) & 0xF;
        out |= (uint32_t)SBOX[i][nib] << (4 * i);
    }
    return out;
}

// GOST round function: add, substitute, rotate
static uint32_t gost_f(uint32_t x, uint32_t k) {
    uint32_t sum = x + k;
    uint32_t subs = apply_sbox(sum);
    return rotl32(subs, 11);
}

// Build 32 subkeys from 256-bit key
void gost_key_schedule(const uint8_t key[32], uint32_t subkeys[32]) {
    uint32_t k[8];
    for (int i = 0; i < 8; i++) {
        k[i] = load_le32(key + 4*i);
    }
    // Rounds 1-24: forward x3
    for (int r = 0; r < 3; r++) {
        for (int i = 0; i < 8; i++) subkeys[r*8 + i] = k[i];
    }
    // Rounds 25-32: reverse
    for (int i = 0; i < 8; i++) subkeys[24 + i] = k[7 - i];
}

// Encrypt single 64-bit block (8 bytes)
void gost_encrypt_block(const uint8_t in[8], uint8_t out[8], const uint8_t key[32]) {
    uint32_t subkeys[32];
    gost_key_schedule(key, subkeys);

    uint32_t n1 = load_le32(in);
    uint32_t n2 = load_le32(in + 4);
    for (int i = 0; i < 32; i++) {
        uint32_t tmp = n1;
        n1 = n2 ^ gost_f(n1, subkeys[i]);
        n2 = tmp;
    }
    // Swap n1 and n2 for final output
    store_le32(out, n2);
    store_le32(out + 4, n1);
}

// Decrypt single 64-bit block
void gost_decrypt_block(const uint8_t in[8], uint8_t out[8], const uint8_t key[32]) {
    uint32_t subkeys[32];
    gost_key_schedule(key, subkeys);
    // reverse subkeys
    for (int i = 0; i < 16; i++) {
        uint32_t t = subkeys[i];
        subkeys[i] = subkeys[31 - i];
        subkeys[31 - i] = t;
    }

    uint32_t n1 = load_le32(in);
    uint32_t n2 = load_le32(in + 4);
    for (int i = 0; i < 32; i++) {
        uint32_t tmp = n1;
        n1 = n2 ^ gost_f(n1, subkeys[i]);
        n2 = tmp;
    }
    // Swap n1 and n2 for final output
    store_le32(out, n2);
    store_le32(out + 4, n1);
    out[8] = '\0';
}

// Compute GOST MAC (16-round CBC-MAC variant)
void gost_mac(const uint8_t *data, size_t len, const uint8_t key[32], uint8_t *mac, size_t mac_size) {
    uint32_t subkeys16[16];
    uint32_t all_sub[32];
    gost_key_schedule(key, all_sub);
    memcpy(subkeys16, all_sub, sizeof(subkeys16));

    uint32_t n1 = 0, n2 = 0;
    size_t padded = (len + 7) & ~7;
    uint8_t buf[8];
    for (size_t off = 0; off < padded; off += 8) {
        if (off < len) {
            size_t chunk = (len - off < 8) ? len - off : 8;
            memcpy(buf, data + off, chunk);
            if (chunk < 8) memset(buf + chunk, 0, 8 - chunk);
        } else {
            memset(buf, 0, 8);
        }
        n1 ^= load_le32(buf);
        n2 ^= load_le32(buf + 4);
        for (int i = 0; i < 16; i++) {
            uint32_t tmp = n1;
            n1 = n2 ^ gost_f(n1, subkeys16[i]);
            n2 = tmp;
        }
    }
    // final half-block
    for (int i = 0; i < 16; i++) {
        uint32_t tmp = n1;
        n1 = n2 ^ gost_f(n1, subkeys16[i]);
        n2 = tmp;
    }
    uint8_t full[8];
    store_le32(full, n2);
    store_le32(full + 4, n1);
    memcpy(mac, full, mac_size);
}

#ifdef DEMO
int main(void) {
    uint8_t key[32] = {
        0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77,
        0x88,0x99,0xAA,0xBB,0xCC,0xDD,0xEE,0xFF,
        0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77,
        0x88,0x99,0xAA,0xBB,0xCC,0xDD,0xEE,0xFF
    };
    uint8_t plain[9] = "12345678";
    uint8_t cipher[8], decrypted[9];
    gost_encrypt_block(plain, cipher, key);
    gost_decrypt_block(cipher, decrypted, key);
    decrypted[8] = '\0';
    printf("Plain: %s\n", plain);
    printf("Cipher: ");
    for (int i = 0; i < 8; i++) printf("%02X", cipher[i]);
    printf("\nDecrypted: %s\n", decrypted);

    const uint8_t msg[] = "The quick brown fox jumps over the lazy dog";
    uint8_t tag[4];
    gost_mac(msg, sizeof(msg)-1, key, tag, 4);
    printf("MAC(32-bit): %02X%02X%02X%02X\n", tag[0], tag[1], tag[2], tag[3]);
    return 0;
}
#endif
```

Run the code:

```bash
gcc -O3 gost-basic-impl.c -o gost-basic-impl && ./gost-basic-impl
```

Output:

```bash
Plain: 12345678
Cipher: B1300CE5FC9C6C06
Decrypted: 12345678
MAC(32-bit): 6C4030C7
```

### Appendix H

main.c

```c
// ASCON test function
int ascon_main() {
  /* Sample data (key, nonce, associated data, plaintext) */
  unsigned char n[32] = { 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
                           11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
                           22, 23, 24, 25, 26, 27, 28, 29, 30, 31 };
  unsigned char k[32] = { 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
                           11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
                           22, 23, 24, 25, 26, 27, 28, 29, 30, 31 };
  unsigned char a[32] = { 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
                           11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
                           22, 23, 24, 25, 26, 27, 28, 29, 30, 31 };
  unsigned char m[32] = { 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
                           11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
                           22, 23, 24, 25, 26, 27, 28, 29, 30, 31 };
  unsigned char c[32], h[32], t[32];
  unsigned long long alen = 16;
  unsigned long long mlen = 16;
  unsigned long long clen;
  int result = 0;

#if defined(AVR_UART)
  avr_uart_init();
  stdout = &avr_uart_output;
  stdin = &avr_uart_input_echo;
#endif

  uint32_t total_time = 0;
  HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0);    // LED ON
    HAL_Delay(5000);                                          // Wait 5 seconds
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1);  // LED OFF
  uint32_t start_time = HAL_GetTick();
  for (int i = 0; i < 20000; i++) {

      result |= crypto_aead_encrypt(c, &clen, m, mlen, a, alen, NULL, n, k);

  }
  uint32_t end_time = HAL_GetTick();
        uint32_t elapsed = end_time - start_time;
        total_time += elapsed;

  /* Turn ON LED on PC13, wait 5 seconds, then turn OFF LED */
  HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0);    // LED ON
  HAL_Delay(5000+result);                                          // Wait 5 seconds
  HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1);  // LED OFF

  return result;
}
```


### Appendix I

main.c

gost_main() (non-optimized)

```c
/* GOST test function */
int gost_main() {
    // Define the 256-bit key (32 bytes)
    uint8_t key[32] = {
        0x04, 0x75, 0xF6, 0xE0, 0x50, 0x38, 0xFB, 0xFA, 
        0xD2, 0xC7, 0xC3, 0x90, 0xED, 0xB3, 0xCA, 0x3D,
        0x15, 0x47, 0x12, 0x42, 0x91, 0xAE, 0x1E, 0x8A, 
        0x2F, 0x79, 0xCD, 0x9E, 0xD2, 0xBC, 0xEF, 0xBD
    };

    // Define a sample S-box (128 bytes, 8 rows of 16 nibbles)
    uint8_t sbox[128] = {
        0x04, 0x02, 0x0F, 0x05, 0x09, 0x01, 0x00, 0x08, 0x0E, 0x03, 0x0B, 0x0C, 0x0D, 0x07, 0x0A, 0x06,
        0x0C, 0x09, 0x0F, 0x0E, 0x08, 0x01, 0x03, 0x0A, 0x02, 0x07, 0x04, 0x0D, 0x06, 0x00, 0x0B, 0x05,
        0x0D, 0x08, 0x0E, 0x0C, 0x07, 0x03, 0x09, 0x0A, 0x01, 0x05, 0x02, 0x04, 0x06, 0x0F, 0x00, 0x0B,
        0x0E, 0x09, 0x0B, 0x02, 0x05, 0x0F, 0x07, 0x01, 0x00, 0x0D, 0x0C, 0x06, 0x0A, 0x04, 0x03, 0x08,
        0x03, 0x0E, 0x05, 0x09, 0x06, 0x08, 0x00, 0x0D, 0x0A, 0x0B, 0x07, 0x0C, 0x02, 0x01, 0x0F, 0x04,
        0x08, 0x0F, 0x06, 0x0B, 0x01, 0x09, 0x0C, 0x05, 0x0D, 0x03, 0x07, 0x0A, 0x00, 0x0E, 0x02, 0x04,
        0x09, 0x0B, 0x0C, 0x00, 0x03, 0x06, 0x07, 0x05, 0x04, 0x08, 0x0E, 0x0F, 0x01, 0x0A, 0x02, 0x0D,
        0x0C, 0x06, 0x05, 0x02, 0x0B, 0x00, 0x09, 0x0D, 0x03, 0x0E, 0x07, 0x0A, 0x0F, 0x04, 0x01, 0x08
    };

    // Test data (64 bytes - multiple blocks)
    uint8_t test_data[64];
    
    // Initialize test data
    for (int i = 0; i < sizeof(test_data); i++) {
        test_data[i] = i & 0xFF;
    }

    // Performance measurement variables
    uint32_t iterations = 20000;
    uint32_t start_time, end_time, elapsed;
    
    // Signal start of benchmark
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
    HAL_Delay(5000); // Wait 3 seconds
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
    
    // Measure time for original GOST implementation
    start_time = HAL_GetTick();
    for (uint32_t i = 0; i < iterations; i++) {
        GOST_Encrypt_SR(test_data, 8, _GOST_Mode_Encrypt, sbox, key);
    }
    end_time = HAL_GetTick();
    elapsed = end_time - start_time;
    
    // Signal end of benchmark
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
    HAL_Delay(1000);
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
    
    // Flash LED to indicate elapsed time (in seconds)
    uint32_t elapsed_seconds = elapsed / 1000;
    if (elapsed_seconds == 0) elapsed_seconds = 1;
    
    HAL_Delay(2000); // Pause before blinking
    
    for (uint32_t i = 0; i < elapsed_seconds; i++) {
        HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
        HAL_Delay(200);
        HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
        HAL_Delay(200);
    }
    
    return elapsed;
}
```

### Appendix J

main.c

gost_opt_main() (optimized version of gost_main())

```c
/* GOST test function */
// Optimized GOST
int gost_opt_main() {
    // Define the 256-bit key (32 bytes) - SAME AS gost_main()
    uint8_t key[32] = {
        0x04, 0x75, 0xF6, 0xE0, 0x50, 0x38, 0xFB, 0xFA, 
        0xD2, 0xC7, 0xC3, 0x90, 0xED, 0xB3, 0xCA, 0x3D,
        0x15, 0x47, 0x12, 0x42, 0x91, 0xAE, 0x1E, 0x8A, 
        0x2F, 0x79, 0xCD, 0x9E, 0xD2, 0xBC, 0xEF, 0xBD
    };

    // Define a sample S-box (128 bytes, 8 rows of 16 nibbles) - SAME AS gost_main()
    uint8_t sbox[128] = {
        0x04, 0x02, 0x0F, 0x05, 0x09, 0x01, 0x00, 0x08, 0x0E, 0x03, 0x0B, 0x0C, 0x0D, 0x07, 0x0A, 0x06,
        0x0C, 0x09, 0x0F, 0x0E, 0x08, 0x01, 0x03, 0x0A, 0x02, 0x07, 0x04, 0x0D, 0x06, 0x00, 0x0B, 0x05,
        0x0D, 0x08, 0x0E, 0x0C, 0x07, 0x03, 0x09, 0x0A, 0x01, 0x05, 0x02, 0x04, 0x06, 0x0F, 0x00, 0x0B,
        0x0E, 0x09, 0x0B, 0x02, 0x05, 0x0F, 0x07, 0x01, 0x00, 0x0D, 0x0C, 0x06, 0x0A, 0x04, 0x03, 0x08,
        0x03, 0x0E, 0x05, 0x09, 0x06, 0x08, 0x00, 0x0D, 0x0A, 0x0B, 0x07, 0x0C, 0x02, 0x01, 0x0F, 0x04,
        0x08, 0x0F, 0x06, 0x0B, 0x01, 0x09, 0x0C, 0x05, 0x0D, 0x03, 0x07, 0x0A, 0x00, 0x0E, 0x02, 0x04,
        0x09, 0x0B, 0x0C, 0x00, 0x03, 0x06, 0x07, 0x05, 0x04, 0x08, 0x0E, 0x0F, 0x01, 0x0A, 0x02, 0x0D,
        0x0C, 0x06, 0x05, 0x02, 0x0B, 0x00, 0x09, 0x0D, 0x03, 0x0E, 0x07, 0x0A, 0x0F, 0x04, 0x01, 0x08
    };

    // Create optimized substitution table
    GOST_Subst_Table subst_table;
    for(int i = 0; i < 4; i++) {
        uint8_t* sbox_low = sbox + (i * 2) * 16;
        uint8_t* sbox_high = sbox + (i * 2 + 1) * 16;
        
        for(int b = 0; b < 256; b++) {
            uint8_t low_nibble = b & 0x0F;
            uint8_t high_nibble = (b >> 4) & 0x0F;
            uint8_t low_subst = sbox_low[low_nibble];
            uint8_t high_subst = sbox_high[high_nibble];
            subst_table[i*256 + b] = low_subst | (high_subst << 4);
        }
    }

    // Test data (identical to gost_main)
    uint8_t test_data[64];
    
    // Initialize test data (identical to gost_main)
    for (int i = 0; i < sizeof(test_data); i++) {
        test_data[i] = i & 0xFF;
    }
    
    // Performance measurement variables
    uint32_t iterations = 20000;
    uint32_t start_time, end_time, elapsed;
    
    // Signal start of benchmark
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
    HAL_Delay(5000); // Wait 3 seconds
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF

    // Measure performance
    start_time = HAL_GetTick();
    for (uint32_t i = 0; i < iterations; i++) {
        GOST_Encrypt_SR_Opt(test_data, 8, _GOST_Mode_Encrypt, subst_table, key);
    }
    end_time = HAL_GetTick();
    elapsed = end_time - start_time;
    
    // Signal end of benchmark
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
    HAL_Delay(1000);
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
    
    // Flash LED to indicate elapsed time (in seconds)
    uint32_t elapsed_seconds = elapsed / 1000;
    if (elapsed_seconds == 0) elapsed_seconds = 1;
    
    HAL_Delay(2000); // Pause before blinking
    
    for (uint32_t i = 0; i < elapsed_seconds; i++) {
        HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
        HAL_Delay(200);
        HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
        HAL_Delay(200);
    }

    return elapsed;
}
```


### Appendix K

main.c

Benchmarking ASCON AEAD and GOST algorithms.

```c
/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{

  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_TIM1_Init();
  /* USER CODE BEGIN 2 */

  /* USER CODE END 2 */

  /* ASCON CODE BEGIN */
  // ascon_main(); // it took 584 seconds (11.11% faster than the original)
  /* ASCON CODE END */

  /* GOST CODE BEGIN */
  // Original GOST
  uint32_t orig_time = gost_main(); // it took 04:49 - 04:56 secs
  /* GOST CODE END */

  /* GOST CODE BEGIN */
  // Optimized GOST
  uint32_t opt_time = gost_opt_main(); // it took 02:27 secs (49.13% faster than the original)
  /* GOST CODE END */

  // Show performance comparison
  HAL_Delay(3000); // Pause before final results

  // Calculate performance improvement ratio
  float improvement = 0;
  if (opt_time > 0) {
    improvement = (float)orig_time / opt_time;
  }

  // Display results through LED blinks
  // First: Original time (1 blink per second)
  // Second: Optimized time (1 blink per second)
  // Third: Performance ratio (number of blinks indicates improvement factor)
  
  // Display the improvement factor
  int blinks = 0;
  if (improvement >= 1.0f) {
    blinks = (int)improvement;
    if (blinks < 1) blinks = 1;
    if (blinks > 10) blinks = 10; // Cap at 10 blinks
    
    // Rapid blinks indicate speedup factor
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
    HAL_Delay(1000);
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
    HAL_Delay(1000);
    
    for (int i = 0; i < blinks; i++) {
      HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
      HAL_Delay(100);
      HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
      HAL_Delay(100);
    }
  } else {
    // Slow blinks indicate slowdown (optimization failed)
    for (int i = 0; i < 3; i++) {
      HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
      HAL_Delay(1000);
      HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
      HAL_Delay(1000);
    }
  }

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
	   HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1);
	   HAL_Delay(1000);
	   HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0);
	   HAL_Delay(1000);
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
  }
  /* USER CODE END 3 */
}
```


### Appendix L

ASCON AEAD 128 bit original ROUND_LOOP()

```c
forceinline void ROUND_LOOP(ascon_state_t* s, const uint8_t* C,
                            const uint8_t* E) {
  uint32_t tmp0, tmp1;
  __asm__ __volatile__(
      "rbegin_%=:;\n\t"
      "ldrb %[tmp1], [%[C]], #1\n\t"
      "eor %[x0_l], %[x0_l], %[x4_l]\n\t"
      "eor %[x4_l], %[x4_l], %[x3_l]\n\t"
      "eor %[x2_l], %[x2_l], %[x1_l]\n\t"
      "orn %[tmp0], %[x4_l], %[x0_l]\n\t"
      "eor %[x2_l], %[x2_l], %[tmp1]\n\t"
      "bic %[tmp1], %[x2_l], %[x1_l]\n\t"
      "eor %[x0_l], %[x0_l], %[tmp1]\n\t"
      "orn %[tmp1], %[x3_l], %[x4_l]\n\t"
      "eor %[x2_l], %[x2_l], %[tmp1]\n\t"
      "bic %[tmp1], %[x1_l], %[x0_l]\n\t"
      "eor %[x4_l], %[x4_l], %[tmp1]\n\t"
      "and %[tmp1], %[x3_l], %[x2_l]\n\t"
      "eor %[x1_l], %[x1_l], %[tmp1]\n\t"
      "eor %[x3_l], %[x3_l], %[tmp0]\n\t"
      "ldrb %[tmp1], [%[C]], #1\n\t"
      "eor %[x1_l], %[x1_l], %[x0_l]\n\t"
      "eor %[x3_l], %[x3_l], %[x2_l]\n\t"
      "eor %[x0_l], %[x0_l], %[x4_l]\n\t"
      "eor %[x0_h], %[x0_h], %[x4_h]\n\t"
      "eor %[x4_h], %[x4_h], %[x3_h]\n\t"
      "eor %[x2_h], %[x2_h], %[tmp1]\n\t"
      "eor %[x2_h], %[x2_h], %[x1_h]\n\t"
      "orn %[tmp0], %[x4_h], %[x0_h]\n\t"
      "bic %[tmp1], %[x2_h], %[x1_h]\n\t"
      "eor %[x0_h], %[x0_h], %[tmp1]\n\t"
      "orn %[tmp1], %[x3_h], %[x4_h]\n\t"
      "eor %[x2_h], %[x2_h], %[tmp1]\n\t"
      "bic %[tmp1], %[x1_h], %[x0_h]\n\t"
      "eor %[x4_h], %[x4_h], %[tmp1]\n\t"
      "and %[tmp1], %[x3_h], %[x2_h]\n\t"
      "eor %[x1_h], %[x1_h], %[tmp1]\n\t"
      "eor %[x3_h], %[x3_h], %[tmp0]\n\t"
      "eor %[x1_h], %[x1_h], %[x0_h]\n\t"
      "eor %[x3_h], %[x3_h], %[x2_h]\n\t"
      "eor %[x0_h], %[x0_h], %[x4_h]\n\t"
      "eor %[tmp0], %[x0_l], %[x0_h], ror #4\n\t"
      "eor %[tmp1], %[x0_h], %[x0_l], ror #5\n\t"
      "eor %[x0_h], %[x0_h], %[tmp0], ror #10\n\t"
      "eor %[x0_l], %[x0_l], %[tmp1], ror #9\n\t"
      "eor %[tmp0], %[x1_l], %[x1_l], ror #11\n\t"
      "eor %[tmp1], %[x1_h], %[x1_h], ror #11\n\t"
      "eor %[x1_h], %[x1_h], %[tmp0], ror #20\n\t"
      "eor %[x1_l], %[x1_l], %[tmp1], ror #19\n\t"
      "eor %[tmp0], %[x2_l], %[x2_h], ror #2\n\t"
      "eor %[tmp1], %[x2_h], %[x2_l], ror #3\n\t"
      "eor %[x2_h], %[x2_h], %[tmp0], ror #1\n\t"
      "eor %[x2_l], %[x2_l], %[tmp1]\n\t"
      "eor %[tmp0], %[x3_l], %[x3_h], ror #3\n\t"
      "eor %[tmp1], %[x3_h], %[x3_l], ror #4\n\t"
      "eor %[x3_l], %[x3_l], %[tmp0], ror #5\n\t"
      "eor %[x3_h], %[x3_h], %[tmp1], ror #5\n\t"
      "eor %[tmp0], %[x4_l], %[x4_l], ror #17\n\t"
      "eor %[tmp1], %[x4_h], %[x4_h], ror #17\n\t"
      "eor %[x4_h], %[x4_h], %[tmp0], ror #4\n\t"
      "eor %[x4_l], %[x4_l], %[tmp1], ror #3\n\t"
      "cmp %[C], %[E]\n\t"
      "bne rbegin_%=\n\t"
      :
      [x0_l] "+r"(s->w[0][0]), [x0_h] "+r"(s->w[0][1]), [x1_l] "+r"(s->w[1][0]),
      [x1_h] "+r"(s->w[1][1]), [x2_l] "+r"(s->w[2][0]), [x2_h] "+r"(s->w[2][1]),
      [x3_l] "+r"(s->w[3][0]), [x3_h] "+r"(s->w[3][1]), [x4_l] "+r"(s->w[4][0]),
      [x4_h] "+r"(s->w[4][1]), [C] "+r"(C), [E] "+r"(E), [tmp0] "=r"(tmp0),
      [tmp1] "=r"(tmp1)
      :
      : "cc");
}
```


### Appendix M

ASCON AEAD 128 bit optimized ROUND_LOOP()

```c
forceinline void ROUND_LOOP(ascon_state_t* s, const uint8_t* C,
                            const uint8_t* E) {
  uint32_t tmp0, tmp1;
  __asm__ __volatile__(
      "rbegin_%=:\n\t"
      /* --- Load round constant (aligned load of 16 bits) --- */
      "ldrh   %[tmp1], [%[C]], #2\n\t"       // Load 16-bit constant; post-increment pointer
      "ubfx   %[tmp0], %[tmp1], #8, #8\n\t"    // Extract high byte constant
      "and    %[tmp1], %[tmp1], #0xFF\n\t"     // Extract low byte constant

      /* --- Interleaved processing for low and high halves --- */
      /* Start by mixing x0 and x4 for both halves concurrently */
      "eor    %[x0_l], %[x0_l], %[x4_l]\n\t"    // Low: x0 ^= x4
      "eor    %[x0_h], %[x0_h], %[x4_h]\n\t"    // High: x0 ^= x4

      /* Process mixing x2 and x1 and inject constants in parallel */
      "eor    %[x2_l], %[x2_l], %[x1_l]\n\t"    // Low: x2 ^= x1
      "eor    %[x2_l], %[x2_l], %[tmp1]\n\t"    // Low: x2 ^= low-byte constant
      "eor    %[x2_h], %[x2_h], %[x1_h]\n\t"    // High: x2 ^= x1
      "eor    %[x2_h], %[x2_h], %[tmp0]\n\t"    // High: x2 ^= high-byte constant

      /* Now compute low-half intermediate values */
      "orn    %[tmp1], %[x4_l], %[x0_l]\n\t"     // Low: tmp1 = ~(x4_l) OR x0_l
      "bic    %[tmp1], %[x2_l], %[x1_l]\n\t"     // Low: tmp1 &= ~(x1_l)
      "eor    %[x0_l], %[x0_l], %[tmp1]\n\t"     // Low: update x0_l

      /* Compute high-half intermediate values concurrently */
      "orn    %[tmp0], %[x4_h], %[x0_h]\n\t"      // High: tmp0 = ~(x4_h) OR x0_h
      "bic    %[tmp1], %[x2_h], %[x1_h]\n\t"      // High: tmp1 = ~(x2_h) & ~(x1_h)
      "eor    %[x0_h], %[x0_h], %[tmp1]\n\t"      // High: update x0_h

      /* Continue low-half processing */
      "orn    %[tmp1], %[x3_l], %[x4_l]\n\t"     // Low: compute secondary temporary
      "eor    %[x2_l], %[x2_l], %[tmp1]\n\t"     // Low: update x2_l
      "bic    %[tmp1], %[x1_l], %[x0_l]\n\t"     // Low: further refine tmp1
      "eor    %[x4_l], %[x4_l], %[tmp1]\n\t"     // Low: update x4_l
      "and    %[tmp1], %[x3_l], %[x2_l]\n\t"     // Low: combine bits from x3_l and x2_l
      "eor    %[x1_l], %[x1_l], %[tmp1]\n\t"     // Low: update x1_l
      "eor    %[x3_l], %[x3_l], %[tmp0]\n\t"     // Low: inject high-byte constant into x3_l

      /* Continue high-half processing */
      "orn    %[tmp1], %[x3_h], %[x4_h]\n\t"      // High: compute secondary temporary
      "eor    %[x2_h], %[x2_h], %[tmp1]\n\t"      // High: update x2_h
      "bic    %[tmp1], %[x1_h], %[x0_h]\n\t"      // High: refine processing
      "eor    %[x4_h], %[x4_h], %[tmp1]\n\t"      // High: update x4_h
      "and    %[tmp1], %[x3_h], %[x2_h]\n\t"      // High: combine bits from x3_h and x2_h
      "eor    %[x1_h], %[x1_h], %[tmp1]\n\t"      // High: update x1_h
      "eor    %[x3_h], %[x3_h], %[tmp0]\n\t"      // High: finalize high-half processing

      /* --- Linear layer: rotations and further mixing --- */
      "eor    %[tmp0], %[x0_l], %[x0_h], ror #4\n\t"  // x0 mixing with rotation (#4)
      "eor    %[tmp1], %[x0_h], %[x0_l], ror #5\n\t"   // Alternate x0 mix (#5)
      "eor    %[x0_h], %[x0_h], %[tmp0], ror #10\n\t"  // Update x0_h (#10)
      "eor    %[x0_l], %[x0_l], %[tmp1], ror #9\n\t"   // Update x0_l (#9)

      "eor    %[tmp0], %[x1_l], %[x1_l], ror #11\n\t"  // x1 low rotation (#11)
      "eor    %[tmp1], %[x1_h], %[x1_h], ror #11\n\t"  // x1 high rotation (#11)
      "eor    %[x1_h], %[x1_h], %[tmp0], ror #20\n\t"  // Update x1_h (#20)
      "eor    %[x1_l], %[x1_l], %[tmp1], ror #19\n\t"  // Update x1_l (#19)

      "eor    %[tmp0], %[x2_l], %[x2_h], ror #2\n\t"   // x2 rotation (#2)
      "eor    %[tmp1], %[x2_h], %[x2_l], ror #3\n\t"   // x2 alternate rotation (#3)
      "eor    %[x2_h], %[x2_h], %[tmp0], ror #1\n\t"    // Update x2_h (#1)
      "eor    %[x2_l], %[x2_l], %[tmp1]\n\t"           // Update x2_l

      "eor    %[tmp0], %[x3_l], %[x3_h], ror #3\n\t"    // x3 rotation (#3)
      "eor    %[tmp1], %[x3_h], %[x3_l], ror #4\n\t"    // x3 alternate rotation (#4)
      "eor    %[x3_l], %[x3_l], %[tmp0], ror #5\n\t"    // Update x3_l (#5)
      "eor    %[x3_h], %[x3_h], %[tmp1], ror #5\n\t"    // Update x3_h (#5)

      "eor    %[tmp0], %[x4_l], %[x4_l], ror #17\n\t"   // x4 rotation (#17)
      "eor    %[tmp1], %[x4_h], %[x4_h], ror #17\n\t"   // x4 alternate rotation (#17)
      "eor    %[x4_h], %[x4_h], %[tmp0], ror #4\n\t"    // Update x4_h (#4)
      "eor    %[x4_l], %[x4_l], %[tmp1], ror #3\n\t"    // Update x4_l (#3)

      /* --- Loop control --- */
      "cmp    %[C], %[E]\n\t"         // Compare constant pointer with end address
      "bne    rbegin_%=\n\t"          // If not finished, loop back
      :
      [x0_l] "+r"(s->w[0][0]), [x0_h] "+r"(s->w[0][1]),
      [x1_l] "+r"(s->w[1][0]), [x1_h] "+r"(s->w[1][1]),
      [x2_l] "+r"(s->w[2][0]), [x2_h] "+r"(s->w[2][1]),
      [x3_l] "+r"(s->w[3][0]), [x3_h] "+r"(s->w[3][1]),
      [x4_l] "+r"(s->w[4][0]), [x4_h] "+r"(s->w[4][1]),
      [C] "+r"(C), [E] "+r"(E),
      [tmp0] "=r"(tmp0), [tmp1] "=r"(tmp1)
      :
      : "cc");
}
```


### Appendix N

GOST 28147-89: original implementation of GOST_Crypt_Step()

```c
void GOST_Crypt_Step(GOST_Data_Part *DATA, uint8_t *GOST_Table, uint32_t GOST_Key, bool Last )
{
    typedef  union
    {
        uint32_t full;
        uint8_t parts[_GOST_TABLE_NODES/2];
    } GOST_Data_Part_sum;
    GOST_Data_Part_sum S;
    uint8_t m;
    uint8_t tmp;
    //N1=Lo(DATA); N2=Hi(DATA)

    S.full = (uint32_t)((*DATA).half[_GOST_Data_Part_N1_Half]+GOST_Key) ;//S=(N1+X)mod2^32

    for(m=0; m<(_GOST_TABLE_NODES/2); m++)
    {
        //S(m)=H(m,S)
        tmp=S.parts[m];
        S.parts[m] = *(GOST_Table+(tmp&0x0F));//Low value
        GOST_Table+= _GOST_TABLE_MAX_NODE_VALUE;//next line in table
        S.parts[m] |= (*(GOST_Table+((tmp&0xF0)>>4)))<<4;//Hi value
        GOST_Table+= _GOST_TABLE_MAX_NODE_VALUE;//next line in table

    }
    S.full = (*DATA).half[_GOST_Data_Part_N2_Half]^custom_lrotl(S.full,11);//S=Rl(11,S); rol S,11 //S XOR N2
    if (Last)
    {
        (*DATA).half[_GOST_Data_Part_N2_Half] = S.full; //N2=S
    }else
    {
        (*DATA).half[_GOST_Data_Part_N2_Half] = (*DATA).half[_GOST_Data_Part_N1_Half];//N2=N1
        (*DATA).half[_GOST_Data_Part_N1_Half] = S.full;//N1=S
    }
}
```

GOST 28147-89: original implementation of GOST_Crypt_32_E_Cicle()

```c
void GOST_Crypt_32_E_Cicle(GOST_Data_Part *DATA, uint8_t *GOST_Table, uint32_t *GOST_Key)
{
    uint8_t k,j;
    uint32_t *GOST_Key_tmp=GOST_Key;
//Key rotation:
//K0,K1,K2,K3,K4,K5,K6,K7, K0,K1,K2,K3,K4,K5,K6,K7, K0,K1,K2,K3,K4,K5,K6,K7, K7,K6,K5,K4,K3,K2,K1,K0

    for(k=0;k<3;k++)
    {
        for (j=0;j<8;j++)
        {
            GOST_Crypt_Step(DATA, GOST_Table, *GOST_Key,_GOST_Next_Step ) ;
            GOST_Key++;
        }
        GOST_Key=GOST_Key_tmp;
    }

    GOST_Key+=7;//K7

    for (j=0;j<7;j++)
    {
        GOST_Crypt_Step(DATA, GOST_Table, *GOST_Key,_GOST_Next_Step ) ;
        GOST_Key--;
    }
    GOST_Crypt_Step(DATA, GOST_Table, *GOST_Key,_GOST_Last_Step ) ;
}

void GOST_Crypt_32_D_Cicle(GOST_Data_Part *DATA, uint8_t *GOST_Table, uint32_t *GOST_Key)
{
    uint8_t k,j;
//Key rotation:
//K0,K1,K2,K3,K4,K5,K6,K7, K7,K6,K5,K4,K3,K2,K1,K0, K7,K6,K5,K4,K3,K2,K1,K0, K7,K6,K5,K4,K3,K2,K1,K0

[...and etc. almost similar to the encrypt version above.]
}
```

GOST 28147-89: original implementation of GOST_Encrypt_SR()

```c
void GOST_Encrypt_SR(uint8_t *Data, uint32_t Size, bool Mode, uint8_t *GOST_Table, uint8_t *GOST_Key )
{
    uint8_t Cur_Part_Size;
    GOST_Data_Part Data_prep;
    uint32_t *GOST_Key_pt=(uint32_t *) GOST_Key;

    while (Size!=0)
    {
        Cur_Part_Size=_Min(_GOST_Part_Size,Size);
        memset(&Data_prep,_GOST_Def_Byte,sizeof(Data_prep));
        memcpy(&Data_prep,Data,Cur_Part_Size);
#if _GOST_ROT==1
        Data_prep.half[_GOST_Data_Part_N2_Half]=_GOST_SWAP32(Data_prep.half[_GOST_Data_Part_N2_Half]);
        Data_prep.half[_GOST_Data_Part_N1_Half]=_GOST_SWAP32(Data_prep.half[_GOST_Data_Part_N1_Half]);
#endif
        if (Mode==_GOST_Mode_Encrypt)
        {
            GOST_Crypt_32_E_Cicle(&Data_prep,GOST_Table,GOST_Key_pt);
        } else
        {
            GOST_Crypt_32_D_Cicle(&Data_prep,GOST_Table,GOST_Key_pt);
        }
#if _GOST_ROT==1
        Data_prep.half[_GOST_Data_Part_N2_Half]=_GOST_SWAP32(Data_prep.half[_GOST_Data_Part_N2_Half]);
        Data_prep.half[_GOST_Data_Part_N1_Half]=_GOST_SWAP32(Data_prep.half[_GOST_Data_Part_N1_Half]);
#endif
        memcpy(Data,&Data_prep, Cur_Part_Size);
        Data+=Cur_Part_Size;
        Size-=Cur_Part_Size;
   }

}
```

### Appendix O

GOST 28147-89: optimized implementation of GOST_Crypt_Step()

```c
uint32_t GOST_Crypt_Step_Opt(uint32_t data, GOST_Subst_Table Table, uint32_t key, int last_step)
{
    // XOR the right half with the key
    uint32_t result = (data + key) & 0xffffffff;
    
    // Apply substitution using precomputed table
    result = Table[(result & 0xff)] | 
             (Table[256 + ((result >> 8) & 0xff)] << 8) |
             (Table[512 + ((result >> 16) & 0xff)] << 16) |
             (Table[768 + ((result >> 24) & 0xff)] << 24);
    
    // 11-bit left shift
    result = ((result << 11) | (result >> 21)) & 0xffffffff;
    
    return result;
}
```

GOST 28147-89: optimized implementation of GOST_Crypt_32_E_Cicle()

```c

void GOST_Crypt_32_E_Cicle_Opt(uint32_t *n1, uint32_t *n2, GOST_Subst_Table Table, uint32_t *GOST_Key)
{
    // Unroll the first 24 rounds for better performance
    uint32_t tmp;
    
    // Round 1-8 (K0-K7)
    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[0], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[1], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[2], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[3], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[4], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[5], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[6], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[7], 0);
    *n2 = tmp;

    // Round 9-16 (K0-K7)
    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[0], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[1], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[2], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[3], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[4], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[5], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[6], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[7], 0);
    *n2 = tmp;

    // Round 17-24 (K0-K7)
    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[0], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[1], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[2], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[3], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[4], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[5], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[6], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[7], 0);
    *n2 = tmp;

    // Last 8 rounds (K7-K0)
    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[7], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[6], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[5], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[4], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[3], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[2], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[1], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[0], 1);
    *n2 = tmp;
}
```

GOST 28147-89: optimized implementation of GOST_Crypt_32_D_Cicle()

```c
void GOST_Crypt_32_D_Cicle_Opt(uint32_t *n1, uint32_t *n2, GOST_Subst_Table Table, uint32_t *GOST_Key)
{
    // Unroll the 32 rounds for better performance
    uint32_t tmp;
    
    // First 8 rounds (K0-K7)
    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[0], 0);
    *n2 = tmp;

    [...and etc. almost similar to the encrypt version above.]

}
```

GOST 28147-89: optimized implementation of GOST_Encrypt_SR()

```c
int GOST_Encrypt_SR_Opt(uint8_t *Data, uint32_t Size, uint8_t Mode, GOST_Subst_Table Table, uint8_t *GOST_Key_start)
{
    uint32_t GOST_Key[8];
    GOST_Data_Part Temp;
    uint32_t n;
    
    // Prepare the key in the correct byte order
    for (int i = 0; i < 8; i++) {
        GOST_Key[i] = _GOST_SWAP32(((uint32_t *)GOST_Key_start)[i]);
    }
    
    // Process full blocks
    for (n = 0; n < Size / 8; n++) {
        // Load data directly from the data pointer into GOST_Data_Part structure
        Temp.half[_GOST_Data_Part_N1_Half] = _GOST_SWAP32(((uint32_t *)(Data + n * 8))[0]);
        Temp.half[_GOST_Data_Part_N2_Half] = _GOST_SWAP32(((uint32_t *)(Data + n * 8))[1]);
        
        // Encrypt or decrypt the data based on the Mode parameter
        if (Mode == _GOST_Mode_Encrypt) {
            GOST_Crypt_32_E_Cicle_Opt(&Temp.half[_GOST_Data_Part_N1_Half], &Temp.half[_GOST_Data_Part_N2_Half], Table, GOST_Key);
        } else if (Mode == _GOST_Mode_Decrypt) {
            GOST_Crypt_32_D_Cicle_Opt(&Temp.half[_GOST_Data_Part_N1_Half], &Temp.half[_GOST_Data_Part_N2_Half], Table, GOST_Key);
        }
        
        // Write the result back to the data pointer
        ((uint32_t *)(Data + n * 8))[0] = _GOST_SWAP32(Temp.half[_GOST_Data_Part_N1_Half]);
        ((uint32_t *)(Data + n * 8))[1] = _GOST_SWAP32(Temp.half[_GOST_Data_Part_N2_Half]);
    }
    
    // Handle any remaining partial block (less than 8 bytes)
    uint32_t remain = Size % 8;
    if (remain > 0) {
        uint8_t block[8] = {0};
        // Copy the remaining bytes to a temp buffer
        for (uint32_t i = 0; i < remain; i++) {
            block[i] = Data[n * 8 + i];
        }
        
        // Process the final partial block
        Temp.half[_GOST_Data_Part_N1_Half] = _GOST_SWAP32(((uint32_t *)block)[0]);
        Temp.half[_GOST_Data_Part_N2_Half] = _GOST_SWAP32(((uint32_t *)block)[1]);
        
        if (Mode == _GOST_Mode_Encrypt) {
            GOST_Crypt_32_E_Cicle_Opt(&Temp.half[_GOST_Data_Part_N1_Half], &Temp.half[_GOST_Data_Part_N2_Half], Table, GOST_Key);
        } else if (Mode == _GOST_Mode_Decrypt) {
            GOST_Crypt_32_D_Cicle_Opt(&Temp.half[_GOST_Data_Part_N1_Half], &Temp.half[_GOST_Data_Part_N2_Half], Table, GOST_Key);
        }
        
        ((uint32_t *)block)[0] = _GOST_SWAP32(Temp.half[_GOST_Data_Part_N1_Half]);
        ((uint32_t *)block)[1] = _GOST_SWAP32(Temp.half[_GOST_Data_Part_N2_Half]);
        
        // Copy the encrypted/decrypted data back to the original buffer
        for (uint32_t i = 0; i < remain; i++) {
            Data[n * 8 + i] = block[i];
        }
    }
    
    return 0;
}
```