
/**
 * Javascript GOST R 34.11-94 hash function implementation.
 * Based on C-code by Alexei Kravchenko and Markku-Juhani Saarinen
 * and Utf8 class by Chris Veness.
 *
 * Usage: gosthash("<string>") returns a hash-string.
 *                                              Alexander Okrugin (November, 11, 2011)
*/
var Utf8 = {}; // Utf8 namespace
Utf8.encode = function (strUni) {
    // use regular expressions & String.replace callback function for better efficiency 
    // than procedural approaches
    var strUtf = strUni.replace(/[\u0080-\u07ff]/g, // U+0080 - U+07FF => 2 bytes 110yyyyy, 10zzzzzz
 
 
    function (c) {
        var cc = c.charCodeAt(0);
        return String.fromCharCode(0xc0 | cc >> 6, 0x80 | cc & 0x3f);
    });
    strUtf = strUtf.replace(/[\u0800-\uffff]/g, // U+0800 - U+FFFF => 3 bytes 1110xxxx, 10yyyyyy, 10zzzzzz
 
 
    function (c) {
        var cc = c.charCodeAt(0);
        return String.fromCharCode(0xe0 | cc >> 12, 0x80 | cc >> 6 & 0x3F, 0x80 | cc & 0x3f);
    });
    return strUtf;
}
 
Utf8.decode = function (strUtf) {
    // note: decode 3-byte chars first as decoded 2-byte strings could appear to be 3-byte char!
    var strUni = strUtf.replace(/[\u00e0-\u00ef][\u0080-\u00bf][\u0080-\u00bf]/g, // 3-byte chars
 
 
    function (c) { // (note parentheses for precence)
        var cc = ((c.charCodeAt(0) & 0x0f) << 12) | ((c.charCodeAt(1) & 0x3f) << 6) | (c.charCodeAt(2) & 0x3f);
        return String.fromCharCode(cc);
    });
    strUni = strUni.replace(/[\u00c0-\u00df][\u0080-\u00bf]/g, // 2-byte chars
 
 
    function (c) { // (note parentheses for precence)
        var cc = (c.charCodeAt(0) & 0x1f) << 6 | c.charCodeAt(1) & 0x3f;
        return String.fromCharCode(cc);
    });
    return strUni;
}
 
function rol(word, n) {
    return ((word << (n & 0x1f)) | (word >>> (32 - (n & 0x1f))));
}
 
function ch2hex(val) {
    var hext = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"];
    return hext[(val >>> 4) & 15] + hext[val & 15];
}
 
function str2bytes(str) {
    var arr = Array(str.length);
    for (var i = 0; i < str.length; ++i)
    arr[i] = str.charCodeAt(i) & 255;
    return arr;
}
 
var hash = new Array(8);
var sum = new Array(8);
var message = new Array(32);
var length = 0,
    r = 0,
    l = 0;
 
var gost_sbox = new Array(4);
for (var j = 0; j < 4; j++) gost_sbox[j] = new Array(256);
 
/* eight 4-bit S-Boxes as defined by RFC 4351 section 11.2 */
var sbox = [
    [4, 10, 9, 2, 13, 8, 0, 14, 6, 11, 1, 12, 7, 15, 5, 3],
    [14, 11, 4, 12, 6, 13, 15, 10, 2, 3, 8, 1, 0, 7, 5, 9],
    [5, 8, 1, 13, 10, 3, 4, 2, 14, 15, 12, 7, 6, 0, 9, 11],
    [7, 13, 10, 1, 0, 8, 9, 15, 14, 4, 6, 12, 11, 2, 5, 3],
    [6, 12, 7, 1, 5, 15, 13, 8, 4, 10, 9, 14, 0, 3, 11, 2],
    [4, 11, 10, 0, 7, 2, 1, 13, 3, 6, 8, 5, 9, 12, 15, 14],
    [13, 11, 4, 1, 3, 15, 5, 9, 0, 10, 14, 7, 6, 8, 2, 12],
    [1, 15, 13, 0, 5, 7, 10, 4, 9, 2, 3, 14, 6, 11, 8, 12]
];
 
/** CryptoPro S-Box: */
/*
var sbox = [
    [10, 4, 5, 6, 8, 1, 3, 7, 13, 12, 14, 0, 9, 2, 11, 15],
    [5, 15, 4, 0, 2, 13, 11, 9, 1, 7, 6, 3, 12, 14, 10, 8],
    [7, 15, 12, 14, 9, 4, 1, 0, 3, 11, 5, 2, 6, 10, 8, 13],
    [4, 10, 7, 12, 0, 15, 2, 8, 14, 1, 6, 5, 13, 11, 9, 3],
    [7, 6, 4, 11, 9, 12, 2, 10, 1, 8, 0, 14, 15, 13, 3, 5],
    [7, 6, 2, 4, 13, 9, 15, 0, 10, 1, 5, 11, 8, 14, 12, 3],
    [13, 14, 4, 1, 7, 0, 5, 10, 3, 12, 8, 15, 6, 2, 9, 11],
    [1, 3, 10, 9, 5, 11, 4, 15, 8, 6, 7, 14, 13, 0, 2, 12]
];
*/
 
/**
 * Initialize algorithm context before calculaing hash.
 */
 
function gost_init() {
    for (var i = 0; i < 8; i++) {
        hash[i] = 0;
        sum[i] = 0;
        message[4 * i] = 0;
        message[4 * i + 1] = 0;
        message[4 * i + 2] = 0;
        message[4 * i + 3] = 0;
    }
    length = 0;
}
 
/*
 *  A full encryption round of GOST 28147-89.
 *  Temporary variables tmp assumed and variables r and l for left and right
 *  blocks.
 */
 
function GOST_ENCRYPT_ROUND(key1, key2) {
    var tmp = (key1) + r;
    l ^= gost_sbox[0][tmp & 0xff] ^ gost_sbox[1][(tmp >>> 8) & 0xff] ^ gost_sbox[2][(tmp >>> 16) & 0xff] ^ gost_sbox[3][(tmp >>> 24) & 0xff];
    tmp = (key2) + l;
    r ^= gost_sbox[0][tmp & 0xff] ^ gost_sbox[1][(tmp >>> 8) & 0xff] ^ gost_sbox[2][(tmp >>> 16) & 0xff] ^ gost_sbox[3][(tmp >>> 24) & 0xff];
}
 
/* encrypt a block with the given key */
 
function GOST_ENCRYPT(ii, key, varhash) {
    r = varhash[ii], l = varhash[ii + 1];
    GOST_ENCRYPT_ROUND(key[0], key[1]);
    GOST_ENCRYPT_ROUND(key[2], key[3]);
    GOST_ENCRYPT_ROUND(key[4], key[5]);
    GOST_ENCRYPT_ROUND(key[6], key[7]);
    GOST_ENCRYPT_ROUND(key[0], key[1]);
    GOST_ENCRYPT_ROUND(key[2], key[3]);
    GOST_ENCRYPT_ROUND(key[4], key[5]);
    GOST_ENCRYPT_ROUND(key[6], key[7]);
    GOST_ENCRYPT_ROUND(key[0], key[1]);
    GOST_ENCRYPT_ROUND(key[2], key[3]);
    GOST_ENCRYPT_ROUND(key[4], key[5]);
    GOST_ENCRYPT_ROUND(key[6], key[7]);
    GOST_ENCRYPT_ROUND(key[7], key[6]);
    GOST_ENCRYPT_ROUND(key[5], key[4]);
    GOST_ENCRYPT_ROUND(key[3], key[2]);
    GOST_ENCRYPT_ROUND(key[1], key[0]);
    return [l, r];
}
 
/**
 * The core transformation. Process a 512-bit block.
 *
 * @param block the message block to process
 */
 
function gost_block_compress(block) {
    var key = new Array(8);
    var u = new Array(8);
    var v = new Array(8);
    var w = new Array(8);
    var s = new Array(8);
 
    /* u := hash, v := <256-bit message block> */
    for (var i = 0; i < 8; i++) {
        u[i] = hash[i];
        v[i] = block[i];
    }
 
    /* w := u xor v */
    w[0] = u[0] ^ v[0];
    w[1] = u[1] ^ v[1];
    w[2] = u[2] ^ v[2];
    w[3] = u[3] ^ v[3];
    w[4] = u[4] ^ v[4];
    w[5] = u[5] ^ v[5];
    w[6] = u[6] ^ v[6];
    w[7] = u[7] ^ v[7];
 
    /* calculate keys, encrypt hash and store result to the s[] array */
    for (var i = 0;; i += 2) { /* key generation: key_i := P(w) */
        key[0] = (w[0] & 0x000000ff) | ((w[2] & 0x000000ff) << 8) | ((w[4] & 0x000000ff) << 16) | ((w[6] & 0x000000ff) << 24);
        key[1] = ((w[0] & 0x0000ff00) >>> 8) | (w[2] & 0x0000ff00) | ((w[4] & 0x0000ff00) << 8) | ((w[6] & 0x0000ff00) << 16);
        key[2] = ((w[0] & 0x00ff0000) >>> 16) | ((w[2] & 0x00ff0000) >>> 8) | (w[4] & 0x00ff0000) | ((w[6] & 0x00ff0000) << 8);
        key[3] = ((w[0] & 0xff000000) >>> 24) | ((w[2] & 0xff000000) >>> 16) | ((w[4] & 0xff000000) >>> 8) | (w[6] & 0xff000000);
        key[4] = (w[1] & 0x000000ff) | ((w[3] & 0x000000ff) << 8) | ((w[5] & 0x000000ff) << 16) | ((w[7] & 0x000000ff) << 24);
        key[5] = ((w[1] & 0x0000ff00) >>> 8) | (w[3] & 0x0000ff00) | ((w[5] & 0x0000ff00) << 8) | ((w[7] & 0x0000ff00) << 16);
        key[6] = ((w[1] & 0x00ff0000) >>> 16) | ((w[3] & 0x00ff0000) >>> 8) | (w[5] & 0x00ff0000) | ((w[7] & 0x00ff0000) << 8);
        key[7] = ((w[1] & 0xff000000) >>> 24) | ((w[3] & 0xff000000) >>> 16) | ((w[5] & 0xff000000) >>> 8) | (w[7] & 0xff000000);
 
        /* encryption: s_i := E_{key_i} (h_i) */
        var res = GOST_ENCRYPT(i, key, hash);
        s[i] = res[0];
        s[i + 1] = res[1];
 
        if (i == 0) { /* w:= A(u) ^ A^2(v) */
            w[0] = u[2] ^ v[4];
            w[1] = u[3] ^ v[5];
            w[2] = u[4] ^ v[6];
            w[3] = u[5] ^ v[7];
            w[4] = u[6] ^ (v[0] ^= v[2]);
            w[5] = u[7] ^ (v[1] ^= v[3]);
            w[6] = (u[0] ^= u[2]) ^ (v[2] ^= v[4]);
            w[7] = (u[1] ^= u[3]) ^ (v[3] ^= v[5]);
        } else if ((i & 2) != 0) {
            if (i == 6) break; /* w := A^2(u) xor A^4(v) xor C_3; u := A(u) xor C_3 */
            /* C_3=0xff00ffff000000ffff0000ff00ffff0000ff00ff00ff00ffff00ff00ff00ff00 */
            u[2] ^= u[4] ^ 0x000000ff;
            u[3] ^= u[5] ^ 0xff00ffff;
            u[4] ^= 0xff00ff00;
            u[5] ^= 0xff00ff00;
            u[6] ^= 0x00ff00ff;
            u[7] ^= 0x00ff00ff;
            u[0] ^= 0x00ffff00;
            u[1] ^= 0xff0000ff;
 
            w[0] = u[4] ^ v[0];
            w[2] = u[6] ^ v[2];
            w[4] = u[0] ^ (v[4] ^= v[6]);
            w[6] = u[2] ^ (v[6] ^= v[0]);
            w[1] = u[5] ^ v[1];
            w[3] = u[7] ^ v[3];
            w[5] = u[1] ^ (v[5] ^= v[7]);
            w[7] = u[3] ^ (v[7] ^= v[1]);
        } else { /* i==4 here */
            /* w:= A( A^2(u) xor C_3 ) xor A^6(v) */
            w[0] = u[6] ^ v[4];
            w[1] = u[7] ^ v[5];
            w[2] = u[0] ^ v[6];
            w[3] = u[1] ^ v[7];
            w[4] = u[2] ^ (v[0] ^= v[2]);
            w[5] = u[3] ^ (v[1] ^= v[3]);
            w[6] = (u[4] ^= u[6]) ^ (v[2] ^= v[4]);
            w[7] = (u[5] ^= u[7]) ^ (v[3] ^= v[5]);
        }
    }
 
    /* step hash function: x(block, hash) := psi^61(hash xor psi(block xor psi^12(S))) */
 
    /* 12 rounds of the LFSR and xor in <message block> */
    u[0] = block[0] ^ s[6];
    u[1] = block[1] ^ s[7];
    u[2] = block[2] ^ (s[0] << 16) ^ (s[0] >>> 16) ^ (s[0] & 0xffff) ^ (s[1] & 0xffff) ^ (s[1] >>> 16) ^ (s[2] << 16) ^ s[6] ^ (s[6] << 16) ^ (s[7] & 0xffff0000) ^ (s[7] >>> 16);
    u[3] = block[3] ^ (s[0] & 0xffff) ^ (s[0] << 16) ^ (s[1] & 0xffff) ^ (s[1] << 16) ^ (s[1] >>> 16) ^ (s[2] << 16) ^ (s[2] >>> 16) ^ (s[3] << 16) ^ s[6] ^ (s[6] << 16) ^ (s[6] >>> 16) ^ (s[7] & 0xffff) ^ (s[7] << 16) ^ (s[7] >>> 16);
    u[4] = block[4] ^ (s[0] & 0xffff0000) ^ (s[0] << 16) ^ (s[0] >>> 16) ^ (s[1] & 0xffff0000) ^ (s[1] >>> 16) ^ (s[2] << 16) ^ (s[2] >>> 16) ^ (s[3] << 16) ^ (s[3] >>> 16) ^ (s[4] << 16) ^ (s[6] << 16) ^ (s[6] >>> 16) ^ (s[7] & 0xffff) ^ (s[7] << 16) ^ (s[7] >>> 16);
    u[5] = block[5] ^ (s[0] << 16) ^ (s[0] >>> 16) ^ (s[0] & 0xffff0000) ^ (s[1] & 0xffff) ^ s[2] ^ (s[2] >>> 16) ^ (s[3] << 16) ^ (s[3] >>> 16) ^ (s[4] << 16) ^ (s[4] >>> 16) ^ (s[5] << 16) ^ (s[6] << 16) ^ (s[6] >>> 16) ^ (s[7] & 0xffff0000) ^ (s[7] << 16) ^ (s[7] >>> 16);
    u[6] = block[6] ^ s[0] ^ (s[1] >>> 16) ^ (s[2] << 16) ^ s[3] ^ (s[3] >>> 16) ^ (s[4] << 16) ^ (s[4] >>> 16) ^ (s[5] << 16) ^ (s[5] >>> 16) ^ s[6] ^ (s[6] << 16) ^ (s[6] >>> 16) ^ (s[7] << 16);
    u[7] = block[7] ^ (s[0] & 0xffff0000) ^ (s[0] << 16) ^ (s[1] & 0xffff) ^ (s[1] << 16) ^ (s[2] >>> 16) ^ (s[3] << 16) ^ s[4] ^ (s[4] >>> 16) ^ (s[5] << 16) ^ (s[5] >>> 16) ^ (s[6] >>> 16) ^ (s[7] & 0xffff) ^ (s[7] << 16) ^ (s[7] >>> 16);
 
    /* 1 round of the LFSR (a mixing transformation) and xor with <hash> */
    v[0] = hash[0] ^ (u[1] << 16) ^ (u[0] >>> 16);
    v[1] = hash[1] ^ (u[2] << 16) ^ (u[1] >>> 16);
    v[2] = hash[2] ^ (u[3] << 16) ^ (u[2] >>> 16);
    v[3] = hash[3] ^ (u[4] << 16) ^ (u[3] >>> 16);
    v[4] = hash[4] ^ (u[5] << 16) ^ (u[4] >>> 16);
    v[5] = hash[5] ^ (u[6] << 16) ^ (u[5] >>> 16);
    v[6] = hash[6] ^ (u[7] << 16) ^ (u[6] >>> 16);
    v[7] = hash[7] ^ (u[0] & 0xffff0000) ^ (u[0] << 16) ^ (u[1] & 0xffff0000) ^ (u[1] << 16) ^ (u[6] << 16) ^ (u[7] & 0xffff0000) ^ (u[7] >>> 16);
 
    /* 61 rounds of LFSR, mixing up hash */
    hash[0] = (v[0] & 0xffff0000) ^ (v[0] << 16) ^ (v[0] >>> 16) ^ (v[1] >>> 16) ^ (v[1] & 0xffff0000) ^ (v[2] << 16) ^ (v[3] >>> 16) ^ (v[4] << 16) ^ (v[5] >>> 16) ^ v[5] ^ (v[6] >>> 16) ^ (v[7] << 16) ^ (v[7] >>> 16) ^ (v[7] & 0xffff);
    hash[1] = (v[0] << 16) ^ (v[0] >>> 16) ^ (v[0] & 0xffff0000) ^ (v[1] & 0xffff) ^ v[2] ^ (v[2] >>> 16) ^ (v[3] << 16) ^ (v[4] >>> 16) ^ (v[5] << 16) ^ (v[6] << 16) ^ v[6] ^ (v[7] & 0xffff0000) ^ (v[7] >>> 16);
    hash[2] = (v[0] & 0xffff) ^ (v[0] << 16) ^ (v[1] << 16) ^ (v[1] >>> 16) ^ (v[1] & 0xffff0000) ^ (v[2] << 16) ^ (v[3] >>> 16) ^ v[3] ^ (v[4] << 16) ^ (v[5] >>> 16) ^ v[6] ^ (v[6] >>> 16) ^ (v[7] & 0xffff) ^ (v[7] << 16) ^ (v[7] >>> 16);
    hash[3] = (v[0] << 16) ^ (v[0] >>> 16) ^ (v[0] & 0xffff0000) ^ (v[1] & 0xffff0000) ^ (v[1] >>> 16) ^ (v[2] << 16) ^ (v[2] >>> 16) ^ v[2] ^ (v[3] << 16) ^ (v[4] >>> 16) ^ v[4] ^ (v[5] << 16) ^ (v[6] << 16) ^ (v[7] & 0xffff) ^ (v[7] >>> 16);
    hash[4] = (v[0] >>> 16) ^ (v[1] << 16) ^ v[1] ^ (v[2] >>> 16) ^ v[2] ^ (v[3] << 16) ^ (v[3] >>> 16) ^ v[3] ^ (v[4] << 16) ^ (v[5] >>> 16) ^ v[5] ^ (v[6] << 16) ^ (v[6] >>> 16) ^ (v[7] << 16);
    hash[5] = (v[0] << 16) ^ (v[0] & 0xffff0000) ^ (v[1] << 16) ^ (v[1] >>> 16) ^ (v[1] & 0xffff0000) ^ (v[2] << 16) ^ v[2] ^ (v[3] >>> 16) ^ v[3] ^ (v[4] << 16) ^ (v[4] >>> 16) ^ v[4] ^ (v[5] << 16) ^ (v[6] << 16) ^ (v[6] >>> 16) ^ v[6] ^ (v[7] << 16) ^ (v[7] >>> 16) ^ (v[7] & 0xffff0000);
    hash[6] = v[0] ^ v[2] ^ (v[2] >>> 16) ^ v[3] ^ (v[3] << 16) ^ v[4] ^ (v[4] >>> 16) ^ (v[5] << 16) ^ (v[5] >>> 16) ^ v[5] ^ (v[6] << 16) ^ (v[6] >>> 16) ^ v[6] ^ (v[7] << 16) ^ v[7];
    hash[7] = v[0] ^ (v[0] >>> 16) ^ (v[1] << 16) ^ (v[1] >>> 16) ^ (v[2] << 16) ^ (v[3] >>> 16) ^ v[3] ^ (v[4] << 16) ^ v[4] ^ (v[5] >>> 16) ^ v[5] ^ (v[6] << 16) ^ (v[6] >>> 16) ^ (v[7] << 16) ^ v[7];
}
 
/**
 * Update block sum and message hash.
 *
 * @param block the 256-bit message block to process
 */
 
function gost_compute_sum_and_hash(block) { /* compute the 256-bit sum */
 
    var carry = 0;
    var hb = 0;
 
    for (var i = 0; i < 8; i++) {
        hb = (sum[i] >>> 24);
        sum[i] = (sum[i] & 0x00ffffff) + (block[i] & 0x00ffffff) + carry;
        hb = hb + (block[i] >>> 24) + (sum[i] >>> 24);
        sum[i] = (sum[i] & 0x00ffffff) | ((hb & 0xff) << 24);
        carry = ((hb & 0x100) != 0 ? 1 : 0);
    } /* update message hash */
    gost_block_compress(block);
}
 
/**
 * Calculate message hash.
 * Can be called repeatedly with chunks of the message to be hashed.
 *
 * @param _msg message chunk
 * @param _size length of the message chunk
 */
 
function gost_update(_msg, _size) {
    var index = length & 31;
    var msg = _msg,
        pmsg = 0;
    var size = _size;
    var msg32 = new Array(8);
 
    length += size;
 
    /* fill partial block */
    if (index != 0) {
        left = 32 - index;
        if (size < left) {
            for (var i = 0; i < size; i++) message[index + i] = msg[i];
            return;
        } else for (var i = 0; i < left; i++) message[index + i] = msg[i];
 
        /* process partitial block */
        for (var i = 0; i < 8; i++) msg32[i] = ((message[4 * i] & 0xff)) | ((message[4 * i + 1] & 0xff) << 8) | ((message[4 * i + 2] & 0xff) << 16) | ((message[4 * i + 3] & 0xff) << 24);
        gost_compute_sum_and_hash(msg32);
        pmsg += left;
        size -= left;
    }
    while (size >= 32) {
        for (var i = 0; i < 8; i++) {
            message[4 * i] = msg[pmsg + 4 * i];
            message[4 * i + 1] = msg[pmsg + 4 * i + 1];
            message[4 * i + 2] = msg[pmsg + 4 * i + 2];
            message[4 * i + 3] = msg[pmsg + 4 * i + 3];
            msg32[i] = ((message[4 * i] & 0xff)) | ((message[4 * i + 1] & 0xff) << 8) | ((message[4 * i + 2] & 0xff) << 16) | ((message[4 * i + 3] & 0xff) << 24);
        }
        gost_compute_sum_and_hash(msg32);
        pmsg += 32;
        size -= 32;
    }
    if (size != 0) {
        for (var i = 0; i < size; i++) {
            message[i] = msg[pmsg + i];
        }
    }
}
 
/**
 * Finish hashing and store message digest into given array.
 *
 * @param result calculated hash in binary form
 */
 
function gost_final() {
    var index = length & 31;
    var msg32 = new Array(8);
 
    /* pad the last block with zeroes and hash it */
    if (index > 0) {
        for (var i = 0; i < 32 - index; i++) {
            message[index + i] = 0;
        }
        for (var i = 0; i < 8; i++) {
            msg32[i] = ((message[4 * i] & 0xff)) | ((message[4 * i + 1] & 0xff) << 8) | ((message[4 * i + 2] & 0xff) << 16) | ((message[4 * i + 3] & 0xff) << 24);
        }
        gost_compute_sum_and_hash(msg32);
    }
 
    /* hash the message length and the sum */
    msg32[0] = (length << 3);
    msg32[1] = (length >>> 29);
    for (var i = 2; i < 8; i++) {
        msg32[i] = 0;
    }
 
    gost_block_compress(msg32);
    gost_block_compress(sum);
 
}
 
/* initialize the lookup tables */
 
function gost_init_table() {
    var ax, bx, cx, dx;
 
    for (var i = 0, a = 0; a < 16; a++) {
        ax = sbox[1][a] << 15;
        bx = sbox[3][a] << 23;
        cx = rol(sbox[5][a], 31);
        dx = sbox[7][a] << 7;
 
        for (var b = 0; b < 16; b++, i++) {
            gost_sbox[0][i] = ax | (sbox[0][b] << 11);
            gost_sbox[1][i] = bx | (sbox[2][b] << 19);
            gost_sbox[2][i] = cx | (sbox[4][b] << 27);
            gost_sbox[3][i] = dx | (sbox[6][b] << 3);
        }
    }
}
 
function gosthash(v) {
    var rx = new Array(8);
    var x = str2bytes(Utf8.encode(v));
    gost_init();
    gost_init_table();
    gost_update(x, x.length);
    gost_final();
    for (var i = 0; i < 8; i++) rx[i] = ch2hex(hash[i] & 0xff) + ch2hex((hash[i] >>> 8) & 0xff) + ch2hex((hash[i] >>> 16) & 0xff) + ch2hex((hash[i] >>> 24) & 0xff);
    return (rx.join(""));
}
 
print(gosthash(readline())); // output it
while(str = readline()) {
        print(gosthash(str));
}


// input / output show all hide all
// # 23 # 22 # 21 # 20 # 19 # 18 # 17 # 16 # 15 # 14 # 13 # 12 # 11 # 10 # 9 # 8 # 7 # 6 # 5 # 4 # 3 # 2 # 1
// upload with new input
// # 23:   show   clone   input   11 days 15 hours ago    Success
// # 22:   show   clone   input   13 days 19 hours ago    Success
// # 21:   show   clone   input   34 days 13 hours ago    Success
// # 20:   show   clone   input   34 days 13 hours ago    Success
// # 19:   show   clone   input   42 days 22 hours ago    Success
// # 18:   show   clone   input   42 days 22 hours ago    Success
// # 17:   show   clone   input   42 days 22 hours ago    Success
// # 16:   show   clone   input   46 days 10 hours ago    Success
// # 15:   show   clone   input   46 days 10 hours ago    Success
// # 14:   show   clone   input   60 days 17 hours ago    Success
// # 13:   show   clone   input   60 days 17 hours ago    Success
// # 12:   show   clone   input   65 days 9 hours ago    Success
// # 11:   show   clone   input   74 days 1 hour ago    Success
// # 10:   show   clone   input   74 days 1 hour ago    Success
// # 9:   show   clone   input   74 days 1 hour ago    Success
// # 8:   show   clone   input   74 days 1 hour ago    Success
// # 7:   show   clone   input   87 days 14 hours ago    Success
// # 6:   show   clone   input   95 days 21 hours ago    Success
// # 5:   show   clone   input   109 days 21 hours ago    Success
// # 4:   show   clone   input   118 days 15 hours ago    Success
// # 3:   show   clone   input   147 days 13 hours ago    Success
// # 2:   show   clone   input   191 days 12 hours ago    Success
// # 1:   hide   clone   input   192 days 11 hours ago
// result: Success     time: 0.03s    memory: 5520 kB     returned value: 0 

 

// input:
// a
// abc
// message digest
// ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789
// 12345678901234567890123456789012345678901234567890123456789012345678901234567890
// This is message, length=32 bytes
// Suppose the original message has length = 50 bytes
// UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
// The quick brown fox jumps over the lazy dog
// The quick brown fox jumps over the lazy cog
// output:
// ce85b99cc46752fffee35cab9a7b0278abb4c2d2055cff685af4912c49490f8d
// d42c539e367c66e9c88a801f6649349c21871b4344c6a573f849fdce62f314dd
// f3134348c44fb1b2a277729e2285ebb5cb5e0f29c975bc753b70497c06a4d51d
// ad4434ecb18f2c99b60cbe59ec3d2469582b65273f48de72db2fde16a4889a4d
// 95c1af627c356496d80274330b2cff6a10c67b5f597087202f94d06d2338cf8e
// cc178dcad4df619dcaa00aac79ca355c00144e4ada2793d7bd9b3518ead3ccd3
// b1c466d37519b82e8319819ff32595e047a28cb6f83eff1c6916a815a637fffa
// 471aba57a60a770d3a76130635c1fbea4ef14de51f78b4ae57dd893b62f55208
// 53a3a3ed25180cef0c1d85a074273e551c25660a87062a52d926a9e8fe5733a4
// 77b7fa410c9ac58a25f49bca7d0468c9296529315eaca76bd1a10f376d1f4294
// a3ebc4daaab78b0be131dab5737a7f67e602670d543521319150d2e14eeec445
// author's note
// Example hashes