%ifndef STRLEN_S
%define STRLEN_S

section .text

; similar to strlen(3)
; int strlen(char* string)
; global strlen
global strlen
strlen:
  xor rax, rax

count_loop:
  cmp byte [rdi], 0
  je .end
  inc rax
  inc rdi
  jmp count_loop

.end:
  ret

%endif