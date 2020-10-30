%ifndef PRINTF_S
%define PRINTF_S

%include "ltoa.s"
%include "print.s"
%include "strrev.s"

%define off_form_string 8
%define off_arg_count 16
%define off_str_chunk 17

%macro print_chunk 0
  mov rdi, rsp
  call strrev
  mov rdi, rsp
  call print
  lea rsp, [rbp - off_str_chunk]
%endmacro

%macro mov_next_stack_arg_to_rdi 0
  mov rax, [rbp - off_arg_count]
  inc qword [rbp - off_arg_count]
  mov rdi, [rbp + (rax * 8) + 16]
%endmacro

section .data
  digits db 20

section .text 
global printf
printf:
  push rbp
  mov rbp, rsp
  sub rsp, 17

  mov qword [rbp - off_form_string], rdi
  mov qword [rbp - off_arg_count], 0
  mov byte [rbp - off_str_chunk], 0

.check_next_char:
  mov rax, [rbp - off_form_string]
  cmp byte [rax], 0
  je .return
  cmp byte [rax], "%"
  je .possibly_print_argument

.add_to_chunk:
  mov cl, [rax]
  sub rsp, 1
  mov byte [rsp], cl

.continue:
  inc qword [rbp - off_form_string]
  jmp .check_next_char 

.possibly_print_argument:
  mov rax, [rbp - off_form_string]
  cmp byte [rax + 1], "s"
  je .print_string_argument
  cmp byte [rax + 1], "d"
  je .print_number_argument
  jmp .add_to_chunk

.print_string_argument:
  print_chunk
  mov_next_stack_arg_to_rdi
  call print
  inc qword [rbp - off_form_string]
  jmp .continue

.print_number_argument:
  print_chunk
  mov_next_stack_arg_to_rdi
  mov rsi, digits
  call ltoa
  mov rdi, digits
  call print
  inc qword [rbp - off_form_string]
  jmp .continue

.return:
  print_chunk
  mov rsp, rbp
  pop rbp
  ret

%endif