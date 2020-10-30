%include "assert.s"
%include "printf.s"

section .data
  test_1_fmt db 0
  test_2_fmt db `%s\n`, 0
  test_3_fmt db `%d\n`, 0
  test_4_fmt db `foo %s bar\n`, 0
  test_5_fmt db `foo %d bar\n`, 0
  test_6_fmt db `foo %s%d bar\n`, 0
  test_7_fmt db `foo %s %s %d bar\n`, 0
  test_8_fmt db `%s foo %d\n`, 0

  str_arg_1 db "lol", 0
  str_arg_2 db "kik", 0
   
section .text
global _start
_start:

test_1:
  set_non_volatile_registers
  mov rdi, test_1_fmt
  call printf
  assert_non_volatile_registers 1

test_2:
  push str_arg_1
  mov rdi, test_2_fmt
  call printf

test_3:
  mov rax, 42
  push rax
  mov rdi, test_3_fmt
  call printf

test_4:
  push str_arg_1
  mov rdi, test_4_fmt
  call printf

test_5:
  mov rax, 23
  push rax
  mov rdi, test_5_fmt
  call printf

test_6:
  mov rax, 23
  push rax
  push str_arg_1
  mov rdi, test_6_fmt
  call printf

test_7:
  mov rax, 42
  push rax
  push str_arg_2
  push str_arg_1
  mov rdi, test_7_fmt
  call printf
  
test_8:
  mov rax, 23
  push rax
  push str_arg_1
  mov rdi, test_8_fmt
  call printf

  exit 0