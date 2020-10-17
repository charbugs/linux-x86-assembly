section .text

; similar to strlen(3)
; int strlen(char* string)
global strlen
strlen:
  ; prologue
  push rbp
  mov rbp, rsp
  xor rax, rax

  ; locals
  sub rsp, 8
  mov [rsp + 0], rdi

.count_loop:
  cmp byte [rdi], 0
  je .end
  inc rax
  inc rdi
  jmp .count_loop

.end:
  mov rsp, rbp
  pop rbp
  ret

