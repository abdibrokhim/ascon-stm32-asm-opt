# Code Optimization for STM32F103/STM32F407 Discovery Boards – Time and Memory Analysis

## Discussion


### What Are the Trade-Offs?

Optimizations introduce trade-offs that are worth exploring in your thesis:

- **Code Complexity:** Inline assembly and bit-interleaving make the code harder to read and maintain, requiring expertise in ARM assembly.
- **Code Size:** While version [4] is labeled “small,” bit-interleaving may increase code size slightly. The ASCON C implementation repository ([ASCON C](https://github.com/ascon/ascon-c)) reports `bi32_armv7m_small` at 1090 bytes for ASCON-AEAD128, compared to 1162 bytes for `armv6m_lowsize`, suggesting a modest size trade-off.
- **Portability:** The optimized version is less portable, as it relies on ARM-specific instructions, unlike the pure C version [1].

### Are There Security Implications?

The optimizations are implementation-level changes and do not alter ASCON’s cryptographic properties. ASCON’s design includes natural resistance to side-channel attacks due to its low-degree S-box, and bit-interleaving does not introduce new vulnerabilities if implemented correctly ([Journal of Cryptology](https://link.springer.com/article/10.1007/s00145-021-09398-7)). However, you should emphasize the need to verify the assembly code to prevent errors that could lead to side-channel leaks, such as timing attacks.

### Can These Techniques Apply Elsewhere?

The optimization strategies are broadly applicable:

- **Bit-Interleaving:** Useful for other lightweight ciphers like PRESENT or SIMON, enabling bitsliced implementations on 32-bit platforms ([Bit Twiddling](https://graphics.stanford.edu/~seander/bithacks.html)).
- **Instruction Scheduling:** Interleaving operations to reduce pipeline stalls can optimize any algorithm with parallelizable computations.
- **Efficient Data Loading:** Loading larger data chunks benefits algorithms with frequent constant accesses, such as AES or ChaCha.

### What About Power Consumption?

While my experiments focused on execution time, power consumption is critical for IoT devices. Faster execution could reduce energy use by allowing the microcontroller to enter low-power modes sooner. Future work could measure power consumption using tools like the STM32 Power Shield, providing a more holistic view of optimization impacts.

### How Does This Fit into IoT Security?

ASCON’s selection as NIST’s lightweight cryptography standard underscores its importance for IoT security. My optimizations make ASCON faster on STM32 microcontrollers, enabling secure communication in applications like smart homes, wearables, and industrial sensors. This aligns with the growing demand for efficient, secure cryptography in resource-constrained environments.

## Future Research Directions

Your thesis can propose several avenues for further exploration:

- **Testing Across STM32 Variants:** Evaluate the optimized implementation on different STM32 series (e.g., STM32F0 with Cortex-M0 vs. STM32F4 with Cortex-M4) to assess performance variations.
- **Energy Efficiency:** Measure power consumption to quantify energy savings, critical for battery-powered IoT devices.
- **Comparison with Other Ciphers:** Benchmark ASCON against other NIST candidates, like Grain-128AEAD, to highlight its advantages on STM32 platforms.
- **Full Unrolling and DSP Extensions:** Explore loop unrolling or Cortex-M4 DSP instructions to further reduce execution time, as suggested in the optimization notes.