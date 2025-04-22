# # Code Optimization for STM32F103/STM32F407 Discovery Boards – Time and Memory Analysis

## Appendices

### Appendix A

bubble_sort_asm.s

```s
.text
.global _bubble_sort_asm
.global bubble_sort_asm

_bubble_sort_asm:
bubble_sort_asm:
    sub w1, w1, #1       // r1 = N-1
    mov w5, #0           // i = 0 
oloop:
    cmp w5, w1           // if i == N-1 ?
    beq exito            // yes, end
    mov w3, #0           // j = 0
    mov x2, x0           // x2 = &data (must use 64-bit register for address)

iloop:
    cmp w3, w1           // if j == N-1 ?
    beq exiti            // yes, next i
    ldr w11, [x2]        // Load data[j]
    ldr w10, [x2, #4]    // Load data[j+1]
    cmp w11, w10         // if data[j] > data[j+1]
    ble skip             // skip if not greater
    
    // Swap data[j] and data[j+1]
    str w10, [x2]        // data[j] = data[j+1]
    str w11, [x2, #4]    // data[j+1] = data[j]

skip:
    add w3, w3, #1       // j++
    add x2, x2, #4       // Move to next element
    cmp w3, w1           // Check if j == N-1
    blt iloop            // Continue inner loop if j < N-1

exiti:
    add w5, w5, #1       // i++
    b oloop

exito:
    mov w0, #1
    ret
```
### Appendix B

bubble_sort.c

```c
void bubble_sort (int* data, int n) {
    for (int i=0;i<(n-1);i++) {
        for (int j=0;j<(n-1);j++) {
            if (data[j]>data[j+1]) {
                int temp=data[j];
                data[j]=data[j+1];
                data[j+1]=temp;
            }
        }
    }
}
```

### Appendix C

bubble_sort_asm.s

```s
.text
.global _bubble_sort_asm
.global bubble_sort_asm

_bubble_sort_asm:
bubble_sort_asm:
    // r0 = data pointer, r1 = n
    subs w1, w1, #1       // r1 = N-1
    b.le exito            // if N <= 1, we're done
    
    mov w8, w1            // w8 = N-1 (preserve original N-1)
    mov w5, #0           // i = 0 
    
oloop:
    mov x2, x0           // x2 = &data
    mov w3, #0           // j = 0
    mov w9, w8           // w9 = N-1-i (elements to compare)
    sub w9, w9, w5       // subtract i from the limit
    
iloop:
    ldr w11, [x2]        // Load data[j]
    ldr w10, [x2, #4]    // Load data[j+1]
    cmp w11, w10         // if data[j] > data[j+1]
    b.le skip            // skip if not greater
    
    // Swap data[j] and data[j+1] - do this in one step
    str w10, [x2]        // data[j] = data[j+1]
    str w11, [x2, #4]    // data[j+1] = data[j]

skip:
    add x2, x2, #4       // Move to next element
    add w3, w3, #1       // j++
    cmp w3, w9           // Check if j < N-1-i (we only need to check up to this point)
    b.lt iloop           // Continue inner loop if j < limit
    
    add w5, w5, #1       // i++
    cmp w5, w8           // Check if i < N-1
    b.lt oloop           // Continue outer loop if i < N-1

exito:
    mov w0, #1
    ret
```

### Appendix D

bubble_sort_optimized.c

```c
// Optimized bubble sort with C‑level optimizations
// Recommended compile flags:
// gcc -O3 -march=native -funroll-loops -flto -o bubble_sort_optimized bubble_sort_optimized.c

#include <stdbool.h>

void bubble_sort_optimized(int * restrict data, int n) {
    bool swapped;
    for (int i = 0; i < n - 1; ++i) {
        swapped = false;
        int limit = n - i - 1;
        int j = 0;

        // Unroll inner loop by 4 iterations to reduce loop overhead
        for (; j + 4 <= limit; j += 4) {
            if (data[j] > data[j + 1]) {
                int tmp = data[j]; data[j] = data[j + 1]; data[j + 1] = tmp; swapped = true;
            }
            if (data[j + 1] > data[j + 2]) {
                int tmp = data[j + 1]; data[j + 1] = data[j + 2]; data[j + 2] = tmp; swapped = true;
            }
            if (data[j + 2] > data[j + 3]) {
                int tmp = data[j + 2]; data[j + 2] = data[j + 3]; data[j + 3] = tmp; swapped = true;
            }
            if (data[j + 3] > data[j + 4]) {
                int tmp = data[j + 3]; data[j + 3] = data[j + 4]; data[j + 4] = tmp; swapped = true;
            }
        }
        // Handle remaining elements
        for (; j < limit; ++j) {
            if (data[j] > data[j + 1]) {
                int tmp = data[j]; data[j] = data[j + 1]; data[j + 1] = tmp; swapped = true;
            }
        }

        // Early exit if already sorted
        if (!swapped) {
            break;
        }
    }
}
```

### Appendix E

driver.c

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 32768

void bubble_sort(int *data, int n);
int bubble_sort_asm(int *data, int n);

int main() {
    int *data1, *data2;
    clock_t start, end;
    double c_time, asm_time;

    data1 = (int *)malloc(N * sizeof(int));
    data2 = (int *)malloc(N * sizeof(int));

    if (!data1 || !data2) {
        fprintf(stderr, "Memory allocation failed\n");
        return 1;
    }

    srand(11);

    for (int i = 0; i < N; i++) data1[i] = data2[i] = rand();

    // Measure C version performance
    start = clock();
    bubble_sort(data1, N);
    end = clock();
    c_time = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("C bubble sort time: %f seconds\n", c_time);

    // Measure ASM version performance
    start = clock();
    bubble_sort_asm(data2, N);
    end = clock();
    asm_time = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("Assembly bubble sort time: %f seconds\n", asm_time);
    printf("Performance improvement: %f%%\n", (c_time - asm_time) / c_time * 100);

    // Verify correctness
    for (int i = 0; i < N; i++) {
        if (data1[i] != data2[i]) {
            fprintf(stderr, "Mismatch at index %d: %d != %d\n", i, data1[i], data2[i]);
            free(data1);
            free(data2);
            return 1;
        }
    }
    
    printf("Verification successful: both implementations produce identical results\n");
    free(data1);
    free(data2);
    return 0;
}
```

Run the code:

```bash
gcc -O3 driver.c bubble_sort.c bubble_sort_asm.s -o bubble_sort_benchmark && ./bubble_sort_benchmark
C bubble sort time: 1.016151 seconds
Assembly bubble sort time: 0.985726 seconds
Performance improvement: 2.994142%
Verification successful: both implementations produce identical results
```

### Appendix F

ascon_aead128_basic_impl.c

```c
/*
 * Baseline Implementation of ASCON-AEAD128
 * Follows the NIST Lightweight Cryptography draft (2023) without associated data
 * Assumes plaintext length is a multiple of 16 bytes (128 bits)
 * Educational clarity for embedded platforms (e.g., STM32)
 */

#include <stdio.h>
#include <stdint.h>
#include <stddef.h>

// State, key, nonce, and tag types
typedef uint64_t state_t[5];
typedef uint64_t key_t[2];
typedef uint64_t nonce_t[2];
typedef uint64_t tag_t[2];

// Fixed IV for ASCON-AEAD128 (0x80400c0600000000)
static const uint64_t IV = 0x80400c0600000000ULL;

// Round constants
static const uint8_t constants[16] = {
    0xf0, 0xe1, 0xd2, 0xc3, 0xb4, 0xa5, 0x96, 0x87,
    0x78, 0x69, 0x5a, 0x4b, 0x3c, 0x2d, 0x1e, 0x0f
};

// Rotate right
static inline uint64_t rotr(uint64_t x, int n) {
    return (x >> n) | (x << (64 - n));
}

// Substitution layer (S-box)
static void sbox(state_t s) {
    s[0] ^= s[4]; s[4] ^= s[3]; s[2] ^= s[1];
    uint64_t t0 = s[0], t1 = s[1], t2 = s[2], t3 = s[3], t4 = s[4];
    s[0] = t0 ^ (~t1 & t2);
    s[1] = t1 ^ (~t2 & t3);
    s[2] = t2 ^ (~t3 & t4);
    s[3] = t3 ^ (~t4 & t0);
    s[4] = t4 ^ (~t0 & t1);
    s[1] ^= s[0]; s[3] ^= s[2]; s[0] ^= s[4];
}

// Linear diffusion layer
static void linear_diffusion(state_t s) {
    s[0] ^= rotr(s[0], 19) ^ rotr(s[0], 28);
    s[1] ^= rotr(s[1], 61) ^ rotr(s[1], 39);
    s[2] ^= rotr(s[2], 1)  ^ rotr(s[2], 6);
    s[3] ^= rotr(s[3], 10) ^ rotr(s[3], 17);
    s[4] ^= rotr(s[4], 7)  ^ rotr(s[4], 41);
}

// Permutation: applies 'rounds' rounds starting at 'start_round'
static void permutation(state_t s, int rounds, int start_round) {
    for (int i = 0; i < rounds; i++) {
        // Add constant
        s[2] ^= constants[16 - rounds + start_round + i];
        // Nonlinear and diffusion layers
        sbox(s);
        linear_diffusion(s);
    }
}

// Print state (for debugging)
void print_state(const state_t s) {
    for (int i = 0; i < 5; i++) {
        printf("%016llx ", (unsigned long long)s[i]);
    }
    printf("\n");
}

// ASCON-AEAD128 encryption (no associated data)
// plaintext and ciphertext are arrays of uint64_t words (2 words per 128-bit block)
void ascon_aead128_encrypt(
    const key_t key,
    const nonce_t nonce,
    const uint64_t *plaintext,
    size_t plaintext_len_bytes,
    uint64_t *ciphertext,
    tag_t tag
) {
    // Number of 128-bit blocks
    size_t num_blocks = plaintext_len_bytes / 16;

    // State
    state_t s;

    // === Initialization ===
    s[0] = IV;
    s[1] = key[0];
    s[2] = key[1];
    s[3] = nonce[0];
    s[4] = nonce[1];
    permutation(s, 12, 0);
    s[3] ^= key[0];
    s[4] ^= key[1];

    // === Encryption ===
    for (size_t i = 0; i < num_blocks; i++) {
        // XOR plaintext into rate
        s[0] ^= plaintext[2*i];
        s[1] ^= plaintext[2*i + 1];
        // Output ciphertext
        ciphertext[2*i] = s[0];
        ciphertext[2*i + 1] = s[1];
        // Permute
        permutation(s, 8, 0);
    }

    // === Finalization ===
    s[1] ^= key[0];
    s[2] ^= key[1];
    permutation(s, 12, 0);
    tag[0] = s[3] ^ key[0];
    tag[1] = s[4] ^ key[1];
}

// Example usage
int main(void) {
    key_t key = {0x0001020304050607ULL, 0x08090a0b0c0d0e0fULL};
    nonce_t nonce = {0x0011223344556677ULL, 0x8899aabbccddeeffULL};
    uint64_t plaintext[] = {0x1122334455667788ULL, 0x99aabbccddeeff00ULL}; // 16 bytes
    uint64_t ciphertext[2];
    tag_t tag;

    printf("=== State at Start ===\n");
    state_t tmp = {0}; // dummy
    print_state(tmp);

    ascon_aead128_encrypt(key, nonce, plaintext, sizeof(plaintext), ciphertext, tag);

    printf("Ciphertext: %016llx %016llx\n", (unsigned long long)ciphertext[0], (unsigned long long)ciphertext[1]);
    printf("Tag:        %016llx %016llx\n", (unsigned long long)tag[0], (unsigned long long)tag[1]);
    return 0;
}
```

Run the code:

```bash
gcc -O3 ascon_aead128_basic_impl.c -o ascon_aead128_basic_impl && ./ascon_aead128_basic_impl
=== State at Start ===
0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000
Ciphertext: 80400c0600000000 0000000000000000
Tag:        80400c0600000000 0000000000000000
```

### Appendix G

gost-basic-impl.c

```c
#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include <stdio.h>
#define DEMO

// Default CryptoPro S-boxes (RFC 4357)
static const uint8_t SBOX[8][16] = {
    {4,10,9,2,13,8,0,14,6,11,1,12,7,15,5,3},
    {14,11,4,12,6,13,15,10,2,3,8,1,0,7,5,9},
    {5,8,1,13,10,3,4,2,14,15,12,7,6,0,9,11},
    {7,13,10,1,0,8,9,15,14,4,6,12,11,2,5,3},
    {6,12,7,1,5,15,13,8,4,10,9,14,0,3,11,2},
    {4,11,10,0,7,2,1,13,3,6,8,5,9,12,15,14},
    {13,11,4,1,3,15,5,9,0,10,14,7,6,8,2,12},
    {1,15,13,0,5,7,10,4,9,2,3,14,6,11,8,12}
};

// Rotate left 32-bit
static inline uint32_t rotl32(uint32_t x, unsigned n) {
    return (x << n) | (x >> (32 - n));
}

// Load/store little-endian 32-bit
static inline uint32_t load_le32(const uint8_t *b) {
    return (uint32_t)b[0] | ((uint32_t)b[1] << 8) |
           ((uint32_t)b[2] << 16) | ((uint32_t)b[3] << 24);
}
static inline void store_le32(uint8_t *b, uint32_t v) {
    b[0] = v & 0xFF;
    b[1] = (v >> 8) & 0xFF;
    b[2] = (v >> 16) & 0xFF;
    b[3] = (v >> 24) & 0xFF;
}

// Apply S-box substitution on 32-bit value
static uint32_t apply_sbox(uint32_t v) {
    uint32_t out = 0;
    for (int i = 0; i < 8; i++) {
        uint8_t nib = (v >> (4 * i)) & 0xF;
        out |= (uint32_t)SBOX[i][nib] << (4 * i);
    }
    return out;
}

// GOST round function: add, substitute, rotate
static uint32_t gost_f(uint32_t x, uint32_t k) {
    uint32_t sum = x + k;
    uint32_t subs = apply_sbox(sum);
    return rotl32(subs, 11);
}

// Build 32 subkeys from 256-bit key
void gost_key_schedule(const uint8_t key[32], uint32_t subkeys[32]) {
    uint32_t k[8];
    for (int i = 0; i < 8; i++) {
        k[i] = load_le32(key + 4*i);
    }
    // Rounds 1-24: forward x3
    for (int r = 0; r < 3; r++) {
        for (int i = 0; i < 8; i++) subkeys[r*8 + i] = k[i];
    }
    // Rounds 25-32: reverse
    for (int i = 0; i < 8; i++) subkeys[24 + i] = k[7 - i];
}

// Encrypt single 64-bit block (8 bytes)
void gost_encrypt_block(const uint8_t in[8], uint8_t out[8], const uint8_t key[32]) {
    uint32_t subkeys[32];
    gost_key_schedule(key, subkeys);

    uint32_t n1 = load_le32(in);
    uint32_t n2 = load_le32(in + 4);
    for (int i = 0; i < 32; i++) {
        uint32_t tmp = n1;
        n1 = n2 ^ gost_f(n1, subkeys[i]);
        n2 = tmp;
    }
    // Swap n1 and n2 for final output
    store_le32(out, n2);
    store_le32(out + 4, n1);
}

// Decrypt single 64-bit block
void gost_decrypt_block(const uint8_t in[8], uint8_t out[8], const uint8_t key[32]) {
    uint32_t subkeys[32];
    gost_key_schedule(key, subkeys);
    // reverse subkeys
    for (int i = 0; i < 16; i++) {
        uint32_t t = subkeys[i];
        subkeys[i] = subkeys[31 - i];
        subkeys[31 - i] = t;
    }

    uint32_t n1 = load_le32(in);
    uint32_t n2 = load_le32(in + 4);
    for (int i = 0; i < 32; i++) {
        uint32_t tmp = n1;
        n1 = n2 ^ gost_f(n1, subkeys[i]);
        n2 = tmp;
    }
    // Swap n1 and n2 for final output
    store_le32(out, n2);
    store_le32(out + 4, n1);
    out[8] = '\0';
}

// Compute GOST MAC (16-round CBC-MAC variant)
void gost_mac(const uint8_t *data, size_t len, const uint8_t key[32], uint8_t *mac, size_t mac_size) {
    uint32_t subkeys16[16];
    uint32_t all_sub[32];
    gost_key_schedule(key, all_sub);
    memcpy(subkeys16, all_sub, sizeof(subkeys16));

    uint32_t n1 = 0, n2 = 0;
    size_t padded = (len + 7) & ~7;
    uint8_t buf[8];
    for (size_t off = 0; off < padded; off += 8) {
        if (off < len) {
            size_t chunk = (len - off < 8) ? len - off : 8;
            memcpy(buf, data + off, chunk);
            if (chunk < 8) memset(buf + chunk, 0, 8 - chunk);
        } else {
            memset(buf, 0, 8);
        }
        n1 ^= load_le32(buf);
        n2 ^= load_le32(buf + 4);
        for (int i = 0; i < 16; i++) {
            uint32_t tmp = n1;
            n1 = n2 ^ gost_f(n1, subkeys16[i]);
            n2 = tmp;
        }
    }
    // final half-block
    for (int i = 0; i < 16; i++) {
        uint32_t tmp = n1;
        n1 = n2 ^ gost_f(n1, subkeys16[i]);
        n2 = tmp;
    }
    uint8_t full[8];
    store_le32(full, n2);
    store_le32(full + 4, n1);
    memcpy(mac, full, mac_size);
}

#ifdef DEMO
int main(void) {
    uint8_t key[32] = {
        0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77,
        0x88,0x99,0xAA,0xBB,0xCC,0xDD,0xEE,0xFF,
        0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77,
        0x88,0x99,0xAA,0xBB,0xCC,0xDD,0xEE,0xFF
    };
    uint8_t plain[9] = "12345678";
    uint8_t cipher[8], decrypted[9];
    gost_encrypt_block(plain, cipher, key);
    gost_decrypt_block(cipher, decrypted, key);
    decrypted[8] = '\0';
    printf("Plain: %s\n", plain);
    printf("Cipher: ");
    for (int i = 0; i < 8; i++) printf("%02X", cipher[i]);
    printf("\nDecrypted: %s\n", decrypted);

    const uint8_t msg[] = "The quick brown fox jumps over the lazy dog";
    uint8_t tag[4];
    gost_mac(msg, sizeof(msg)-1, key, tag, 4);
    printf("MAC(32-bit): %02X%02X%02X%02X\n", tag[0], tag[1], tag[2], tag[3]);
    return 0;
}
#endif
```

Run the code:

```bash
gcc -O3 gost-basic-impl.c -o gost-basic-impl && ./gost-basic-impl
Plain: 12345678
Cipher: B1300CE5FC9C6C06
Decrypted: 12345678
MAC(32-bit): 6C4030C7
```

### Appendix H

main.c

```c
// ASCON test function
int ascon_main() {
  /* Sample data (key, nonce, associated data, plaintext) */
  unsigned char n[32] = { 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
                           11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
                           22, 23, 24, 25, 26, 27, 28, 29, 30, 31 };
  unsigned char k[32] = { 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
                           11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
                           22, 23, 24, 25, 26, 27, 28, 29, 30, 31 };
  unsigned char a[32] = { 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
                           11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
                           22, 23, 24, 25, 26, 27, 28, 29, 30, 31 };
  unsigned char m[32] = { 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
                           11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
                           22, 23, 24, 25, 26, 27, 28, 29, 30, 31 };
  unsigned char c[32], h[32], t[32];
  unsigned long long alen = 16;
  unsigned long long mlen = 16;
  unsigned long long clen;
  int result = 0;

#if defined(AVR_UART)
  avr_uart_init();
  stdout = &avr_uart_output;
  stdin = &avr_uart_input_echo;
#endif

  uint32_t total_time = 0;
  HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0);    // LED ON
    HAL_Delay(5000);                                          // Wait 5 seconds
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1);  // LED OFF
  uint32_t start_time = HAL_GetTick();
  for (int i = 0; i < 20000; i++) {

      result |= crypto_aead_encrypt(c, &clen, m, mlen, a, alen, NULL, n, k);

  }
  uint32_t end_time = HAL_GetTick();
        uint32_t elapsed = end_time - start_time;
        total_time += elapsed;

  /* Turn ON LED on PC13, wait 5 seconds, then turn OFF LED */
  HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0);    // LED ON
  HAL_Delay(5000+result);                                          // Wait 5 seconds
  HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1);  // LED OFF

  return result;
}
```


### Appendix I

main.c

gost_main() (non-optimized)

```c
/* GOST test function */
int gost_main() {
    // Define the 256-bit key (32 bytes)
    uint8_t key[32] = {
        0x04, 0x75, 0xF6, 0xE0, 0x50, 0x38, 0xFB, 0xFA, 
        0xD2, 0xC7, 0xC3, 0x90, 0xED, 0xB3, 0xCA, 0x3D,
        0x15, 0x47, 0x12, 0x42, 0x91, 0xAE, 0x1E, 0x8A, 
        0x2F, 0x79, 0xCD, 0x9E, 0xD2, 0xBC, 0xEF, 0xBD
    };

    // Define a sample S-box (128 bytes, 8 rows of 16 nibbles)
    uint8_t sbox[128] = {
        0x04, 0x02, 0x0F, 0x05, 0x09, 0x01, 0x00, 0x08, 0x0E, 0x03, 0x0B, 0x0C, 0x0D, 0x07, 0x0A, 0x06,
        0x0C, 0x09, 0x0F, 0x0E, 0x08, 0x01, 0x03, 0x0A, 0x02, 0x07, 0x04, 0x0D, 0x06, 0x00, 0x0B, 0x05,
        0x0D, 0x08, 0x0E, 0x0C, 0x07, 0x03, 0x09, 0x0A, 0x01, 0x05, 0x02, 0x04, 0x06, 0x0F, 0x00, 0x0B,
        0x0E, 0x09, 0x0B, 0x02, 0x05, 0x0F, 0x07, 0x01, 0x00, 0x0D, 0x0C, 0x06, 0x0A, 0x04, 0x03, 0x08,
        0x03, 0x0E, 0x05, 0x09, 0x06, 0x08, 0x00, 0x0D, 0x0A, 0x0B, 0x07, 0x0C, 0x02, 0x01, 0x0F, 0x04,
        0x08, 0x0F, 0x06, 0x0B, 0x01, 0x09, 0x0C, 0x05, 0x0D, 0x03, 0x07, 0x0A, 0x00, 0x0E, 0x02, 0x04,
        0x09, 0x0B, 0x0C, 0x00, 0x03, 0x06, 0x07, 0x05, 0x04, 0x08, 0x0E, 0x0F, 0x01, 0x0A, 0x02, 0x0D,
        0x0C, 0x06, 0x05, 0x02, 0x0B, 0x00, 0x09, 0x0D, 0x03, 0x0E, 0x07, 0x0A, 0x0F, 0x04, 0x01, 0x08
    };

    // Test data (64 bytes - multiple blocks)
    uint8_t test_data[64];
    
    // Initialize test data
    for (int i = 0; i < sizeof(test_data); i++) {
        test_data[i] = i & 0xFF;
    }

    // Performance measurement variables
    uint32_t iterations = 20000;
    uint32_t start_time, end_time, elapsed;
    
    // Signal start of benchmark
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
    HAL_Delay(5000); // Wait 3 seconds
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
    
    // Measure time for original GOST implementation
    start_time = HAL_GetTick();
    for (uint32_t i = 0; i < iterations; i++) {
        GOST_Encrypt_SR(test_data, 8, _GOST_Mode_Encrypt, sbox, key);
    }
    end_time = HAL_GetTick();
    elapsed = end_time - start_time;
    
    // Signal end of benchmark
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
    HAL_Delay(1000);
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
    
    // Flash LED to indicate elapsed time (in seconds)
    uint32_t elapsed_seconds = elapsed / 1000;
    if (elapsed_seconds == 0) elapsed_seconds = 1;
    
    HAL_Delay(2000); // Pause before blinking
    
    for (uint32_t i = 0; i < elapsed_seconds; i++) {
        HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
        HAL_Delay(200);
        HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
        HAL_Delay(200);
    }
    
    return elapsed;
}
```

### Appendix J

main.c

gost_opt_main() (optimized version of gost_main())

```c
/* GOST test function */
// Optimized GOST
int gost_opt_main() {
    // Define the 256-bit key (32 bytes) - SAME AS gost_main()
    uint8_t key[32] = {
        0x04, 0x75, 0xF6, 0xE0, 0x50, 0x38, 0xFB, 0xFA, 
        0xD2, 0xC7, 0xC3, 0x90, 0xED, 0xB3, 0xCA, 0x3D,
        0x15, 0x47, 0x12, 0x42, 0x91, 0xAE, 0x1E, 0x8A, 
        0x2F, 0x79, 0xCD, 0x9E, 0xD2, 0xBC, 0xEF, 0xBD
    };

    // Define a sample S-box (128 bytes, 8 rows of 16 nibbles) - SAME AS gost_main()
    uint8_t sbox[128] = {
        0x04, 0x02, 0x0F, 0x05, 0x09, 0x01, 0x00, 0x08, 0x0E, 0x03, 0x0B, 0x0C, 0x0D, 0x07, 0x0A, 0x06,
        0x0C, 0x09, 0x0F, 0x0E, 0x08, 0x01, 0x03, 0x0A, 0x02, 0x07, 0x04, 0x0D, 0x06, 0x00, 0x0B, 0x05,
        0x0D, 0x08, 0x0E, 0x0C, 0x07, 0x03, 0x09, 0x0A, 0x01, 0x05, 0x02, 0x04, 0x06, 0x0F, 0x00, 0x0B,
        0x0E, 0x09, 0x0B, 0x02, 0x05, 0x0F, 0x07, 0x01, 0x00, 0x0D, 0x0C, 0x06, 0x0A, 0x04, 0x03, 0x08,
        0x03, 0x0E, 0x05, 0x09, 0x06, 0x08, 0x00, 0x0D, 0x0A, 0x0B, 0x07, 0x0C, 0x02, 0x01, 0x0F, 0x04,
        0x08, 0x0F, 0x06, 0x0B, 0x01, 0x09, 0x0C, 0x05, 0x0D, 0x03, 0x07, 0x0A, 0x00, 0x0E, 0x02, 0x04,
        0x09, 0x0B, 0x0C, 0x00, 0x03, 0x06, 0x07, 0x05, 0x04, 0x08, 0x0E, 0x0F, 0x01, 0x0A, 0x02, 0x0D,
        0x0C, 0x06, 0x05, 0x02, 0x0B, 0x00, 0x09, 0x0D, 0x03, 0x0E, 0x07, 0x0A, 0x0F, 0x04, 0x01, 0x08
    };

    // Create optimized substitution table
    GOST_Subst_Table subst_table;
    for(int i = 0; i < 4; i++) {
        uint8_t* sbox_low = sbox + (i * 2) * 16;
        uint8_t* sbox_high = sbox + (i * 2 + 1) * 16;
        
        for(int b = 0; b < 256; b++) {
            uint8_t low_nibble = b & 0x0F;
            uint8_t high_nibble = (b >> 4) & 0x0F;
            uint8_t low_subst = sbox_low[low_nibble];
            uint8_t high_subst = sbox_high[high_nibble];
            subst_table[i*256 + b] = low_subst | (high_subst << 4);
        }
    }

    // Test data (identical to gost_main)
    uint8_t test_data[64];
    
    // Initialize test data (identical to gost_main)
    for (int i = 0; i < sizeof(test_data); i++) {
        test_data[i] = i & 0xFF;
    }
    
    // Performance measurement variables
    uint32_t iterations = 20000;
    uint32_t start_time, end_time, elapsed;
    
    // Signal start of benchmark
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
    HAL_Delay(5000); // Wait 3 seconds
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF

    // Measure performance
    start_time = HAL_GetTick();
    for (uint32_t i = 0; i < iterations; i++) {
        GOST_Encrypt_SR_Opt(test_data, 8, _GOST_Mode_Encrypt, subst_table, key);
    }
    end_time = HAL_GetTick();
    elapsed = end_time - start_time;
    
    // Signal end of benchmark
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
    HAL_Delay(1000);
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
    
    // Flash LED to indicate elapsed time (in seconds)
    uint32_t elapsed_seconds = elapsed / 1000;
    if (elapsed_seconds == 0) elapsed_seconds = 1;
    
    HAL_Delay(2000); // Pause before blinking
    
    for (uint32_t i = 0; i < elapsed_seconds; i++) {
        HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
        HAL_Delay(200);
        HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
        HAL_Delay(200);
    }

    return elapsed;
}
```


### Appendix K

main.c

Benchmarking ASCON AEAD and GOST algorithms.

```c
/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{

  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_TIM1_Init();
  /* USER CODE BEGIN 2 */

  /* USER CODE END 2 */

  /* ASCON CODE BEGIN */
  // ascon_main(); // it took 584 seconds (11.11% faster than the original)
  /* ASCON CODE END */

  /* GOST CODE BEGIN */
  // Original GOST
  uint32_t orig_time = gost_main(); // it took 04:49 - 04:56 secs
  /* GOST CODE END */

  /* GOST CODE BEGIN */
  // Optimized GOST
  uint32_t opt_time = gost_opt_main(); // it took 02:27 secs (49.13% faster than the original)
  /* GOST CODE END */

  // Show performance comparison
  HAL_Delay(3000); // Pause before final results

  // Calculate performance improvement ratio
  float improvement = 0;
  if (opt_time > 0) {
    improvement = (float)orig_time / opt_time;
  }

  // Display results through LED blinks
  // First: Original time (1 blink per second)
  // Second: Optimized time (1 blink per second)
  // Third: Performance ratio (number of blinks indicates improvement factor)
  
  // Display the improvement factor
  int blinks = 0;
  if (improvement >= 1.0f) {
    blinks = (int)improvement;
    if (blinks < 1) blinks = 1;
    if (blinks > 10) blinks = 10; // Cap at 10 blinks
    
    // Rapid blinks indicate speedup factor
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
    HAL_Delay(1000);
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
    HAL_Delay(1000);
    
    for (int i = 0; i < blinks; i++) {
      HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
      HAL_Delay(100);
      HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
      HAL_Delay(100);
    }
  } else {
    // Slow blinks indicate slowdown (optimization failed)
    for (int i = 0; i < 3; i++) {
      HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
      HAL_Delay(1000);
      HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
      HAL_Delay(1000);
    }
  }

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
	   HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1);
	   HAL_Delay(1000);
	   HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0);
	   HAL_Delay(1000);
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
  }
  /* USER CODE END 3 */
}
```


### Appendix L

ASCON AEAD 128 bit original ROUND_LOOP()

```c
forceinline void ROUND_LOOP(ascon_state_t* s, const uint8_t* C,
                            const uint8_t* E) {
  uint32_t tmp0, tmp1;
  __asm__ __volatile__(
      "rbegin_%=:;\n\t"
      "ldrb %[tmp1], [%[C]], #1\n\t"
      "eor %[x0_l], %[x0_l], %[x4_l]\n\t"
      "eor %[x4_l], %[x4_l], %[x3_l]\n\t"
      "eor %[x2_l], %[x2_l], %[x1_l]\n\t"
      "orn %[tmp0], %[x4_l], %[x0_l]\n\t"
      "eor %[x2_l], %[x2_l], %[tmp1]\n\t"
      "bic %[tmp1], %[x2_l], %[x1_l]\n\t"
      "eor %[x0_l], %[x0_l], %[tmp1]\n\t"
      "orn %[tmp1], %[x3_l], %[x4_l]\n\t"
      "eor %[x2_l], %[x2_l], %[tmp1]\n\t"
      "bic %[tmp1], %[x1_l], %[x0_l]\n\t"
      "eor %[x4_l], %[x4_l], %[tmp1]\n\t"
      "and %[tmp1], %[x3_l], %[x2_l]\n\t"
      "eor %[x1_l], %[x1_l], %[tmp1]\n\t"
      "eor %[x3_l], %[x3_l], %[tmp0]\n\t"
      "ldrb %[tmp1], [%[C]], #1\n\t"
      "eor %[x1_l], %[x1_l], %[x0_l]\n\t"
      "eor %[x3_l], %[x3_l], %[x2_l]\n\t"
      "eor %[x0_l], %[x0_l], %[x4_l]\n\t"
      "eor %[x0_h], %[x0_h], %[x4_h]\n\t"
      "eor %[x4_h], %[x4_h], %[x3_h]\n\t"
      "eor %[x2_h], %[x2_h], %[tmp1]\n\t"
      "eor %[x2_h], %[x2_h], %[x1_h]\n\t"
      "orn %[tmp0], %[x4_h], %[x0_h]\n\t"
      "bic %[tmp1], %[x2_h], %[x1_h]\n\t"
      "eor %[x0_h], %[x0_h], %[tmp1]\n\t"
      "orn %[tmp1], %[x3_h], %[x4_h]\n\t"
      "eor %[x2_h], %[x2_h], %[tmp1]\n\t"
      "bic %[tmp1], %[x1_h], %[x0_h]\n\t"
      "eor %[x4_h], %[x4_h], %[tmp1]\n\t"
      "and %[tmp1], %[x3_h], %[x2_h]\n\t"
      "eor %[x1_h], %[x1_h], %[tmp1]\n\t"
      "eor %[x3_h], %[x3_h], %[tmp0]\n\t"
      "eor %[x1_h], %[x1_h], %[x0_h]\n\t"
      "eor %[x3_h], %[x3_h], %[x2_h]\n\t"
      "eor %[x0_h], %[x0_h], %[x4_h]\n\t"
      "eor %[tmp0], %[x0_l], %[x0_h], ror #4\n\t"
      "eor %[tmp1], %[x0_h], %[x0_l], ror #5\n\t"
      "eor %[x0_h], %[x0_h], %[tmp0], ror #10\n\t"
      "eor %[x0_l], %[x0_l], %[tmp1], ror #9\n\t"
      "eor %[tmp0], %[x1_l], %[x1_l], ror #11\n\t"
      "eor %[tmp1], %[x1_h], %[x1_h], ror #11\n\t"
      "eor %[x1_h], %[x1_h], %[tmp0], ror #20\n\t"
      "eor %[x1_l], %[x1_l], %[tmp1], ror #19\n\t"
      "eor %[tmp0], %[x2_l], %[x2_h], ror #2\n\t"
      "eor %[tmp1], %[x2_h], %[x2_l], ror #3\n\t"
      "eor %[x2_h], %[x2_h], %[tmp0], ror #1\n\t"
      "eor %[x2_l], %[x2_l], %[tmp1]\n\t"
      "eor %[tmp0], %[x3_l], %[x3_h], ror #3\n\t"
      "eor %[tmp1], %[x3_h], %[x3_l], ror #4\n\t"
      "eor %[x3_l], %[x3_l], %[tmp0], ror #5\n\t"
      "eor %[x3_h], %[x3_h], %[tmp1], ror #5\n\t"
      "eor %[tmp0], %[x4_l], %[x4_l], ror #17\n\t"
      "eor %[tmp1], %[x4_h], %[x4_h], ror #17\n\t"
      "eor %[x4_h], %[x4_h], %[tmp0], ror #4\n\t"
      "eor %[x4_l], %[x4_l], %[tmp1], ror #3\n\t"
      "cmp %[C], %[E]\n\t"
      "bne rbegin_%=\n\t"
      :
      [x0_l] "+r"(s->w[0][0]), [x0_h] "+r"(s->w[0][1]), [x1_l] "+r"(s->w[1][0]),
      [x1_h] "+r"(s->w[1][1]), [x2_l] "+r"(s->w[2][0]), [x2_h] "+r"(s->w[2][1]),
      [x3_l] "+r"(s->w[3][0]), [x3_h] "+r"(s->w[3][1]), [x4_l] "+r"(s->w[4][0]),
      [x4_h] "+r"(s->w[4][1]), [C] "+r"(C), [E] "+r"(E), [tmp0] "=r"(tmp0),
      [tmp1] "=r"(tmp1)
      :
      : "cc");
}
```


### Appendix M

ASCON AEAD 128 bit optimized ROUND_LOOP()

```c
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
```


### Appendix N

GOST 28147-89: original implementation of GOST_Crypt_Step()

```c
void GOST_Crypt_Step(GOST_Data_Part *DATA, uint8_t *GOST_Table, uint32_t GOST_Key, bool Last )
{
    typedef  union
    {
        uint32_t full;
        uint8_t parts[_GOST_TABLE_NODES/2];
    } GOST_Data_Part_sum;
    GOST_Data_Part_sum S;
    uint8_t m;
    uint8_t tmp;
    //N1=Lo(DATA); N2=Hi(DATA)

    S.full = (uint32_t)((*DATA).half[_GOST_Data_Part_N1_Half]+GOST_Key) ;//S=(N1+X)mod2^32

    for(m=0; m<(_GOST_TABLE_NODES/2); m++)
    {
        //S(m)=H(m,S)
        tmp=S.parts[m];
        S.parts[m] = *(GOST_Table+(tmp&0x0F));//Low value
        GOST_Table+= _GOST_TABLE_MAX_NODE_VALUE;//next line in table
        S.parts[m] |= (*(GOST_Table+((tmp&0xF0)>>4)))<<4;//Hi value
        GOST_Table+= _GOST_TABLE_MAX_NODE_VALUE;//next line in table

    }
    S.full = (*DATA).half[_GOST_Data_Part_N2_Half]^custom_lrotl(S.full,11);//S=Rl(11,S); rol S,11 //S XOR N2
    if (Last)
    {
        (*DATA).half[_GOST_Data_Part_N2_Half] = S.full; //N2=S
    }else
    {
        (*DATA).half[_GOST_Data_Part_N2_Half] = (*DATA).half[_GOST_Data_Part_N1_Half];//N2=N1
        (*DATA).half[_GOST_Data_Part_N1_Half] = S.full;//N1=S
    }
}
```

GOST 28147-89: original implementation of GOST_Crypt_32_E_Cicle()

```c
void GOST_Crypt_32_E_Cicle(GOST_Data_Part *DATA, uint8_t *GOST_Table, uint32_t *GOST_Key)
{
    uint8_t k,j;
    uint32_t *GOST_Key_tmp=GOST_Key;
//Key rotation:
//K0,K1,K2,K3,K4,K5,K6,K7, K0,K1,K2,K3,K4,K5,K6,K7, K0,K1,K2,K3,K4,K5,K6,K7, K7,K6,K5,K4,K3,K2,K1,K0

    for(k=0;k<3;k++)
    {
        for (j=0;j<8;j++)
        {
            GOST_Crypt_Step(DATA, GOST_Table, *GOST_Key,_GOST_Next_Step ) ;
            GOST_Key++;
        }
        GOST_Key=GOST_Key_tmp;
    }

    GOST_Key+=7;//K7

    for (j=0;j<7;j++)
    {
        GOST_Crypt_Step(DATA, GOST_Table, *GOST_Key,_GOST_Next_Step ) ;
        GOST_Key--;
    }
    GOST_Crypt_Step(DATA, GOST_Table, *GOST_Key,_GOST_Last_Step ) ;
}

void GOST_Crypt_32_D_Cicle(GOST_Data_Part *DATA, uint8_t *GOST_Table, uint32_t *GOST_Key)
{
    uint8_t k,j;
//Key rotation:
//K0,K1,K2,K3,K4,K5,K6,K7, K7,K6,K5,K4,K3,K2,K1,K0, K7,K6,K5,K4,K3,K2,K1,K0, K7,K6,K5,K4,K3,K2,K1,K0

[...and etc. almost similar to the encrypt version above.]
}
```

GOST 28147-89: original implementation of GOST_Encrypt_SR()

```c
void GOST_Encrypt_SR(uint8_t *Data, uint32_t Size, bool Mode, uint8_t *GOST_Table, uint8_t *GOST_Key )
{
    uint8_t Cur_Part_Size;
    GOST_Data_Part Data_prep;
    uint32_t *GOST_Key_pt=(uint32_t *) GOST_Key;

    while (Size!=0)
    {
        Cur_Part_Size=_Min(_GOST_Part_Size,Size);
        memset(&Data_prep,_GOST_Def_Byte,sizeof(Data_prep));
        memcpy(&Data_prep,Data,Cur_Part_Size);
#if _GOST_ROT==1
        Data_prep.half[_GOST_Data_Part_N2_Half]=_GOST_SWAP32(Data_prep.half[_GOST_Data_Part_N2_Half]);
        Data_prep.half[_GOST_Data_Part_N1_Half]=_GOST_SWAP32(Data_prep.half[_GOST_Data_Part_N1_Half]);
#endif
        if (Mode==_GOST_Mode_Encrypt)
        {
            GOST_Crypt_32_E_Cicle(&Data_prep,GOST_Table,GOST_Key_pt);
        } else
        {
            GOST_Crypt_32_D_Cicle(&Data_prep,GOST_Table,GOST_Key_pt);
        }
#if _GOST_ROT==1
        Data_prep.half[_GOST_Data_Part_N2_Half]=_GOST_SWAP32(Data_prep.half[_GOST_Data_Part_N2_Half]);
        Data_prep.half[_GOST_Data_Part_N1_Half]=_GOST_SWAP32(Data_prep.half[_GOST_Data_Part_N1_Half]);
#endif
        memcpy(Data,&Data_prep, Cur_Part_Size);
        Data+=Cur_Part_Size;
        Size-=Cur_Part_Size;
   }

}
```

### Appendix O

GOST 28147-89: optimized implementation of GOST_Crypt_Step()

```c
uint32_t GOST_Crypt_Step_Opt(uint32_t data, GOST_Subst_Table Table, uint32_t key, int last_step)
{
    // XOR the right half with the key
    uint32_t result = (data + key) & 0xffffffff;
    
    // Apply substitution using precomputed table
    result = Table[(result & 0xff)] | 
             (Table[256 + ((result >> 8) & 0xff)] << 8) |
             (Table[512 + ((result >> 16) & 0xff)] << 16) |
             (Table[768 + ((result >> 24) & 0xff)] << 24);
    
    // 11-bit left shift
    result = ((result << 11) | (result >> 21)) & 0xffffffff;
    
    return result;
}
```

GOST 28147-89: optimized implementation of GOST_Crypt_32_E_Cicle()

```c

void GOST_Crypt_32_E_Cicle_Opt(uint32_t *n1, uint32_t *n2, GOST_Subst_Table Table, uint32_t *GOST_Key)
{
    // Unroll the first 24 rounds for better performance
    uint32_t tmp;
    
    // Round 1-8 (K0-K7)
    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[0], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[1], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[2], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[3], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[4], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[5], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[6], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[7], 0);
    *n2 = tmp;

    // Round 9-16 (K0-K7)
    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[0], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[1], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[2], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[3], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[4], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[5], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[6], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[7], 0);
    *n2 = tmp;

    // Round 17-24 (K0-K7)
    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[0], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[1], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[2], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[3], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[4], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[5], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[6], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[7], 0);
    *n2 = tmp;

    // Last 8 rounds (K7-K0)
    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[7], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[6], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[5], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[4], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[3], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[2], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[1], 0);
    *n2 = tmp;

    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[0], 1);
    *n2 = tmp;
}
```

GOST 28147-89: optimized implementation of GOST_Crypt_32_D_Cicle()

```c
void GOST_Crypt_32_D_Cicle_Opt(uint32_t *n1, uint32_t *n2, GOST_Subst_Table Table, uint32_t *GOST_Key)
{
    // Unroll the 32 rounds for better performance
    uint32_t tmp;
    
    // First 8 rounds (K0-K7)
    tmp = *n1;
    *n1 = *n2 ^ GOST_Crypt_Step_Opt(*n1, Table, GOST_Key[0], 0);
    *n2 = tmp;

    [...and etc. almost similar to the encrypt version above.]

}
```

GOST 28147-89: optimized implementation of GOST_Encrypt_SR()

```c
int GOST_Encrypt_SR_Opt(uint8_t *Data, uint32_t Size, uint8_t Mode, GOST_Subst_Table Table, uint8_t *GOST_Key_start)
{
    uint32_t GOST_Key[8];
    GOST_Data_Part Temp;
    uint32_t n;
    
    // Prepare the key in the correct byte order
    for (int i = 0; i < 8; i++) {
        GOST_Key[i] = _GOST_SWAP32(((uint32_t *)GOST_Key_start)[i]);
    }
    
    // Process full blocks
    for (n = 0; n < Size / 8; n++) {
        // Load data directly from the data pointer into GOST_Data_Part structure
        Temp.half[_GOST_Data_Part_N1_Half] = _GOST_SWAP32(((uint32_t *)(Data + n * 8))[0]);
        Temp.half[_GOST_Data_Part_N2_Half] = _GOST_SWAP32(((uint32_t *)(Data + n * 8))[1]);
        
        // Encrypt or decrypt the data based on the Mode parameter
        if (Mode == _GOST_Mode_Encrypt) {
            GOST_Crypt_32_E_Cicle_Opt(&Temp.half[_GOST_Data_Part_N1_Half], &Temp.half[_GOST_Data_Part_N2_Half], Table, GOST_Key);
        } else if (Mode == _GOST_Mode_Decrypt) {
            GOST_Crypt_32_D_Cicle_Opt(&Temp.half[_GOST_Data_Part_N1_Half], &Temp.half[_GOST_Data_Part_N2_Half], Table, GOST_Key);
        }
        
        // Write the result back to the data pointer
        ((uint32_t *)(Data + n * 8))[0] = _GOST_SWAP32(Temp.half[_GOST_Data_Part_N1_Half]);
        ((uint32_t *)(Data + n * 8))[1] = _GOST_SWAP32(Temp.half[_GOST_Data_Part_N2_Half]);
    }
    
    // Handle any remaining partial block (less than 8 bytes)
    uint32_t remain = Size % 8;
    if (remain > 0) {
        uint8_t block[8] = {0};
        // Copy the remaining bytes to a temp buffer
        for (uint32_t i = 0; i < remain; i++) {
            block[i] = Data[n * 8 + i];
        }
        
        // Process the final partial block
        Temp.half[_GOST_Data_Part_N1_Half] = _GOST_SWAP32(((uint32_t *)block)[0]);
        Temp.half[_GOST_Data_Part_N2_Half] = _GOST_SWAP32(((uint32_t *)block)[1]);
        
        if (Mode == _GOST_Mode_Encrypt) {
            GOST_Crypt_32_E_Cicle_Opt(&Temp.half[_GOST_Data_Part_N1_Half], &Temp.half[_GOST_Data_Part_N2_Half], Table, GOST_Key);
        } else if (Mode == _GOST_Mode_Decrypt) {
            GOST_Crypt_32_D_Cicle_Opt(&Temp.half[_GOST_Data_Part_N1_Half], &Temp.half[_GOST_Data_Part_N2_Half], Table, GOST_Key);
        }
        
        ((uint32_t *)block)[0] = _GOST_SWAP32(Temp.half[_GOST_Data_Part_N1_Half]);
        ((uint32_t *)block)[1] = _GOST_SWAP32(Temp.half[_GOST_Data_Part_N2_Half]);
        
        // Copy the encrypted/decrypted data back to the original buffer
        for (uint32_t i = 0; i < remain; i++) {
            Data[n * 8 + i] = block[i];
        }
    }
    
    return 0;
}
```