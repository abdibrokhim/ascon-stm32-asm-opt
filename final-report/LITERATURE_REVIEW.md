# Code Optimization for STM32F103/STM32F407 Discovery Boards – Time and Memory Analysis

## Literature Review

### 3.1 Performance‑Oriented Programming for Embedded Systems

Performance-oriented programming for embedded systems focuses on developing software optimized explicitly for constrained computational environments typical in embedded processors. Unlike desktop or server processors, which utilize complex features like extensive out-of-order execution units and sophisticated cache hierarchies to extract maximum performance from unoptimized legacy or architecture-agnostic code, embedded processors necessitate deliberate software-level optimization to achieve efficient performance (Yiu, 2014; Furber, 2000). Embedded systems generally have limited resources, including processing power, memory bandwidth, and energy availability, requiring tailored programming techniques to maximize resource utilization (Patterson & Hennessy, 2017).

Seminal literature in the field identifies several key performance-tuning techniques frequently employed in embedded-systems programming:

1. **Loop Unrolling:** This technique involves replicating the body of a loop multiple times, reducing the overhead associated with loop control instructions, conditional branching, and indexing. Loop unrolling can significantly improve performance by enabling better scheduling of instructions and facilitating compiler optimizations such as vectorization and pipelining (Wolf, 2012). However, excessive unrolling may cause instruction cache pressure and diminish returns due to instruction fetch bandwidth limitations (Muchnick, 1997).

2. **Compiler Flags and Optimization Levels:** Compiler-driven optimization strategies play a critical role in embedded systems. Compiler flags such as `-O2`, `-O3`, or specialized flags like `-funroll-loops`, `-ftree-vectorize`, and architecture-specific flags (`-mcpu=cortex-m4`, `-mfpu=fpv4-sp-d16`) allow the compiler to generate machine code specifically tailored to a processor’s architecture and application needs (Sakr, 2020). Empirical studies have demonstrated that judicious selection of compiler optimization flags can yield performance improvements exceeding 30% in compute-intensive embedded applications (Baque et al., 2020).

3. **Memory Alignment and Access Patterns:** Proper data alignment within memory can dramatically improve memory throughput and reduce access latency. Embedded processors typically enforce strict memory alignment constraints; misaligned memory accesses can incur substantial performance penalties or even generate processor faults (Hennessy & Patterson, 2018). Literature on ARM Cortex-based systems emphasizes aligning data structures and arrays to boundaries (e.g., 32-bit or 64-bit alignment) to leverage efficient burst memory accesses and minimize memory stalls (Yiu, 2014; ARM Holdings, 2020).

4. **Instruction-Level Parallelism (ILP) and SIMD:** Embedded processors such as ARM Cortex-M4 offer specialized Single Instruction, Multiple Data (SIMD) extensions, such as ARM’s NEON technology. Exploiting SIMD instructions allows parallel execution of arithmetic operations on multiple data elements, enhancing computational throughput, particularly in digital signal processing and multimedia applications (ARM Holdings, 2020; Gavrielov et al., 2019). However, effective use of SIMD typically necessitates explicit programmer intervention through intrinsics or inline assembly due to limitations in compiler auto-vectorization capabilities (Yiu, 2014).

While these techniques can significantly improve the performance of compute-bound tasks, it is crucial to recognize the distinction between compute-bound and I/O-bound applications. Compute-bound tasks, such as video encoding, benefit substantially from these optimization strategies, whereas I/O-bound tasks typically do not, since their performance is dominated by peripheral or communication latency rather than processor or memory efficiency (Wolf, 2012).

Thus, the emphasis on performance-oriented programming in embedded systems is justified by the substantial gap in performance achievable by optimized versus non-optimized code, particularly in computation-intensive domains such as digital signal processing, cryptographic operations, and control algorithms (Hennessy & Patterson, 2018).

### 3.2 ARM Architecture and STM32F1/F4 Series Features

ARM (Advanced RISC Machine) architectures have profoundly influenced embedded system design by introducing Reduced Instruction Set Computing (RISC) principles to achieve superior performance and efficiency in resource-constrained environments. ARM architectures have evolved through various generations, notably ARMv6 and ARMv7, each iteration introducing incremental enhancements designed to optimize performance and power efficiency (Furber, 2000; ARM Holdings, 2020).

#### Evolution of ARM RISC Architectures (ARMv6, ARMv7)

ARM architectures emphasize simplicity and efficiency through load-store instruction paradigms, where arithmetic instructions only operate on register operands, necessitating explicit memory load/store instructions (ARM Holdings, 2020). ARMv6 introduced notable advancements in instruction pipeline optimization, improved branch prediction, and basic DSP-oriented instructions. ARMv7 further augmented these capabilities with enhanced SIMD instructions via the NEON extension, significantly boosting performance for multimedia and digital signal processing tasks (ARM Holdings, 2020; Yiu, 2014).

Comparative analyses indicate that ARMv7-based processors exhibit substantial improvements in instruction throughput, particularly for applications exploiting parallel data processing, where NEON instructions can improve arithmetic operation efficiency by a factor of four to eight compared to scalar operations (Gavrielov et al., 2019).

#### STM32F1 and STM32F4 Series Microarchitectural Features

STMicroelectronics’ STM32 microcontroller families, particularly the STM32F1 and STM32F4 series, exemplify the application of ARM architectures in high-performance embedded applications. The STM32F1 series, based on the ARM Cortex-M3 core, delivers a straightforward and cost-effective platform with clock speeds up to 72 MHz and integrated peripherals such as CAN, USB, and Ethernet MAC interfaces (STMicroelectronics, 2021). The relatively simple three-stage pipeline of the Cortex-M3 allows predictable execution timing suitable for deterministic, real-time embedded control systems.

In contrast, the STM32F4 series, employing the ARM Cortex-M4 core, significantly advances computational capabilities by integrating digital signal processing (DSP) instructions, hardware floating-point units (FPU), and advanced microarchitectural enhancements (STMicroelectronics, 2021). Key features of the STM32F4 family include:

- **Advanced Pipeline and Caches:** The Cortex-M4’s pipeline improvements and the Adaptive Real-Time (ART) Accelerator™ enable instruction execution at frequencies up to 180 MHz, achieving up to 225 DMIPS (STMicroelectronics, 2021). The inclusion of instruction and data caches significantly reduces memory access latency, providing substantial performance improvements for compute-intensive applications.

- **Floating-Point and DSP Instructions:** Integrated hardware floating-point units substantially accelerate mathematical computations common in signal processing, control algorithms, and graphical applications, potentially delivering a threefold performance gain over software floating-point emulation (ARM Holdings, 2020; STMicroelectronics, 2021).

- **Dynamic Power Scaling:** Power efficiency enhancements, such as dynamic frequency scaling and peripheral clock gating, enable optimized energy consumption, critical for battery-operated or energy-constrained embedded systems. Comparative studies highlight a significant performance-to-power efficiency advantage in STM32F4 over STM32F1 devices (Baque et al., 2020).

- **Rich Peripheral Integration:** The STM32F4 microcontrollers integrate diverse communication interfaces (e.g., Quad-SPI, Ethernet, USB OTG), high-density memory options, and enhanced security peripherals, expanding their suitability for advanced embedded applications requiring robust connectivity, multimedia support, and secure data handling (STMicroelectronics, 2021).

In summary, the STM32F4 series' architectural improvements over the STM32F1 reflect ARM’s evolutionary approach toward enhanced computational performance and power efficiency, addressing the growing demand for sophisticated functionalities within embedded applications. These microarchitectural and instruction-set advancements demonstrate the critical interplay between hardware enhancements and software optimization strategies, underscoring the importance of both architectural features and optimized software practices for achieving maximal embedded-system performance.

### 3.3 C vs. Assembly: Case Study of Bubble Sort  
### Case Study: Bubble Sort in C and Assembly

This experiment compares the performance of compiler-optimized C code with manually optimized Assembly code for the bubble sort algorithm. Bubble sort is chosen as a baseline due to its simplicity, allowing clear analysis of optimization impacts in resource-constrained IoT environments.

#### Methodology

C Implementation
The bubble sort algorithm is implemented in C.

bubble_sort.c.

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

The -O3 flag enables optimizations such as loop unrolling and function inlining. Execution time is measured using the SysTick timer for an array of size ( N = 32768 ).

Assembly Implementation

A hand-optimized Assembly implementation is developed for the ARM Cortex-M4 architecture. 

bubble_sort_asm.s.

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

Execution time is measured using the SysTick timer, consistent with the C implementation.

Results

To ensure correctness, both implementations are tested with an array of size ( N = 32768 ). A test driver initializes identical arrays, sorts them using both methods, and compares outputs to confirm identical results, ensuring optimizations do not introduce errors.

Driver code: driver.c

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

```bash
C bubble sort time: 1.002104 seconds
Assembly bubble sort time: 1.342916 seconds
Performance improvement: -34.009644%
Verification successful: both implementations produce identical results
abdibrokhim@Ibrohims-MacBook-Pro verify %
```

Interestingly, our assembly implementation is actually slower than the C version. This is likely because the compiler is able to produce highly optimized code with -O3 for the C version. Let's improve our assembly implementation (refer to Materials and Methods section).


### 3.4 Baseline Implementation of ASCON-AEAD128

This section presents a detailed implementation of the ASCON-AEAD128 algorithm in C, tailored for educational clarity and alignment with the NIST Lightweight Cryptography initial public draft published in 2023 (NIST Draft). ASCON, selected as the winner of NIST’s Lightweight Cryptography competition in February 2023, is designed for resource-constrained environments such as Internet of Things (IoT) devices, making it highly relevant for secure embedded systems like STM32 microcontrollers. The implementation focuses on the Authenticated Encryption with Associated Data (AEAD) mode, specifically ASCON-AEAD128, which provides both confidentiality and authenticity using a 128-bit key, 128-bit nonce, and 128-bit authentication tag. This baseline serves as a foundation for understanding ASCON’s structure and supports further optimization studies in this thesis.

Introduction to ASCON-AEAD128

ASCON-AEAD128 is a variant of the ASCON family, based on ASCON-128a, optimized for a 128-bit rate and 192-bit capacity within its 320-bit internal state. The algorithm operates as a sponge-based duplex construction, processing data in blocks and incorporating domain separation to prevent attacks that could mix initialization, associated data, or plaintext phases (ASCON Specification). Its lightweight design ensures efficiency on constrained platforms, critical for IoT applications requiring secure communication. The implementation described here simplifies the process by omitting associated data handling and assuming plaintext sizes are multiples of the block size, aligning with the lecture’s educational focus on core functionality.

Implementation Environment

The implementation is developed in C using Visual Studio, ensuring portability across platforms, including ARM-based STM32 microcontrollers. Standard libraries, such as <stdio.h>, facilitate input/output for debugging, while <stdint.h> ensures consistent data types. The code uses uint64_t for 64-bit unsigned integers, representing the state, key, nonce, and other variables, providing clarity and compatibility with 32-bit and 64-bit architectures.

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

Initialization Phase
Initialization prepares the state for encryption:

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

This phase, shown in Figure Z, ensures the tag authenticates the ciphertext and any associated data (omitted here), leveraging domain separation to prevent forgery attacks.

Table: ASCON-AEAD128 Parameters

Component, Size (bits), Description
State, 320, Five 64-bit words
Key, 128, Two 64-bit words
Nonce, 128, Two 64-bit words
Tag, 128, Two 64-bit words for authentication
Rate, 128, Bits processed per block (s[0], s[1])
Capacity, 192, Remaining state bits for security
Initialization Rounds, 12, Permutation rounds during initialization
Encryption Rounds, 8, Permutation rounds per block
Finalization Rounds, 12, Permutation rounds for tag generation


### 3.5 GOST 28147‑89: Encryption, Decryption & MAC Algorithms 


### 3.6 Research Gaps and Thesis Focus  

