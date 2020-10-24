%include "assert.s"
%include "isspace.s"

section .text
global _start
_start:

; space
.test_1:
  mov rdi, " "
  call isspace
  assert rax, 1, 1

; tab
.test_2:
  mov rdi, `\t`
  call isspace
  assert rax, 1, 2

; line feed
.test_3:
  mov rdi, `\n`
  call isspace
  assert rax, 1, 3

; vertical tab
.test_4:
  mov rdi, `\v`
  call isspace
  assert rax, 1, 4

; form feed
.test_5:
  mov rdi, `\f`
  call isspace
  assert rax, 1, 5

; carriage return
.test_6:
  mov rdi, `\r`
  call isspace
  assert rax, 1, 6

; non space
.test_7:
  mov rdi, "a"
  call isspace
  assert rax, 0, 7

  exit 0