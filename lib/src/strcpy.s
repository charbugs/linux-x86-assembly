%ifndef STRCPY_S
%define STRCPY_S

section .text

; similar to strcpy(3)
; void strcpy(char *dest, char *src)
global strcpy
strcpy:
.loop:
  mov al, [rsi]
  mov [rdi], al
  cmp byte [rsi], 0
  je .return
  inc rdi
  inc rsi
  jmp .loop

.return:
  ret

%endif