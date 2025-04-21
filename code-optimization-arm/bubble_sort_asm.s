.equ N, 32768
.comm data, N*4, 4
.global main
.arch armv8-a

main:
    ldr w1, =N
    sub w1, w1, #1       // r1 = N-1
    mov w5, #0           // r2 = 0

oloop:
    cmp w5, w1           // if i == N-1 ?
    b.eq exito           // yes, end
    mov w3, #0           // j = 0
    ldr x2, =data        // r2 = &data
    ldr w11, [x2]

iloop:
    cmp w3, w1           // if j == N-1 ?
    b.eq exiti           // yes, next i
    ldr w10, [x2, #4]!
    cmp w10, w11
    b.le skip1
    stp w10, w11, [x2, #-4]
    b skip2

skip1:
    mov w11, w10
    add w3, w3, #1       // j++
    b iloop

exiti:
    add w2, w2, #1       // i++
    b oloop

exito:
    br lr
