%include "assert.s"
%include "alloc.s"

section .text
global _start
_start:

test_1:
    set_non_volatile_registers
    mov rdi, 8
    call alloc
    assert_non_volatile_registers 1
    
test_2:
    ; allocate 8 bytes and save 42 to it
    mov rdi, 8
    call alloc
    mov r10, rax
    mov qword [r10], 42
    ; allcate another 8 bytes and save 23 to it
    mov rdi, 8
    call alloc
    mov r11, rax
    mov qword [r11], 23
    ; check that 42 is untouched
    mov rax, qword [r10]
    assert_cmp_eq rax, 42, 2

test_3:
    ; allocate 8 bytes and save 42 to it
    mov rdi, 8
    call alloc
    mov r10, rax
    mov qword [r10], 42
    ; free it
    mov rdi, r10
    call free
    ; allcate another 8 bytes and save 23 to it
    mov rdi, 8
    call alloc
    mov r11, rax
    mov qword [r11], 23
    ; the 23 should be at position of the old 42
    mov rax, qword [r10]
    assert_cmp_eq rax, 23, 3

    exit 0