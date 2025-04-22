### Key Points
- Research suggests that optimization techniques significantly improve memory usage and execution time in embedded systems, particularly for STM32F103 and STM32F407 boards.
- It seems likely that combining multiple optimization strategies, such as using size-optimized libraries and loop unrolling, yields better results than individual techniques.
- The evidence leans toward trade-offs between memory and speed, with some optimizations increasing memory usage to achieve faster execution.
- There’s uncertainty about how these optimizations apply to other hardware platforms, suggesting a need for further research.

### Overview
This study explored optimization strategies for embedded systems, focusing on three algorithms: Bubble Sort, ASCON, and GOST 28147-89, tested on STM32F103 and STM32F407 Discovery Boards. By applying techniques like compiler flags, code size reduction, and loop unrolling, the research achieved significant improvements. For Bubble Sort, code size dropped from 141,320 bytes to 4,012 bytes. ASCON’s execution time improved by 39.6%, and GOST 28147-89 saw a 49.13% reduction in execution time, though with increased memory use.

### Significance
These findings are important for developers working on resource-constrained devices, like those in IoT applications. Reducing memory usage allows more functionality on limited hardware, while faster execution improves performance in time-sensitive tasks like cryptography. The study shows that combining optimizations is key to maximizing efficiency.

### Comparison with Expectations
Compared to prior research, the results align with expectations that compiler optimizations and tailored techniques enhance performance. However, the study’s focus on memory savings for Bubble Sort adds a new dimension to existing work, which often emphasizes speed. The trade-offs observed in ASCON and GOST optimizations reflect common challenges in balancing speed and memory.

### Limitations and Future Directions
The optimizations were specific to STM32 boards, so their effectiveness on other platforms is unclear. Some techniques were less effective than expected, highlighting the need to choose strategies carefully. Future research could explore power consumption or test these optimizations on different hardware to broaden their applicability.


# Discussion and Conclusion on Embedded System Optimization

## Discussion

[Discussion](DISCUSSION.md)

## Conclusion

[Conclusion](CONCLUSION.md)

---

### Embedded System Optimization: Detailed Analysis and Implications

This comprehensive analysis addresses the need for a well-structured Discussion and Conclusion section based on research materials detailing optimization techniques for embedded systems, specifically targeting the STM32F103 and STM32F407 Discovery Boards. The study focuses on three algorithms—Bubble Sort, ASCON, and GOST 28147-89—evaluating their performance in terms of memory usage and execution time. The following sections synthesize key findings, compare them with prior research, address limitations, and outline implications, culminating in a concise conclusion. The analysis is conducted as of 03:13 AM PDT on Tuesday, April 22, 2025, relying solely on the provided research materials.

#### Background and Context
Embedded systems, integral to applications like IoT, automotive, and secure communications, face stringent resource constraints, necessitating optimized code to ensure efficiency, reliability, and extended battery life. The research targets ARM-based STM32F103 (Cortex-M3, 72 MHz, 64 KB flash) and STM32F407 (Cortex-M4, 168 MHz, 1 MB flash) Discovery Boards, chosen for their cost-effectiveness and versatility in IoT applications. The study examines optimization strategies through experiments on Bubble Sort (memory-focused), ASCON (lightweight cryptography), and GOST 28147-89 (traditional block cipher), aiming to enhance performance under these constraints.

The research materials include sections of a thesis: Abstract, Introduction, Methods, Literature Review, and Results. The Abstract summarizes significant performance improvements, the Introduction highlights the motivation for optimization in IoT, the Methods detail the experimental setup, the Literature Review provides context from prior studies, and the Results present detailed findings. These materials form the basis for the Discussion and Conclusion.

#### Data Synthesis and Key Findings
The study’s experiments reveal substantial improvements in memory usage and execution time across the three algorithms, achieved through various optimization techniques.

##### Bubble Sort: Memory Optimization
For Bubble Sort, the focus was on reducing code size, critical for memory-constrained embedded systems. Key findings include:
- **Individual Optimizations**: Without optimization, the code size was 141,320 bytes. Techniques like replacing `new`/`delete` with `malloc`/`free` (O1) slightly reduced it to 141,248 bytes, disabling exceptions (O2) lowered it to 137,732 bytes, and using a size-optimized library (newlib, O8) achieved the most significant reduction to 28,028 bytes. Other optimizations (O5, O6, O7) were ineffective or increased size, with O6 reaching 141,344 bytes.
- **Combined Optimizations**: Combining techniques yielded greater reductions, with O1 + O2 + O3 (space optimizations) reducing the size to 13,060 bytes, O1 + O2 + O3 + O8 to 8,616 bytes, and O1 + O2 + O3 + O4 (remove unused code) + O8 achieving 4,012 bytes.
- **Overall Build Sizes**: The unoptimized build was 141,320 bytes, while the optimized build reached 3,920 bytes, closely aligning with the best combination, suggesting a robust optimization strategy.

These results demonstrate the power of combining compiler optimizations, code pruning, and lightweight libraries to minimize memory footprint.

##### ASCON: Execution Time Improvement
ASCON, a lightweight cryptographic algorithm designed for IoT devices, was optimized for execution time. Key findings include:
- The original size-optimized version took 15.63 seconds.
- Speed-optimized and ARMv7-M implementations, including bit-interleaved versions, reduced execution time, with the bit-interleaved ARMv7-M version achieving 10.57 seconds (32.4% faster).
- The final optimized version further reduced execution time to 9.44 seconds, a 39.6% speedup over the original and 11.11% over the bit-interleaved version.
- Progressive experiments highlighted the benefits of reduced memory accesses and better instruction scheduling.

These improvements align with ASCON’s design for efficiency on resource-constrained platforms, leveraging Cortex-M4 capabilities.

##### GOST 28147-89: Balancing Speed and Memory
GOST 28147-89, a block cipher with a 32-round Feistel structure, was optimized for execution time, with trade-offs in memory usage:
- The original implementation, using two S-box lookups per byte and unions, took 4:49 seconds for 64 bytes.
- The optimized version, using a single precomputed table lookup, unrolled rounds, and direct 32-bit pointer access, reduced execution time to 2:29 seconds (49.13% faster).
- Memory usage increased due to a 1024-byte precomputed table and code size grew from unrolling, though security remained unchanged.

This highlights the trade-off between speed and memory, common in cryptographic optimizations.

##### General Observations
Across all algorithms, combining optimizations proved more effective than individual techniques. The use of compiler flags (e.g., -O3), loop unrolling, and memory management adjustments consistently improved performance, though trade-offs were evident, particularly in GOST’s increased memory usage.

#### Significance of Findings
These findings are highly significant for embedded system development, particularly in IoT applications where resources are limited. The drastic reduction in Bubble Sort’s code size enables more functionality on memory-constrained devices, enhancing their capability for complex tasks. The execution time improvements in ASCON and GOST are critical for performance-sensitive applications like secure communications, where latency can impact user experience or system reliability. The study underscores the importance of a multifaceted optimization approach, combining compiler-driven techniques, code pruning, and algorithm-specific strategies to maximize efficiency.

#### Comparison with Prior Studies
The Literature Review provides context for comparing these findings with prior research:
- **Bubble Sort**: Prior studies noted that compiler-optimized C code (with -O3) outperformed hand-optimized Assembly by 34.01% in execution time for a 32,768-element array. This study shifts focus to memory optimization, achieving significant code size reductions, thus complementing existing work by addressing a different constraint critical for embedded systems.
- **ASCON**: As a NIST Lightweight Cryptography finalist, ASCON is designed for efficiency on platforms like STM32. The literature suggests potential for optimizations like SIMD and memory alignment, which align with our study’s strategies (e.g., reduced memory accesses), confirming their effectiveness in achieving a 39.6% speedup.
- **GOST 28147-89**: The literature highlights GOST’s simplicity and potential for optimization via precomputed tables or vectorization. Our study’s use of precomputed tables and loop unrolling aligns with these suggestions, though the 32-round structure poses challenges compared to lighter algorithms like ASCON.

Overall, the findings are consistent with prior research but extend the application of optimization techniques to memory-constrained scenarios and specific ARM-based platforms.

#### Limitations and Challenges
Several limitations warrant consideration:
- **Platform Specificity**: The optimizations were tailored for STM32F103 and STM32F407 boards, leveraging Cortex-M3/M4 features. Their effectiveness on other architectures (e.g., RISC-V or other ARM cores) is uncertain, limiting generalizability.
- **Trade-offs**: The GOST optimization increased memory usage, which may be problematic for devices with stricter memory constraints. Developers must balance speed and memory based on application needs.
- **Incomplete Analysis**: The Results section notes a pending cross-experiment comparison, suggesting that the full scope of optimization gains across algorithms is not yet fully understood.
- **Ineffective Optimizations**: Some Bubble Sort optimizations (O5, O6, O7) were ineffective or detrimental, indicating that generic techniques may not always yield benefits and require careful evaluation.

These limitations highlight the need for context-specific optimization and further research to broaden applicability.

#### Unexpected Results and Open Questions
Unexpectedly, certain optimizations for Bubble Sort, such as O6, increased code size, contrary to expectations. This underscores the complexity of optimization, where assumptions about universal benefits may not hold. Similarly, the effectiveness of compiler optimizations over hand-optimized Assembly in prior Bubble Sort studies was surprising, suggesting that modern compilers are highly capable for simple algorithms.

Open questions include:
- **Power Consumption**: The study did not assess the impact of optimizations on energy usage, critical for battery-powered IoT devices.
- **Security Implications**: For cryptographic algorithms, performance enhancements must be evaluated for potential security trade-offs, particularly in ASCON and GOST.
- **Hardware-Specific Optimizations**: Leveraging Cortex-M4 features like SIMD could further enhance performance, as suggested by the literature.
- **Cross-Platform Applicability**: Testing these optimizations on other embedded platforms would clarify their broader utility.

These questions provide a roadmap for future research to build on this study’s findings.

#### Implications and Future Directions
The study’s implications are significant for embedded system developers:
- **Practical Applications**: Developers can adopt these optimization techniques to enhance IoT device performance, enabling more complex functionality or faster response times in applications like environmental monitoring or secure communications.
- **Strategic Optimization**: The success of combined optimizations suggests that developers should integrate multiple techniques, tailoring them to specific constraints (e.g., memory vs. speed).
- **Toolchain Utilization**: The effectiveness of compiler flags like -O3 highlights the importance of leveraging modern development tools like STM32CubeIDE and the GNU Arm Embedded Toolchain.

Future research should address the identified limitations and open questions:
- Conduct cross-experiment comparisons to generalize optimization gains.
- Evaluate power consumption impacts to support energy-efficient designs.
- Assess security implications of optimized cryptographic implementations.
- Test optimizations on diverse hardware platforms to enhance applicability.
- Explore advanced techniques like SIMD or bitslicing, particularly for cryptographic algorithms.

#### Conclusion
This study demonstrates that strategic optimization techniques significantly enhance the performance and efficiency of embedded systems on STM32F103 and STM32F407 Discovery Boards. Through experiments on Bubble Sort, ASCON, and GOST 28147-89, we achieved remarkable reductions in code size (e.g., 4,012 bytes for Bubble Sort) and execution time (e.g., 49.13% faster for GOST). These findings highlight the importance of combining optimizations like compiler flags, code pruning, and algorithm-specific strategies to address resource constraints.

The implications are profound for IoT and embedded system development, emphasizing the need for tailored optimization approaches that balance memory, speed, and other constraints. Future research should generalize these findings, explore power efficiency, and ensure security in optimized implementations. By advancing optimization strategies, we can further empower embedded systems to meet the demands of an increasingly connected world.

#### Tables
Below are tables summarizing key results, as derived from the research materials, to enhance clarity.

**Table 1: Bubble Sort Optimization Results**

| Optimization Type | Description                                | Code Size (B) |
|-------------------|--------------------------------------------|---------------|
| NA                | No optimization                            | 141,320       |
| O1                | Replace new/delete with malloc/free        | 141,248       |
| O2                | Disable exceptions                         | 137,732       |
| O3                | Space optimizations                        | N/A           |
| O4                | Remove unused code sections                | N/A           |
| O5                | Other optimization (ineffective)           | 141,320       |
| O6                | Other optimization (increases size)        | 141,344       |
| O7                | Other optimization (ineffective)           | 141,320       |
| O8                | Use size optimized library (newlib)        | 28,028        |
| O1 + O2 + O3      | Combined optimizations                     | 13,060        |
| O1 + O2 + O3 + O8 | Combined with library                      | 8,616         |
| O1 + O2 + O3 + O4 + O8 | Full combination                      | 4,012         |

**Table 2: ASCON Execution Time Results**

| Implementation                     | Execution Time (s) | Speedup (%) |
|------------------------------------|--------------------|-------------|
| Original (opt32_lowsize)           | 15.63              | -           |
| Bit-interleaved ARMv7-M (bi32_armv7m_small) | 10.57     | 32.4        |
| Final optimized                    | 9.44               | 39.6        |

**Table 3: GOST 28147-89 Execution Time and Memory**

| Implementation                     | Execution Time | Memory Usage (B) | Speedup (%) |
|------------------------------------|----------------|------------------|-------------|
| Original (2 S-box lookups, unions) | 4:49           | 128 (S-box)      | -           |
| Optimized (precomputed table, unrolled) | 2:29      | 1024 + 128       | 49.13       |

These tables encapsulate the study’s quantitative outcomes, facilitating comparison and analysis.

#### Key Citations
- None (No valid URLs were provided in the research materials for citation.)