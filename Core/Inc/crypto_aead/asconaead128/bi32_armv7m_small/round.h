#ifndef ROUND_H_
#define ROUND_H_

#include "ascon.h"
#include "constants.h"
#include "forceinline.h"
#include "printstate.h"
#include "word.h"

forceinline void ROUND_LOOP(ascon_state_t* s, const uint8_t* C,
                            const uint8_t* E) {
  uint32_t tmp0, tmp1;
  __asm__ __volatile__(
      "rbegin_%=:\n\t"
      /* --- Load round constant (aligned load of 16 bits) --- */
      "ldrh   %[tmp1], [%[C]], #2\n\t"       // Load 16-bit constant; post-increment pointer
      "ubfx   %[tmp0], %[tmp1], #8, #8\n\t"    // Extract high byte constant
      "and    %[tmp1], %[tmp1], #0xFF\n\t"     // Extract low byte constant

      /* --- Interleaved processing for low and high halves --- */
      /* Start by mixing x0 and x4 for both halves concurrently */
      "eor    %[x0_l], %[x0_l], %[x4_l]\n\t"    // Low: x0 ^= x4
      "eor    %[x0_h], %[x0_h], %[x4_h]\n\t"    // High: x0 ^= x4

      /* Process mixing x2 and x1 and inject constants in parallel */
      "eor    %[x2_l], %[x2_l], %[x1_l]\n\t"    // Low: x2 ^= x1
      "eor    %[x2_l], %[x2_l], %[tmp1]\n\t"    // Low: x2 ^= low-byte constant
      "eor    %[x2_h], %[x2_h], %[x1_h]\n\t"    // High: x2 ^= x1
      "eor    %[x2_h], %[x2_h], %[tmp0]\n\t"    // High: x2 ^= high-byte constant

      /* Now compute low-half intermediate values */
      "orn    %[tmp1], %[x4_l], %[x0_l]\n\t"     // Low: tmp1 = ~(x4_l) OR x0_l
      "bic    %[tmp1], %[x2_l], %[x1_l]\n\t"     // Low: tmp1 &= ~(x1_l)
      "eor    %[x0_l], %[x0_l], %[tmp1]\n\t"     // Low: update x0_l

      /* Compute high-half intermediate values concurrently */
      "orn    %[tmp0], %[x4_h], %[x0_h]\n\t"      // High: tmp0 = ~(x4_h) OR x0_h
      "bic    %[tmp1], %[x2_h], %[x1_h]\n\t"      // High: tmp1 = ~(x2_h) & ~(x1_h)
      "eor    %[x0_h], %[x0_h], %[tmp1]\n\t"      // High: update x0_h

      /* Continue low-half processing */
      "orn    %[tmp1], %[x3_l], %[x4_l]\n\t"     // Low: compute secondary temporary
      "eor    %[x2_l], %[x2_l], %[tmp1]\n\t"     // Low: update x2_l
      "bic    %[tmp1], %[x1_l], %[x0_l]\n\t"     // Low: further refine tmp1
      "eor    %[x4_l], %[x4_l], %[tmp1]\n\t"     // Low: update x4_l
      "and    %[tmp1], %[x3_l], %[x2_l]\n\t"     // Low: combine bits from x3_l and x2_l
      "eor    %[x1_l], %[x1_l], %[tmp1]\n\t"     // Low: update x1_l
      "eor    %[x3_l], %[x3_l], %[tmp0]\n\t"     // Low: inject high-byte constant into x3_l

      /* Continue high-half processing */
      "orn    %[tmp1], %[x3_h], %[x4_h]\n\t"      // High: compute secondary temporary
      "eor    %[x2_h], %[x2_h], %[tmp1]\n\t"      // High: update x2_h
      "bic    %[tmp1], %[x1_h], %[x0_h]\n\t"      // High: refine processing
      "eor    %[x4_h], %[x4_h], %[tmp1]\n\t"      // High: update x4_h
      "and    %[tmp1], %[x3_h], %[x2_h]\n\t"      // High: combine bits from x3_h and x2_h
      "eor    %[x1_h], %[x1_h], %[tmp1]\n\t"      // High: update x1_h
      "eor    %[x3_h], %[x3_h], %[tmp0]\n\t"      // High: finalize high-half processing

      /* --- Linear layer: rotations and further mixing --- */
      "eor    %[tmp0], %[x0_l], %[x0_h], ror #4\n\t"  // x0 mixing with rotation (#4)
      "eor    %[tmp1], %[x0_h], %[x0_l], ror #5\n\t"   // Alternate x0 mix (#5)
      "eor    %[x0_h], %[x0_h], %[tmp0], ror #10\n\t"  // Update x0_h (#10)
      "eor    %[x0_l], %[x0_l], %[tmp1], ror #9\n\t"   // Update x0_l (#9)

      "eor    %[tmp0], %[x1_l], %[x1_l], ror #11\n\t"  // x1 low rotation (#11)
      "eor    %[tmp1], %[x1_h], %[x1_h], ror #11\n\t"  // x1 high rotation (#11)
      "eor    %[x1_h], %[x1_h], %[tmp0], ror #20\n\t"  // Update x1_h (#20)
      "eor    %[x1_l], %[x1_l], %[tmp1], ror #19\n\t"  // Update x1_l (#19)

      "eor    %[tmp0], %[x2_l], %[x2_h], ror #2\n\t"   // x2 rotation (#2)
      "eor    %[tmp1], %[x2_h], %[x2_l], ror #3\n\t"   // x2 alternate rotation (#3)
      "eor    %[x2_h], %[x2_h], %[tmp0], ror #1\n\t"    // Update x2_h (#1)
      "eor    %[x2_l], %[x2_l], %[tmp1]\n\t"           // Update x2_l

      "eor    %[tmp0], %[x3_l], %[x3_h], ror #3\n\t"    // x3 rotation (#3)
      "eor    %[tmp1], %[x3_h], %[x3_l], ror #4\n\t"    // x3 alternate rotation (#4)
      "eor    %[x3_l], %[x3_l], %[tmp0], ror #5\n\t"    // Update x3_l (#5)
      "eor    %[x3_h], %[x3_h], %[tmp1], ror #5\n\t"    // Update x3_h (#5)

      "eor    %[tmp0], %[x4_l], %[x4_l], ror #17\n\t"   // x4 rotation (#17)
      "eor    %[tmp1], %[x4_h], %[x4_h], ror #17\n\t"   // x4 alternate rotation (#17)
      "eor    %[x4_h], %[x4_h], %[tmp0], ror #4\n\t"    // Update x4_h (#4)
      "eor    %[x4_l], %[x4_l], %[tmp1], ror #3\n\t"    // Update x4_l (#3)

      /* --- Loop control --- */
      "cmp    %[C], %[E]\n\t"         // Compare constant pointer with end address
      "bne    rbegin_%=\n\t"          // If not finished, loop back
      :
      [x0_l] "+r"(s->w[0][0]), [x0_h] "+r"(s->w[0][1]),
      [x1_l] "+r"(s->w[1][0]), [x1_h] "+r"(s->w[1][1]),
      [x2_l] "+r"(s->w[2][0]), [x2_h] "+r"(s->w[2][1]),
      [x3_l] "+r"(s->w[3][0]), [x3_h] "+r"(s->w[3][1]),
      [x4_l] "+r"(s->w[4][0]), [x4_h] "+r"(s->w[4][1]),
      [C] "+r"(C), [E] "+r"(E),
      [tmp0] "=r"(tmp0), [tmp1] "=r"(tmp1)
      :
      : "cc");
}


forceinline void ROUND(ascon_state_t* s, uint64_t C) {
  uint32_t tmp0, tmp1;
  __asm__ __volatile__(
      /* --- Process low half --- */
      "eor    %[x0_l], %[x0_l], %[x4_l]\n\t"
      "eor    %[x4_l], %[x4_l], %[x3_l]\n\t"
      "eor    %[x2_l], %[x2_l], %[x1_l]\n\t"
      "orn    %[tmp0], %[x4_l], %[x0_l]\n\t"
      "eor    %[x2_l], %[x2_l], %[C_e]\n\t"  // Inject lower 32 bits of constant
      "bic    %[tmp1], %[x2_l], %[x1_l]\n\t"
      "eor    %[x0_l], %[x0_l], %[tmp1]\n\t"
      "orn    %[tmp1], %[x3_l], %[x4_l]\n\t"
      "eor    %[x2_l], %[x2_l], %[tmp1]\n\t"
      "bic    %[tmp1], %[x1_l], %[x0_l]\n\t"
      "eor    %[x4_l], %[x4_l], %[tmp1]\n\t"
      "and    %[tmp1], %[x3_l], %[x2_l]\n\t"
      "eor    %[x1_l], %[x1_l], %[tmp1]\n\t"
      "eor    %[x3_l], %[x3_l], %[tmp0]\n\t"
      
      /* --- Process high half --- */
      "eor    %[x0_h], %[x0_h], %[x4_h]\n\t"
      "eor    %[x4_h], %[x4_h], %[x3_h]\n\t"
      "eor    %[x2_h], %[x2_h], %[C_o]\n\t"  // Inject higher 32 bits of constant
      "eor    %[x2_h], %[x2_h], %[x1_h]\n\t"
      "orn    %[tmp0], %[x4_h], %[x0_h]\n\t"
      "bic    %[tmp1], %[x2_h], %[x1_h]\n\t"
      "eor    %[x0_h], %[x0_h], %[tmp1]\n\t"
      "orn    %[tmp1], %[x3_h], %[x4_h]\n\t"
      "eor    %[x2_h], %[x2_h], %[tmp1]\n\t"
      "bic    %[tmp1], %[x1_h], %[x0_h]\n\t"
      "eor    %[x4_h], %[x4_h], %[tmp1]\n\t"
      "and    %[tmp0], %[x3_h], %[x2_h]\n\t"
      "eor    %[x1_h], %[x1_h], %[tmp0]\n\t"
      "eor    %[x3_h], %[x3_h], %[tmp0]\n\t"  // Extra mixing for scheduling
      
      /* --- Linear layer (same as in ROUND_LOOP) --- */
      "eor    %[tmp0], %[x0_l], %[x0_h], ror #4\n\t"
      "eor    %[tmp1], %[x0_h], %[x0_l], ror #5\n\t"
      "eor    %[x0_h], %[x0_h], %[tmp0], ror #10\n\t"
      "eor    %[x0_l], %[x0_l], %[tmp1], ror #9\n\t"
      
      "eor    %[tmp0], %[x1_l], %[x1_l], ror #11\n\t"
      "eor    %[tmp1], %[x1_h], %[x1_h], ror #11\n\t"
      "eor    %[x1_h], %[x1_h], %[tmp0], ror #20\n\t"
      "eor    %[x1_l], %[x1_l], %[tmp1], ror #19\n\t"
      
      "eor    %[tmp0], %[x2_l], %[x2_h], ror #2\n\t"
      "eor    %[tmp1], %[x2_h], %[x2_l], ror #3\n\t"
      "eor    %[x2_h], %[x2_h], %[tmp0], ror #1\n\t"
      "eor    %[x2_l], %[x2_l], %[tmp1]\n\t"
      
      "eor    %[tmp0], %[x3_l], %[x3_h], ror #3\n\t"
      "eor    %[tmp1], %[x3_h], %[x3_l], ror #4\n\t"
      "eor    %[x3_l], %[x3_l], %[tmp0], ror #5\n\t"
      "eor    %[x3_h], %[x3_h], %[tmp1], ror #5\n\t"
      
      "eor    %[tmp0], %[x4_l], %[x4_l], ror #17\n\t"
      "eor    %[tmp1], %[x4_h], %[x4_h], ror #17\n\t"
      "eor    %[x4_h], %[x4_h], %[tmp0], ror #4\n\t"
      "eor    %[x4_l], %[x4_l], %[tmp1], ror #3\n\t"
      :
      [x0_l] "+r"(s->w[0][0]), [x0_h] "+r"(s->w[0][1]),
      [x1_l] "+r"(s->w[1][0]), [x1_h] "+r"(s->w[1][1]),
      [x2_l] "+r"(s->w[2][0]), [x2_h] "+r"(s->w[2][1]),
      [x3_l] "+r"(s->w[3][0]), [x3_h] "+r"(s->w[3][1]),
      [x4_l] "+r"(s->w[4][0]), [x4_h] "+r"(s->w[4][1]),
      [tmp0] "=r"(tmp0), [tmp1] "=r"(tmp1)
      : [C_e] "i"((uint32_t)C), [C_o] "i"((uint32_t)(C >> 32))
      :);
}

#define ROUND5(x0, x1, x2, x3, x4, C)                                       \
  do {                                                                      \
    uint32_t tmp0, tmp1, tmp2;                                              \
    /* Optimized ROUND5 for STM32: reordered instructions for better pipelining */ \
    __asm__ __volatile__(                                                   \
        "eor %[x2_l], %[x2_l], %[C_e]\n\t"                                  \
        "eor %[tmp0], %[x1_l], %[x2_l]\n\t"                                 \
        "eor %[tmp1], %[x0_l], %[x4_l]\n\t"                                 \
        "eor %[tmp2], %[x3_l], %[x4_l]\n\t"                                 \
        "orn %[x4_l], %[x3_l], %[x4_l]\n\t"                                 \
        "eor %[x4_l], %[x4_l], %[tmp0]\n\t"                                 \
        "eor %[x3_l], %[x3_l], %[x1_l]\n\t"                                 \
        "orr %[x3_l], %[x3_l], %[tmp0]\n\t"                                 \
        "eor %[x3_l], %[x3_l], %[tmp1]\n\t"                                 \
        "eor %[x2_l], %[x2_l], %[tmp1]\n\t"                                 \
        "orr %[x2_l], %[x2_l], %[x1_l]\n\t"                                 \
        "eor %[x2_l], %[x2_l], %[tmp2]\n\t"                                 \
        "bic %[x1_l], %[x1_l], %[tmp1]\n\t"                                 \
        "eor %[x1_l], %[x1_l], %[tmp2]\n\t"                                 \
        "orr %[x0_l], %[x0_l], %[tmp2]\n\t"                                 \
        "eor %[x0_l], %[x0_l], %[tmp0]\n\t"                                 \
        "eor %[x2_h], %[x2_h], %[C_o]\n\t"                                  \
        "eor %[tmp0], %[x1_h], %[x2_h]\n\t"                                 \
        "eor %[tmp1], %[x0_h], %[x4_h]\n\t"                                 \
        "eor %[tmp2], %[x3_h], %[x4_h]\n\t"                                 \
        "orn %[x4_h], %[x3_h], %[x4_h]\n\t"                                 \
        "eor %[x4_h], %[x4_h], %[tmp0]\n\t"                                 \
        "eor %[x3_h], %[x3_h], %[x1_h]\n\t"                                 \
        "orr %[x3_h], %[x3_h], %[tmp0]\n\t"                                 \
        "eor %[x3_h], %[x3_h], %[tmp1]\n\t"                                 \
        "eor %[x2_h], %[x2_h], %[tmp1]\n\t"                                 \
        "orr %[x2_h], %[x2_h], %[x1_h]\n\t"                                 \
        "eor %[x2_h], %[x2_h], %[tmp2]\n\t"                                 \
        "bic %[x1_h], %[x1_h], %[tmp1]\n\t"                                 \
        "eor %[x1_h], %[x1_h], %[tmp2]\n\t"                                 \
        "orr %[x0_h], %[x0_h], %[tmp2]\n\t"                                 \
        "eor %[x0_h], %[x0_h], %[tmp0]\n\t"                                 \
        "eor %[tmp0], %[x2_l], %[x2_h], ror #4\n\t"                         \
        "eor %[tmp1], %[x2_h], %[x2_l], ror #5\n\t"                         \
        "eor %[x2_h], %[x2_h], %[tmp0], ror #10\n\t"                        \
        "eor %[x2_l], %[x2_l], %[tmp1], ror #9\n\t"                         \
        "eor %[tmp0], %[x3_l], %[x3_l], ror #11\n\t"                        \
        "eor %[tmp1], %[x3_h], %[x3_h], ror #11\n\t"                        \
        "eor %[x3_h], %[x3_h], %[tmp0], ror #20\n\t"                        \
        "eor %[x3_l], %[x3_l], %[tmp1], ror #19\n\t"                        \
        "eor %[tmp0], %[x4_l], %[x4_h], ror #2\n\t"                         \
        "eor %[tmp1], %[x4_h], %[x4_l], ror #3\n\t"                         \
        "eor %[x4_h], %[x4_h], %[tmp0], ror #1\n\t"                         \
        "eor %[x4_l], %[x4_l], %[tmp1]\n\t"                                 \
        "eor %[tmp0], %[x0_l], %[x0_h], ror #3\n\t"                         \
        "eor %[tmp1], %[x0_h], %[x0_l], ror #4\n\t"                         \
        "eor %[x0_l], %[x0_l], %[tmp0], ror #5\n\t"                         \
        "eor %[x0_h], %[x0_h], %[tmp1], ror #5\n\t"                         \
        "eor %[tmp0], %[x1_l], %[x1_l], ror #17\n\t"                        \
        "eor %[tmp1], %[x1_h], %[x1_h], ror #17\n\t"                        \
        "eor %[x1_h], %[x1_h], %[tmp0], ror #4\n\t"                         \
        "eor %[x1_l], %[x1_l], %[tmp1], ror #3\n\t"                         \
        : [x0_l] "+r"(x0.w[0]), [x0_h] "+r"(x0.w[1]), [x1_l] "+r"(x1.w[0]), \
          [x1_h] "+r"(x1.w[1]), [x2_l] "+r"(x2.w[0]), [x2_h] "+r"(x2.w[1]), \
          [x3_l] "+r"(x3.w[0]), [x3_h] "+r"(x3.w[1]), [x4_l] "+r"(x4.w[0]), \
          [x4_h] "+r"(x4.w[1]), [tmp0] "=r"(tmp0), [tmp1] "=r"(tmp1),       \
          [tmp2] "=r"(tmp2)                                                 \
        : [C_e] "i"((uint32_t)C), [C_o] "i"((uint32_t)(C >> 32))            \
        :);                                                                 \
  } while (0)

forceinline void PROUNDS(ascon_state_t* s, int nr) {
  ROUND_LOOP(s, constants + START(nr), constants + 24);
}

#endif /* ROUND_H_ */