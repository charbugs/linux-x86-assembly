%include "constants.s"
%include "strlen.s"

section .text

; Prints a null terminated string to stdout and appends a new line.
; void println(char* string)
global println
println:
  ; prologue
  push rbp
  mov rbp, rsp
  xor rax, rax

  ; locals
  sub rsp, 16
  mov [rsp + 8], rdi ; string
  mov [rsp + 0], byte 10 ; line feed

  call strlen ; string* already in rdi

  ; print string  
  mov rdx, rax ; size of string 
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, [rsp + 8]
  syscall

  ; print line feed
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, [rsp + 0]
  mov rdx, 1
  syscall

.end:
  mov rsp, rbp
  pop rbp
  ret
