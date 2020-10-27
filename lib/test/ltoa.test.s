%include "assert.s"
%include "ltoa.s"

section .bss
  result resb 20

section .data
  number2 equ 123
  digits2 db "123", 0

  number3 equ 0
  digits3 db "0", 0

  number4 equ -42
  digits4 db "-42", 0

  ; highest signed long
  number5 equ 9223372036854775807
  digits5 db "9223372036854775807", 0

  ; lowest signed long the function can take
  number6 equ -9223372036854775807
  digits6 db "-9223372036854775807", 0

  ; an overflow results in the corresponding negative number
  number7 equ 9223372036854775809
  digits7 db "-9223372036854775807", 0
  

section .text
global _start
_start:

test_1:
  set_non_volatile_registers
  mov rdi, number2
  mov rsi, result
  call ltoa
  assert_non_volatile_registers 1

test_2:
  mov rdi, number2
  mov rsi, result
  call ltoa
  assert_str_eq result, digits2, 2

test_3:
  mov rdi, number3
  mov rsi, result
  call ltoa
  assert_str_eq result, digits3, 3

test_4:
  mov rdi, number4
  mov rsi, result
  call ltoa
  assert_str_eq result, digits4, 4

test_5:
  mov rdi, number5
  mov rsi, result
  call ltoa
  assert_str_eq result, digits5, 5

test_6:
  mov rdi, number6
  mov rsi, result
  call ltoa
  assert_str_eq result, digits6, 6

test_7:
  mov rdi, number7
  mov rsi, result
  call ltoa
  assert_str_eq result, digits7, 7

  exit 0