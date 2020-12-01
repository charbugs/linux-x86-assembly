; This is an Array class that implements the Collection interface.

%include "Collection.s"
%include "alloc.s"
%include "print.s"
%include "ltoa.s"

; offset to store capacity of the array
%define CAPACITY 24
; offset to store current number of items in the array
%define COUNT 32
; offset to the actual items
%define ITEMS 40

section .data
    ; some global variables used in the print method 
    type_label db "Array: ", 0
    space db " ", 0
    newline db `\n`, 0

section .text

; Constructor function to create an Array instance.
; It implements the Collection interface.
;
; Array(qword capacity)
global Array
Array:
    ; allocate memory for the instance:
    ;   function pointer to append method (8 byte) +
    ;   function pointer to length method (8 bytes) +
    ;   function pointer to print method (8 bytes) +
    ;   size to store the capacity of the array (8 bytes)
    ;   size to store the current length of the array (8 byte) +
    ;   size for items (rdi * 8)
    mov rax, rdi
    mov r8, 8
    mul r8
    add rax, 40
    push rdi
    mov rdi, rax
    call alloc      ; The array instance is now in rax.
    pop rdi    
    
    ; Set the Collection interface methods to the instance .
    mov qword [rax + COLLECTION_APPEND], .append
    mov qword [rax + COLLECTION_LENGTH], .length
    mov qword [rax + COLLECTION_PRINT], .print

    ; Set some private variables to the instance.
    ; The items start at [rax + ITEMS], but for now there are no items
    mov qword [rax + CAPACITY], rdi 
    mov qword [rax + COUNT], 0
    ret

; This is a inteface method of Collection (see there for method signature).
; It appends a item to the array.
.append:
    mov r8, [rdi + COUNT]
    cmp r8, [rdi + CAPACITY]
    jge .return_append
    mov [rdi + r8 * 8 + ITEMS], rsi
    inc qword [rdi + COUNT]
.return_append:
    mov rax, [rdi + COUNT]
    ret

; This is a inteface method of Collection (see there for method signature).
; It returns the current length of the array.
.length:
    mov rax, [rdi + COUNT]
    ret

; This is a inteface method of Collection (see there for method signature).
; It prints something like: "Array: 1 4 5 4"
.print:
    push rbp
    mov rbp, rsp
    sub rsp, 40
    mov qword [rbp - 8], 0
    mov qword [rbp - 16], rdi
    mov rdi, type_label
    call print
    nop
.print_loop:
    nop
    mov rcx, [rbp - 8]
    mov rdi, [rbp - 16]
    cmp rcx, [rdi + COUNT]
    je .return_print
    mov rdi, [rdi + rcx * 8 + ITEMS]
    mov rsi, rsp
    call ltoa
    mov rdi, rsp
    call print
    mov rdi, space
    call print
    inc qword [rbp - 8]
    jmp .print_loop
.return_print:
    mov rdi, newline
    call print
    leave
    ret


%undef CAPACITY
%undef COUNT
%undef ITEMS
