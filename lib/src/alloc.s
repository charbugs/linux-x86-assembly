; This code was taken from 
; https://baptiste-wicht.com/posts/2012/08/memory-manager-intel-assembly-64-linux.html
; There are some modifications though.

%ifndef ALLOC_S
%define ALLOC_S

%include "constants.s"

section .data
    lib_alloc_mem_last dq 0
    lib_alloc_mem_start dq 0

section .text

; Free a memory block at the heap
; void free(void *p)
global free
free:
    mov qword [rdi - 16], 1
    ret

 ; Allocate `size` bytes on the heap.
; Return a pointer to the start of the allocated block.
;
; void *alloc(int size)
global alloc
alloc:
    cmp qword [lib_alloc_mem_start], 0        ; if this function is not called the first time
    jne .start                          ; the jump to start
    push rdi                            ; save wanted size                          
    mov rax, SYS_BRK
    xor rdi, rdi
    syscall
    pop rdi                             ; restore wanted size
    mov [lib_alloc_mem_start], rax
    mov [lib_alloc_mem_last], rax
.start:
    add rdi, 16                         ; add the header size (16 bytes) to the wanted size
    mov r8, [lib_alloc_mem_start]       ; start of the first block on the heap
    mov r9, [lib_alloc_mem_last]        ; en of heap
.iterate_blocks:
    cmp r8, r9                          ; if we are at the end of the heap
    je .alloc                           ; then allocated a new block
    mov rsi, [r8]                       ; the first 8 bytes of the current block tell if the block is in use (0) or free (1)  
    mov rdx, [r8 + 8]                   ; the next 8 bytes of the current block contain the block size
    cmp rsi, 1                          ; if the block is already in use
    jne .move_to_next_block             ; then move to the next block 
    cmp rdx, rdi                        ; if the size of the free block is to small
    jl .move_to_next_block                            ; them move to the next block
    mov qword [r8], 0                   ; mark the block 'in use'
    lea rax, [r8 + 16]                  ; the return value points to the first byte after the header
    ret
.move_to_next_block:
    add r8, rdx                         ; next block is at the start of the current block plus the size of the current block
    jmp .iterate_blocks 
.alloc:
    mov rax, SYS_BRK                    
    push rdi                            ; save the wanted block size
    lea rdi, [r8 + rdi]                 ; the new break is the current break plus the wanted size 
    syscall
    mov [lib_alloc_mem_last], rax       ; set the new break
    pop rdi                             ; restore the wanted block size
    mov qword [r8], 0                   ; mark the new block as 'in use' in the header
    mov qword [r8 + 8], rdi             ; store the block size in the header
    lea rax, [r8 + 16]                  ; the return value points to the first byte after the header
    ret

%endif