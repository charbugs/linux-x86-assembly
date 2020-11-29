%ifndef MAP_S
%define MAP_S

%include "alloc.s"

%define fn      rbp - 8
%define arr_in  rbp - 16
%define len     rbp - 24
%define arr_out rbp - 32
%define i       rbp - 40
%define STACK_SIZE 40

section .text

; byte* map_b2b(func fn, byte* arr, qword len)
global map_b2b
map_b2b:
    ; set arguments on the stack
    push rbp
    mov rbp, rsp
    sub rsp, STACK_SIZE
    mov [fn], rdi
    mov [arr_in], rsi
    mov [len], rdx
    mov qword [i], 0

    ; allocate memory for result array
    mov rdi, [len]
    call alloc
    mov [arr_out], rax

.populate_result:
    mov rcx, [i]
    cmp rcx, [len]
    je .return
    mov r8, [arr_in]
    mov dl, [r8 + rcx]
    call [fn]
    mov r9, [arr_out]
    mov [r9 + rcx], al
    inc qword [i]
    jmp .populate_result

.return:
    mov rax, [arr_out]
    leave
    ret

%endif