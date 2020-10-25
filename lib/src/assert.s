%ifndef ASSERT_S
%define ASSERT_S

%include "constants.s"
%include "strcmp.s"

%macro exit 1
  mov rax, SYS_EXIT
  mov rdi, %1
  syscall
%endmacro

%macro assert_cmp_eq 3
  cmp %1, %2
  je %%continue
  exit %3
  %%continue:
%endmacro

%macro assert_str_eq 3
  mov rdi, %1
  mov rsi, %2
  call strcmp
  cmp rax, 0
  je %%continue
  exit %3
  %%continue:
%endmacro

%macro set_non_volatile_registers 0
  mov rbp, 123456
  mov rbx, 123456
  mov r12, 123456
  mov r13, 123456
  mov r14, 123456
  mov r15, 123456
%endmacro

%macro assert_non_volatile_registers 1
  assert_cmp_eq rbp, 123456, %1
  assert_cmp_eq rbx, 123456, %1
  assert_cmp_eq r12, 123456, %1
  assert_cmp_eq r13, 123456, %1
  assert_cmp_eq r14, 123456, %1
  assert_cmp_eq r15, 123456, %1
%endmacro

%endif