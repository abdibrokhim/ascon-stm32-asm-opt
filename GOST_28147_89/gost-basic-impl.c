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
