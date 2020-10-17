%include "constants.s"
%include "strlen.s"

section .text

; Writes a null terminated string and appends a new line.
; void println(int fd, char* string)
global println
println:
  ; prologue
  push rbp
  mov rbp, rsp
  xor rax, rax

  ; locals
  sub rsp, 24
  mov [rsp + 16], rdi ; fd
  mov [rsp + 8], rsi ; string
  mov [rsp + 0], byte 10 ; line feed

  call strlen ; string already in rdi

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
