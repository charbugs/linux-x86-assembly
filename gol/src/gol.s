%include "assert.s"
%include "randbyte.s"
%include "sleep.s"
%include "print.s"
%include "board.s"
%include "print_board.s"
%include "next_generation.s"

%define COLS 80
%define ROWS 80

section .data
    clear_screen db "\n33[2J", 0

section .text

global _start
_start:
    push rbp
    mov rbp, rsp

    ; make space for the BOARD struct on the stack
    mov rax, COLS
    mov r8, ROWS
    mul r8              ; total of cells in rax (cols * rows)
    mov r8, rax         ; save total of cells in r8
    add rax, 24         ; add size of 3 qwords (cols, rows, total)
    sub rsp, rax        ; stack space for (cols, rows, total and cells)

    ; set the BOARD struct on the stack
    mov qword [rsp + BOARD_COLS], COLS
    mov qword [rsp + BOARD_ROWS], ROWS
    mov qword [rsp + BOARD_TOTAL], r8

    xor r12, r12
.seed_board:
    cmp r12, [rsp + BOARD_TOTAL]
    je .game_loop
    call randbyte
    mov r8, 0
    mov r9, 1
    cmp al, 110
    cmovg r8, r9
    mov byte [rsp + BOARD_CELLS + r12], r8b
    inc r12
    jmp .seed_board

.game_loop:
    mov rdi, clear_screen
    call print 

    mov rdi, rsp 
    call print_board
    
    mov rdi, rsp
    call next_generation

    mov rdi, 0
    mov rsi, 200
    call sleep

    jmp .game_loop



