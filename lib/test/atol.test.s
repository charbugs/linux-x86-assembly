%include "assert.s"
%include "atol.s"

section .text
  string1 db "123", 0
  string2 db "0", 0
  string3 db "2147483647"
  string4 db "foobar", 0
  string5 db "   123", 0
  string6 db `\t\v\n 123`, 0
  string7 db "+123", 0
  string8 db "-123", 0
  string9 db "  -123foo", 0

global _start
_start:

.test_10:
  set_non_volatile_registers
  mov rdi, string1
  call atol
  assert_non_volatile_registers 10

.test_1:
  mov rdi, string1
  call atol
  assert rax, 123, 1

.test_2:
  mov rdi, string2
  call atol
  assert rax, 0, 2

.test_3:
  mov rdi, string3
  call atol
  assert rax, 2147483647, 3

; returns 0 if string can't be parsed to a number
.test_4:
  mov rdi, string4
  call atol
  assert rax, 0, 4

; works with leading space
.test_5:
  mov rdi, string5
  call atol
  assert rax, 123, 5

; works with other, possibly mixed space too
.test_6:
  mov rdi, string6
  call atol
  assert rax, 123, 6

; treats leading plus sign correct
.test_7:
  mov rdi, string7
  call atol
  assert rax, 123, 7

; treats leading minus sign correct
.test_8:
  mov rdi, string8
  call atol
  assert rax, -123, 8

; all together
.test_9:
  mov rdi, string9
  call atol
  assert rax, -123, 9

  exit 0
