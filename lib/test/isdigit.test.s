%include "assert.s"
%include "isdigit.s"

section .text
global _start
_start:

.test_1:
  set_non_volatile_registers
  mov rdi, "0"
  call isdigit
  assert_non_volatile_registers 1

.test_2:
  mov rdi, "0"
  call isdigit
  assert rax, 1, 2

.test_3:
  mov rdi, "9"
  call isdigit
  assert rax, 1, 3

.test_4:
  mov rdi, "/"
  call isdigit
  assert rax, 0, 4

.test_5:
  mov rdi, ":"
  call isdigit
  assert rax, 0, 5

  exit 0