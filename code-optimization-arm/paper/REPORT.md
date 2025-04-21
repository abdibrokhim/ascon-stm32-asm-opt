# Report: Code optimization for STM-32 f103/STM-32 F407 Discovery Time and Memory (analysis)

## Literature review

Performance-oriented Programming
Mobile embedded processors prioritize energy efficiency, requiring more effort for high-performance code than desktop/server processors.
Embedded processors typically lack these features:
Execute instructions in program order, limiting parallelism.
Have simpler caches with fewer hierarchy levels and lower bandwidth.

ARM Technology
ARM stands for Advanced RISC Machine, based on the RISC (Reduced Instruction Set Computer) philosophy.
Data must be explicitly loaded into registers before processing and stored back to memory after.
ARM processors can be programmed using various high-level languages, with C being the focus for performance optimization.
Note: The STM32F103 microcontroller is based on the ARM architecture.

### Using C

compile `bubble_sort.c` file using; 

```bash
gcc bubble_sort.c -O3 -o bubble_sort
```

execute and time the program;

```bash
time ./bubble_sort
```

> book says:
![execute-time](stuff/execute-time.png)

### Using Assembly

compile `bubble_sort_asm.s` file using; 

```bash
gcc -c bubble_sort_asm.s -o bubble_sort_asm.o 
```

execute and time the program;

```bash
time ./bubble_sort_asm
```

compare the execution time of the two programs;

![execute-time-c-asm](stuff/execute-time-c-asm.png)

> book says:
![execute-time-c-asm-book](stuff/execute-time-c-asm-book.png)

### Result verification

enter `verify` folder and run the following command;
    
```bash
gcc driver.c bubble_sort.c bubble_sort_asm.s -o main
```

ASCON
ASCON is a family of lightweight cryptographic primitives designed for the Internet of Things (IoT) and embedded systems.


### Research focus & goals

Research focus areas:
Code Optimization for STM32 Microcontrollers. Specifically reducing execution time and minimizing memory usage.
Goals:
Improve performance by achieving significant reductions in execution time and decrease memory consumption.
Evaluate the effectiveness of different optimization strategies.
Identify performance bottlenecks and their solutions.
Study different algorithms and their performance to the given task.


## Methods

### STM32F4 – Code Optimization

We know that `embedded systems` usually have *limited computing/memory resources*. But we can always use various optimizations to *reduce space size* or *improve computing performance*. Here are some of the most common optimization techniques:

#### Memory Footprint Optimization

Build without enabled optimization

![Build without enabled optimization](/stuff/build-without-opt.png)

Build with enabled optimization

![Build with enabled optimization](/stuff/build-with-opt.png)

From the images above, we can see that the code size has been reduced from `(141,320 B)` to `(3,920 B)`.

#### Isolated Optimization

Here, one (or more) optimizations can be selected.

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

Here, multiple optimizations can be selected.

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

### ASCON

### High-Level Context

- The speaker is implementing the **Ascon-based ASCON AEAD algorithm**, specifically the variant chosen by NIST for standardization: **ASCON AEA 128**.
- ASCON was the winner of the NIST Lightweight Cryptography Competition, and as of the transcript’s date, an initial public draft of the standard was released. The final specification may still change.
- ASCON is a family of authenticated encryption and hashing algorithms designed for constrained environments. The implementation shown focuses on the authenticated encryption variant (AEAD).

---

### Key Algorithmic Details

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

---

### The Code Structure in the Transcript

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

### Testing and Verification

- The speaker prints intermediate states to ensure the code runs and doesn’t crash.
- Without official test vectors from the final standard or comparison to reference implementations, correctness verification is tentative at this stage.
- The final displayed ciphertext and tag are placeholders, as no official checks were done. Still, the logic aligns with the ASCON specification steps.

---

### What’s Missing or Simplified?

- **Associated Data (AD) Processing**: Not implemented, but would follow similar steps: absorb AD into the state, permute, and domain-separate.
- **Padding for Partial Blocks**: The transcript assumes full blocks. Real implementation must handle partial blocks by padding.
- **Official Test Vectors**: The final standard might provide test vectors for validation. Until then, confidence in correctness is limited.

---

### Key Takeaways

- The ASCON algorithm has a very clean and structured design, making it relatively straightforward to implement once you understand the permutation and the order of operations (initialize, absorb AD, encrypt plaintext, finalize).
- Implementing the S-box as Boolean functions over 64-bit words is a clever trick that avoids looping over each bit individually.
- Domain separation is crucial. XORing key material at different steps ensures that different phases of the algorithm (initialization, associated data, plaintext) remain cryptographically independent.



## Results

## Discussion

## Conclusion

## References

[ARM ® Programming and Optimization](https://lira.epac.to/DOCS-TECH/Programming/Mobile%20and%20Embedded/Embedded/Embedded%20Systems%20-%20ARM%20Programming%20and%20Optimization.pdf)

[Embedded systems. 2nd edition. ARM Programming and Optimization by Jason D. Bakos](https://books.google.co.uz/books?hl=en&lr=&id=NFLSEAAAQBAJ&oi=fnd&pg=PP1&dq=code+optimization+in+embedded+systems+ARM+Cortex-M+microcontrollers&ots=T3i_rewRb5&sig=8zz_aNTTMfCUmMFtyiUifn3w6i0&redir_esc=y#v=onepage&q&f=false)

[STM32F4 – Code Optimization](https://istarc.wordpress.com/2014/07/26/stm32f4-code-optimizations/)

[Code optimization with Stm32 Cube IDE](https://www.disk91.com/2020/technology/programming/code-optimization-with-stm32-cube-ide/)

[Ascon Lightweight Cryptography](https://ascon.iaik.tugraz.at/index.html)

[Submission to the CAESAR Competition](https://competitions.cr.yp.to/round3/asconv12.pdf)

[Ascon-Based Lightweight Cryptography Standards for Constrained Devices: Authenticated Encryption, Hash, and Extendable Output Functions](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-232.ipd.pdf)

