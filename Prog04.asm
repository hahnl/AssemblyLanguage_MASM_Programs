TITLE Composite Numbers     (Prog04.asm)

; Author: Larissa Hahn
; Email: hahnl@onid.oregonstate.edu
; Course / Project ID: CS 271-400 Program #4       Due Date: 5-10-15
; Description: This program displays the number of composite numbers
; the user wishes to display in a range of [1...400].

INCLUDE Irvine32.inc

UPPER_LIMIT = 400

.data ; Variable Definitions:
lowerLimit  DWORD   ?
n           DWORD   ?    ; user input number
possibleComposite DWORD  ?   ; used for calculations
halfPossibleComposite DWORD ?  ; used for calculations
divisor     DWORD   ?    ; used for calculations
progTitle   BYTE    "Composite Numbers",0
progName    BYTE    "      Programmed by Larissa Hahn",0
prompt_1    BYTE    "Enter the number of composites you would like to see.",0
prompt_2    BYTE    "I'll accept orders for up to 400 composites.",0
main_prompt BYTE    "Enter the number of composites to display [1 ... 400]: ",0
outRange    BYTE    "Out of range. Try again.",0
final_msg   BYTE    "Results certified by Larissa Hahn. Goodbye.",0
spaces      BYTE    "   ",0

.code ; Instruction Code:
main PROC
; Call IntroFunct PROC (introduction)
     call IntroFunct

; Call getUserData PROC
     call getUserData

; Call showComposites PROC
     call showComposites

; Call farewell PROC
     call farewell

; Terminate the program
     exit ; exit to Operating System
main ENDP

IntroFunct PROC
; Display program title and programmer's name.
     mov  edx,OFFSET progTitle
     call WriteString
     mov  edx,OFFSET progName
     call WriteString
     call CrLf
     call CrLf

; Display instructions for the user.
     mov  edx,OFFSET prompt_1
     call WriteString
     call CrLf
     mov  edx,OFFSET prompt_2
     call WriteString
     call CrLf
     call CrLf
     ret
IntroFunct ENDP

getUserData PROC
; Repeatedly prompt the user to enter how many composite numbers and validate input.
     mov  edx,OFFSET main_prompt
     call WriteString
     call ReadInt
     call validate
     ret
getUserData ENDP

validate PROC
     mov	n,eax
     mov  eax,1
     mov  lowerLimit,eax
     mov  eax,n
     mov  ebx,UPPER_LIMIT
     cmp  eax,ebx
     jg   out_of_range
     mov  eax,n
     mov  ebx,lowerLimit
     cmp  eax,ebx
     jl   out_of_range
     jmp  within_range
out_of_range:
     mov  edx,OFFSET outRange
     call WriteString
     call CrLf
     jmp  prompt_again
prompt_again:
     mov  edx,OFFSET main_prompt
     call WriteString
     call ReadInt
     call validate
within_range:
     call CrLf
     ret
validate ENDP

showComposites PROC
; Calculate and display the composite numbers.
     mov  ecx,n
     mov  possibleComposite,4    
Testing:
     mov  eax,possibleComposite
     mov  ebx,2
     mov  edx,0
     div  ebx
     mov  halfPossibleComposite,eax
     mov  divisor,2
Calculate:  
     mov  eax,halfPossibleComposite
     mov  ebx,divisor
     cmp  eax,ebx
     jl   is_prime
     mov  eax,possibleComposite
     mov  ebx,divisor
     mov  edx,0
     div  ebx
     cmp  edx,0
     jne  keep_going              
     mov  eax,possibleComposite
     call WriteDec
     mov  edx,OFFSET spaces
     call WriteString
     inc  eax
     mov  possibleComposite,eax
     loop Testing
     jmp  Finished 
keep_going:
     mov  eax,divisor
     inc  eax
     mov  divisor,eax
     jmp  Calculate
is_prime:
     mov  eax,possibleComposite
     inc  eax
     mov  possibleComposite,eax
     jmp  Testing
Finished:
     ret
showComposites ENDP

farewell PROC
; Display a parting message that includes the programmer's name
     call CrLf
     call CrLf
     mov  edx,OFFSET final_msg
     call WriteString
     call CrLf
     call CrLf
     ret
farewell ENDP

END main