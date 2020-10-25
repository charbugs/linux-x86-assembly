%include "assert.s"
%include "strrev.s"

section .data
  string1 db "foo", 0

  string2_a db "hello", 0
  string2_b db "olleh", 0

  string3_a db "hello!", 0
  string3_b db "!olleh", 0

  string4_a db "", 0
  string4_b db "", 0

  string5_a db "a", 0
  string5_b db "a", 0

  string6_a db "fo", 0
  string6_b db "of", 0

section .text
global _start
_start:

test_1:
  set_non_volatile_registers
  mov rdi, string1
  call strrev
  assert_non_volatile_registers 1
  
; length of string is even
test_2:
  mov rdi, string2_a
  call strrev
  assert_str_eq string2_a, string2_b, 2

; length of string is odd
test_3:
  mov rdi, string3_a
  call strrev
  assert_str_eq string3_a, string3_b, 3

; length of string is 0
test_4:
  mov rdi, string4_a
  call strrev
  assert_str_eq string4_a, string4_b, 4

; length of string is 1
test_5:
  mov rdi, string5_a
  call strrev
  assert_str_eq string5_a, string5_b, 5

; length of string is 2
test_6:
  mov rdi, string6_a
  call strrev
  assert_str_eq string6_a, string6_b, 6

  exit 0