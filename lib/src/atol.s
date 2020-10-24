%ifndef ATOL_S
%define ATOL_S

%include "isdigit.s"
%include "isspace.s"

section .text

; similar to man atol(3)
; passed string must be null terminated.
; long atoi(char* s)
global atol
atol:
  push r12
  push r13
  push r14
  push r15
  mov r12, rdi      ; string that was passed
  xor r13, r13      ; number to calculate
  mov r14, 10

.space_loop:
  movzx rdi, byte [r12]
  call isspace
  cmp rax, 0
  je .check_sign
  inc r12
  jmp .space_loop

.check_sign:
  cmp byte [r12], "+"
  je .set_plus
  cmp byte [r12], "-"
  je .set_minus
  jmp .calc_loop

.set_plus:
  mov r15, 0
  inc r12
  jmp .calc_loop

.set_minus:
  mov r15, 1
  inc r12
  jmp .calc_loop

.calc_loop:
  movzx rdi, byte [r12]
  call isdigit
  cmp rax, 0
  je .possibly_negate                  ; if current char isn't a digit return what we calculatet so far
  movzx rdi, byte [r12]       ; copy current digit
  sub rdi, "0"                ; get integer value of digit
  mov rax, r13
  mul r14
  mov r13, rax
  add r13, rdi
  inc r12
  jmp .calc_loop

.possibly_negate:
  cmp r15, 0
  je .return
  neg r13

.return:
  mov rax, r13
  pop r15
  pop r14
  pop r13
  pop r12
  ret

%endif