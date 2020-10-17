%include "../src/utils/constants.s"
%include "../src/utils/println.s"

section .data
  msg db "hello", 0

section .text

global _start
_start:
  mov rdi, msg
  call println

exit:
  mov rax, SYS_EXIT
  mov rdi, 0
  syscall
