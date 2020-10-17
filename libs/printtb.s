%include "constants.s"
%include "strlen.s"

section .text

; Prints strings to stdout 
global printtb
printtb:
  xor rax, rax


