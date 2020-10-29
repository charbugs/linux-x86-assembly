%include "assert.s"
%include "printc.s"

section .text
global _start
_start:

test_1:
  set_non_volatile_registers
  mov dl, "x"
  call printc
  assert_non_volatile_registers 1

  exit 0