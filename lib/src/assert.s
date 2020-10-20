%ifndef ASSERT_S
%define ASSERT_S

%include "constants.s"

%macro assert 3
  cmp %1, %2
  je %%continue
  mov rax, SYS_EXIT
  mov rdi, %3
  syscall
  %%continue:
%endmacro

%macro exit 1
  mov rax, SYS_EXIT
  mov rdi, %1
  syscall
%endmacro

%endif