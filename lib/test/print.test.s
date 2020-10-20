%include "../src/constants.s"
%include "../src/print.s"

section .data
  msg db "hello", 0

section .text

global _start
_start:
  mov rdi, msg
  call print
  cmp rax, 5
  jne exit_fail

exit_success:
  mov rax, SYS_EXIT
  mov rdi, 0
  syscall

exit_fail:
  mov rax, SYS_EXIT
  mov rdi, 1
  syscall