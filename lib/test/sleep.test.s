%include "assert.s"
%include "sleep.s"

section .text
global _start
_start:

test_1:
    set_non_volatile_registers
    mov rdi, 0
    mov rsi, 0
    call sleep
    assert_non_volatile_registers 1

    exit 0
