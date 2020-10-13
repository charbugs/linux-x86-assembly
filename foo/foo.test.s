extern foo

section .text

global _start
_start:
  mov rdi, 42
  call foo
  push rax
  mov rax, 1
  mov rdi, 1
  mov rsi, rsp
  mov rdx, 1
  syscall

exit:
  mov rax, 60
  mov rdi, 0
  syscall