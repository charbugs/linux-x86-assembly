%include "board.s"

%define nw  rbp - 8
%define n   rbp - 16
%define ne  rbp - 24
%define w   rbp - 32
%define e   rbp - 40
%define sw  rbp - 48
%define s   rbp - 56
%define se  rbp - 64
%define STACK_SIZE 64

section .text

; int get_neighbors(board *board, int cell)
get_neighbors:
    push rbp
    mov rbp, rsp
    sub rsp, STACK_SIZE
    ; nw
    mov r8, rsi
    sub r8, [rdi + BOARD_COLS]
    sub r8, 1
    mov [nw], r8
    ; n
    mov r8, rsi
    sub r8, [rdi  + BOARD_COLS]
    mov [n], r8
    ; ne
    mov r8, rsi
    sub r8, [rdi + BOARD_COLS]
    add r8, 1
    mov [ne], r8
    ; w
    mov r8, rsi
    sub r8, 1
    mov [w], r8
    ; e
    mov r8, rsi
    add r8, 1
    mov [e], r8
    ; sw
    mov r8, rsi
    add r8, [rdi + BOARD_COLS]
    sub r8, 1
    mov [sw], r8
    ; s
    mov r8, rsi
    add r8, [rdi + BOARD_COLS]
    mov [s], r8
    ; se
    mov r8, rsi
    add r8, [rdi + BOARD_COLS]
    add r8, 1
    mov [se], r8

    xor rcx, rcx
.handle_outsiders:
    cmp rcx, 8          ; 8 neighbors
    je .get_values
    mov r8, [rsp + rcx * 8]
    cmp r8, 0
    jl .handle_underflow
    cmp r8, [rdi + BOARD_TOTAL]
    jge .handle_overflow
    jmp .continue
.handle_underflow:
    add r8, [rdi + BOARD_TOTAL]
    mov [rsp + rcx * 8], r8
    jmp .continue
.handle_overflow:
    sub r8, [rdi + BOARD_TOTAL]
    mov [rsp + rcx * 8], r8
.continue:
    inc rcx
    jmp .handle_outsiders

.get_values:
    xor rax, rax
    xor rcx, rcx
.get_values_loop:
    cmp rcx, 8          ; 8 neighbors
    je .return
    shl rax, 8
    mov r8, [rsp + rcx * 8]
    mov al, [rdi + BOARD_CELLS + r8]
    inc rcx
    jmp .get_values_loop

.return:
    leave
    ret
