%ifndef PRINTC_S
%define PRINTC_S

%include "constants.s"

global printc
printc:
  mov [rsp - 1], dil
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  lea rsi, [rsp - 1]
  mov rdx, 1
  syscall
  ret
%endif