%include "assert.s"
%include "strcmp.s"

section .data

  string2_a db "foo_a", 0
  string2_b db "foo_a", 0

  string3_a db "foo_a", 0
  string3_b db "foo_b", 0

  string4_a db "foo_c", 0
  string4_b db "foo_a", 0

  string5_a db "f", 0
  string5_b db "foo", 0

  string6_a db "foo", 0
  string6_b db "f", 0

  string7_a db "", 0
  string7_b db "", 0

  string8_a db "a", 0
  string8_b db "", 0

section .text
global _start
_start:

test_1:
  set_non_volatile_registers
  mov rdi, string2_a
  mov rsi, string2_b
  call strcmp
  assert_non_volatile_registers 1

test_2:
  mov rdi, string2_a
  mov rsi, string2_b
  call strcmp
  assert_cmp_eq rax, 0, 2

test_3:
  mov rdi, string3_a
  mov rsi, string3_b
  call strcmp
  assert_cmp_eq rax, -1, 3

test_4:
  mov rdi, string4_a
  mov rsi, string4_b
  call strcmp
  assert_cmp_eq rax, 2, 4

test_5:
  mov rdi, string5_a
  mov rsi, string5_b
  call strcmp
  assert_cmp_eq rax, -111, 5

test_6:
  mov rdi, string6_a
  mov rsi, string6_b
  call strcmp
  assert_cmp_eq rax, 111, 6

test_7:
  mov rdi, string7_a
  mov rsi, string7_b
  call strcmp
  assert_cmp_eq rax, 0, 6

test_8:
  mov rdi, string8_a
  mov rsi, string8_b
  call strcmp
  assert_cmp_eq rax, 97, 8

  exit 0