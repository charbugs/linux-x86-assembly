%ifndef PRINTF_S
%define PRINTF_S

%include "ltoa.s"
%include "print.s"
%include "strrev.s"

; stack offset of format string
%define off_form_string 8
; stack offset of the current of format argument index
%define off_arg_count 16
; stack offset of the current string chunk
; i.e. the string chunks between format arguments
%define off_str_chunk 17

; prints the string chunk that is recorded on the stack
; and sets the stack pointer so we can record a new chunk
%macro print_chunk 0
  mov rdi, rsp
  call strrev
  mov rdi, rsp
  call print
  lea rsp, [rbp - off_str_chunk]
%endmacro

; moves the next stack argument to rdi
%macro mov_next_stack_arg_to_rdi 0
  mov rax, [rbp - off_arg_count]
  inc qword [rbp - off_arg_count]
  mov rdi, [rbp + (rax * 8) + 16]
%endmacro

section .bss
  ; ltoa() will store the digits here
  digits resb 20

section .text 
global printf
printf:
  push rbp
  mov rbp, rsp
  sub rsp, 17

  mov qword [rbp - off_form_string], rdi  ; save the 1st argument (format string)
  mov qword [rbp - off_arg_count], 0      ; current format argument count is 0
  mov byte [rbp - off_str_chunk], 0       ; set null termination byte for string chunk

.check_next_char:
  mov rax, [rbp - off_form_string]        ; get current char of format string
  cmp byte [rax], 0                       ; if char is NULL ...
  je .return                              ; then return
  cmp byte [rax], "%"                     ; if char is %
  je .possibly_print_argument             ; then jump to label

.add_to_chunk:
  mov cl, [rax]                           ; get current char of format string
  sub rsp, 1                              ; extend stack to save one char
  mov byte [rsp], cl                      ; store current char on stack

.continue:
  inc qword [rbp - off_form_string]       ; point to next char of format string
  jmp .check_next_char                    ; loop

.possibly_print_argument:                 ; at this point we know, that we have a % char 
  mov rax, [rbp - off_form_string]        
  cmp byte [rax + 1], "s"                 ; if the "% "is followed by a "s"
  je .print_string_argument               ; then print string
  cmp byte [rax + 1], "d"                 ; if the "%" if followd by s "n"
  je .print_number_argument               ; then print number
  jmp .add_to_chunk                       ; otherwise proceed constructing the chunk on stack

.print_string_argument:
  print_chunk                             ; before we print the string argument we print the chunk recorded so far
  mov_next_stack_arg_to_rdi               ; set the corresponding string argument as 1st arg to print()
  call print                              ; print string argument
  inc qword [rbp - off_form_string]       ; skip the current "s", because we don't want to print it
  jmp .continue                           ; continue recording the next chunk

.print_number_argument:   
  print_chunk                             ; before we print the string argument we print the chunk recorded so far            
  mov_next_stack_arg_to_rdi               ; set the corresponding number argument as 1st arg to ltoa()
  mov rsi, digits                         ; set the digit string as the 2nd arg t ltoa()
  call ltoa                               ; transfrom number to string
  mov rdi, digits                         ; set the digit string as 1st arg to print()
  call print                              ; print digits
  inc qword [rbp - off_form_string]       ; skip the current "n" because we don't want to print it
  jmp .continue                           ; continue recording the next chunk

.return:
  print_chunk                             ; print the last chunk
  mov rsp, rbp
  pop rbp
  ret

%endif