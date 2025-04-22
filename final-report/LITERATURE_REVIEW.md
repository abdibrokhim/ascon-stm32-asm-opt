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

```bash
C bubble sort time: 1.305865 seconds
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

```bash
Assembly bubble sort time: 1.366740 seconds
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

Test run:

```bash
gcc -O3 ascon_aead128_basic_impl.c -o ascon_aead128 && ./ascon_aead128
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

> Full code implementation in Appendix A


### 3.5 GOST 28147-89: Encryption, Decryption, and Message Authentication Code Algorithms

## Introduction and Background  
**GOST 28147-89** is a Soviet/Russian government standard block cipher algorithm, first established in 1989, that defines both data encryption/decryption and message authentication code (MAC) generation procedures ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). The name "GOST" is an acronym for *Gosudarstvennyi Standard*, meaning "State Standard" in Russian. Developed during the late 1970s, the cipher was originally classified as *Top Secret* (later downgraded to *Secret* in 1990) within the USSR, and it remained undisclosed to the public until after the Soviet Union's dissolution ([GOST (block cipher) - Wikipedia](https://en.wikipedia.org/wiki/GOST_(block_cipher))). In 1994, the algorithm was declassified and released publicly as GOST 28147-89, intended as a national alternative to the U.S. DES (Data Encryption Standard) and designed with a similar Feistel network structure ([GOST (block cipher) - Wikipedia](https://en.wikipedia.org/wiki/GOST_(block_cipher))). The standard was made **mandatory in the Russian Federation** for all public-sector data processing systems, underscoring its national importance ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). Over the ensuing decades, GOST 28147-89 (sometimes referred to by the codename "Magma" in modern Russian standards) has been deployed in government and military applications for protecting classified communications, and it has been incorporated into various cryptographic libraries and protocols (e.g., via RFC 5830 for informational reference). Notably, the GOST 28147-89 cipher also underpins the legacy GOST hash function and forms the basis of a MAC generation method defined in the same standard.

Historically, GOST 28147-89 was conceived as an **analogue to DES**, but with significant adjustments to increase security and longevity. While DES uses a 56-bit key and 16 rounds, GOST employs a much larger 256-bit key and 32 rounds of encryption, reflecting design decisions intended to resist brute-force attacks by orders of magnitude beyond DES’s capability ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)) ([GOST (block cipher) - Wikipedia](https://en.wikipedia.org/wiki/GOST_(block_cipher))). At the time of its design, Western block cipher design principles were not widely published in the USSR, yet GOST’s developers arrived at a structure broadly similar to DES’s Feistel construction, likely informed by open literature on DES and an independent cryptographic analysis. By doubling the number of rounds and quadrupling the key size, the architects of GOST 28147-89 sought to ensure a high security margin and future-proof the cipher against cryptanalytic advances. Moreover, unlike DES, the standard allowed the use of secret or customized S-boxes (substitution boxes) as an additional security parameter, theoretically increasing the complexity for an adversary who does not know the precise S-box values ([GOST (block cipher) - Wikipedia](https://en.wikipedia.org/wiki/GOST_(block_cipher))). This flexibility in S-box selection, combined with the algorithm’s extended key length, meant that GOST could, in principle, offer a much larger effective key space than DES if the S-boxes remain undisclosed ([GOST (block cipher) - Wikipedia](https://en.wikipedia.org/wiki/GOST_(block_cipher))). The trade-off was that, without fixed S-boxes in the original specification, interoperability required agreeing on specific S-box sets for implementation. Over time, standardized S-boxes were published (for example, in the Cryptographic Providers guidelines RFC 4357) to facilitate compatibility ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). 

## Algorithm Overview and Feistel Structure  

**GOST 28147-89 is a 64-bit block cipher** operating on 64-bit data blocks and using a 256-bit secret key ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). Like many classical block ciphers, GOST is built on a **Feistel network** structure with iterative rounds. Specifically, it performs 32 rounds of encryption transformations on the input block ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). Each round is a Feistel round in which one half of the data is transformed with a round function and combined with the other half. After 32 rounds, the two 32-bit halves are recombined to produce the 64-bit ciphertext output. (In GOST’s implementation, the final swapping of halves typical in Feistel ciphers is effectively handled by the round structure itself, so the output is obtained directly from the pair of registers after the last round.)

The cipher’s **overall structure** can be understood as follows: the 64-bit plaintext is divided into two 32-bit halves, often denoted as *N1* (left half) and *N2* (right half). These halves are processed through 32 iterations of the round function. In each round, a 32-bit subkey (derived from the 256-bit master key) is applied to one half of the data through a non-linear transformation, and the result is XORed into the other half. Then the halves swap roles for the next round. Figure 1 provides a conceptual diagram of the Feistel rounds in GOST 28147-89, illustrating the data flow and operations in each round.

![GOST Diagram](/stuff/GOSTDiagram.png) *Figure 1: Simplified Feistel structure of GOST 28147-89.* Each round uses one 32-bit subkey kᵢ, added to the right half (⊕ denotes addition mod 2³² here) before an S-box substitution and 11-bit left rotation (≪≪11). The output is XORed into the left half, and the halves swap for the next round. GOST performs 32 such rounds (with 29 intermediate rounds omitted in the illustration), after which *N1* and *N2* form the 64-bit ciphertext.

At a high level, this design mirrors that of DES in its Feistel construction, but there are crucial differences in the round function and key schedule (discussed below) that distinguish GOST. One immediate consequence of the Feistel structure is that decryption is achieved by running the same algorithm in reverse (i.e. feeding in the subkeys in the opposite order), a property that GOST shares with DES. This simplifies the implementation of decryption, since no separate algorithm is needed – only the subkey schedule is inverted. The 32-round depth was chosen to ensure extensive diffusion and confusion; even though each individual round function is relatively simple, the large number of rounds and the repeated application of non-linear S-box transformations make the cipher output highly non-linear with respect to the input and key.

Importantly, GOST’s **256-bit key** is one of the largest for block ciphers of its era, far exceeding the 56-bit effective key of DES. The key is conceptually stored in eight 32-bit components, often labeled X0 through X7 ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). These serve as the subkeys for the round operations. The expanded key storage means GOST can incorporate a massive keyspace (2^256 possible keys). This was likely intended to thwart brute-force attacks even by adversaries with significant computing resources, providing a security margin that was thought to be impractical to overcome. Additionally, as noted, if the S-box tables are treated as secret parameters, they add an extra layer of key-like secrecy (on the order of 354 additional bits of entropy if one treats the S-box configuration as part of the key ([GOST (block cipher) - Wikipedia](https://en.wikipedia.org/wiki/GOST_(block_cipher)))). In practice, however, most modern implementations use publicly specified S-box sets for interoperability, and rely on the algorithm’s strength rather than obscurity of S-box values.

## Round Function and Operations  

Each of the 32 rounds in GOST 28147-89 uses an **F-function** (round function) that combines arithmetic addition, substitution through S-boxes, bit rotation, and XOR operations. The design of this round function is simple but effective, falling into the class of ARX (Add-Rotate-XOR) operations augmented with S-box substitution for nonlinearity. The following sequence outlines the transformation in one round (considering a round *i*, where the inputs are the 32-bit halves *N1* and *N2*, and the round subkey is *X_j* for some j depending on the key schedule):

1. **Key Mixing (Addition mod 2^32):** The 32-bit subkey is added to the *N1* half *modulo 2^32*. This operation (denoted "[+]" in the standard) combines the subkey with the data, introducing key-dependent changes ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). The use of modular addition (rather than a simple XOR as in DES) adds non-linearity because it involves carry bits between bit positions, which helps thwart linear cryptanalysis by not being a linear operation over GF(2). For example, in the first round, if *N1* is the left half of the plaintext and *X0* is the first subkey, the algorithm computes *(N1 + X0 mod 2^32)* ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)).

2. **S-Box Substitution:** The 32-bit sum from the previous step is then broken into eight 4-bit chunks, and each 4-bit nibble is transformed via a substitution box (S-box) lookup ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). GOST uses **eight S-boxes**, denoted K1...K8, each mapping a 4-bit input to a 4-bit output. Conceptually, there is a single 32-bit wide S-box *K* composed of these eight smaller S-box mappings applied in parallel. This substitution is the source of non-linear confusion in the cipher – it permutes bits within each 4-bit group according to a fixed (or system-defined) substitution table. The original GOST standard notably did **not fix the S-box values**; instead, it treated the choice of S-box set as a parameter to be agreed upon (and possibly kept secret)  ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). In practice, various standardized S-box sets have been used (for instance, one published in RFC 4357 for cryptographic interoperability). Regardless of the specific S-box values, the effect in the round is the same: each 4-bit segment of the sum *(N1 + key)* is non-linearly transformed, scrambling the bits in a key-dependent manner.

3. **Bit Rotation:** The 32-bit output of the S-box layer is then rotated left by 11 bits (a cyclic shift) ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). This rotation (sometimes called a cyclic shift) further diffuses the influence of any single bit across the 32-bit word. By rotating, bits that were output from a particular S-box in this round will move into the input of a different S-box in the next round (since the rotation shifts the alignment of 4-bit groups relative to the fixed S-box segmentation). The rotation by 11 positions is relatively large, ensuring a rapid dispersal of bits to different positions over multiple rounds. This operation is linear but key-independent; its purpose is to spread the output bits before the next XOR step and subsequent rounds, contributing to thorough diffusion as required by Shannon’s criteria for a strong cipher.

4. **XOR with Right Half:** The rotated result is then XORed with the other half of the data (the 32-bit *N2*). In the context of a Feistel network, if *N1* was the half that went through the F-function, this XOR adds the modified *N1* into *N2*. Formally, the operation is *N2 := N2 ⊕ F(N1, subkey)*, where F(N1, subkey) denotes the combination of the previous three steps. This XOR (bitwise addition mod 2, denoted "(+)" in the standard’s notation ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830))) completes the round’s mixing of the two halves.

5. **Swap Halves:** Finally, the two halves are swapped so that the output of this round has the former right half (*N2*) become the new left half for the next round, and the former left half (which was processed) becomes the new right half. In GOST’s description, this is implicitly handled by writing the result of the XOR into *N1* and moving the old *N1* into *N2* ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). Thus, after the round: *N1_i = ( old N1 + subkey_i through S-box and rotated ) XOR old N2*, and *N2_i = old N1*. This swap is what makes the Feistel network reversible: only one half is modified per round, and the other is just rotated into place.

By the end of the first round, the two halves have effectively been transformed and swapped. GOST then proceeds to the second round, third round, and so forth, repeating the same pattern of operations with possibly different subkeys in each round. After 32 rounds, the algorithm does not perform a final swap; the standard specifies that after the last (32nd) round, the two registers *N1* and *N2* hold the final ciphertext halves directly ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). (This is a minor detail – whether or not one performs a swap after the last round is a matter of convention; GOST’s round structure is arranged such that the output is taken as *(N1, N2)* without swapping, which is equivalent to the classical Feistel output with a swap.) The **decryption process** uses the identical round function sequence, but the subkeys are applied in reverse order (more on the subkey schedule below). Thanks to the Feistel construction, decrypting is just as efficient as encrypting – the cipher is symmetric with respect to key schedule reversal ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)).

To summarize the round operation: *N1* is combined with a round key via modular addition, an S-box substitution and bit rotation are applied to introduce nonlinearity and diffusion, and then this result is XORed into *N2*, followed by a swap of halves. Each round’s transformation can be expressed by the pair of equations:  
\[ 
N1_{i} = N2_{i-1} \tag{swap half} 
\]  
\[ 
N2_{i} = N1_{i-1} \oplus \text{ROL}_{11}( S( (N1_{i-1} + X_j) \bmod 2^{32} ) ) \tag{round function} 
\]  
where $X_j$ is the subkey used in that round, $S(\cdot)$ is the S-box substitution of 32-bit input, and $\text{ROL}_{11}$ is an 11-bit left rotation. This formulation highlights that only one of the two halves ($N1_{i-1}$) is processed with the key and S-box in each round, and its influence is then propagated to the other half via XOR.

The **design rationale** behind these operations appears to favor simplicity and hardware efficiency, using basic arithmetic and bit-wise operations that map well onto 32-bit architectures. The combination of modular addition and XOR (along with S-boxes) means the cipher does not rely purely on linear operations; it injects non-linearity at two points: once through addition (though addition is *affine* rather than strictly linear in GF(2)) and again through the S-box lookup. The fixed rotation by 11 bits each round is a static diffusion mechanism (contrast with DES which uses a fixed permutation of bits after the S-boxes). By eliminating the need for a complex bit permutation or expansion operation, GOST’s round function remains quite compact. This likely reflects a design emphasis on **ease of implementation** in both hardware and software. In hardware, a 32-bit adder and a barrel-rotator are straightforward components, and S-box lookups can be implemented with small ROMs or logic tables. In software, addition and rotation are single CPU instructions on most architectures, making GOST relatively fast per round. The cost of this simplicity is that GOST requires more rounds than DES to achieve comparable security; however, given the small computational cost of each round and the absence of complex key schedule processing in-round, the overall cipher is efficient. 

## Subkey Schedule (Key Expansion)  

The **key schedule of GOST 28147-89** is notably simple. The 256-bit master key is divided into eight 32-bit words, labeled $X_0, X_1, \dots, X_7$ ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)), which serve directly as the subkeys in the encryption rounds. Unlike DES and many modern ciphers, GOST does not employ a complex key expansion algorithm with rotations or permutation of key bits per round; instead, it *reuses* these 32-bit key components in a fixed pattern over the 32 rounds. This design means the security of GOST does not depend on a one-way key schedule function – the subkeys are just the master key chunks reused – which simplifies analysis but also means there is less diffusion of key material across rounds. 

The round subkey selection sequence is as follows (where round numbers 1–32 are given): 

- **Rounds 1–8:** use $X_0, X_1, ..., X_7$ in order (one subkey per round).  
- **Rounds 9–16:** repeat $X_0, X_1, ..., X_7$ in the same order again ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)).  
- **Rounds 17–24:** repeat $X_0, X_1, ..., X_7$ a third time ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms  ](https://datatracker.ietf.org/doc/html/rfc5830)).  
- **Rounds 25–32:** for the final eight rounds, the subkeys are used in *reverse* order: $X_7, X_6, ..., X_0$ ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)) ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)).

In other words, the first 24 rounds cycle through the eight key components three times in forward order, and the last 8 rounds cycle once through all key components in reverse order. This fixed schedule is illustrated in the standard by listing the subkey usage sequence as:  
```
X0, X1, X2, X3, X4, X5, X6, X7,  
X0, X1, X2, X3, X4, X5, X6, X7,  
X0, X1, X2, X3, X4, X5, X6, X7,  
X7, X6, X5, X4, X3, X2, X1, X0.  
```  
Here the commas separate round-by-round keys, and the line breaks indicate grouping into 8 rounds each ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)) ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)).

Because of the Feistel structure, the decryption process simply uses the subkeys in the exact opposite order of encryption. That is, decryption rounds begin with $X_0$ (the same component used in the last encryption round) and proceed through the reverse sequence: $X_1, X_2, ..., X_7, X_7, X_6, ..., X_0, ...$ etc., effectively reversing the above list ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). As a result, implementing decryption just requires reading the subkey array in reverse; no other alteration to the round function is needed.

The simplicity of GOST's key schedule is a double-edged sword. On one hand, it avoids the risk of inadvertently weakening the cipher through a poor key schedule design (since each key bit influences many rounds directly given the repetitions). On the other hand, it lacks the *key diffusion* that many modern ciphers have, where a single bit of the master key affects many subkeys and hence many round operations. In GOST, each 32-bit subkey affects exactly those rounds where it is used. However, since each subkey is used four times in encryption (three times forward, once backward) out of 32 rounds, each part of the key still has a broad influence on the encryption process. There are no known *weak keys* for GOST in the sense that a particular key leads to a degenerate behavior (in contrast to DES, which has a few weak keys due to the structure of the key schedule and S-box symmetry). The absence of weak keys is partly because the S-boxes can be arbitrary, breaking any symmetry, and because the addition and rotation operations do not exhibit linear key relations easily. In modern adaptations (e.g., the 2015 update of the standard), a slightly more complex key schedule or key derivation may be introduced to address theoretical weaknesses, but the original GOST 28147-89 keeps it straightforward ([GOST (block cipher) - Wikipedia](https://en.wikipedia.org/wiki/GOST_(block_cipher))).

## S-Boxes and Parameterization  

A distinctive feature of GOST 28147-89 is its approach to **S-boxes** (substitution boxes). The cipher uses eight fixed 4x4 S-box tables per instantiation, but the values of these tables were *not explicitly specified* in the original 1989 standard ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). Instead, the standard allowed different organizations or applications to choose their own set of S-box values (often referred to as a "S-box tuple" or **parameter set**) to potentially tailor the cipher for specific domains or to keep them secret as an added security measure. This is in contrast to DES, which has fixed, publicly known S-boxes built into its design. 

In GOST, each S-box (K1 through K8) is a mapping from 4-bit input to 4-bit output, typically represented as a table of 16 hexadecimal values (0 to 15). When the standard says the S-box has "64-bit memory" ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)), it refers to the total storage for one such 4→4 mapping (since 16 entries * 4 bits = 64 bits of data per S-box). Eight such S-box tables together constitute the substitution layer for a 32-bit word. During encryption, when the 32-bit round output is fed into the substitution block *K*, the first 4-bit chunk of that output is transformed by S-box K1, the second 4-bit chunk by K2, and so on through K8, yielding a substituted 32-bit word ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)).

Because the standard did not pin down specific S-box values, various **S-box sets** have been used historically: some were kept secret (with the idea that an attacker who didn't know the S-box values would have a significantly harder time mounting certain attacks), and others were later published for interoperability. For example, one commonly referenced set is the so-called **CryptoPro S-boxes**, published in RFC 4357, which are used in many Russian cryptographic implementations ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). Another known set is from the Central Bank of the Russian Federation, and yet another from the Russian Federal Security Service (FSB) for their applications. The ability to substitute different S-box tables means GOST can be seen as a family of algorithms; security can vary depending on the quality of the chosen S-boxes. Ideally, the S-boxes should be chosen to have good cryptographic properties (such as no linear or differential weaknesses, i.e., low bias in XOR profiles and high nonlinearity). Poorly chosen S-boxes could, in theory, weaken the cipher's resistance to differential or linear cryptanalysis. However, the standard's allowance for secret S-boxes was also a recognition that keeping the S-boxes confidential could effectively increase the key space. In fact, if treated as additional secret key material, the S-boxes contribute an entropy of about 354 bits (since there are $(16!)^8 \approx 2^{354}$ possible ways to populate eight 4x4 S-boxes) ([GOST (block cipher) - Wikipedia](https://en.wikipedia.org/wiki/GOST_(block_cipher))). This far exceeds the 256-bit key entropy of the cipher itself. 

There is a caveat: if one treats S-boxes as secret, the security proof becomes twofold – one must trust both the algorithm and the secrecy of the S-box parameters. Over time, the cryptographic community has gravitated away from secret algorithm parameters (Kerckhoffs' principle advocates that a cipher's security should not rely on secret design, only on secret keys). Thus, modern practice with GOST is to use publicly known S-box sets that are believed to be strong. Indeed, by 2010, the **ISO/IEC 18033-3** standardization process and others evaluating GOST recommended specific S-boxes. The 2015 revision of the GOST standard (GOST R 34.12-2015) finally fixed an official S-box set for the cipher, removing ambiguity ([GOST (block cipher) - Wikipedia](https://en.wikipedia.org/wiki/GOST_(block_cipher))). In that revision, the cipher GOST 28147-89 with a fixed S-box is officially named "Magma." This change allows consistent interoperability and eases analysis – and it acknowledges that the benefit of secret S-boxes was largely theoretical, whereas the benefit of public well-analyzed S-boxes is practical security assurance.

## Encryption and Decryption Process  

Using the components described above (the Feistel round function, subkey schedule, and S-boxes), we can now describe the **process of encrypting a 64-bit block** under GOST 28147-89 step by step. We assume a 64-bit plaintext block is given, and a 256-bit key has been loaded into the eight subkey registers $X_0 \dots X_7$. For clarity, let the plaintext halves be $N1_0$ and $N2_0$ (initial values of left and right 32-bit halves, respectively), and after $i$ rounds let $N1_i, N2_i$ be the half values.

- **Initial Preparation:** Assign the 64-bit plaintext block into the two 32-bit registers: $N1_0$ (left half) and $N2_0$ (right half). No other preprocessing (such as an initial permutation) is done – GOST does **not** use a bit-permutation like DES's initial permutation; the bits are taken as they are input ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)).

- **Rounds 1–32:** Perform the round operation iteratively for 32 rounds, as defined in the previous section. Specifically, for each round *i* from 1 to 32, do:
  1. Compute an intermediate value: $F_i = \text{ROL}_{11}\Big(S\big((N1_{i-1} + K_i) \bmod 2^{32}\big)\Big)$, where $K_i$ is the 32-bit subkey for round *i* according to the key schedule, $S(\cdot)$ is the application of the eight S-boxes, and $\text{ROL}_{11}$ is an 11-bit left rotate of the 32-bit result ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)).
  2. Update the halves: $N1_{i} = N2_{i-1} \oplus F_i$ and $N2_{i} = N1_{i-1}$ ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). This effectively means the old left half is processed and combined into the right half, and then the halves swap.
  
  After executing this for 32 iterations, we have $N1_{32}$ and $N2_{32}$ as the output halves. The concatenation $N1_{32}||N2_{32}$ (where $N1_{32}$ is the high-order 32 bits and $N2_{32}$ the low-order 32 bits) is the 64-bit ciphertext block.

- **Output:** The 64-bit ciphertext is obtained as $(N1_{32}, N2_{32})$. Notably, because of the way the last round is defined, the output halves are **not swapped again** – the standard explicitly states that after the 32nd round, the content of $N1$ and $N2$ "are an encrypted data block corresponding to a block of plain text" ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)), indicating that $(N1_{32}, N2_{32})$ is the ciphertext in the same left-right order as the final round.

The **decryption** process is essentially the mirror of encryption. Given a 64-bit ciphertext $(C1, C2)$ and the same 256-bit key, one can decrypt by using the same round function but feeding the subkeys in reverse order. Concretely, one would load $N1_{32} = C1$, $N2_{32} = C2$ as the starting state and then run 32 rounds of the Feistel network *backwards* (round 32's inverse, then round 31's inverse, etc.). Because each round's operations (addition, S-box, rotation, XOR, swap) are reversible, applying them in reverse with the correct subkey undoes the encryption. In practice, it is simpler to implement decryption by taking the encryption routine and just iterating the subkey index from 32 down to 1. The sequence of subkeys for decryption will be: $K_{32}, K_{31}, ..., K_{1}$, which expands to: $X_0, X_1, ..., X_7,$ $X_7, X_6, ..., X_0,$ $X_7, X_6, ..., X_0,$ $X_0, ..., X_7$ (this is exactly the reverse of the encryption key order derived earlier) ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). By using this reversed key schedule, each decryption round "undoes" the corresponding encryption round, ultimately recovering $(N1_0, N2_0)$ which are the original plaintext halves. The correctness of this decryption procedure is guaranteed by the Feistel structure.

An interesting property of GOST (and Feistel ciphers in general) is that encryption and decryption have the same complexity and a very similar implementation. This symmetry was advantageous for hardware implementations in the 1980s and 90s: a single circuit could be used for both encryption and decryption, with only control logic to feed subkeys in reverse for decryption. Similarly, software implementations can use one code path for both operations. 

In terms of performance, GOST 28147-89's 32 rounds make it somewhat slower than DES (which has 16 rounds) on a per-block basis if each round were of similar complexity. However, each GOST round is simpler (DES's round involves expanding 32 bits to 48, eight 6→4 S-box lookups, and a permutation, whereas GOST's involves one 32-bit add, eight 4→4 S-box lookups, and one rotation). In practice, GOST encryption can be quite efficient, and modern optimizations (like bitslicing or vectorizing the S-box operations, or using precomputed lookup tables) can further speed it up. The lack of an initial or final bit permutation in GOST also saves some operations compared to DES.

Finally, it's important to note that GOST encryption in actual use is typically employed in a **mode of operation** (just like any block cipher). The standard itself describes several modes: Electronic Codebook (ECB), Counter (CTR), and feedback modes (CFB) for encryption, as well as a mode for MAC generation ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)) ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). In ECB mode, described above, each 64-bit block is encrypted independently. In other modes, either an IV (initialization vector) and chaining are used to encrypt variable-length data securely, or a keystream is generated for stream cipher operation. The core cipher operations remain the same regardless of mode.

## Message Authentication Code (MAC) Generation Mode  

In addition to encryption, GOST 28147-89 specifies a method for computing a **message authentication code** (MAC) using the block cipher. The MAC algorithm in GOST is essentially a specialized variant of a CBC-MAC, with the twist that only the first 16 rounds of the cipher are used for each block chaining step. The rationale for using 16 rounds (half the cipher) per block in MAC generation is not explicitly stated in the standard, but it is presumably to provide a balance between security and performance when processing potentially long messages – using only half the rounds per intermediate step doubles the speed of MAC computation, while the final MAC still benefits from a full encryption pass. The MAC generation is defined as follows for a message divided into $M$ blocks of 64 bits (with padding as needed):

- **Initialization:** Set the internal state registers $N1, N2$ to zero (or to an initialization vector if one is provided, though the standard MAC mode typically starts from zero). Load the 256-bit key into the KDS (subkey registers) as usual ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)).

- **Processing Blocks:** For each 64-bit message block $T_p(i)$ (where $i$ ranges from 1 to $M$, and $T_p(i)$ is split into 32-bit halves $(a^{(i)}[0], b^{(i)}[0])$ in the standard's notation ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)) ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830))):
  1. XOR the current message block into the state: $N1 \gets N1 \oplus a^{(i)}[0]$ (32 bits), $N2 \gets N2 \oplus b^{(i)}[0]$ (32 bits). In other words, the 64-bit block is added (mod 2) to the current contents of $(N1, N2)$. For the first block, $N1, N2$ might start at 0, so this just loads the block into the state ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). This step is analogous to CBC-MAC where each plaintext block is XORed with the previous cipher output.
  2. Encrypt the state using *16 rounds* of the GOST encryption algorithm (in ECB mode) with the given key ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). That is, apply rounds 1–16 of the Feistel network to $(N1, N2)$ with the normal subkey sequence $X_0 \dots X_7$ repeated twice (since 16 rounds). After 16 rounds, output state is $(N1, N2)$ half-encrypted.
  3. Proceed to the next block. The output state after 16 rounds is then XORed with the next plaintext block $T_p(i+1)$ and then again run through 16 rounds of the cipher.

  This process continues iteratively: each new plaintext block is XORed with the intermediate state (which is the result of encrypting the previous state for 16 rounds), and then 16 more rounds of encryption are applied.

- **Finalization:** After processing the last plaintext block $T_p(M)$ in this manner, one more 16-round encryption is performed on the final state $(N1, N2)$ ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)) ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). Now the state is essentially the encryption of the cumulative XOR of all message blocks (through this iterated process) carried out to 16 rounds *of the final block*. From this final state, the MAC value is extracted. The standard allows the MAC length *l* to be variable – one can take the most significant $l$ bits of the final state as the MAC (where $l$ is a security parameter, e.g., 32 or 64 bits) ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)) ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). For example, one might use a 32-bit MAC or the full 64-bit output as the MAC. The MAC is denoted $I(l)$ in the standard, and is appended to the transmitted message for integrity verification ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)).

To put it succinctly, GOST’s MAC mode chains blocks through half-round encryption steps: each block is integrated by XOR, and the block cipher is run for 16 rounds to mix this into the state, then the process repeats. The final MAC is a substring of the last state after a final half-encryption. The verification process recomputes this MAC on the received plaintext (after decryption, if the message was encrypted) and compares it to the received MAC $I(l)$ ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc583)).

This MAC mechanism is designed to detect any modification of the message blocks. If any bit of the message is changed, due to the avalanche effect of the cipher across multiple blocks, the final MAC will with high probability not match, and the verification will fail, indicating tampering or corruption. The strength of the MAC is $2^{-l}$ probability of a forgery going undetected (since an attacker would have to guess the correct $l$-bit string) ([RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms](https://datatracker.ietf.org/doc/html/rfc5830)). In practice, using at least $l=32$ or $l=64$ is advisable to deter brute-force guessing or collision attempts on the MAC.

One subtlety: Because only 16 rounds (instead of the full 32) are used per block mixing, there might be theoretical concerns about whether this truncated encryption is a pseudo-random permutation on each step. However, since the final output is subjected to a full 32-round encryption (16 rounds in the last chaining step plus 16 in the final output stage, effectively 32 on the last block), and earlier truncated encryptions are concealed by subsequent XORs, no practical weaknesses in the MAC procedure have been published. The GOST MAC is conceptually similar to well-known MAC constructions like CBC-MAC; its security rests on the difficulty of forging outputs without knowing the key.

> Full code implementation in Appendix A