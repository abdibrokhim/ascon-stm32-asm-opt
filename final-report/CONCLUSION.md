# Code Optimization for STM32F103/STM32F407 Discovery Boards – Time and Memory Analysis

## Conclusion

## DRAFT ##

In conclusion, the security of GOST 28147-89, when used with an appropriate S-box set, remains strong for practical use – certainly in the context of symmetric key encryption it is not the weak link (keys of 256 bits and no feasible cryptanalytic attack). However, from an academic perspective, the cipher is not as over-designed as one might think from just counting key size and rounds; it has quirks that skilled cryptanalysts have learned to exploit in theory. The lessons from cryptanalysis of GOST contributed to the design of its successors, ensuring that new designs would avoid such pitfalls (for example, by using more complex key schedules or larger block sizes).

GOST 28147-89 stands as a significant piece of cryptographic history and practice. Technically, it is a 32-round Feistel network with a 256-bit key and 64-bit block size, using modular addition, rotation, and S-box substitutions to achieve confusion and diffusion. Its flexible S-box approach and simple key schedule reflect design philosophies of its time – emphasizing certain security margins and practical implementation considerations, possibly influenced by the need for adaptability and secrecy. Over the years, it has been rigorously tested by cryptanalysts; while some theoretical weaknesses have been exposed, it remains a robust cipher for real-world use when properly implemented. The algorithm’s inclusion of a MAC generation method also highlights an integrated approach to data security (confidentiality and integrity together) that was ahead of its time. In an academic context, GOST 28147-89 offers lessons in cipher design: it demonstrates how more rounds and key bits can extend security, but also how structural simplicity can invite innovative attacks if not carefully vetted. Comparisons with its contemporary (DES) underline how two ciphers with similar frameworks can have very different security postures due to parameter choices. The transition to the Magma and Kuznechik standards in recent years shows the natural evolution of cryptographic standards in response to new requirements and analysis. In summary, GOST 28147-89 is both a historically important cipher and a technically intriguing one. It bridged the gap between the era of DES and the era of AES in its own domain, and it continues to be relevant both in applied cryptography within its sphere of influence and as a subject of academic study in cryptanalysis. As cryptography advances, the story of GOST 28147-89 – from secret Soviet algorithm to globally analyzed cipher, and its eventual succession by newer designs – remains a rich case study in the lifecycle of a cryptographic algorithm. References: The information presented is based on the official GOST 28147-89 specification (English summary in RFC 5830)​
datatracker.ietf.org
​
datatracker.ietf.org
, historical accounts of its development​
en.wikipedia.org
, technical descriptions of its operation​
datatracker.ietf.org
​
datatracker.ietf.org
, and published cryptanalysis results​
en.wikipedia.org
, as well as updates from the 2015 revision of the standard​
en.wikipedia.org
.