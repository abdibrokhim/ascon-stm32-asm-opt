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
