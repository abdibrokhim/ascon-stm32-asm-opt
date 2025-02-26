probably draft

15 Feb 2025

today i spent my whole day for ascon. so... few results from todays experiments: 

original: [4]: bi32_armv7m_small: 32-bit small bit-interleaved ARMv7-M, ARMv8, ARMv9. time; took 10:57 seconds. (c and inline asm implementation)

exp 1: time: 10:44 seconds. (1.98% faster than [4])

exp 2: time: 09:56 seconds. (9.28% faster than [4])

exp 3: time: 09:44 seconds. (11.11% faster than [4])

## configurations

calling `ROUND_LOOP`.

`config.h`
```c
#ifndef CONFIG_H_
#define CONFIG_H_

/* inline the ascon mode */
#ifndef ASCON_INLINE_MODE
#define ASCON_INLINE_MODE 1
#endif

/* inline all permutations */
#ifndef ASCON_INLINE_PERM
#define ASCON_INLINE_PERM 0
#endif

/* unroll permutation loops */
#ifndef ASCON_UNROLL_LOOPS
#define ASCON_UNROLL_LOOPS 0
#endif

/* inline bitinterleaving */
#ifndef ASCON_INLINE_BI
#define ASCON_INLINE_BI 0
#endif

/* extern bitinterleaving */
#ifndef ASCON_EXTERN_BI
#define ASCON_EXTERN_BI 0
#endif

#endif /* CONFIG_H_ */
```

`api.h`
```c
#define CRYPTO_VERSION "1.3.0"
#define CRYPTO_KEYBYTES 16
#define CRYPTO_NSECBYTES 0
#define CRYPTO_NPUBBYTES 16
#define CRYPTO_ABYTES 16
#define CRYPTO_NOOVERLAP 1
#define ASCON_AEAD_RATE 16
#define ASCON_VARIANT 1
```