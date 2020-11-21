
; this is just a slightly more convenient wrapper around
; the nanosleep syscall. while the nanosleep syscall
; expects a struct of seconds and nanoseconds this function
; expects to int params of seconds and milliseconds.

%ifndef SLEEP_S
%define SLEEP_S

%include "constants.s"

; The order matters since we want to create
; the `timespec` struct from nanosleep(2)
; and rsp will become a pointer to this struct.
%define sleep_nano_seconds  rbp - 8
%define sleep_seconds       rbp - 16

%define STACK_SIZE 16

section .text

; pause for the given seconds and miliseconds (approximately)
; void (int s, int ms)
global sleep
sleep:
    push rbp
    mov rbp, rsp
    sub rsp, STACK_SIZE

    ; if the ms argument is creater than 1000 we convert it
    ; to seconds and add it to the s agrument. the rest
    ; stays in the ms argument. 
    cmp rsi, 1000           
    jl .create_timespec
    mov rax, rsi
    cqo
    mov r8, 1000
    div r8
    add rdi, rax
    mov rsi, rdx  

.create_timespec:
    mov [sleep_seconds], rdi

    ; convert the ms argument to nanoseconds so that it is
    ; valid for the nanosleep syscall
    mov rax, rsi
    mov r8, 1000000
    mul r8
    mov [sleep_nano_seconds], rax

    mov rax, SYS_NANOSLEEP
    mov rdi, rsp
    mov rsi, 0
    syscall

    leave
    ret

%endif