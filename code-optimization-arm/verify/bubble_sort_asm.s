.text
.global bubble_sort_asm
.arch armv8-a
.type bubble_sort_asm, %function

bubble_sort_asm:
    sub w1, w1, #1       // r1 = N-1
    mov w5, #0           // r2 = 0 
oloop:
    cmp w5, w1           // if i == N-1 ?
    beq exito            // yes, end
    mov w3, #0           // j = 0
    mov w2, x0           // r2 = &data
    ldr w11, [x2]

iloop:
    cmp w3, w1           // if j == N-1 ?
    beq exiti            // yes, next i
    ldr w10, [x2, #4]!   // Load data[j+1] and increment x2
    cmp w10, w11
    ble skip1
    stp w10, w11, [x2, #-4] // Swap data[j] and data[j+1]
    b skip2

skip1:
    mov w11, w10
    add w3, w3, #1       // j++
    b iloop

exiti:
    add w5, w5, #1       // i++
    b oloop

exito:
    mov w0, #1
    ret