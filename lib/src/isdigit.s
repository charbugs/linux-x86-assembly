%ifndef ISDIGIT_S
%define ISDIGIT_S

section .text

; similar to man isdigit(3)
; int isdigit(char c)
global isdigit
isdigit:
  cmp rdi, 48
  jl .return_false
  cmp rdi, 57
  jg .return_false
  mov rax, 1
  ret

.return_false:
  mov rax, 0
  ret

%endif