
### 2.7 Continued Literature Review: ASCON Optimization Techniques on STM32 Microcontrollers

To further enhance our understanding of ASCON optimization on STM32 platforms, it is essential to analyze recent studies that investigate low-level programming strategies and microarchitectural optimizations. These additional insights expand upon prior research by Primas and Schlaffer, NIST updates, and Arduino-class evaluations already discussed.

Recent benchmarks by the Lightweight Secure Systems Laboratory (LaS³) highlight the effectiveness of DMA-assisted Authenticated Encryption with Associated Data (AEAD). Specifically, the overlapping of cryptographic permutation calculations with block input/output operations yields approximately an 8% throughput improvement on STM32 F7 and H7 devices. Additionally, implementation strategies leveraging ARM's Thumb-2 assembly instructions for XOR-rotate-XOR sequences further enhance execution efficiency, reducing permutation rounds by up to 2 CPU cycles.

Moreover, the extensive study presented in the MDPI survey outlines critical side-channel resistance techniques, such as Domain-Oriented Masking (DOM) and Threshold Implementation (TI). Implementations incorporating these masking strategies have demonstrated energy savings ranging between 11% to 48% on complementary metal-oxide-semiconductor (CMOS) technologies, making them highly relevant for secure deployments on STM32-based IoT devices.

Given the NIST’s selection of ASCON as a standard, exploring hardware-software co-design approaches on STM32 platforms presents promising avenues for additional optimizations. Preliminary investigations suggest potential performance gains of around 15% when utilizing STM32’s integrated cryptographic accelerators, such as Public-Key Accelerator (PKA) and Symmetric AES (SAES) engines. Future implementations on STM32 microcontrollers could significantly benefit from such integrated hardware features, resulting in substantial energy efficiency and speed improvements.

### 3.6 Continued Literature Review: GOST 28147-89 Optimization Techniques on STM32 Microcontrollers

Extending the analysis of GOST 28147-89 implementation on STM32 microcontrollers requires delving deeper into practical software optimization methods and leveraging existing cryptographic libraries provided by STMicroelectronics.

Although direct literature focusing on GOST optimizations specifically for ARM Cortex-M microcontrollers is limited, insights can be effectively extrapolated from studies targeting similar platforms or FPGA-based implementations. For example, FPGA-based research employing pipeline structures demonstrated considerable encryption speed enhancements by optimizing S-box storage through RAM packing. Applying these principles to STM32 software implementations could potentially lead to meaningful performance gains.

Furthermore, optimization techniques developed for resource-constrained 8-bit microcontrollers, as documented in the ResearchGate pre-print (2021), can be highly beneficial. The study’s use of a table-free S-box implementation via affine transformations significantly reduces flash memory usage by approximately 30%. Such techniques are directly applicable to STM32 devices, particularly the flash-limited STM32 F0 and F1 series, offering valuable guidance for balancing computational performance against memory constraints.

Additionally, practical implementations demonstrated on platforms like Wokwi provide straightforward, minimal code bases as effective starting points for custom optimizations. These minimal implementations serve as benchmarks for systematically introducing optimization techniques such as round pipelining and efficient barrel shifter utilization, which exploit the 32-bit architecture of STM32 microcontrollers. Specifically, the unrolling of cipher rounds into pairs has shown to reduce the total execution cycles significantly by maintaining data locality within CPU registers, thus enhancing performance notably.

Lastly, STMicroelectronics' X-CUBE-CRYPTOLIB presents a comprehensive, optimized cryptographic solution for STM32 microcontrollers. While explicit documentation of GOST inclusion requires confirmation, the library's structured framework offers built-in support for constant-time cryptographic implementations. Integrating and tuning this library for specific STM32 microcontroller variants could accelerate development efforts significantly, especially for applications requiring cryptographic certification or compliance with security standards.

In summary, incorporating FPGA-inspired pipeline optimizations, 8-bit microcontroller techniques, and leveraging the existing cryptographic library support from STMicroelectronics could substantially improve the efficiency of GOST 28147-89 implementations on STM32 platforms.

