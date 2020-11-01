%include "assert.s"
%include "printf.s"
%include "constants.s"

%define BUF_SIZE    4096
%define args        rbp + 8
%define argc        rbp + 0
%define argi        rbp - 8
%define fd          rbp - 16
%define bytes_read  rbp - 24 
%define cur_fname   rbp - 32

section .bss
  buf resb BUF_SIZE

section .data
  err_msg_args db `cat: no file name given\n`, 0
  err_msg_open db `cat: could not open file %s\n`, 0
  err_msg_read db `cat: could not read from file %s\n`, 0

section .text
global _start
_start:
  mov rbp, rsp  ; system args >= rsp; local vars < rsp
  sub rsp, 32

  ; exit if no file arguments were passed
  cmp byte [argc], 2
  jge .set_first_file_arg_index
  mov rdi, err_msg_args
  call printf
  exit 1

.set_first_file_arg_index:
  ; the first file argument is at args[1]
  mov byte [argi], 1

.process_next_file:
  ; if there are no more file arguments left then exit
  mov rax, [argi]
  inc qword [argi]
  cmp rax, [argc]
  jl .set_current_fname   
  exit 0

.set_current_fname:
  mov rax, [rbp + rax * 8 + 8]
  mov [cur_fname], rax

.open_file:
  mov rdi, [cur_fname]
  mov rax, SYS_OPEN
  mov rsi, O_RDONLY
  syscall

  ;save fd
  mov [fd], rax

  ; if error on open then exit with message
  ; else jump to read file
  cmp rax, 0
  jge .read_file
  mov rax, [cur_fname]
  push rax
  mov rdi, err_msg_open
  call printf
  exit 1

.read_file:
  mov rdi, [fd]
  mov rax, SYS_READ
  mov rsi, buf
  mov rdx, BUF_SIZE
  syscall

  ; save byte read
  mov [bytes_read], rax

  ; if error on read then exit with message
  ; else jump to print data
  cmp rax, 0
  jge .print_data
  mov rax, [cur_fname]
  push rax
  mov rdi, err_msg_read
  call printf
  exit 1

.print_data:
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, buf
  mov rdx, [bytes_read]
  syscall

  ; if bytes read greater then 0 then continue reading
  cmp qword [bytes_read], 0
  jg .read_file

  ; close file
  mov rax, SYS_CLOSE
  mov rdi, [fd]
  syscall
  jmp .process_next_file
  
