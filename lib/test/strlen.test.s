%include "../src/assert.s"
%include "../src/strlen.s"

section .data
  msg db "hello", 0

section .text
global _start
_start:
  nop
  mov rdi, msg
  call strlen
  assert rax, 5, 1
  
  exit 0

  


