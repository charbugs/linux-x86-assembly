%ifndef PRINT_S
%define PRINT_S

%include "constants.s"
%include "strlen.s"

section .text

; Prints a null terminated string to stdout and returns the string length.
; int print(char* string)
global print
print:
  push r12
  mov r12, rdi ; save string
  
  call strlen
  
  mov rdi, STDOUT ; 1st param: fd
  mov rsi, r12    ; 2nd param: string
  mov rdx, rax    ; 3rd param: length
  mov r12, rax    ; save string length
  mov rax, SYS_WRITE
  syscall

  mov rax, r12 ; return value: string length
  
  pop r12
  ret
  
%endif