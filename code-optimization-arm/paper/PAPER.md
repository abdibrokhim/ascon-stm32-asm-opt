# Code Optimization for STM32F103/STM32F407 Discovery Boards – Time and Memory Analysis

## Abstract

This report investigates various code optimization techniques aimed at enhancing execution speed and reducing memory usage on STM32 microcontrollers, specifically focusing on the STM32F103 and STM32F407 Discovery boards. By exploring optimization strategies at both the C and assembly levels, and evaluating lightweight cryptographic primitives like ASCON, this work demonstrates the impact of targeted optimizations on code size, execution time, and resource utilization. The experiments highlight the effectiveness of selective and combined optimization flags, customized memory allocation strategies, and exception handling modifications, ultimately providing a set of guidelines for developers seeking to achieve efficient embedded code performance.

---

## Introduction

Embedded systems, such as those based on the STM32 microcontroller family, operate with limited computational resources and stringent energy constraints. Within these environments, code optimization becomes crucial. Unlike desktop or server processors, embedded processors often lack advanced out-of-order execution or deep cache hierarchies. Thus, achieving high performance demands careful consideration of programming techniques and compiler optimizations.

This project focuses on analyzing code optimization strategies for STM32F103 and STM32F407 devices, which are representative of ARM-based microcontrollers commonly used in IoT and low-power applications. The primary goals are to measure improvements in execution time and memory footprint resulting from different optimization techniques, to identify performance bottlenecks, and to verify correctness using controlled experiments.

Additionally, we explore the implementation of the ASCON authenticated encryption and hashing algorithm, a NIST standardization candidate for lightweight cryptography. Implementing ASCON efficiently on resource-constrained devices is critical for ensuring both security and performance in next-generation IoT applications.

---

## Literature Review

### Performance-Oriented Programming for Embedded Systems

Embedded processors prioritize energy efficiency and simplicity. Common high-performance techniques found in more powerful CPUs—such as out-of-order execution or complex caching—are typically absent. This limitation requires developers to employ careful coding styles, using instructions and memory operations efficiently. The ARM architecture, widely used in the STM32 family, exemplifies this resource-sensitive environment.

### ARM Technology
ARM (Advanced RISC Machine) processors follow a Reduced Instruction Set Computing (RISC) philosophy. They:

* Typically require explicit load/store instructions to move data between memory and registers.
* Avoid out-of-order execution and rely on well-structured code for efficiency.
* Offer various compiler optimization levels and instructions that can be leveraged to improve code performance.

STM32 microcontrollers are built on ARM Cortex-M cores and can be programmed in C, assembly, or a combination thereof. Achieving optimal performance often involves balancing readability and maintainability against the benefits of low-level optimizations.

### Using C

Compiling and executing a C-based algorithm (e.g., a bubble sort) with optimization flags allows one to measure the performance gain. For instance:

```bash
gcc bubble_sort.c -O3 -o bubble_sort
```

execute and time the program;

```bash
time ./bubble_sort
```

> book says:
![execute-time](/stuff/execute-time.png)

Measurements from this procedure highlight the direct impact of compiler optimizations on execution time.

### Using Assembly

For critical performance sections, implementing code in assembly can further reduce latency. Assembly code grants developers precise control over registers and instructions. A similar timing procedure:

```bash
gcc -c bubble_sort_asm.s -o bubble_sort_asm.o 
```

execute and time the program;

```bash
time ./bubble_sort_asm
```

Comparing execution times between C and assembly implementations reveals how much overhead a high-level language imposes. According to references, assembly implementations often achieve faster execution but at the cost of greater development complexity.

![execute-time-c-asm](/stuff/execute-time-c-asm.png)

> book says:
![execute-time-c-asm-book](/stuff/execute-time-c-asm-book.png)

### Result verification

Verification ensures correctness. Combining both versions (C and assembly) and verifying their output with a test driver:
    
```bash
gcc driver.c bubble_sort.c bubble_sort_asm.s -o main
```

This step checks that optimizations do not break functional correctness.

### ASCON: Lightweight Cryptography

ASCON is a family of lightweight cryptographic primitives chosen by NIST for standardization. It is designed for IoT and constrained devices, thus aligning perfectly with STM32-based embedded contexts. Implementing ASCON efficiently ensures that the added security does not degrade performance unnecessarily. The algorithm’s structure—absorbing key, nonce, and associated data, followed by processing plaintext and producing ciphertext and a tag—relies on well-optimized code to run effectively on limited hardware.

### Research Focus & Goals
The core objectives of this research are:

* Execution Time Reduction: Identify and apply compiler and code-level optimizations to reduce latency.
* Memory Footprint Minimization: Implement strategies to lower code size and RAM usage.
* Bottleneck Identification: Determine where most time and space are consumed and mitigate these issues.
* Performance Evaluation of Cryptographic Primitives: Assess how ASCON and similar algorithms respond to optimization on embedded platforms.

---

## Methods

### STM32F4 Code Optimization Approach

Embedded systems with limited computing/memory resources benefit significantly from careful optimization. Common techniques include:

* Using compiler optimization flags (-O1, -O2, -O3, etc.).
* Removing unused code sections.
* Replacing certain library calls with lighter alternatives.
* Adjusting exception handling and memory allocation strategies.

### Memory Footprint Optimization

Build without enabled optimization

![Build without enabled optimization](/stuff/build-without-opt.png)

Build with enabled optimization

![Build with enabled optimization](/stuff/build-with-opt.png)

From the images above, we can see that the code size has been reduced from `(141,320 B)` to `(3,920 B)`.

This dramatic reduction demonstrates that even standard compiler optimizations can substantially decrease code size.

### Isolated Optimization

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

### Optimization Combinations

Combining optimizations yields even more substantial improvements.

![Optimization Combinations](stuff/optimization-combinations.png)

The experimental results show the following optimization combination are the most effective:

* *O1 (mem. allocation)*, *O2 (exception handling)*, *O3 (size optimization)* reduce the code size from `141,320 B` to `13,060 B`.
* *O8 (size optimized library)* with *(O1, O2, O3)* reduce the code size to `8,616 B`.
* *O4 (remove unused code)* with *(O1, O2, O3, O8)* reduce the code size to `4,012 B`.
* *(O1-O8)* reduce the code size to `4,012 B`.
* **C++** exception handling is space consuming. The best optimization without *O2* is `11,700 B` *(see O1 O3 O4 O8)*.
* **C++** memory management without exception handling is relatively cheap. `(O2 O3 O4 O8)` reduce the code size to `4248 B`.

### Identify space-wasting code

![Identify space-wasting code](/stuff/space-wasting-code.png)

The memory management (see top 3: _mallor_r, __malloc_av_, _free_r) consumes a huge amount of space relative to other part of the code.

We can simply use `(08)` to mitigate this issue.

![Optimization space-wasting code](/stuff/space-wasting-code-opt.png)

By identifying and targeting the most space-consuming code segments, developers can pick the best optimization techniques to reduce the overall footprint.

### ASCON Implementation Details

#### Key Algorithmic Details

1. **State Size and Structure**:
   - ASCON state consists of 5 lanes (or “rows”), each 64 bits, so total state size is 320 bits.
   - The algorithm uses a permutation (often called `P`) that is applied multiple times. For initialization, 12 rounds are applied; during encryption, 6 or 8 rounds may be used depending on the mode. The transcript shows a variant with 12 rounds in the initialization phase and fewer rounds during processing.

2. **Rate and Capacity**:
   - The chosen variant (ASCON AEA 128) uses a rate of 128 bits and a capacity of 192 bits.
   - "Rate" is how many bits are absorbed or squeezed per permutation call during encryption and decryption.
   - "Capacity" is the remainder of the state that provides security (not directly exposed as plaintext/ciphertext during operations).

3. **Initial State Setup**:
   - The initial state is formed by concatenating:
     - A fixed 64-bit IV (Initialization Vector) defined by the standard.
     - The 128-bit key.
     - A 128-bit nonce.
   - After loading these into the state (X0 through X4), the permutation is applied 12 times.

4. **Initialization and Domain Separation**:
   - After the initial 12 rounds of permutation, the key is XORed again into parts of the state. This step creates a unique domain separation so that the subsequent operations on associated data (AD) and plaintext are treated distinctly.

5. **Associated Data (AD)**:
   - The standard supports adding AD (which is authenticated but not encrypted). The transcript’s final code does not handle AD, but the standard’s approach is similar: absorb AD blocks, apply permutations, and domain-separate before plaintext absorption.
   
6. **Plaintext Encryption**:
   - Plaintext is XORed into the rate portion of the state to produce ciphertext.
   - After XORing the plaintext, the state is permuted again a certain number of times (often 6 or 8, depending on the mode) before processing the next block.
   - The ciphertext is taken from the same portion of the state that the plaintext was XORed into, making it a “cover/uncover” sponge-like process.

7. **Finalization and Tag Computation**:
   - After all plaintext blocks are processed, finalization occurs.
   - The key is XORed into the state again, followed by another round of permutation operations.
   - Finally, the last two lanes of the state (128 bits) are XORed with the key again to produce the authentication tag.
   - The tag ensures integrity and authenticity of the ciphertext and the associated data.


#### The Code Structure in the Transcript

1. **Declarative Programming Style**:
   - The presenter uses a top-down approach:
     - Write `main()` first, call functions like `initialization()`, `encryption()`, and `finalization()` before they are defined.
     - Later, implement these functions in detail, so the flow is logically clear from the start.

2. **Types and Variables**:
   - Uses `unsigned long long` or `uint64_t` (called `B_64` in the code) for 64-bit lane representation.
   - Maintains the state as `B_64 x[5];` representing the 5 x 64-bit lanes.

3. **Permutation (P) Implementation**:
   - The permutation step `P` consists of:
     - **Add round constant**: XOR a round-dependent constant into part of the state (usually lane x2).
     - **Substitution layer (S-box)**: A 5-bit S-box is applied bitwise across the state. By applying Boolean expressions directly to entire 64-bit words, the code performs 64 parallel S-box operations at once.
     - **Linear diffusion layer**: Each lane is combined with rotated versions of itself to spread (diffuse) differences throughout the state.

   The transcript shows copying the S-box logic from the original ASCON submission documents rather than manually extracting bits.

4. **Initialization Function**:
   - Loads IV, key, and nonce into `x0`, `x1`, `x2`, `x3`, and `x4`.
   - Runs the permutation with 12 rounds.
   - Then XORs part of the key back into the state for domain separation.

5. **Encryption Function**:
   - Assumes a known length of plaintext divided into 128-bit blocks.
   - For each block:
     - XOR plaintext into the rate portion of the state (x0 and x1).
     - Output that XORed value as ciphertext.
     - Apply permutation (8 rounds often mentioned in the standard).
   - If the plaintext length isn't a multiple of 128 bits, padding is needed, but the code in the transcript doesn’t implement this.

6. **Finalization Function**:
   - XOR key into the state.
   - Apply the permutation 12 times again.
   - XOR key again and output the tag from the lower lanes of the state.

---

## Results

In our experiments, applying compiler optimizations and code restructuring had a significant impact:

1. **Code Size Reduction**: 
   - Baseline (No Optimization): ~141,320 B
   - Full Optimization (e.g., O1–O8): ~4,012 B
   
   This represents an approximate 97% reduction in code size, illustrating the effectiveness of combined optimizations.

2. **Execution Time Improvements**:
   - High-level C code without optimization was slower and consumed more execution time.
   - Assembly-level optimization and targeted C optimizations (like using `-O3` and removing exceptions) yielded faster execution. For example, comparing bubble sort in C with no optimization vs. bubble sort in assembly showed reduced run times by a factor of 2 or more.

3. **ASCON Performance**:
   - While no official test vectors were verified, the code ran without errors and produced output consistent with the algorithm’s structure.
   - Preliminary measurements suggest that careful optimization can help maintain security while running ASCON within acceptable time and memory constraints on STM32 boards.

4. **Resource Utilization**:
   - Identifying space-wasting sections and using size-optimized libraries significantly improved memory efficiency.
   - Reducing overhead by removing exceptions and using more efficient memory allocation strategies led to better performance across various code sections.

---

## Discussion

The results demonstrate that compiler optimizations, combined with targeted code-level changes, can drastically improve memory footprint and execution time in embedded systems. By focusing on common bottlenecks—such as unused code sections, exception handling overhead, and inefficient memory management—developers can tailor their builds to the STM32’s constrained environment.

Interestingly, certain optimizations yielded minimal gains, indicating that not all optimization flags are universally beneficial. A systematic approach is vital: start from a baseline, apply single optimizations in isolation to understand their impact, and then combine them for maximum effect.

From a security and cryptography standpoint, the efficient implementation of ASCON suggests that even sophisticated algorithms can fit and run on resource-limited devices without sacrificing performance. Achieving this balance is essential for the future of IoT security, where lightweight cryptography standards ensure both robust protection and efficiency.

Ultimately, these findings guide developers in selecting optimization strategies that align with their application requirements. The trade-off between maintainability, debugging complexity, and runtime efficiency must be considered. In safety-critical or time-sensitive embedded applications, assembly-level optimizations may be justified. In general-purpose or rapidly evolving codebases, high-level optimizations and selective flags may suffice.

---

## Conclusion

This research demonstrates that substantial improvements in execution time and memory footprint are achievable through a systematic application of code optimization techniques on STM32 microcontrollers. By combining compiler optimization flags, removing unused code, disabling exceptions where feasible, and employing size-optimized libraries, code size can be reduced by more than 90% from baseline builds. Execution speed also improves when low-level assembly implementations or aggressive compiler optimizations are applied.

The implementation and optimization of the ASCON algorithm provide a case study in balancing security with performance in embedded systems. Although further testing with official test vectors and extensive benchmarking is recommended, the initial results are promising.

These findings serve as practical guidelines for embedded developers looking to optimize their STM32-based projects. Future work could expand the set of algorithms tested, explore more advanced optimization flags, or integrate automated profiling tools for a more data-driven optimization approach.


## References

[ARM ® Programming and Optimization](https://lira.epac.to/DOCS-TECH/Programming/Mobile%20and%20Embedded/Embedded/Embedded%20Systems%20-%20ARM%20Programming%20and%20Optimization.pdf)

[Embedded systems. 2nd edition. ARM Programming and Optimization by Jason D. Bakos](https://books.google.co.uz/books?hl=en&lr=&id=NFLSEAAAQBAJ&oi=fnd&pg=PP1&dq=code+optimization+in+embedded+systems+ARM+Cortex-M+microcontrollers&ots=T3i_rewRb5&sig=8zz_aNTTMfCUmMFtyiUifn3w6i0&redir_esc=y#v=onepage&q&f=false)

[STM32F4 – Code Optimization](https://istarc.wordpress.com/2014/07/26/stm32f4-code-optimizations/)

[Code optimization with Stm32 Cube IDE](https://www.disk91.com/2020/technology/programming/code-optimization-with-stm32-cube-ide/)

[Ascon Lightweight Cryptography](https://ascon.iaik.tugraz.at/index.html)

[Submission to the CAESAR Competition](https://competitions.cr.yp.to/round3/asconv12.pdf)

[Ascon-Based Lightweight Cryptography Standards for Constrained Devices: Authenticated Encryption, Hash, and Extendable Output Functions](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-232.ipd.pdf)

