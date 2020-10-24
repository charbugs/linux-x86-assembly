%ifndef ISSPACE_S
%define ISSPACE_S

section .text

; returns true if char is ascii space, false otherwise
; bool isspace(char c)
global isspace
isspace:
  cmp rdi, 9
  je .return_true
  cmp rdi, 10
  je .return_true
  cmp rdi, 11
  je .return_true
  cmp rdi, 12
  je .return_true
  cmp rdi, 13
  je .return_true
  cmp rdi, 32
  je .return_true
  
.return_false:
  mov rax, 0
  ret

.return_true:
  mov rax, 1
  ret

%endif