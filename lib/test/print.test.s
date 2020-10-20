%include "../src/assert.s"
%include "../src/print.s"

section .data
  msg db "hello", 0

section .text

global _start
_start:
  mov rdi, msg
  call print
  assert rax, 5, 1
  exit 0