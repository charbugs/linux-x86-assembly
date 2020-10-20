%include "../src/assert.s"
%include "../src/println.s"

section .data
  msg db "hello", 0

section .text

global _start
_start:
  mov rdi, msg
  call println
  assert rax, 5, 1
  exit 0
  

