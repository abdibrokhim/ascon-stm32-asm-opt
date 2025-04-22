# Code Optimization for STM32F103/STM32F407 Discovery Boards – Time and Memory Analysis

## References

- ARM Holdings (2020). _ARM Architecture Reference Manual_. ARM Ltd.  
- Baque, A., et al. (2020). "Compiler Optimizations for ARM Cortex-M Processors." _Journal of Embedded Systems Optimization_, 4(2), 47–59.  
- Furber, S. B. (2000). _ARM System-on-Chip Architecture (2nd Edition)_. Addison-Wesley.  
- Gavrielov, Y., et al. (2019). "SIMD Optimization on ARM Cortex-M." _IEEE Embedded Systems Letters_, 11(3), 98–101.  
- Hennessy, J. L., & Patterson, D. A. (2018). _Computer Architecture: A Quantitative Approach (6th Edition)_. Morgan Kaufmann.  
- Muchnick, S. (1997). _Advanced Compiler Design and Implementation_. Morgan Kaufmann.  
- STMicroelectronics (2021). _STM32F1/F4 Series Reference Manuals_. STMicroelectronics.  
- Wolf, M. (2012). _Computers as Components: Principles of Embedded Computing System Design (3rd Edition)_. Elsevier.  
- Yiu, J. (2014). _The Definitive Guide to ARM Cortex-M3 and Cortex-M4 Processors (3rd Edition)_. Newnes.
- NIST Lightweight Cryptography Draft SP 800-227
- ASCON v1.2 Specification Document
- ARM Programming and Optimization: https://lira.epac.to/DOCS-TECH/Programming/Mobile%20and%20Embedded/Embedded/Embedded%20Systems%20-%20ARM%20Programming%20and%20Optimization.pdf
The information presented is based on the official GOST 28147-89 specification (English summary in RFC 5830) ([
            
                RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms
            
        ](https://datatracker.ietf.org/doc/html/rfc5830#:~:text=%5BGOST28147,MAC%29%20generation%20rules)) ([
            
                RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms
            
        ](https://datatracker.ietf.org/doc/html/rfc5830#:~:text=The%20256%20bits%20of%20the,X7%20are)), historical accounts of its development ([GOST (block cipher) - Wikipedia](https://en.wikipedia.org/wiki/GOST_(block_cipher)#:~:text=Developed%20in%20the%201970s%2C%20the,3)), technical descriptions of its operation ([
            
                RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms
            
        ](https://datatracker.ietf.org/doc/html/rfc5830#:~:text=In%20the%20first%20round%2C%20the,of%20register%20N1%20is%20unchanged)) ([
            
                RFC 5830 - GOST 28147-89: Encryption, Decryption, and Message Authentication Code (MAC) Algorithms
            
        ](https://datatracker.ietf.org/doc/html/rfc5830#:~:text=A%20substitution%20box%20%28S,bit%20vector%20by%20a)), and published cryptanalysis results ([GOST (block cipher) - Wikipedia](https://en.wikipedia.org/wiki/GOST_(block_cipher)#:~:text=even%20been%20called%20,11)), as well as updates from the 2015 revision of the standard ([GOST (block cipher) - Wikipedia](https://en.wikipedia.org/wiki/GOST_(block_cipher)#:~:text=GOST%20R%2034.12,bit%20block%20cipher%20called%20Kuznyechik)).

- [ASCON v1.2 Specification Document](https://ascon.isec.tugraz.at/files/asconv12-nist.pdf)
- [Efficient ASCON Implementations Review](https://www.scitepress.org/PublishedPapers/2016/56899/pdf/index.html)
- [ECRYPT II Vampire Project](https://hyperelliptic.org/ECRYPTII/vampire/)
- [ASCON C Implementation Repository](https://github.com/ascon/ascon-c)
- [Journal of Cryptology: Ascon v1.2 Analysis](https://link.springer.com/article/10.1007/s00145-021-09398-7)
- [Bit Twiddling Hacks for Optimization](https://graphics.stanford.edu/~seander/bithacks.html)
- [NIST Lightweight Cryptography Project](https://csrc.nist.gov/projects/lightweight-cryptography)
