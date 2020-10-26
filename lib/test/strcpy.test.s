%include "assert.s"
%include "strcpy.s"

section .data

  src2 db "hello", 0
  dst2 db "     ", 0
  cmp2 db "hello", 0 

  src3 db "foo", 0
  dst3 db "           ", 0
  cmp3 db "foo", 0 

  src4 db "", 0
  dst4 db "", 0
  cmp4 db "", 0 

section .text
global _start
_start:

test_1:
  set_non_volatile_registers
  mov rdi, dst2
  mov rsi, src2
  call strcpy
  assert_non_volatile_registers 1

test_2:
  mov rdi, dst2
  mov rsi, src2
  call strcpy
  assert_str_eq dst2, cmp2, 2

test_3:
  mov rdi, dst3
  mov rsi, src3
  call strcpy
  assert_str_eq dst3, cmp3, 2

test_4:
  mov rdi, dst4
  mov rsi, src4
  call strcpy
  assert_str_eq dst4, cmp4, 2

  exit 0