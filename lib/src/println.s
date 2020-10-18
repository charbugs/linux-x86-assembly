extern strlen, STDOUT, SYS_WRITE

section .data
  LF dq 10

section .text

; Prints a null terminated string to stdout followed by new line and returns the string length.
; int println(char* string)
global println
println:
  push rbp
  mov rbp, rsp

  sub rsp, 16
  mov [rbp - 8], rdi ; string

  call strlen; string already in rdi
  mov [rbp - 16], rax ; string length

  ; write string to stdout
  mov rdi, STDOUT     ; 1st param: fd
  mov rsi, [rbp - 8]  ; 2nd param: string
  mov rdx, [rbp - 16] ; 3rd param: length
  mov rax, SYS_WRITE
  syscall

  ; write line feed to stdout
  mov rdi, STDOUT     ; 1st param: fd
  mov rsi, LF         ; 2nd param: line feed
  mov rdx, 1          ; 3rd param: length
  mov rax, SYS_WRITE
  syscall

  mov rax, [rbp - 16] ; return: string length

  mov rsp, rbp
  pop rbp
  ret