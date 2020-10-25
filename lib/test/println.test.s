%include "../src/assert.s"
%include "../src/println.s"

section .data
  msg db "hello", 0
  empty db "", 0

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
  assert_cmp_eq rax, 5, 2

.test_3:
  mov rdi, empty
  call println
  assert_cmp_eq rax, 0, 3
  
  exit 0
  

