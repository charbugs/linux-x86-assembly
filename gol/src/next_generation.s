%include "board.s"
%include "get_neighbors.s"
%include "determine_cell.s"

%define loop_count      rbp - 8
%define board_pointer   rbp - 16
%define STACK_SIZE      16

section .text

; void next_generation(board *board)
global next_generation
next_generation:
    push rbp
    mov rbp, rsp
    sub rsp, STACK_SIZE
    mov qword [loop_count], 0
    mov qword [board_pointer], rdi
.get_neighbors_of_all_cells:
    mov rcx, [loop_count]
    mov r8, [board_pointer]
    cmp rcx, [r8 + BOARD_TOTAL]
    je .determine_all_cells
    mov rdi, r8
    mov rsi, rcx
    call get_neighbors
    push rax
    inc qword [loop_count]
    jmp .get_neighbors_of_all_cells
.determine_all_cells:
    mov rcx, [loop_count]
    cmp rcx, 0
    je .return
    mov rdi, [board_pointer]
    mov rsi, rcx
    sub rsi, 1
    pop rdx
    call determine_cell
    dec qword [loop_count]
    jmp .determine_all_cells
.return:
    leave
    ret    
