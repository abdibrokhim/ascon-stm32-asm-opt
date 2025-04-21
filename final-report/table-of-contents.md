# Code Optimization for STM32F103/STM32F407 Discovery Boards – Time and Memory Analysis

## Table of Contents

1. **Abstract**  
    A concise summary of the problem, methods, key results, and conclusions.

2. **Introduction**  
    2.1. Research Context and Motivation  
    2.2. Objectives and Research Questions  
    2.3. Overview of Optimization Experiments  
        2.3.1. Bubble Sort (C vs. Assembly)  
        2.3.2. ASCON AEAD (C & Inline Assembly)  
        2.3.3. GOST 28147‑89 (C & Inline Assembly)  

3. **Literature Review**  
    3.1. Performance‑Oriented Programming for Embedded Systems  
    3.2. ARM Architecture and STM32F1/F4 Series Features  
    3.3. C vs. Assembly: Case Study of Bubble Sort  
    3.4. ASCON AEAD and Hashing: Specifications & Baseline Implementations  
    3.5. GOST 28147‑89: Encryption, Decryption & MAC Algorithms  

4. **Materials and Methods**  
    4.1. Experimental Platform  
        4.1.1. Hardware: STM32F103 & STM32F407 Discovery Boards  
        4.1.2. Toolchain and Measurement Setup  
    4.2. Optimization Framework  
        4.2.1. Profiling & Benchmarking Tools  
        4.2.2. Memory‑Footprint Analysis  
        4.2.3. Code Isolation & Modular Testing  
    4.3. Bubble Sort Optimization  
        4.3.1. Baseline C Implementation  
        4.3.2. C‑Level Optimizations (flags, loop unrolling, etc.)  
        4.3.3. Assembly‑Level Optimizations  
    4.4. ASCON Optimization  
        4.4.1. Baseline C & Inline‑Assembly Code  
        4.4.2. AEAD ROUND_LOOP Optimization Strategy  
        4.4.3. Side‑by‑Side Code Comparison  
    4.5. GOST 28147‑89 Optimization  
        4.5.1. Baseline C & Inline‑Assembly Code  
        4.5.2. S‑Box & Round Function Optimizations  
        4.5.3. Comparative Code Analysis  

5. **Results**  
    5.1. Bubble Sort: Execution‑Time & Memory Metrics  
    5.2. ASCON: Throughput, Latency & Footprint  
    5.3. GOST 28147‑89: Throughput, Latency & Footprint  
    5.4. Cross‑Experiment Comparison of Optimization Gains  

6. **Discussion**  
    6.1. Implications for Embedded Cryptography  
    6.2. Trade‑Offs Between Time and Memory Optimizations  
    6.3. Study Limitations  

7. **Conclusion and Future Work**  
    7.1. Summary of Key Findings  
    7.2. Practical Recommendations  
    7.3. Directions for Further Research  

8. **References**  
    8.1. Complete list of all cited works.

9. **Appendices**  
    9.1. Full Code Listings  
    9.2. Profiling Scripts & Raw Data  
    9.3. Additional Figures and Tables  
