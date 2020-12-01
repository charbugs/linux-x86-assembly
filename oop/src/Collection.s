%ifndef COLLECTION_S
%define COLLECTION_S

; Interface Collection:

; It specifies method signatures and the offsets
; of the methods in the Collection instances

; For the sake of simplicity the Collection is
; a collection of qword items only.

; (Collection this, qword x) -> qword length
; x - item to append
; length - length of collection after x was append
%define COLLECTION_APPEND 0

; (Collection this) -> qword length
; length - current length of the collection
%define COLLECTION_LENGTH 8

; (Collection this) -> void
; prints a string representation of the collection
%define COLLECTION_PRINT 16

%endif