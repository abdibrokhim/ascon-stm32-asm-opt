notes

NIST: National Institute of Standards and Technology

Ascon designers: Christoph Dobraunig, Maria Eichlseder, Florian Mendel, and Martin Schläffe

Institute for Applied Information Processing and Communications 
Graz University of Technology
Infineon Technologies Austria AG

The authors also acknowledge and appreciate contributions from their colleagues at NIST during the selection process, including Lawrence Bassham, Çağdaş Çalık, Deukjo Hong, and Noah Waller. The authors also thank Elaine Barker, Lily Chen, Andrew Regenscheid, Noah Ross and Sara Kerman, who provided technical and administrative support.


references

https://competitions.cr.yp.to/round3/asconv12.pdf
https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-232.ipd.pdf


abstract

there was a need for a lightweight encryption algorithm for the internet of things. because as you know, the internet of things, embedded systems, and and low power sensors are resource constrained. here's ascon. ascon family is characterized by lightweight permutation-based primitives and provides robust security, efficiency, and flexibility, making it ideal for that stuff.


introduction

Ascon-AEAD128 is a nonce-based authenticated encryption with associated data
that provides 128-bit security strength in the single-key setting.

Ascon-Hash256 is a cryptographic hash function that produces a 256-bit hash of the
input messages, offering a security strength of 128 bits.

Ascon-XOF128 is an XOF, where the output size of the hash of the message can be
selected by the user, and the supported security strength is up to 128 bits.

Ascon-CXOF128 is a customized XOF that allows users to specify a customization
string and choose the output size of the message hash. It supports a security strength
of up to 128 bits.


Permutations. The Ascon submission defined three Ascon permutations having 6, 8, and 12 rounds. This standard specifies additional Ascon permutations by providing round constants for up to 16 rounds to accommodate potential functionality extensions in the future.

AEAD variants. The Ascon submission package defined AEAD variants ASCON-128, ASCON-128a, and ASCON-80pq. This standard specifies the Ascon-AEAD128 algorithm, which is based on ASCON-128a.

Hash function variants. The Ascon submission defined ASCON-HASH and ASCON-HASHA.
This standard specifies Ascon-Hash256, which is based on ASCON-HASH.

XOF variants. The Ascon submission defined two extendable output functions, ASCONXOF and ASCON-XOFA. This standard specifies Ascon-XOF128, which is based on ASCON-XOF, and a new customized XOF, Ascon-CXOF128.

Initial values. The initial values of the algorithms are updated to support a new format that accommodates potential functionality extensions.

Endianness. The endianness has been switched from big endian to little endian to improve performance on little-endian microcontrollers.

Truncation and nonce-masking. The implementation options of Ascon-AEAD128 with truncation and nonce-masking have been added.

Main Features of Ascon. The main features of the Ascon family are:
Multiple functionalities. The same permutations are used to construct multiple functionalities, which allows an implementation of AEAD, hash, and XOF functionalities to share logic and, therefore, have a more compact implementation than functions that were developed independently.

Online and single pass. Ascon-AEAD128 is online, meaning that the 𝑖-th ciphertext block is determined by the key, nonce, associated data, and the first 𝑖 plaintext blocks. Ascon family members require only a single pass over the data.

Inverse-free. Since all of the Ascon family members only use the underlying permutations in the forward direction, implementing the inverse permutations is not needed. This approach significantly reduces implementation costs compared to designs that require inverse operations for decryption.

