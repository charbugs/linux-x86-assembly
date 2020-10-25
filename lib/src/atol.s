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
  push r12          ; use: input string
  push r13          ; use: resulting number
  push r14          ; use: base 10
  push r15          ; use: sign

  mov r12, rdi      ; save input string
  xor r13, r13      ; set result number to null
  xor r15, r15      ; set sign to false (which means plus)
  mov r14, 10       ; set base 10

; forward string until we find the first non-space character
.space_loop:
  movzx rdi, byte [r12]
  call isspace
  cmp rax, 0
  je .check_sign
  inc r12
  jmp .space_loop

; check if the next character is a plus or minus sign
.check_sign:
  cmp byte [r12], "+"
  je .set_plus
  cmp byte [r12], "-"
  je .set_minus
  jmp .calc_loop

.set_plus:
  mov r15, 0        ; false means plus
  inc r12
  jmp .calc_loop

.set_minus:
  mov r15, 1        ; true means minus
  inc r12
  jmp .calc_loop

; calculate the number from the string
.calc_loop:
  movzx rdi, byte [r12]
  call isdigit
  cmp rax, 0
  je .possibly_negate         
  movzx rdi, byte [r12]
  sub rdi, "0"
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