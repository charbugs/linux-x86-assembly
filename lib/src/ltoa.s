%ifndef LTOA_S
%define LTOA_S

%include "strcpy.s"

section .text

; turns a number into a string
; 
; strategy is to interative divide the number by 10,
; transform the division rest into it's ascii respresentation
; and put it on the stack. finally copy the result from the stack
; to the passed destination string.
;
; void (long number, char *dest)
;
global ltoa
ltoa:
  push rbp
  mov rbp, rsp
  
  push rdi                ; save input number at rbp - 8
  push rsi                ; save destination string at rbp -16

  ; we use the absolute of the input number
  ; to calculate the digits and append a
  ; minus sign if necessary later on.
  mov rax, rdi
  neg rax
  cmovl rax, rdi          ; set abs number to rax

  sub rsp, 1
  mov byte [rsp], 0       ; set 0 on the stack to mark the end of the digit string that we're going to create
  mov r8, 10              ; base 10 

.loop:
  cqo                     ; widening conversion of rax: needed for signed division
  idiv r8                 ; divide abs number in rax by 10
  add dl, "0"             ; the division rest is in rdx. transform rest to ascii digit
  sub rsp, 1 
  mov [rsp], dl           ; copy digit to stack
  cmp rax, 0              ; are we finished?
  je .possibly_add_minus
  inc r9
  jmp .loop

.possibly_add_minus:
  ; compare the input number and add minus if negative
  cmp qword [rbp - 8], 0
  jge .copy_to_dest
  sub rsp, 1
  mov byte [rsp], "-"

.copy_to_dest:
  mov rdi, [rbp - 16]     ; the destination string
  mov rsi, rsp            ; the digit string
  call strcpy
  
.return:
  mov rsp, rbp
  pop rbp
  ret

%endif