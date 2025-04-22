# Code Optimization for STM32F103/STM32F407 Discovery Boards – Time and Memory Analysis

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

> Full code can be found in the Appendix B.

To run the benchmark for performance measurements:

```bash
gcc -O3 driver.c bubble_sort.c -o bubble_sort_benchmark && ./bubble_sort_benchmark
```

Results:

```bash
C bubble sort time: 1.366740 seconds
```

#### Assembly‑Level Optimizations  

Let's take our bubble sort example again. Earlier we got slightly worse results in Assembly compare to the C version. Let's refactor the code to improve the performance.

bubble_sort_asm.s.

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

> Full code can be found in the Appendix B.

Then we'll be using the same bubble_sort.c and driver.c files as before.

To run the benchmark for performance measurements:

```bash
gcc -O3 driver.c bubble_sort.c bubble_sort_asm.s -o bubble_sort_benchmark && ./bubble_sort_benchmark
```

```bash
C bubble sort time: 1.016151 seconds
Assembly bubble sort time: 0.985726 seconds
Performance improvement: 2.994142%
Verification successful: both implementations produce identical results
```

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

In this section, we will be discussing the optimization of ASCON-AEAD128, a variant with a 128-bit key, 128-bit nonce, and 128-bit authentication tag, optimized for a 128-bit rate and 192-bit capacity. Our research compares two implementations: the original `opt32_lowsize` (version 1), a 32-bit size-optimized pure C implementation, and an optimized `bi32_armv7m_small` (version 4), a 32-bit bit-interleaved implementation using C and inline assembly, tailored for ARMv7-M architectures like the STM32F103 & STM32F407.

#### Experimental Setup

To evaluate the performance of these implementations, we conducted experiments on an STM32F103 & STM32F407 Discovery Boards, a common platform for IoT development. The test involved running the `crypto_aead_encrypt()` function 20,000 times, encrypting a 16-byte plaintext with a 16-byte key, nonce, and associated data. The test code, shown below, uses the HAL library to measure execution time via the `HAL_GetTick()` function, ensuring accurate timing on the microcontroller.

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

> Full code can be found in the Appendix B.

The results, summarized in Table 1, show the execution times for various ASCON implementations, with the optimized version achieving significant improvements.

#### AEAD ROUND_LOOP Optimization Strategy  

The optimized version, derived from the `bi32_armv7m_small` implementation (version 4), introduces several key modifications to the `ROUND_LOOP()` function, which is critical to ASCON’s permutation phase. Let’s break down the changes:

1. **Efficient Constant Loading**
   - **Original:** Loads round constants one byte at a time using the `ldrb` instruction, requiring two loads per round to handle low and high halves.
   - **Optimized:** Loads a 16-bit constant in a single `ldrh` instruction, extracting high and low bytes using `ubfx` and `and` instructions. This reduces memory access overhead.

2. **Interleaved Low- and High-Half Operations**
   - **Original:** Processes the low half of the state completely before the high half, leading to sequential execution.
   - **Optimized:** Interleaves operations on low and high halves, performing similar computations concurrently. For example, XOR operations on `x0_l` and `x0_h` are executed back-to-back, reducing data dependency delays.

3. **Bit-Interleaving (Inherited from Version 4)**
   - The optimized version builds on version 4’s bit-interleaved state representation, where bits are reorganized to enable parallel processing of multiple S-box operations using 32-bit instructions. While not a change from version 4, it’s a foundational optimization compared to earlier versions like [1].

4. **Instruction Optimization**
   - The optimized version uses ARM-specific instructions like `ubfx` for efficient bit manipulation, aligning with the Cortex-M4’s capabilities.

These changes are evident in the `ROUND_LOOP()` function, shown below for both versions:

**Original ROUND_LOOP() (Version 1):**

```c
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

**Optimized ROUND_LOOP() (Version 4):**

```c
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

> Full code for both versions can be found in the Appendix B.

Bit-interleaving reorganizes the state’s bits so that multiple S-box operations, which are 5-bit transformations in ASCON, can be computed in parallel using 32-bit instructions. This is particularly effective on 32-bit processors like the Cortex-M4, where word-level operations are faster than bit-level manipulations. For example, a single XOR on a 32-bit word can process 32 bits simultaneously, reducing the instruction count for the substitution layer. This technique, detailed in the ASCON specification ([ASCON v1.2](https://ascon.isec.tugraz.at/files/asconv12-nist.pdf)), is a cornerstone of version [4] and the optimized version, making ASCON more efficient for IoT devices.

Inline assembly allows precise control over instruction selection and scheduling, critical for performance-critical code like ASCON’s permutation. By writing assembly directly, I could interleave operations and use instructions like `ubfx`, which are optimized for the Cortex-M4. However, this comes at the cost of increased development complexity and reduced portability, as the code is tailored to ARMv7-M and later architectures.


[DRAFT]

The optimized AEAD ROUND_LOOP function, based on the `bi32_armv7m_small` implementation (version 4), incorporates significant enhancements to improve the performance of ASCON's permutation stage on the STM32F407 microcontroller's ARM Cortex-M4 core. This optimization strategically addresses memory access inefficiencies, pipeline stalls, and instruction-level parallelism, essential for efficient cryptographic computations.

Efficient constant loading is achieved by replacing the previous byte-wise loading method, which required two separate `ldrb` instructions per round, with a single 16-bit load using the `ldrh` instruction. The extracted high and low bytes of the constant utilize the ARM-specific `ubfx` and `and` instructions. This modification significantly reduces memory latency and optimizes performance by minimizing memory cycles, a common bottleneck in microcontroller operations.

Further improvement comes from interleaving operations between the low and high halves of the internal state. Previously, the sequential processing of low-half operations followed by high-half operations resulted in pipeline stalls due to data dependencies. By interleaving these computations, instructions such as XOR operations on corresponding parts (`x0_l` and `x0_h`) are performed in rapid succession, effectively reducing delays and enhancing the processor pipeline utilization.

The bit-interleaved state representation, inherited from version 4, continues to provide substantial advantages by reorganizing state bits to enable parallel computation of multiple 5-bit S-box transformations. This approach leverages the 32-bit word size capability of the Cortex-M4 core, allowing simultaneous processing of multiple operations and significantly reducing the total number of instructions required during ASCON's substitution phase.

The adoption of ARM-specific instructions, particularly `ubfx`, leverages the Cortex-M4's DSP extensions and efficient bit manipulation features, further improving computational efficiency. This careful selection of instructions is made feasible through the use of inline assembly, which offers precise control over instruction selection and scheduling, critical for high-performance cryptographic applications.

Collectively, these optimizations directly respond to the computational requirements typical of IoT environments, where efficient and fast cryptographic operations are vital. The targeted enhancements not only reduce execution latency but also increase throughput, making the implementation especially suitable for real-time data processing in applications such as smart sensors and wearable technology. While inline assembly provides significant performance benefits, it also introduces complexity and reduces code portability, restricting it to ARMv7-M and subsequent architectures.




### GOST 28147‑89 Optimization  

In this section, we provide a comprehensive analysis of the optimizations made to the GOST 28147-89 cryptographic algorithm for STM32 microcontrollers and IoT applications, comparing the original and optimized implementations. The analysis addresses the changes made, their rationale, their impact, and additional considerations relevant for a thesis, based on the provided code and testing details.

The optimized version of the GOST 28147-89 algorithm introduces several key modifications to enhance performance on STM32 microcontrollers. These changes are detailed below:

### 1.1 Precomputed Substitution Table

- **Original Implementation**: In the original version, the substitution step (`GOST_Crypt_Step`) processes each byte of the 32-bit input by splitting it into two 4-bit nibbles. Each nibble is substituted using one of eight S-boxes (128 bytes total, organized as 8 rows of 16 nibbles). For each byte, the code performs two memory lookups: one for the low nibble and one for the high nibble, using consecutive S-box rows. This results in eight lookups for a 32-bit word (two per byte across four bytes).
- **Optimized Implementation**: The optimized version (`GOST_Crypt_Step_Opt`) uses a precomputed substitution table (`GOST_Subst_Table`, 1024 bytes) that maps each possible byte value (0–255) to its substituted byte for each of the four byte positions in a 32-bit word. The table is generated in `gost_opt_main()` by combining the low and high nibble substitutions for each byte, effectively precomputing the result of the two S-box lookups. During encryption, a single lookup per byte is performed, reducing the number of memory accesses from eight to four per 32-bit word.
- **Code Example**:
  - Original (per byte in `GOST_Crypt_Step`):
    ```c
    tmp = S.parts[m];
    S.parts[m] = *(GOST_Table + (tmp & 0x0F)); // Low nibble
    GOST_Table += 16;
    S.parts[m] |= (*(GOST_Table + ((tmp & 0xF0) >> 4))) << 4; // High nibble
    GOST_Table += 16;
    ```
  - Optimized (for all bytes in `GOST_Crypt_Step_Opt`):
    ```c
    result = Table[(result & 0xff)] | 
             (Table[256 + ((result >> 8) & 0xff)] << 8) |
             (Table[512 + ((result >> 16) & 0xff)] << 16) |
             (Table[768 + ((result >> 24) & 0xff)] << 24);
    ```

> Full code for both versions can be found in the Appendix B.

### 1.2 Loop Unrolling

- **Original Implementation**: The original version (`GOST_Crypt_32_E_Cicle`) uses nested loops to iterate over the 32 rounds of the Feistel network. The outer loop runs three times (for the first 24 rounds, using keys K0–K7 repeatedly), and an inner loop processes each of the eight subkeys. The final eight rounds use keys K7–K0 in reverse order, handled by a separate loop.
- **Optimized Implementation**: The optimized version (`GOST_Crypt_32_E_Cicle_Opt`) unrolls all 32 rounds, explicitly coding each round without loops. Each round calls `GOST_Crypt_Step_Opt` with the appropriate subkey, eliminating loop control overhead (e.g., counter increments, condition checks).
- **Code Example**:
  - Original (looped):
    ```c
    for(k=0; k<3; k++) {
        for (j=0; j<8; j++) {
            GOST_Crypt_Step(DATA, GOST_Table, *GOST_Key, _GOST_Next_Step);
            GOST_Key++;
        }
        GOST_Key = GOST_Key_tmp;
    }
    ```
  - Optimized (unrolled, partial):
    ```c
    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[0], 0);
    *n2 = tmp;
    // Repeated for each round
    ```

> Full code for both versions can be found in the Appendix B.

### 1.3 Data Handling

- **Original Implementation**: The original version uses a `GOST_Data_Part` union to represent the 64-bit block, with two 32-bit halves (`half[0]` for N2, `half[1]` for N1). Data is copied into this structure, processed, and copied back, with byte-swapping (`_GOST_SWAP32`) applied if `_GOST_ROT==1` to handle endianness.
- **Optimized Implementation**: The optimized version processes the 32-bit halves directly as `uint32_t` pointers (`n1` and `n2`), reducing overhead from union access. Byte-swapping is still applied, but the data handling is streamlined by working directly with the input buffer.
- **Code Example**:
  - Original (`GOST_Encrypt_SR`):
    ```c
    memcpy(&Data_prep, Data, Cur_Part_Size);
    Data_prep.half[_GOST_Data_Part_N2_Half] = _GOST_SWAP32(Data_prep.half[_GOST_Data_Part_N2_Half]);
    ```
  - Optimized (`GOST_Encrypt_SR_Opt`):
    ```c
    Temp.half[_GOST_Data_Part_N1_Half] = _GOST_SWAP32(((uint32_t *)(Data + n * 8))[0]);
    ```

> Full code for both versions can be found in the Appendix B.
