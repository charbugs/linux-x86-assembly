%include "../src/assert.s"
%include "../src/println.s"

section .data
  msg db "hello", 0

section .text

global _start
_start:

.test_1:
  set_non_volatile_registers
  mov rdi, msg
  call println
  assert_non_volatile_registers 1

.test_2:
  mov rdi, msg
  call println
  assert rax, 5, 2
  
  exit 0
  

