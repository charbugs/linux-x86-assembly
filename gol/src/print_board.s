%include "board.s"
%include "print.s"

section .data
    on_char db "x"
    off_char db "."

section .text

; void print_board(board *board)
global print_board
print_board:
    push rbp
    mov rbp, rsp

    ; The goal is to create a string on the stack
    ; that represents the board to print. So we
    ; need enough space on the stack.
    xor rcx, rcx                       ; rcx holds the stack size
    add rcx, [rdi + BOARD_TOTAL]       ; one byte for each cell
    add rcx, [rdi + BOARD_COLS]        ; one new line char for each column
    add rcx, 1                         ; one byte for the terminating null byte
    sub rsp, rcx
 
    ; set a pointer to the start of cells
    ; for convenient iteration through cells
    lea r8, [rdi + BOARD_CELLS]

    ; counts the columns set so far
    ; so that we can tell if we need a line break
    mov rsi, 0

.build_output:
    cmp rcx, 0
    jle .print_output 
    mov r9, [off_char]          ; set the off_char
    cmp byte [r8], 0            ; check if current cell is 0
    cmovg r9, [on_char]         ; if so overwrite the off_char with the on_char
    mov r10, rbp
    sub r10, rcx
    mov byte [r10], r9b         ; set on_ or off_char on the stack
    inc r8                      ; increment cell pointer
    inc rsi                     ; increment cols count
    dec rcx                     ; decrement stack size
    cmp rsi, [rdi + BOARD_COLS] ; check if we reached the end of the column
    je .insert_line_break       ; if so then insert line break
    jmp .build_output           ; continue with next cell

.insert_line_break:
    mov r10, rbp
    sub r10, rcx
    mov byte [r10], `\n`
    mov rsi, 0                  ; reset cols count
    dec rcx                     ; decrement stack size
    jmp .build_output           ; continue with next cell

.print_output:
    mov byte [rbp - 1], 0       ; set terminating null byte
    mov rdi, rsp
    call print
    leave
    ret
