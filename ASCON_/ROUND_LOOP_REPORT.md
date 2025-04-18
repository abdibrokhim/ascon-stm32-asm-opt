# ROUND LOOP REPORT

### Key Points
- It seems likely that the optimized ASCON implementation improves performance by 1.98%, reducing runtime from 10:57 to 10:44 seconds, mainly through better memory access.
- The main change is loading two bytes at once using `ldrh` instead of two separate `ldrb` instructions, potentially reducing memory access overhead.
- The optimized code uses the high byte in both low and high state processing, which may be specific to this implementation and could affect correctness.

### Implementation Differences
The original ASCON implementation for "bi32_armv7m_small" (32-bit small bit-interleaved ARMv7-M, ARMv8, ARMv9) uses C with inline assembly, loading constants one byte at a time for both low and high state processing. In contrast, the optimized version, also in inline assembly, loads two bytes at once using `ldrh`, extracts them, and uses the low byte for low part processing and the high byte for both low and high parts. This change aims to enhance memory access efficiency.

### Performance Improvement
The optimized version runs in about 10:44 seconds, a 1.98% improvement over the original 10:57 seconds. This likely stems from fewer memory access instructions, potentially improving cache behavior and reducing pipeline stalls on ARM architectures.

### Unexpected Detail
An unexpected aspect is that the optimized code uses the high byte in both `eor %[x3_l], %[x3_l], %[tmp0]` and `eor %[x2_h], %[x2_h], %[tmp0]`, differing from the original, which uses separate bytes for `x2_l` and `x2_h`. This could indicate a design choice or potential error, requiring further verification against the ASCON specification.

---

### Detailed Analysis of ASCON Implementations

This report provides a comprehensive analysis of two implementations of the ASCON algorithm, specifically the `ROUND_LOOP` function in the `round.h` file for the "bi32_armv7m_small" target (32-bit small bit-interleaved ARMv7-M, ARMv8, ARMv9). The original implementation, an open-source version available on GitHub, took approximately 10:57 seconds, while the optimized version, provided by the user, reduced this to 10:44 seconds, achieving a 1.98% performance improvement. The analysis covers differences, improvements, changes made, locations of changes, reasons for those changes, and additional noteworthy observations.

#### Background on ASCON
ASCON is a family of lightweight cryptographic algorithms selected by the US National Institute of Standards and Technology (NIST) for standardization in lightweight cryptography, particularly for constrained devices like those in the Internet of Things (IoT) [Ascon – Lightweight Cryptography](https://ascon.iaik.tugraz.at/). It is based on a sponge construction, utilizing a permutation that includes round transformations with round constants, a nonlinear substitution layer, and a linear diffusion layer. The `ROUND_LOOP` function is part of this permutation, likely handling multiple rounds with constant additions and state updates.

#### Comparison of Implementations

The original and optimized implementations both use inline assembly for ARM architectures, but they differ significantly in how they handle constant loading and state processing. Below is a detailed comparison:

| Aspect                  | Original Implementation                          | Optimized Implementation                          |
|-------------------------|--------------------------------------------------|---------------------------------------------------|
| Constant Loading        | Uses two `ldrb` instructions to load one byte at a time for low and high parts, incrementing C by 1 each time. | Uses one `ldrh` instruction to load a halfword (two bytes), then extracts low and high bytes using `ubfx` and `and`, incrementing C by 2. |
| Constant Usage          | First byte loaded is XORed to `x2_l` in low part processing; second byte is XORed to `x2_h` in high part processing. | Low byte (`tmp1`) is XORed to `x2_l` in low part; high byte (`tmp0`) is XORed to both `x3_l` in low part and `x2_h` in high part. |
| Memory Access Pattern   | Two separate byte loads per iteration, potentially more memory access overhead. | Single halfword load per iteration, potentially reducing memory access overhead and improving cache efficiency. |
| Performance             | Takes approximately 10:57 seconds.               | Takes approximately 10:44 seconds, 1.98% faster.  |
| Linear Layer            | Identical in both versions, performing rotations and XORs for diffusion. | Identical to original, no changes in linear layer implementation. |

#### Improvements in Optimized Code
The primary improvement in the optimized code is in memory access efficiency. By using `ldrh` to load two bytes simultaneously, it reduces the number of memory access instructions from two `ldrb` operations to one, which can lead to:
- Fewer memory latency cycles, especially beneficial on ARM architectures with pipelined memory access.
- Potentially better cache utilization, as halfword loads might align better with cache line sizes.
- Reduced instruction count, which could improve instruction fetch and decode stages in the processor pipeline.

The performance gain of 1.98% (from 10:57 to 10:44 seconds) aligns with these optimizations, suggesting that memory access was a bottleneck in the original implementation.

#### Changes Made in Optimized Code
The optimized code made the following specific changes:
1. Replaced the two `ldrb %[tmp1], [%[C]], #1` instructions with `ldrh %[tmp1], [%[C]], #2`, followed by:
   - `ubfx %[tmp0], %[tmp1], #8, #8` to extract the high byte into `tmp0`.
   - `and %[tmp1], %[tmp1], #0xFF` to extract the low byte into `tmp1`.
2. Changed the usage of constants: the high byte (`tmp0`) is now used in both `eor %[x3_l], %[x3_l], %[tmp0]` in the low part processing and `eor %[x2_h], %[x2_h], %[tmp0]` in the high part processing, whereas in the original, two different bytes were used for `x2_l` and `x2_h`.

These changes were implemented in the initial part of the `ROUND_LOOP` function, specifically in the constant loading and early state processing stages.

#### Locations of Changes
The changes are located at the beginning of the `ROUND_LOOP` function, where constants are loaded:
- Original: Lines with `ldrb %[tmp1], [%[C]], #1` appear twice, once before low part processing and once before high part processing.
- Optimized: Replaced with `ldrh %[tmp1], [%[C]], #2` and subsequent extraction operations, affecting the constant loading mechanism for the entire loop.

The rest of the function, including the substitution-like operations and linear diffusion layer, remains structurally identical, suggesting that the optimization is focused on the memory access bottleneck.

#### Reasons for Specific Changes
The specific changes were likely made to address performance bottlenecks in memory access:
- **Halfword Load (`ldrh`)**: Loading two bytes at once reduces the number of memory access instructions, which is critical for performance on ARM architectures where memory latency can impact throughput. This is particularly important for lightweight cryptography on constrained devices, where minimizing cycles is essential.
- **Constant Reuse**: Using the high byte in both `x3_l` and `x2_h` might be an optimization to reduce the number of unique constants needed, potentially aligning with the bit-interleaved representation ("bi32") of the state. However, this deviates from the original, where different bytes were used, raising questions about correctness that require verification against the ASCON specification [Ascon v1.2: Lightweight Authenticated Encryption and Hashing](https://link.springer.com/article/10.1007/s00145-021-09398-9).
- **Register Efficiency**: By extracting bytes into `tmp0` and `tmp1`, the optimized code might improve register allocation, reducing dependencies and potentially allowing better instruction scheduling by the compiler or processor.

The 1.98% performance improvement suggests these changes effectively reduced overhead, likely due to fewer memory operations and better cache alignment.

#### Additional Observations
Several points are worth noting:
1. **Potential Correctness Concern**: The optimized code's use of the high byte in both `x3_l` and `x2_h` differs from the original, where separate bytes were used for `x2_l` and `x2_h`. According to the ASCON specification, round constants are 1-byte values XORed to word S2, which corresponds to `x2` in the state. The original code aligns with this by XORing to `x2_l` and `x2_h` with different bytes, but the optimized version's reuse of the high byte for `x3_l` and `x2_h` may indicate a design choice or error. Further analysis against the full ASCON implementation is recommended to ensure cryptographic security is maintained.
2. **Bit-Interleaved Representation**: The "bi32_armv7m_small" target suggests a bit-interleaved state representation, which may explain the dual usage of constants in low and high parts. This could be an optimization for parallel processing on ARM, but it requires alignment with the standard to ensure no security vulnerabilities are introduced.
3. **Performance Metrics**: The 1.98% improvement, while modest, is significant for lightweight cryptography, where every cycle counts. This aligns with ASCON's design for efficiency on constrained devices, as noted in NIST's selection [NIST Selects ‘Lightweight Cryptography’ Algorithms to Protect Small Devices](https://www.nist.gov/news-events/news/2023/02/nist-selects-lightweight-cryptography-algorithms-protect-small-devices).

#### Conclusion
The optimized ASCON implementation enhances performance by optimizing memory access through halfword loads, achieving a 1.98% reduction in runtime. However, the change in constant usage, particularly the reuse of the high byte, warrants further investigation to ensure compliance with the ASCON specification and maintain cryptographic integrity. This analysis highlights the trade-offs between performance and correctness in lightweight cryptography implementations.

### Key Citations
- [Ascon – Lightweight Cryptography](https://ascon.iaik.tugraz.at/)
- [Ascon v1.2: Lightweight Authenticated Encryption and Hashing](https://link.springer.com/article/10.1007/s00145-021-09398-9)
- [NIST Selects ‘Lightweight Cryptography’ Algorithms to Protect Small Devices](https://www.nist.gov/news-events/news/2023/02/nist-selects-lightweight-cryptography-algorithms-protect-small-devices)


------------------------------------------------------------

### Key Points
- It seems likely that the second optimized ASCON implementation improves performance by 9.28%, reducing runtime from 10:57 (657 seconds) to 9:56 (596 seconds), mainly through better instruction scheduling and aligned memory access.
- Research suggests the main changes are reordering instructions for pipeline efficiency and ensuring aligned halfword loads, critical for STM32 devices.
- The evidence leans toward these optimizations being effective for in-order pipelines like Cortex-M3/M4/M7, but correctness needs verification due to potential sequence changes.

### Direct Answer

The second optimized version of the ASCON implementation shows significant improvements over the original and first optimized versions, running in 9:56 (596 seconds) compared to the original 10:57 (657 seconds), a 9.28% speed increase. Here's a breakdown for easy understanding:

#### Performance Boost
- This version is much faster, likely due to better use of the processor's pipeline, which helps execute more instructions at once on devices like STM32 (Cortex-M3/M4/M7).
- It also ensures memory access is aligned, which is crucial for these devices to avoid slowdowns.

#### Key Changes
- **Instruction Reordering**: The order of operations in processing the state (low and high halves) was changed to let the processor handle more tasks simultaneously, reducing wait times.
- **Aligned Memory Access**: It loads round constants using halfword loads from aligned memory, which is faster on ARM chips, especially STM32, where unaligned access can hurt performance.

#### Where Changes Happened
- These updates are in the low and high half processing parts of the `ROUND_LOOP` function, with comments added to explain the new scheduling.

#### Why These Changes?
- The reordering helps the in-order pipeline of STM32 devices avoid delays, making the code run smoother.
- Aligned loads are vital for STM32, as unaligned access can slow down the processor significantly, and this version ensures efficiency.

#### Unexpected Detail
- One interesting change is that the sequence of operations might differ from the original, potentially affecting how the state is computed. While this boosts speed, it’s important to check if it still produces the correct cryptographic results, as security is critical for ASCON [Ascon – Lightweight Cryptography](https://ascon.iaik.tugraz.at/).

This optimization seems promising for performance, but verifying correctness is key, especially for cryptographic security.

---

### Survey Note: Detailed Analysis of Second Optimized ASCON Implementation

This note provides a comprehensive analysis of the second optimized version of the ASCON implementation, focusing on changes, updates, and improvements compared to the original and first optimized versions. The second version claims a 9.28% performance improvement, reducing runtime from 10:57 (657 seconds) to 9:56 (596 seconds), and is targeted for STM32 devices (Cortex-M3/M4/M7). The analysis is structured to highlight the technical details and implications, ensuring a professional and thorough examination.

#### Background and Context
ASCON is a lightweight cryptographic algorithm selected by the US National Institute of Standards and Technology (NIST) for standardization in lightweight cryptography, particularly for constrained devices like those in the Internet of Things (IoT) [Ascon – Lightweight Cryptography](https://ascon.iaik.tugraz.at/). It uses a sponge construction with a permutation involving round transformations, including round constants, a nonlinear substitution layer, and a linear diffusion layer. The `ROUND_LOOP` function, part of the permutation, is implemented in inline assembly for ARM architectures (32-bit ARMv7-M, ARMv8, ARMv9), focusing on performance optimization.

The original implementation took 657 seconds, the first optimized version took 644 seconds (1.98% faster), and this second optimized version takes 596 seconds, achieving a significant 9.28% improvement over the original. The analysis compares this version with both the original and first optimized versions, emphasizing changes made to achieve the performance boost.

#### Comparison with Previous Versions
To understand the improvements, let's first summarize the key characteristics of the previous versions:

| Aspect                  | Original Implementation                          | First Optimized Implementation                     | Second Optimized Implementation                     |
|-------------------------|--------------------------------------------------|---------------------------------------------------|----------------------------------------------------|
| Constant Loading        | Uses two `ldrb` instructions, one byte at a time, incrementing C by 1 each time. | Uses one `ldrh` instruction to load two bytes, extracts low and high bytes, increments C by 2. | Same as first optimized: uses `ldrh` with aligned access, extracts low and high bytes. |
| Low Half Processing     | Sequential operations, including `eor %[x4_l], %[x4_l], %[x3_l]` before using `%[x4_l]` in later operations. | Similar to original, with `eor %[x4_l], %[x4_l], %[x3_l]` before using `%[x4_l]` in `orn`. | Reordered operations, omitting explicit modification of `%[x4_l]` before `orn %[tmp1], %[x4_l], %[x0_l]`, using original `%[x4_l]`. |
| High Half Processing    | Similar sequential approach, with clear separation but no specific reordering for pipeline. | Similar to original, with standard sequence. | Maintains clear separation, with potential reordering for pipeline efficiency. |
| Performance             | 657 seconds.                                     | 644 seconds (1.98% faster than original).         | 596 seconds (9.28% faster than original).          |
| Target Devices          | General ARMv7-M, ARMv8, ARMv9.                   | Same as original.                                 | Specifically optimized for STM32 (Cortex-M3/M4/M7). |

The second optimized version builds on the first by focusing on instruction scheduling and aligned memory access, tailored for STM32 devices with in-order pipelines.

#### Detailed Changes and Updates
The second optimized version introduces several key changes, as outlined in the provided comments and code:

1. **Instruction Reordering for Pipeline Efficiency**:
   - The operations in both low-half and high-half processing parts are reordered to expose more independent operations to the pipeline. This is critical for STM32 devices, which have in-order pipelines (Cortex-M3/M4/M7), where instruction dependencies can cause stalls.
   - For example, in the low half processing, the sequence starts with `eor %[x0_l], %[x0_l], %[x4_l]` and `eor %[x2_l], %[x2_l], %[x1_l]`, followed by constant injection and other operations, potentially allowing parallel execution of independent instructions.
   - This reordering aims to reduce pipeline stalls by ensuring that the processor can execute as many instructions as possible in parallel, leveraging the limited out-of-order capabilities of these architectures.

2. **Aligned Halfword Load for Round Constants**:
   - The round constant is loaded using `ldrh %[tmp1], [%[C]], #2`, ensuring a halfword (16-bit) load from an aligned location. This is explicitly noted as critical for STM32 devices, where unaligned memory accesses can significantly degrade performance due to additional cycles for alignment handling.
   - The extraction of low and high bytes using `ubfx %[tmp0], %[tmp1], #8, #8` and `and %[tmp1], %[tmp1], #0xFF` remains the same as the first optimized version, but the emphasis on alignment ensures optimal memory access.

3. **Inline Comments for Clarity**:
   - The code includes detailed inline comments, such as "Load 16-bit constant from C and post-increment" and "Inject high-byte constant into x2 (high)", which annotate the changes and describe the new scheduling. This improves maintainability and understanding, especially for developers working on STM32 platforms.

#### Improvements and Performance Impact
The 9.28% performance improvement (from 657 to 596 seconds) is significant and can be attributed to the following factors:

- **Pipeline Efficiency**: By reordering instructions, the second optimized version reduces dependencies, allowing the in-order pipeline to execute more instructions concurrently. This is particularly effective for Cortex-M3/M4/M7, where pipeline stalls can be a major bottleneck. The reordering likely minimizes wait states, improving throughput.
- **Aligned Memory Access**: Ensuring aligned halfword loads reduces memory access latency, which is crucial for STM32 devices. Unaligned accesses can introduce additional cycles, and this optimization avoids such overhead, contributing to the performance gain.
- **Targeted Optimization for STM32**: The focus on STM32 devices, with their specific architectural constraints, ensures that the optimizations are tailored to the target hardware, maximizing efficiency.

However, an unexpected detail emerged during analysis: the sequence of operations in the low half processing differs from the original and first optimized versions. Specifically, in the second optimized version, `%[x4_l]` is used in `orn %[tmp1], %[x4_l], %[x0_l]` without being modified by `eor %[x4_l], %[x4_l], %[x3_l]` beforehand, unlike the original. This raises concerns about correctness, as it may alter the state computation. While the performance improvement suggests the code is functional, verifying equivalence to the ASCON specification is essential to ensure cryptographic security [Ascon v1.2: Lightweight Authenticated Encryption and Hashing](https://link.springer.com/article/10.1007/s00145-021-09398-9).

#### Where Changes Were Made
The changes are primarily in the low-half and high-half processing sections of the `ROUND_LOOP` function, with the following specific locations:
- **Low Half Processing**: Reordered sequence of `eor`, `orn`, `bic`, and `and` operations to maximize parallelism.
- **High Half Processing**: Similar reordering, maintaining the structure but optimizing for pipeline efficiency.
- **Constant Loading**: Ensured alignment for `ldrh` instruction, with no change from the first optimized version but emphasized for STM32.

#### Why These Changes Were Made
The changes were made to address performance bottlenecks specific to STM32 devices:
- **Pipeline Stalls**: The in-order pipeline of Cortex-M3/M4/M7 can stall if instructions have dependencies. Reordering exposes independent operations, reducing wait times and improving instruction throughput.
- **Memory Access Overhead**: Aligned halfword loads minimize latency, as unaligned accesses on ARM can introduce additional cycles, which is particularly detrimental for lightweight cryptography on constrained devices.
- **Target Hardware**: The optimizations are tailored for STM32, aligning with its architectural characteristics, as noted in NIST's selection for lightweight cryptography [NIST Selects ‘Lightweight Cryptography’ Algorithms to Protect Small Devices](https://www.nist.gov/news-events/news/2023/02/nist-selects-lightweight-cryptography-algorithms-protect-small-devices).

#### Additional Observations
Several points are worth noting:
- The linear layer (rotations and mixing) remains unchanged from previous versions, suggesting that the performance gain is solely from the substitution layer and constant loading optimizations.
- The bit-interleaved representation ("bi32_armv7m_small") is maintained, which may explain the dual usage of constants in low and high parts, but the reordering must align with the ASCON specification to ensure security.
- The 9.28% improvement is significant for lightweight cryptography, where every cycle counts, aligning with ASCON's design for efficiency on constrained devices.

#### Conclusion
The second optimized ASCON implementation achieves a 9.28% performance improvement through instruction reordering for pipeline efficiency and aligned halfword loads, tailored for STM32 devices. However, the potential change in operation sequence, particularly in low half processing, requires verification against the ASCON specification to ensure correctness and maintain cryptographic integrity. This optimization is promising for performance but highlights the trade-offs between speed and security in lightweight cryptography implementations.

### Key Citations
- [Ascon – Lightweight Cryptography](https://ascon.iaik.tugraz.at/)
- [Ascon v1.2: Lightweight Authenticated Encryption and Hashing](https://link.springer.com/article/10.1007/s00145-021-09398-9)
- [NIST Selects ‘Lightweight Cryptography’ Algorithms to Protect Small Devices](https://www.nist.gov/news-events/news/2023/02/nist-selects-lightweight-cryptography-algorithms-protect-small-devices)

------------------------------------------------------------

### Key Points
- It seems likely that the third optimized ASCON implementation improves performance by 11.11%, reducing runtime from 10:57 to 9:44 seconds, mainly through interleaving low and high half operations for better pipeline utilization.
- Research suggests the main changes include interleaving operations, but there’s a potential correctness issue with temporary register usage that needs fixing.
- The evidence leans toward this optimization being effective for in-order pipelines like STM32, but verifying cryptographic correctness is crucial due to the register misuse.

### Performance Improvement
The third version of the ASCON implementation runs in about 9:44 seconds, which is 11.11% faster than the original 10:57 seconds. This boost likely comes from interleaving operations for the low and high halves, helping the processor handle more tasks at once on devices like STM32 (Cortex-M3/M4/M7).

### Key Changes
- **Interleaving Operations**: Instead of processing low and high halves separately, the code mixes their operations to reduce delays in the processor’s pipeline, letting it work on multiple tasks simultaneously.
- **Potential Issue**: There’s a mistake where a temporary register (`tmp0`) is overwritten in high half processing and then used incorrectly in low half processing, which could affect the results.

### Why It Matters
This optimization is great for speed, especially on in-order pipelines, but the register issue could compromise the security of the cryptographic algorithm. Fixing this is essential to ensure the code works correctly.

---

### Survey Note: Detailed Analysis of Third Optimized ASCON Implementation

This note provides a comprehensive analysis of the third optimized version of the ASCON implementation, focusing on changes, updates, and improvements compared to the original, first optimized, and second optimized versions. The third version claims an 11.11% performance improvement, reducing runtime from 10:57 (657 seconds) to 9:44 (584 seconds), and is targeted for performance on ARM architectures, particularly STM32 devices (Cortex-M3/M4/M7). The analysis is structured to highlight technical details and implications, ensuring a professional and thorough examination.

#### Background and Context
ASCON is a lightweight cryptographic algorithm selected by the US National Institute of Standards and Technology (NIST) for standardization in lightweight cryptography, particularly for constrained devices like those in the Internet of Things (IoT) [Ascon – Lightweight Cryptography](https://ascon.iaik.tugraz.at/). It uses a sponge construction with a permutation involving round transformations, including round constants, a nonlinear substitution layer, and a linear diffusion layer. The `ROUND_LOOP` function, part of the permutation, is implemented in inline assembly for ARM architectures (32-bit ARMv7-M, ARMv8, ARMv9), focusing on performance optimization.

The original implementation took 657 seconds, the first optimized version took 644 seconds (1.98% faster), the second optimized version took 596 seconds (9.28% faster), and this third optimized version takes 584 seconds, achieving an 11.11% improvement over the original. The analysis compares this version with all previous versions, emphasizing changes made to achieve the performance boost.

#### Comparison with Previous Versions
To understand the improvements, let's first summarize the key characteristics of the previous versions in a table:

| Aspect                  | Original Implementation                          | First Optimized Implementation                     | Second Optimized Implementation                     | Third Optimized Implementation                     |
|-------------------------|--------------------------------------------------|---------------------------------------------------|----------------------------------------------------|----------------------------------------------------|
| Constant Loading        | Uses two `ldrb` instructions, one byte at a time, incrementing C by 1 each time. | Uses one `ldrh` instruction to load two bytes, extracts low and high bytes, increments C by 2. | Same as first optimized: uses `ldrh` with aligned access, extracts low and high bytes. | Same as second optimized: uses `ldrh` with aligned access, extracts low and high bytes. |
| Low Half Processing     | Sequential operations, including `eor %[x4_l], %[x4_l], %[x3_l]` before using `%[x4_l]` in later operations. | Similar to original, with `eor %[x4_l], %[x4_l], %[x3_l]` before using `%[x4_l]` in `orn`. | Reordered operations, omitting explicit modification of `%[x4_l]` before `orn %[tmp1], %[x4_l], %[x0_l]`, using original `%[x4_l]`. | Interleaves operations with high half, starting with `eor %[x0_l], %[x0_l], %[x4_l]` and mixing with high half operations. |
| High Half Processing    | Similar sequential approach, with clear separation but no specific reordering for pipeline. | Similar to original, with standard sequence. | Maintains clear separation, with potential reordering for pipeline efficiency. | Interleaves with low half, starting with `eor %[x0_h], %[x0_h], %[x4_h]` and mixing operations for better pipeline utilization. |
| Performance             | 657 seconds.                                     | 644 seconds (1.98% faster than original).         | 596 seconds (9.28% faster than original).          | 584 seconds (11.11% faster than original).         |
| Target Devices          | General ARMv7-M, ARMv8, ARMv9.                   | Same as original.                                 | Specifically optimized for STM32 (Cortex-M3/M4/M7). | Same as second optimized, with focus on pipeline efficiency. |

The third optimized version builds on the second by introducing interleaving of low and high half operations, aiming to further enhance pipeline utilization.

#### Detailed Changes and Updates
The third optimized version introduces several key changes, as outlined in the provided comments and code:

1. **Interleaving Low- and High-Half Operations**:
   - Instead of processing the low half fully and then the high half (as in the second optimized version), the operations are interleaved to allow the processor's pipeline to work on independent data streams concurrently, reducing stalls due to data dependencies. This is critical for in-order pipelines like those in STM32 devices (Cortex-M3/M4/M7).
   - For example, the code starts by mixing x0 and x4 for both low and high halves concurrently (`eor %[x0_l], %[x0_l], %[x4_l]` and `eor %[x0_h], %[x0_h], %[x4_h]`), then processes mixing x2 and x1 and injects constants in parallel for both halves (`eor %[x2_l], %[x2_l], %[x1_l]` and `eor %[x2_h], %[x2_h], %[x1_h]`, with constant injection).
   - This interleaving aims to maximize parallelism, allowing the processor to execute more instructions in parallel, leveraging the limited out-of-order capabilities of these architectures.

2. **Other Potential Optimizations Mentioned**:
   - The comments mention full loop unrolling, exploiting DSP extensions, placing constants in fast memory, and writing a dedicated assembly routine. However, in the provided code, the loop is not fully unrolled (still uses a branch for loop control), and there are no explicit DSP instructions or directives for fast memory placement. The function is already in inline assembly, so it may be considered a dedicated routine.
   - These suggestions indicate potential future optimizations but are not implemented in this version.

#### Improvements and Performance Impact
The 11.11% performance improvement (from 657 to 584 seconds) is significant and can be attributed to the following factors:

- **Pipeline Efficiency**: By interleaving operations, the third optimized version reduces dependencies, allowing the in-order pipeline to execute more instructions concurrently. This is particularly effective for Cortex-M3/M4/M7, where pipeline stalls can be a major bottleneck. The interleaving likely minimizes wait states, improving throughput, contributing to the 2.01% improvement from the second optimized version (596 to 584 seconds).
- **Maintained Aligned Memory Access**: The constant loading using `ldrh` with aligned access, as in the second optimized version, is retained, ensuring minimal memory access latency, which is crucial for STM32 devices.
- **Targeted Optimization for STM32**: The focus on pipeline efficiency aligns with the architectural characteristics of STM32, maximizing efficiency, as noted in NIST's selection for lightweight cryptography [NIST Selects ‘Lightweight Cryptography’ Algorithms to Protect Small Devices](https://www.nist.gov/news-events/news/2023/02/nist-selects-lightweight-cryptography-algorithms-protect-small-devices).

However, an unexpected detail emerged during analysis: there is a potential correctness issue in the third version. Specifically, the temporary register `tmp0` is initially set to the high byte constant, used in high half processing (`orn %[tmp0], %[x4_h], %[x0_h]`), and then reused in low half processing (`eor %[x3_l], %[x3_l], %[tmp0]`). This means `tmp0` is overwritten in high half processing before being used in low half processing, potentially using an incorrect value. In the second optimized version, `tmp0` held the high byte constant throughout low half processing, ensuring correctness. This error could lead to incorrect state computation, which is critical for cryptographic security, and must be addressed.

#### Where Changes Were Made
The changes are primarily in the low-half and high-half processing sections of the `ROUND_LOOP` function, with the following specific locations:
- **Interleaved Processing**: Operations like `eor %[x0_l], %[x0_l], %[x4_l]` and `eor %[x0_h], %[x0_h], %[x4_h]` are performed concurrently, followed by mixing x2 and x1 and constant injection for both halves.
- **Continued Processing**: The subsequent operations for low and high halves are interleaved, with `orn`, `bic`, and `eor` operations mixed to maximize parallelism, compared to the sequential processing in the second optimized version.

#### Why These Changes Were Made
The changes were made to address performance bottlenecks specific to STM32 devices:
- **Pipeline Stalls**: The in-order pipeline of Cortex-M3/M4/M7 can stall if instructions have dependencies. Interleaving exposes independent operations, reducing wait times and improving instruction throughput.
- **Memory Access Overhead**: While the aligned halfword loads are retained from the second optimized version, the interleaving further optimizes pipeline utilization, minimizing latency.
- **Target Hardware**: The optimizations are tailored for STM32, aligning with its architectural characteristics, as noted in NIST's selection for lightweight cryptography [NIST Selects ‘Lightweight Cryptography’ Algorithms to Protect Small Devices](https://www.nist.gov/news-events/news/2023/02/nist-selects-lightweight-cryptography-algorithms-protect-small-devices).

#### Additional Observations
Several points are worth noting:
- The linear layer (rotations and mixing) remains unchanged from previous versions, suggesting that the performance gain is solely from the substitution layer and constant loading optimizations.
- The bit-interleaved representation ("bi32_armv7m_small") is maintained, which may explain the dual usage of constants in low and high parts, but the register misuse must align with the ASCON specification to ensure security.
- The 11.11% improvement is significant for lightweight cryptography, where every cycle counts, aligning with ASCON's design for efficiency on constrained devices.
- The potential correctness issue with `tmp0` is a critical finding, as it could introduce security vulnerabilities if not addressed, highlighting the trade-off between performance and correctness in cryptographic implementations.

#### Conclusion
The third optimized ASCON implementation achieves an 11.11% performance improvement through interleaving low and high half operations for better pipeline efficiency, tailored for STM32 devices. However, there is a significant correctness issue with the misuse of temporary register `tmp0`, which must be fixed to ensure cryptographic integrity. To resolve this, the user should preserve the high byte constant in a separate register, such as introducing an additional temporary register to hold it throughout the necessary operations. This optimization is promising for performance but underscores the importance of verifying correctness in lightweight cryptography implementations.

### Key Citations
- [Ascon – Lightweight Cryptography](https://ascon.iaik.tugraz.at/)
- [Ascon v1.2: Lightweight Authenticated Encryption and Hashing](https://link.springer.com/article/10.1007/s00145-021-09398-9)
- [NIST Selects ‘Lightweight Cryptography’ Algorithms to Protect Small Devices](https://www.nist.gov/news-events/news/2023/02/nist-selects-lightweight-cryptography-algorithms-protect-small-devices)