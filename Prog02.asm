TITLE Fibonacci Numbers     (Prog02.asm)

; Author: Larissa Hahn
; Course / Project ID: CS 271 Program #2           Date: 4-16-15
; Description: This program calculates the Fibonacci sequence
; up to the nth term.  It displays all the numbers of the
; sequence up till that term to the console. This program
; also asks for and prints the user name as well as the programmer
; name.

INCLUDE Irvine32.inc

UPPER_LIMIT = 46                                    ; Constant

.data ; Variable Definitions:
userName    BYTE	33 DUP(0)
n           DWORD	?                               ; n for the nth term of the Fibonacci sequence
lowerLimit  DWORD   ?                               ; min number for n
fibNum_2    DWORD   ?                               ; second number in fibonacci calculation
colSpan     DWORD   ?                               ; number of columns for output format
progTitle   BYTE    "Fibonacci Numbers by ",0
progName    BYTE    "Larissa Hahn",0
prompt_1    BYTE    "What's your name? ",0
greeting_1  BYTE    "Hello, ",0
prompt_2    BYTE    "Enter the number of Fibonacci terms to be displayed. Please",0
prompt_3    BYTE    "give the number as an integer in the range [1 ... 46].",0
prompt_4    BYTE    "How many Fibonacci terms do you want? ",0
outRange    BYTE    "Out of range. Enter a number in [1 ... 46].",0
formatSpace BYTE    "     ",0
end_1       BYTE    "Results certified by Larissa Hahn.",0
end_2       BYTE    "Goodbye, ",0

.code ; Instruction Code:
main PROC
; Display program title and programmer's name.
     mov  edx,OFFSET progTitle
     call WriteString
     mov  edx,OFFSET progName
     call WriteString
     call CrLf
     call CrLf

; Get the user's name and greet the user.
     mov  edx,OFFSET prompt_1
     call WriteString
     mov  edx,OFFSET userName
     mov  ecx,32
     call ReadString
     Call CrLf
     mov  edx,OFFSET greeting_1
     call WriteString
     mov  edx,OFFSET userName
     call WriteString
     Call CrLf

; Prompt the user to enter the number of Fibonacci terms to be displayed.
     mov  edx,OFFSET prompt_2
     call WriteString
     call CrLf
     mov  edx,OFFSET prompt_3
     call WriteString
     call CrLf
     call CrLf

; Get and validate the user input (n)
prompt_again:
     mov  edx,OFFSET prompt_4
     call WriteString
     call ReadInt
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
within_range:
     call CrLf

; Calculate and display all the Fibonacci numbers up to and included the nth term.
     mov  eax,1
     call WriteDec
     mov  edx,OFFSET formatSpace
     call WriteString
     mov  fibNum_2,0
     mov  colSpan,2
     mov  eax,0
     mov  ebx,1
     mov  ecx,n
     dec  ecx
calculate_and_print:
     mov  eax,ebx
     add  eax,fibNum_2
     mov  fibNum_2,ebx
     mov  ebx,eax
     call WriteDec
     mov  edx,OFFSET formatSpace
     call WriteString
     cmp  colSpan,5
     je   rowSpan
     mov  edx,colSpan
     inc  edx
     mov  colSpan,edx
     jmp  continue
rowSpan:
     mov  colSpan,1
     call CrLf
     call CrLf
continue:
     loop calculate_and_print

; Display a parting message that includes the user's name
     call CrLf
     call CrLf
     mov  edx,OFFSET end_1
     call WriteString
     call CrLf
     mov  edx,OFFSET end_2
     call WriteString
     mov  edx,OFFSET userName
     call WriteString
     call CrLf
     call CrLF

; Terminate the program

     exit	; Exit to operating system
main ENDP

END main
