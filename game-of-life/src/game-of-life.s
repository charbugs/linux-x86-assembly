%include "assert.s"
%include "print.s"
%include "ltoa.s"
%include "strcpy.s"

%define COLS 10
%define ROWS 10

section .bss
    cells resb 100
    digits resb 20
    cursor_reset_sequence resb 12

section .data
    on_char db "x"
    off_char db "."

section .text
global _start:
_start:
    call .init
.game_loop:
    call .print_board
    call .next_generation
    jmp .game_loop
    exit 0

.init:
    mov rdi, ROWS
    mov rsi, digits
    call ltoa
    mov byte [cursor_reset_sequence + 0], 27
    mov byte [cursor_reset_sequence + 1], 91
    lea rdi, [cursor_reset_sequence  + 2]
    mov rsi, digits
    call strcpy
    mov byte [cursor_reset_sequence + 9], 65

    mov byte [cells + 1], 1
    mov byte [cells + 3], 1
    mov byte [cells + 5], 1
    mov byte [cells + 7], 1
    ret

.print_board:
    push rbp
    mov rbp, rsp
    mov rdi, cells
    mov rsi, 0
    mov rax, COLS
    mov r8, ROWS
    mul r8
    add rax, COLS
    sub rsp, rax
    mov byte [rbp - 1], 0
.build_output:
    cmp rax, 0
    jle .print_output 
    mov rcx , [off_char]
    cmp byte [rdi], 0
    cmovg rcx, [on_char]
    mov r8, rbp
    sub r8, rax
    mov byte [r8], cl
    inc rdi
    inc rsi
    dec rax
    cmp rsi, COLS
    je .insert_line_break
    jmp .build_output
.insert_line_break:
    mov r8, rbp
    sub r8, rax
    mov byte [r8], `\n`
    mov rsi, 0
    dec rax
    jmp .build_output
.print_output:
    mov rdi, rsp
    call print
    mov rdi, cursor_reset_sequence
    call print
    leave
    ret

.next_generation:
    ret
    