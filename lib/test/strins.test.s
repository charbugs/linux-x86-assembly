%include "assert.s"
%include "strins.s"
%include "strcmp.s"

section .data
    child2 db "bar", 0
    parent2 db "foobaz", 0
    pos2 dq 3
    result2 db "foobarbaz", 0

    child3 db "bar", 0
    parent3 db "foobaz", 0
    pos3 dq 0
    result3 db "barfoobaz", 0

    child4 db "bar", 0
    parent4 db "foobaz", 0
    pos4 dq 6
    result4 db "foobazbar", 0

    child5 db "", 0
    parent5 db "foobaz", 0
    pos5 dq 3
    result5 db "foobaz", 0

    child6 db "bar", 0
    parent6 db "", 0
    pos6 dq 0
    result6 db "bar", 0

section .text

global _start
_start:

test_1:
    set_non_volatile_registers
    mov rdi, child2
    mov rsi, parent2
    mov rdx, [pos2]
    call strins
    assert_non_volatile_registers 1

test_2:
    mov rdi, child2
    mov rsi, parent2
    mov rdx, [pos2]
    call strins
    assert_str_eq rax, result2, 2

test_3:
    mov rdi, child3
    mov rsi, parent3
    mov rdx, [pos3]
    call strins
    assert_str_eq rax, result3, 3

test_4:
    mov rdi, child4
    mov rsi, parent4
    mov rdx, [pos4]
    call strins
    assert_str_eq rax, result4, 4

test_5:
    mov rdi, child5
    mov rsi, parent5
    mov rdx, [pos5]
    call strins
    assert_str_eq rax, result5, 5

test_6:
    mov rdi, child6
    mov rsi, parent6
    mov rdx, [pos6]
    call strins
    assert_str_eq rax, result6, 6

    exit 0
