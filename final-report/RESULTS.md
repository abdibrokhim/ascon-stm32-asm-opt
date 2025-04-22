# Code Optimization for STM32F103/STM32F407 Discovery Boards – Time and Memory Analysis

## Results

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