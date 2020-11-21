%include "assert.s"
%include "randbyte.s"

section .text
global _start
_start:

.test_1:
    set_non_volatile_registers
    call randbyte
    assert_non_volatile_registers 1

    exit 0