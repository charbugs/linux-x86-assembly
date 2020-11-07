%ifndef ATOL_S
%define ATOL_S

%include "isdigit.s"
%include "isspace.s"

; char* - null terminated input digit string
%define digits  [rbp - 8]
; long - output number
%define number  [rbp - 16]
; long - base 10 because digits represent a decimal number
%define base10  [rbp - 24]
; bool - 0 if +, 1 if -
%define sign    [rbp - 25]
; stack size
%define stack_size 25

section .text

; similar to man atol(3).
; passed string must be null terminated.
; only treats decimal.
;
; long atoi(char* digits)
;
global atol
atol:
  push rbp
  mov rbp, rsp
  sub rsp, stack_size

  mov digits, rdi
  mov qword number, 0
  mov qword base10, 10
  mov sign, byte 0

; forward string until we find the first non-space character
.space_loop:
  mov rdi, digits
  movzx rdi, byte [rdi]
  call isspace
  cmp rax, 0
  je .check_sign
  inc qword digits
  jmp .space_loop

; check if the next character is a plus or minus sign
.check_sign:
  mov rdi, digits
  cmp [rdi], byte "+"
  je .set_plus
  cmp [rdi], byte "-"
  je .set_minus
  jmp .calc_loop

.set_plus:
  mov sign, byte 0        ; false means plus
  inc qword digits
  jmp .calc_loop

.set_minus:
  mov sign, byte 1        ; true means minus
  inc qword digits
  jmp .calc_loop

; calculate the number from the string
.calc_loop:
  mov rdi, digits
  movzx rdi, byte [rdi]
  call isdigit
  cmp rax, 0
  je .possibly_negate         
  mov rdi, digits
  movzx rdi, byte [rdi]
  sub rdi, "0"
  mov rax, number
  mul qword base10
  mov number, rax
  add number, rdi
  inc qword digits
  jmp .calc_loop

.possibly_negate:
  cmp sign, byte 0
  je .return
  neg qword number

.return:
  mov rax, number
  mov rsp, rbp
  pop rbp
  ret

%endif