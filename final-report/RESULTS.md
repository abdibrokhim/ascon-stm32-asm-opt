# Code Optimization for STM32F103/STM32F407 Discovery Boards – Time and Memory Analysis

## Results

### 5.1. Bubble Sort: Execution‑Time & Memory Metrics  

Below are the tables, ensuring all data from the text is included:

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


### 5.2. ASCON: Throughput, Latency & Footprint  

**Table 1: Performance Results for ASCON Implementations**

| Implementation | Description | Time (seconds) | Speedup vs. Original [1] |
|----------------|-------------|----------------|--------------------------|
| Original [1] | opt32_lowsize: 32-bit size-optimized (pure C) | 15.63 | - |
| Original [2] | opt32: 32-bit speed-optimized (pure C) | 13.31 | 14.8% |
| Original [3] | armv7m_small: 32-bit speed-optimized ARMv7-M (C + inline ASM) | 10.83 | 30.7% |
| Original [4] | bi32_armv7m_small: 32-bit bit-interleaved ARMv7-M (C + inline ASM) | 10.57 | 32.4% |
| Optimized | Further optimized bi32_armv7m_small | 9.44 | 39.6% |

## How Did These Changes Influence Performance?

The experimental results demonstrate a clear performance improvement:

- **Original Version [1] (opt32_lowsize):** 15.63 seconds
- **Original Version [4] (bi32_armv7m_small):** 10.57 seconds
- **Optimized Version:** 9.44 seconds

The optimized version is 39.6% faster than version [1] and 11.11% faster than version [4]. Progressive experiments further refined the performance:

- **Experiment 1:** 10.44 seconds (1.98% faster than version [4])
- **Experiment 2:** 9.56 seconds (9.28% faster than version [4])
- **Experiment 3:** 9.44 seconds (11.11% faster than version [4])

The 11.11% improvement from version [4] to the optimized version stems from the combined effect of reduced memory accesses and improved instruction scheduling. The 39.6% speedup over version [1] highlights the cumulative impact of bit-interleaving (introduced in version [4]) and the additional optimizations.


### 5.3. GOST 28147‑89: Throughput, Latency & Footprint  

**Table 2: Performance Comparison of GOST Implementations**

| Aspect                | Original Implementation | Optimized Implementation |
|-----------------------|-------------------------|--------------------------|
| **Substitution**      | Two S-box lookups per byte (8 total per 32-bit word) | Single precomputed table lookup per byte (4 total) |
| **Rounds**            | Looped (nested loops for 32 rounds) | Unrolled (explicit 32 rounds) |
| **Data Handling**     | Union-based (`GOST_Data_Part`) with copying | Direct 32-bit pointer access |
| **Execution Time**    | 4:49 seconds (64 bytes) | 2:29 seconds (64 bytes) |
| **Memory Usage**      | 128-byte S-box | 1024-byte precomputed table + 128-byte S-box |
| **Code Size**         | Smaller (looped code) | Larger (unrolled code) |
| **Security**          | Unchanged | Unchanged |
