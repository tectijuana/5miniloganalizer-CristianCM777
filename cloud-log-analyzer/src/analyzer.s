/*
Autor: Camarillo Molina Cristian
Curso: Lenguaje de Interfaz
Práctica: Mini Cloud Log Analyzer (Bash + ARM64 + GNU Make)
Fecha: 23 de abril de 2026
Descripción: Lee códigos HTTP desde stdin (uno por línea), clasifica 2xx/4xx/5xx
             y muestra un reporte en español usando únicamente syscalls Linux.
*/

/*
Mini Cloud Log Analyzer - Variante D
Detecta 3 errores consecutivos y guarda logs
*/

.equ SYS_read, 63
.equ SYS_write, 64
.equ SYS_exit, 93
.equ STDIN, 0
.equ STDOUT, 1

.section .bss
buffer:         .skip 4096
num_buf:        .skip 32
errores_array:  .skip 8000

.section .data
msg_title: .asciz "=== Mini Cloud Log Analyzer ===\n"
msg_ok:    .asciz "Se detectaron 3 errores consecutivos\n\n"
msg_fail:  .asciz "No se detectaron 3 errores consecutivos\n\n"
msg_err:   .asciz "Errores detectados:\n"
space:     .asciz " "
nl:        .asciz "\n"

.section .text
.global _start

_start:
    mov x22, #0      // numero actual
    mov x23, #0      // flag digitos
    mov x27, #0      // contador errores
    mov x28, #0      // consecutivos
    mov x29, #0      // flag detección

leer:
    mov x0, #STDIN
    adrp x1, buffer
    add x1, x1, :lo12:buffer
    mov x2, #4096
    mov x8, #SYS_read
    svc #0

    cmp x0, #0
    beq fin
    blt exit

    mov x24, #0
    mov x25, x0

loop:
    cmp x24, x25
    b.ge leer

    adrp x1, buffer
    add x1, x1, :lo12:buffer
    ldrb w26, [x1, x24]
    add x24, x24, #1

    cmp w26, #10
    b.eq process

    cmp w26, #'0'
    b.lt loop
    cmp w26, #'9'
    b.gt loop

    mov x9, #10
    mul x22, x22, x9
    sub w26, w26, #'0'
    uxtw x26, w26
    add x22, x22, x26
    mov x23, #1
    b loop

process:
    cbz x23, reset
    mov x0, x22
    bl classify

reset:
    mov x22, #0
    mov x23, #0
    b loop

fin:
    cbz x23, print
    mov x0, x22
    bl classify

print:
    adrp x0, msg_title
    add x0, x0, :lo12:msg_title
    bl write_str

    cmp x29, #1
    b.eq ok
    adrp x0, msg_fail
    add x0, x0, :lo12:msg_fail
    bl write_str
    b list

ok:
    adrp x0, msg_ok
    add x0, x0, :lo12:msg_ok
    bl write_str

list:
    adrp x0, msg_err
    add x0, x0, :lo12:msg_err
    bl write_str

    mov x10, x27
    mov x11, #0

loop_print:
    cmp x11, x10
    b.ge end_print

    adrp x12, errores_array
    add x12, x12, :lo12:errores_array
    add x12, x12, x11, lsl #3

    ldr x0, [x12]
    bl print_uint

    adrp x0, space
    add x0, x0, :lo12:space
    bl write_str

    add x11, x11, #1
    b loop_print

end_print:
    adrp x0, nl
    add x0, x0, :lo12:nl
    bl write_str

exit:
    mov x0, #0
    mov x8, #SYS_exit
    svc #0

classify:
    cmp x0, #400
    b.lt ok_code
    cmp x0, #599
    b.gt ok_code

    add x28, x28, #1

    adrp x11, errores_array
    add x11, x11, :lo12:errores_array
    add x12, x11, x27, lsl #3
    str x0, [x12]

    add x27, x27, #1

    cmp x28, #3
    b.lt end_class
    mov x29, #1

end_class:
    ret

ok_code:
    mov x28, #0
    ret

write_str:
    mov x9, x0
    mov x10, #0

len:
    ldrb w11, [x9, x10]
    cbz w11, done
    add x10, x10, #1
    b len

done:
    mov x1, x9
    mov x2, x10
    mov x0, #STDOUT
    mov x8, #SYS_write
    svc #0
    ret

print_uint:
    cbnz x0, conv
    adrp x1, num_buf
    add x1, x1, :lo12:num_buf
    mov w2, #'0'
    strb w2, [x1]
    mov x0, #STDOUT
    mov x2, #1
    mov x8, #SYS_write
    svc #0
    ret

conv:
    adrp x12, num_buf
    add x12, x12, :lo12:num_buf
    add x12, x12, #31

    mov x14, #10
    mov x15, #0

loop2:
    udiv x16, x0, x14
    msub x17, x16, x14, x0
    add x17, x17, #'0'

    sub x12, x12, #1
    strb w17, [x12]
    add x15, x15, #1

    mov x0, x16
    cbnz x0, loop2

    mov x1, x12
    mov x2, x15
    mov x0, #STDOUT
    mov x8, #SYS_write
    svc #0
    ret
