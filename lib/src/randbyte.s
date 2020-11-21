%ifndef RANDBYTE_S
%define RANDBYTE_S

%include "constants.s"

section .text

; returns a random byte in al
; char randbyte()
global randbyte
randbyte:
    push 0
    mov rax, SYS_GETRANDOM
    mov rdi, rsp
    mov rsi, 1
    mov rdx, 0
    syscall
    pop rax
    ret 

%endif