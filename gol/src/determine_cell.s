
section .text
; void determine_cell(board *board, int cell, int neighbors)
global determine_cell
determine_cell:
    mov r8, 0
    mov r9, 1
    xor rax, rax 
    xor rcx, rcx
.count_neighbors:
    cmp rcx, 8      ; 8 neighbors
    je .check_dead_or_alive
    add al, dl
    shr rdx, 8
    inc rcx
    jmp .count_neighbors
.check_dead_or_alive:
    mov r10b, [rdi + BOARD_CELLS + rsi]
    cmp r10b, 0
    je .handle_dead_cell
    jg .handle_living_cell
.handle_dead_cell:
    cmp rax, 3
    cmove r8, r9
    mov [rdi + BOARD_CELLS + rsi], r8b
    ret
.handle_living_cell:
    cmp rax, 2
    cmovl r9, r8
    cmp rax, 3
    cmovg r9, r8
    mov [rdi + BOARD_CELLS + rsi], r9b
    ret
