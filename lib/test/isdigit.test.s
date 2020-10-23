%include "assert.s"
%include "isdigit.s"

section .text
global _start
_start:

test_1:
  mov rdi, "0"
  call isdigit
  assert rax, 1, 1

test_2:
  mov rdi, "9"
  call isdigit
  assert rax, 1, 2

test_3:
  mov rdi, "/"
  call isdigit
  assert rax, 0, 3

test_4:
  mov rdi, ":"
  call isdigit
  assert rax, 0, 4

  exit 0