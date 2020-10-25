%ifndef STRCMP_S
%define STRCMP_S

%define left rdi
%define right rsi

section .text

; similar to man strcmp(3)
;
; int strcmp(char* left, char* right)
;
global strcmp
strcmp:
.compare_loop:
  cmp byte [left], 0
  je .calc_result
  mov cl, [right]
  cmp cl, [left]
  jne .calc_result
  inc left
  inc right
  jmp .compare_loop

.calc_result:
  xor rax, rax
  xor rcx, rcx
  mov al, [left]
  mov cl, [right]
  sub rax, rcx
  ret

%endif