%ifndef STRREV_S
%define STRREV_S

%include "strlen.s"

section .text

; Reverses a string in place.
; The passed string must be null terminated.
;
; void strrev(char *s)
;
global strrev
strrev:
  ; r12:  input string
  ; r8:   highest index of string
  ; rax:  loop count
  ; r10:  loop index
  ; cl:  left character
  ; dl:  right character
  push r12

  mov r12, rdi              ; set input string
  xor r10, r10              ; set loop index to 0
  
  call strlen               ; string already in rdi
  lea r8, [rax - 1]         ; set highest index of string
  xor rdx, rdx              ; zero out upper portion of division
  mov rdi, 2                ; set divisor
  div rdi                   ; rax = string length / 2

.reverse_loop:
  cmp r10, rax
  jge .return             
  
  mov rsi, r8
  sub rsi, r10

  mov cl, [r12 + r10]
  mov dl, [r12 + rsi]

  mov [r12 + r10], dl
  mov [r12 + rsi], cl
  
  inc r10
  jmp .reverse_loop

.return:
  pop r12
  ret

%endif