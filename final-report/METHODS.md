# Code Optimization for STM32F103/STM32F407 Discovery Boards – Time and Memory Analysis

## Methods

### Experimental Platform  

Hardware: STM32F103 & STM32F407 Discovery Boards  

Toolchain and Measurement Setup  


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

```bash
gcc -O3 driver.c bubble_sort.c -o bubble_sort_benchmark && ./bubble_sort_benchmark
```

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


```bash
gcc -O3 -march=native -funroll-loops -flto driver.c bubble_sort_optimized.c bubble_sort_asm.s -o bubble_sort_benchmark && 
./bubble_sort_benchmark
```

### ASCON Optimization  

#### Baseline C & Inline‑Assembly Code  

#### AEAD ROUND_LOOP Optimization Strategy  

#### Side‑by‑Side Code Comparison  


### GOST 28147‑89 Optimization  

#### Baseline C & Inline‑Assembly Code

#### S‑Box & Round Function Optimizations

#### Comparative Code Analysis