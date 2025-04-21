
Update 9 November, 2024
Task: 
Code optimization for STM-32 f103/STM-32 F407 Discovery Time and memory

Note:
STM32CubeMX 6.9.0 KeilMDK538a applications are needed to work with STM-32

Update 18 November, 2024

Resources;

https://chatgpt.com/share/673ae995-c85c-8003-a6ed-ae660a8bf8a5

https://chatgpt.com/share/67463bde-c698-8003-9613-75e008c14649

https://books.google.co.uz/books?hl=en&lr=&id=NFLSEAAAQBAJ&oi=fnd&pg=PP1&dq=code+optimization+in+embedded+systems+ARM+Cortex-M+microcontrollers&ots=T3i_rewRb5&sig=8zz_aNTTMfCUmMFtyiUifn3w6i0&redir_esc=y

https://lira.epac.to/DOCS-TECH/Programming/Mobile%20and%20Embedded/Embedded/Embedded%20Systems%20-%20ARM%20Programming%20and%20Optimization.pdf

https://stackoverflow.com/questions/10800372/c-tips-for-code-optimization-on-arm-devices

https://www.disk91.com/2020/technology/programming/code-optimization-with-stm32-cube-ide/

https://istarc.wordpress.com/2014/07/26/stm32f4-code-optimizations/

https://github.com/micropython/micropython/wiki/Board-STM32F407-Discovery



my stuff:

Github: https://github.com/abdibrokhim/code-optimization-arm


Slides:

https://www.canva.com/design/DAGYIhh5ce4/nh29Mfb10Jt2mMzgli42kg/view?utm_content=DAGYIhh5ce4&utm_campaign=designshare&utm_medium=link&utm_source=editor

Research:


*[ChatGPT]:
Your thesis project on code optimization for the STM32 F103 and STM32 F407 microcontrollers is an exciting endeavor that focuses on enhancing execution time and memory efficiency. To move forward effectively, consider the following structured steps:
Conduct a Comprehensive Literature Review:
Research Existing Studies: Explore academic papers, technical articles, and books related to code optimization in embedded systems, particularly for ARM Cortex-M microcontrollers.
Understand Optimization Techniques: Familiarize yourself with various optimization strategies, such as algorithmic optimizations, compiler settings, and hardware-specific enhancements.
Define the Scope and Objectives of Your Thesis:
Specific Areas of Focus: Decide whether to concentrate on specific code segments (e.g., interrupt routines, communication protocols) or general optimization.
Set Clear Goals: Establish measurable objectives, like achieving a certain percentage reduction in execution time or memory usage.
Set Up Your Development Environment:
Install Necessary Tools: Ensure you have the appropriate Integrated Development Environment (IDE) like STM32CubeIDE, Keil MDK, or IAR Embedded Workbench.
Configure Hardware: Prepare your STM32 F103 and F407 Discovery boards for development and testing.
Develop or Select Benchmark Applications:
Representative Workloads: Choose applications or algorithms that are typical for the STM32 platform, such as signal processing tasks, control algorithms, or communication protocols.
Baseline Measurements: Run these applications without any optimizations to collect baseline data on execution time and memory usage.
Apply Code Optimization Techniques:
Algorithmic Optimizations: Simplify algorithms to reduce computational complexity (e.g., optimize loops, use efficient data structures).
Compiler Optimizations: Experiment with different compiler optimization levels (-O1, -O2, -O3, -Os) and analyze their impact.
Inline Assembly: For critical code sections, consider using inline assembly to exploit specific hardware features.
Memory Management: Optimize the use of stack and heap memory, and utilize memory-efficient coding practices.
Measure and Analyze Performance Improvements:
Profiling Tools: Use tools like STM32CubeMonitor or built-in IDE profilers to identify performance bottlenecks.
Data Collection: After each optimization, record the execution time and memory usage.
Statistical Analysis: Use statistical methods to determine the significance of improvements.
Document Your Methodology and Findings:
Detailed Records: Keep a meticulous log of the changes made, including code snippets and compiler settings.
Methodology Section: In your thesis, clearly describe the steps taken and justify the choices made during optimization.
Discuss the Results:
Interpretation: Analyze how each optimization affects performance and resource utilization.
Trade-offs: Discuss any trade-offs encountered, such as increased code complexity for performance gains.
Conclude and Suggest Future Work:
Summarize Achievements: Highlight the key improvements and their implications for embedded systems development.
Future Research: Suggest areas where further optimization or research could be beneficial.
Seek Feedback and Guidance:
Advisor Consultations: Regularly meet with your thesis supervisor to discuss progress and receive feedback.
Peer Reviews: Share your findings with peers or mentors to gain different perspectives.
Finalize Your Thesis Document:
Editing: Ensure your thesis is well-organized, with a logical flow and clarity in explanations.
Formatting and Citations: Adhere to your institution's formatting guidelines and properly cite all references.
Prepare for Thesis Defense (if applicable):
Presentation: Create a compelling presentation that summarizes your work and highlights key findings.
Anticipate Questions: Prepare answers to potential questions regarding your methodology, results, and conclusions.
Additional Considerations:
Stay Updated: Keep abreast of the latest developments in STM32 microcontroller technology and optimization techniques.
Practical Implementation: Whenever possible, validate your optimizations with real-world applications to demonstrate practical relevance.
Ethical Research: Ensure all your work complies with academic integrity policies and properly acknowledges the contributions of others.
By systematically approaching your thesis with these steps, you'll be well-positioned to produce a thorough and impactful study on code optimization for STM32 microcontrollers. Good luck with your project!



Thesis (draft)

Task:
(1) you need to make a written report on (a) literature review on your topic and related work, (b) describe your task, aims and goals, (c) describe methods you use (with references), (d) describe data if any you use (source, layout, size, types of information - categorical, numerical, so on), (e) write a section on your current results (this section should be updated each week)
(2) make a presentation similar to the review sections. Here you want only to highlight the major parts and milestones.


Literature review
Embedded systems. 2nd edition. ARM Programming and Optimization by Jason D. Bakos
The STM32F103 microcontroller is based on the ARM architecture. Specifically, it uses the ARM Cortex-M3 core, which is a 32-bit processor designed for embedded applications. This microcontroller is widely used in various applications due to its performance and efficiency in handling tasks within embedded systems. 
The first ARM processor technology was introduced in the 1980s. Since then it became the `de facto` mobile technology architecture.
1.1 Performance-oriented Programming
Mobile embedded processors prioritize energy efficiency, requiring more effort for high-performance code than desktop/server processors.
Desktop/server CPUs maximize performance for legacy and generic code through:
Instruction-level Parallelism: Executes multiple instructions per cycle, rearranges execution to reduce dependencies, and speculatively executes instructions.
Large, Complex Caches: Enhance memory performance and reduce repeated memory accesses.
Embedded processors typically lack these features:
Execute instructions in program order, limiting parallelism.
Have simpler caches with fewer hierarchy levels and lower bandwidth.
Performance tuning significantly impacts embedded processor performance, especially for compute-bound and memory-bound applications.
I/O bound programs depend on peripheral speeds, not processor technology.
Specialized hardware in SoCs handles tasks like video encoding efficiently, but emerging applications may need to use CPU, GPU, or other processors.
The textbook covers code optimization techniques for embedded and ARM processors, programming mobile GPGPUs with OpenCL, and uses examples like image processing and computer vision.
Utilizes Linux tools and supports low-cost ARM boards like Raspberry Pi for interactive development.
1.2 ARM Technology
ARM stands for Advanced RISC Machine, based on the RISC (Reduced Instruction Set Computer) philosophy.
RISC, developed in the 1980s at UC Berkeley, uses a small set of simple instructions.
This design minimizes the complexity of each instruction, allowing the processor to execute many simple instructions efficiently.
Brief History of ARM
ARMv6 (2002): Introduced with the ARM11 processor core, powering early single-board computers like the original Raspberry Pi, BeagleBone, PandaBoard, and the first smartphones.
ARMv7 (2004): Expanded into variants:
ARMv7-M: Optimized for microcontrollers.
ARMv7-R: Designed for real-time processors with limited instruction sets and hardware exception handling.
ARMv7-A: Targeted general-purpose applications, supporting modern operating systems with pipelined architectures.
Key Differences (ARMv6 vs. ARMv7):
NEON Instructions: ARMv7 added 128-bit SIMD instructions, enhancing parallel data processing.
Dropped VFP: Vector Floating Point support was replaced by NEON for performance improvements.
64-bit ARM (ARMv8)
Release (2013): Introduced significant enhancements over ARMv7.
New Features:
AArch32 and AArch64 Modes: Enabled running 32-bit ARMv7 code on ARMv8 processors while introducing a new 64-bit execution mode.
Enhanced SIMD: Retained 128-bit width with new reduction operations and expanded SIMD capabilities.
64-bit Arithmetic: Supported 64-bit operations and added instructions like insert (ins) for scalar transfers between SIMD lanes.
Register Expansion: Increased general-purpose registers from 16 to 32.
Instruction Set Changes: Removed conditional execution for most instructions, expanded branch instructions, and added hardware divide.
ARMv9 (2021): Added features for artificial intelligence and security, though single-board computers based on ARMv9 are not yet available.
ARM CPUs
ARMv6 Deployments:
Single-Core: ARM1136J(F)-S, ARM1156T2(F)-S, ARM1176JZ(F)-S.
Multi-Core: ARM11MPCore.
Microcontrollers: ARM Cortex-M0 and Cortex-M1 based on ARMv6-M for low power and deterministic execution.
ARMv7 Deployments:
Microcontrollers: Cortex-M3 to Cortex-M7 (ARMv7-M).
Real-Time Processors: Cortex-R4 to Cortex-R8 (ARMv7-R).
General-Purpose: Cortex-A5 to Cortex-A17 (ARMv7-A).
Advanced Technologies:
big.LITTLE and DynamIQ: Combine low-power cores (e.g., Cortex-A7, Cortex-A53) with high-performance cores (e.g., Cortex-A15, Cortex-A72) on the same SoC for enhanced energy efficiency.
ARM Programming
Language Support: ARM processors can be programmed using various high-level languages, with C being the focus for performance optimization.
Compiler Toolchains:
Open-Source: GCC and Clang support ARM through dedicated backends, providing comprehensive C/C++ development and debugging.
Commercial: Offered by ARM, Keil, and Texas Instruments, potentially generating faster object code.
Focus: The textbook utilizes GCC for characterizing high-level code performance.
The Linux/ARM Embedded Platform
RISC Architecture: ARM's simple instruction set allows efficient compiler utilization.
Complex Instructions: Modern ARM includes media, DSP, and SIMD instructions, which may require intrinsics or assembly for optimal use.
Development Tools: Uses Linux's GCC compiler, debug tools, OpenMP runtime, and supports interactive development on boards like Raspberry Pi.
ARM Architecture Set Architecture
Load-Store Architecture: Data must be explicitly loaded into registers before processing and stored back to memory after.
Arithmetic Operations: Use register contents for both inputs and results, facilitating efficient computation.
Register Usage: Registers hold temporary or intermediate results, such as loop counters or sub-expressions.
ARM General-Purpose Registers
Three-Address Architecture: Instructions can reference up to three registers (two sources and one destination).
Register Allocation: In GCC assembler, the destination register is listed first.
ARMv6/ARMv7 Integer Registers
Registers r0 to r15: Sixteen 32-bit user-accessible registers.
r0-r12: General-purpose use.
r13 (SP): Stack Pointer, managed by compiler for function calls.
r14 (LR): Link Register, holds return addresses from branch-and-link instructions.
r15 (PC): Program Counter, tracks instruction execution.
Function Conventions:
r0 and r1: Return values.
r2-r3: Function arguments.
r4-r11: Variable registers, generally safe for use.
Special Considerations: Avoid altering r14 and r15 directly; be cautious with registers used by the compiler (e.g., r9 as static base).
ARMv8 Integer Registers
Registers x0 to x30: Thirty-one 64-bit user-accessible registers, also accessible as 32-bit w0 to w30.
w-registers: Access the lower 32 bits of x-registers, zeroing the upper bits on write.
x31/w31: Acts as zero or stack pointer based on context; does not hold a constant zero like r0 in earlier versions.
Register 30 (LR): Link Register, stores return addresses.
Program Counter: Not a numbered register in ARMv8.
Instruction Enhancements: Separate 64-bit and 32-bit operations, improved shift and rotate instructions, and expanded functionality for SIMD and arithmetic operations.
…


References

…

---

chat:

Let's do ASCON

This is quite new algorithm. It's already optimized for some systems, so, you can download good source code

Analyze it, with CubeMX you can upload the code to the device and measure memory consumption

I would like to have a More complicated system to implement. For example, reading sensors, reacting to them, sending encrypted data, receiving encrypted answer/request, decrypt it and execute the order

https://github.com/haskucy/ascon_implementation_C/blob/main/ascon.c 
( This code uses 64bit architecture. But STM32 is 32bit processor )

https://github.com/ascon/ascon-c/tree/f1601cb5ff52e65baa475fcc6959e7d6e0be8d77/src 
( Here you can find way more variety of implementations )


Report needs
Methods
Results
Discussion

---

