%include "assert.s"
%include "Collection.s"
%include "Array.s"

%define arr1 rbp - 8
%define arr2 rbp - 16
%define STACK_SIZE 16

section .text

global _start
_start:
    push rbp
    mov rbp, rsp
    sub rsp, STACK_SIZE

    ; ARRAY 1
    ; create array instance and save it
    mov rdi, 3
    call Array
    mov [arr1], rax
    ; append the number 1
    mov rsi, 1
    mov rdi, [arr1]
    mov rax, [rdi + COLLECTION_APPEND]
    call rax
    ; append the number 2
    mov rsi, 2
    mov rdi, [arr1]
    mov rax, [rdi + COLLECTION_APPEND]
    call rax

    ; ARRAY 2
    ; create array instance and save it
    mov rdi, 3
    call Array
    mov [arr2], rax
    ; append the number 6
    mov rsi, 6
    mov rdi, [arr2]
    mov rax, [rdi + COLLECTION_APPEND]
    call rax
    ; append the number 7
    mov rsi, 7
    mov rdi, [arr2]
    mov rax, [rdi + COLLECTION_APPEND]
    call rax
    ; append the number 8
    mov rsi, 8
    mov rdi, [arr2]
    mov rax, [rdi + COLLECTION_APPEND]
    call rax

    ; print array 1
    ; expeceted output is: "Array: 1 2"
    mov rdi, [arr1]
    mov rax, [rdi + COLLECTION_PRINT]
    call rax

    ; print array 2
    ; expected output is: "Array: 6 7 8"
    mov rdi, [arr2]
    mov rax, [rdi + COLLECTION_PRINT]
    call rax

    exit 0

%undef arr