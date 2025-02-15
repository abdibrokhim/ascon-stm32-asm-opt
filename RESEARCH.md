[Question]:
If I implement everything in pure ASM. will It be faster compare to other all implementations? How much it could be faster? Why ? Why not? I have provided repo below for "bi32_armv7m_small (32-bit small bit-interleaved for ARMv7-M/ARMv8/ARMv9):".

given the repo: "https://github.com/ascon/ascon-c/tree/main/crypto_aead/asconaead128/bi32_armv7m_small".

[Answer]:
Implementing the algorithm entirely in pure assembly could yield some speed improvements—but the gains are likely to be incremental rather than dramatic. Here’s why:

### Potential Advantages of Pure Assembly

- **Fine-Grained Control:**  
  Writing everything in assembly gives you complete control over instruction selection, register allocation, and scheduling. This can allow you to eliminate any residual overhead that might still exist in a C function even with inline assembly. For instance, you can tightly optimize inner loops, reduce branching penalties, and better align with the STM32’s microarchitecture.

- **Removal of Compiler Overhead:**  
  Even with inline assembly, the surrounding C code may introduce overhead (such as calling conventions or less-than-optimal register usage) that a pure ASM implementation can avoid.

### Likely Performance Improvements

- **Marginal Gains:**  
  The repository for the *bi32_armv7m_small* version (which already uses inline assembly in C) shows a highly optimized implementation. When parts of the critical code are already in assembly, the pure ASM version might only squeeze out an extra 5–10% improvement at best. This is because most of the performance-critical paths are already hand-optimized.

- **Diminishing Returns:**  
  Modern compilers are very good at optimizing C code, and when you combine that with well-crafted inline assembly, much of the potential improvement is already realized. Therefore, rewriting the entire code in pure ASM might not provide a dramatic speedup compared to these optimized mixed implementations.

### Practical Considerations

- **Development and Maintenance:**  
  Pure assembly code tends to be harder to write, understand, and maintain. The risk of subtle bugs increases, and the code becomes less portable. The mixed approach (C with inline ASM) strikes a balance between performance and maintainability.

- **Portability:**  
  A pure ASM implementation is generally tailored to a specific architecture (in this case, ARMv7-M/ARMv8/ARMv9), whereas the mixed version can often be more easily adapted or integrated with other C codebases.

### Conclusion

In summary, while a pure ASM implementation can theoretically be faster due to complete control over hardware-specific optimizations, in practice the gain might be modest—on the order of 5–10% over the current *bi32_armv7m_small* implementation. The existing inline assembly version already captures most of the low-level optimization benefits, so further speed improvements are likely to come with increased complexity and reduced portability.

For a deeper look into how these optimizations are structured, you can explore the [bi32_armv7m_small repository](https://github.com/ascon/ascon-c/tree/main/crypto_aead/asconaead128/bi32_armv7m_small) which demonstrates the current hybrid approach.