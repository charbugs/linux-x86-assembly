%ifndef STRINS_S
%define STRINS_S

%include "strlen.s"
%include "alloc.s"

%define child   rbp -8
%define parent  rbp - 16
%define pos     rbp - 24
%define length  rbp - 32
%define stack_size   32

section .text

; Insert nullterminated child string into nullterminted parent string
; at the given position of the parent string.
;
; It returns a new allocated string.
;
; char *strins(char *child, char *parent, int pos) 
global strins
strins:
    push rbp
    mov rbp, rsp
    sub rsp, stack_size

    mov [child], rdi
    mov [parent], rsi
    mov [pos], rdx
    mov qword [length], 0

    mov rdi, [child]
    call strlen
    add [length], rax
    mov rdi, [parent]
    call strlen
    add [length], rax

    mov rdi, [length]
    inc rdi                 ; space for null byte
    call alloc
    mov r9, rax

    xor rcx, rcx
.copy_parent_head:
    cmp rcx, [pos]
    je .copy_child
    mov r8, [parent]                ; copy addr of parent to to r8
    mov r8b, [r8]                  ; copy one byte of parent to r8b
    mov [r9], r8b
    inc qword [parent]
    inc r9
    inc rcx
    jmp .copy_parent_head

.copy_child:
    mov r8, [child]
    mov r8b, [r8]
    cmp r8b, 0
    je .copy_parent_tail
    mov [r9], r8b
    inc qword [child]
    inc r9
    jmp .copy_child

.copy_parent_tail:
    mov r8, [parent]
    mov r8b, [r8]
    cmp r8b, 0
    je .return
    mov [r9], r8b
    inc qword [parent]
    inc r9
    jmp .copy_parent_tail

.return:
    mov byte [r9], 0
    mov rsp, rbp
    pop rbp
    ret

%undef child
%undef parent
%undef pos
%undef length
%undef stack_size

%endif