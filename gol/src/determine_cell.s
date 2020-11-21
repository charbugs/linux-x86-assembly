
section .text
; Set a cell on or off based on its neighbors.
; The neighbors argument is a 4 byte number in edx
; where each byte holds the value of a neighbor cell.
; The order from high to low is: N, E, S, W.
;
; void determine_cell(board *board, int cell, int neighbors)
global determine_cell
determine_cell:
    xor rax, rax 
    add al, dl
    shr edx, 8
    add al, dl
    shr edx, 8
    add al, dl
    shr edx, 8
    add al, dl

    mov r8, 0
    mov r9, 1

    cmp byte [rdi + BOARD_CELLS + rsi], 1
    je .determine_on_cell
.determine_off_cell:
    cmp al, 1
    cmovg r8, r9
    mov byte [rdi + BOARD_CELLS + rsi], r8b
    ret
.determine_on_cell:
    cmp al, 2
    cmovg r9, r8
    mov byte [rdi + BOARD_CELLS + rsi], r9b
    ret

    

    cmove r8, r9
    mov [rdi + BOARD_CELLS + rsi], r8b
    ret