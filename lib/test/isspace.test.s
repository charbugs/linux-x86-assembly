%include "assert.s"
%include "isspace.s"

section .text
global _start
_start:

.test_1:
  set_non_volatile_registers
  mov rdi, " "
  call isspace
  assert_non_volatile_registers 1

; space
.test_2:
  mov rdi, " "
  call isspace
  assert_cmp_eq rax, 1, 2

; tab
.test_3:
  mov rdi, `\t`
  call isspace
  assert_cmp_eq rax, 1, 3

; line feed
.test_4:
  mov rdi, `\n`
  call isspace
  assert_cmp_eq rax, 1, 4

; vertical tab
.test_5:
  mov rdi, `\v`
  call isspace
  assert_cmp_eq rax, 1, 5

; form feed
.test_6:
  mov rdi, `\f`
  call isspace
  assert_cmp_eq rax, 1, 6

; carriage return
.test_7:
  mov rdi, `\r`
  call isspace
  assert_cmp_eq rax, 1, 7

; non space
.test_8:
  mov rdi, "a"
  call isspace
  assert_cmp_eq rax, 0, 8

  exit 0