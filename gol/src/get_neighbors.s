%include "board.s"

%define north   rbp - 1
%define east    rbp - 2
%define south   rbp - 3
%define west    rbp - 4
%define STACK_SIZE 4

section .text

; Returns 4 bytes in eax where each byte represents a neighbor of the cell.
; The order is (from highest to lowest byte): N, E, S, W
;
; int get_neighbors(board *board, int cell)
get_neighbors:
    push rbp
    mov rbp, rsp
    sub rsp, STACK_SIZE     
.get_north:
    cmp rsi, [rdi + BOARD_COLS]
    jl .overflow_north
    lea r8, [rdi + BOARD_CELLS]
    add r8, rsi
    sub r8, [rdi + BOARD_COLS] 
    mov al, [r8]
    mov [north], al
    jmp .get_east
.overflow_north:
    lea r8, [rdi + BOARD_CELLS]
    add r8, rsi
    add r8, [rdi + BOARD_TOTAL]
    sub r8, [rdi + BOARD_COLS]
    mov al, [r8]
    mov [north], al
.get_east:
    mov rax, rsi 
    add rax, 1
    cqo
    idiv qword [rdi + BOARD_COLS]
    cmp rdx, 0
    je .overflow_east
    lea r8, [rdi + BOARD_CELLS]
    add r8, rsi
    add r8, 1
    mov al, [r8]
    mov [east], al
    jmp .get_south
.overflow_east:
    lea r8, [rdi + BOARD_CELLS]
    add r8, rsi
    sub r8, [rdi + BOARD_COLS]
    add r8, 1
    mov al, [r8]
    mov [east], al
.get_south:
    mov r9, rsi
    add r9, [rdi + BOARD_COLS]
    cmp r9, [rdi + BOARD_TOTAL]
    jge .overflow_south
    lea r8, [rdi + BOARD_CELLS]
    add r8, rsi
    add r8, [rdi + BOARD_COLS]
    mov al, [r8]
    mov [south], al
    jmp .get_west
.overflow_south:
    lea r8, [rdi + BOARD_CELLS]
    add r8, r9
    sub r8, [rdi + BOARD_TOTAL]
    mov al, [r8]
    mov [south], al
.get_west:
    mov rax, rsi
    add rax, 1
    cqo
    idiv qword [rdi + BOARD_COLS]
    cmp rdx, 1
    je .overflow_west
    lea r8, [rdi + BOARD_CELLS]
    add r8, rsi
    sub r8, 1
    mov al, [r8]
    mov [west], al
    jmp .return
.overflow_west:
    lea r8, [rdi + BOARD_CELLS]
    add r8, rsi
    add r8, [rdi + BOARD_COLS]
    sub r8, 1
    mov al, [r8]
    mov [west], al
.return:
    mov eax, [west]
    leave
    ret