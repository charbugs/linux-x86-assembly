%include "assert.s"
%include "map.s"

section .data
    arr db 1,2,3,4,5

section .text

global _start
_start:

.test_1:
    set_non_volatile_registers
    mov rdi, plus_two
    mov rsi, arr
    mov rdx, 5
    call map_b2b
    assert_non_volatile_registers 1

.test_2:
    mov rdi, plus_two
    mov rsi, arr
    mov rdx, 5
    call map_b2b
    mov dl, [rax]
    assert_cmp_eq dl, 3, 2
    mov dl, [rax + 1]
    assert_cmp_eq dl, 4, 2
    mov dl, [rax + 2]
    assert_cmp_eq dl, 5, 2
    mov dl, [rax + 3]
    assert_cmp_eq dl, 6, 2
    mov dl, [rax + 4]
    assert_cmp_eq dl, 7, 2

    exit 0

; byte plus_two(byte x)
plus_two:
    mov al, dl
    add al, 2
    ret
