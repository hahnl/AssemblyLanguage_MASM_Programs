TITLE Designing low-level I/O procedures     (Prog06.asm)

; Author: Larissa Hahn
; Email: hahnl@onid.oregonstate.edu
; Course / Project ID: CS 271-400 Program #6       Due Date: 6-07-15
; Description: This program displays a list of integers that the user
; provides that are small enough to fit inside a 32 bit register. It
; also displays their sum and their average value.

INCLUDE Irvine32.inc

MAX = 4294967295

displayString MACRO buffer
     mov  edx,OFFSET buffer 
     call WriteString
ENDM

getString MACRO buffer,buffer1,buffer2
     mov  edx,OFFSET buffer
     call WriteString
     mov  edx,OFFSET buffer1
     mov  ecx,(SIZEOF buffer1)-1
     call ReadString
     mov  buffer2,eax
ENDM

.data ; Variable Definitions:
prompt1     BYTE    "PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures",0
prompt2     BYTE    "Written by: Larissa Hahn",0
prompt3     BYTE    "Please provide 10 unsigned decimal integers.",0
prompt4     BYTE    "Each number needs to be small enough to fit inside a 32 bit register.",0
prompt5     BYTE    "After you have finished inputting the raw numbers I will display a list",0
prompt6     BYTE    "of the integers, their sum, and their average value.",0
askNumber   BYTE    "Please enter an unsigned number: ",0
errorMsg    BYTE    "ERROR: You did not enter an unsigned number or your number was too big.",0
num_msg     BYTE    "You entered the following numbers:",0
sum_msg     BYTE    "The sum of these numbers is: ",0
avg_msg     BYTE    "The average is: ",0
thanks_msg  BYTE    "Thanks for playing!",0
array1      DWORD   10 DUP(?)
array2      BYTE    10 DUP(0)
array3      BYTE    20 DUP(?)
numS        DWORD   0

.code ; Instruction Code:
main PROC
; Display Program Title and Programmer's Name
; Display Instructions for the User
     push OFFSET prompt1
     push OFFSET prompt2
     push OFFSET prompt3
     push OFFSET prompt4
     push OFFSET prompt5
     push OFFSET prompt6
     call IntroFunct

; Digit String to Numeric Value Conversion
     push OFFSET array1
     push OFFSET errorMsg
     push OFFSET askNumber
     push OFFSET array2
     push OFFSET numS
     call ReadVal

; Numeric Value to Digit String Conversion
     push OFFSET num_msg
     push OFFSET array1
     push OFFSET array3
     call WriteVal

; Display Average and Sum of Array
     push OFFSET array1
     push OFFSET sum_msg
     push OFFSET avg_msg
     call DisplayValues

; Display Parting Message
     push OFFSET thanks_msg
     call Farewell
   
; Terminate the program.
     exit ; exit to Operating System
main ENDP

IntroFunct PROC
; Display program title and programmer's name.
; Display instructions for the user.
     push ebp
     mov  ebp,esp
     pushad
     mov  edx,[ebp+28]
     call WriteString
     call CrLf
     mov  edx,[ebp+24]
     call WriteString
     call CrLf
     call CrLf
     mov  edx,[ebp+20]
     call WriteString
     call CrLf
     mov  edx,[ebp+16]
     call WriteString
     call CrLf
     mov  edx,[ebp+12]
     call WriteString
     call CrLf
     mov  edx,[ebp+8]
     call WriteString
     call CrLf
     call CrLf
     popad
     pop  ebp
     ret  24
IntroFunct ENDP

ReadVal PROC
; Request user's string of digits, then convert the digit string
; to numeric, while validating user's input.
     push ebp
     mov  ebp,esp
     mov  esi,[ebp+12]
     mov  edi,[ebp+24]
     mov  ecx,10 ; loop counter
OuterLoop:
     pushad
     jmp  MakeRequest
Again:
     mov  esi,[ebp+12]
MakeRequest:
     getString askNumber,array2,[ebp+8]
     mov  edx,0
     mov  ecx,[ebp+8] ; now string size
     cld
Counter:
     lodsb
     cmp  ecx,0
     je   Finished
     cmp  al,48 ; if less than 0
     jl   InvalidInput
     cmp  al,57 ; if greater than 9
     jg   InvalidInput
     jmp  Save
InvalidInput:
     mov  edx,[ebp+20]
     call WriteString
     call CrLf
     jmp  Again
Save:                 
     sub  al,48 ; convert to ASCII
     push eax               
     push ecx
     mov  eax,edx         
     mov  ecx,10
     mul  ecx
     cmp  edx,0
     mov  edx,eax
     pop  ecx
     pop  eax
     jnz  InvalidInput
     push ebx
     movsx ebx,al
     add  edx,ebx
     pop  ebx
     jc   InvalidInput
     loop Counter
     mov  [edi],edx
     popad
     cmp  ecx,0
     je   Finished
     add  edi,4
     loop OuterLoop
Finished:
     pop  ebp
     ret  20
ReadVal ENDP

WriteVal PROC
; Convert a numeric value to a string of digits, and invoke displayString
; macro to produce an output.
     push ebp
     mov  ebp,esp
     mov  esi,[ebp+12] ; digit array
     mov  edi,[ebp+8]  ; string array
     mov  edx,[ebp+16]
     call CrLf
     call WriteString
     call CrLf
     pushad   
     mov  ecx, 10 ; loop counter
Testing:
     push ecx
     mov  ebx,1000000000 ; 10 digits
Divide: 
     mov  eax,[esi] ; first number
     cmp  eax,0           
     je   Store ; store zero
     cmp  eax,ebx         
     jg   Process
     cmp  eax,ebx
     je   Equal
     jmp  Smaller
Smaller:
     mov  eax,ebx
     mov  ebx,10
     mov  edx,0
     div  ebx
     mov  ebx,eax
     jmp  Divide
Process:
     mov  edx,0
     div  ebx
     add  eax,48 ; convert to ASCII
     cld
     stosb
     cmp  ebx,100
     jge  DivideAgain
     cmp  edx,0
     je   Space
     jmp  DoAgain
DoAgain:
     mov  eax,ebx
     push ecx
     mov  ecx,edx ; save remainder
     mov  edx,0
     mov  ebx,10
     div  ebx
     mov  ebx,eax
     mov  eax,ecx
     pop  ecx
     mov  edx,0
     div  ebx
     add  eax,48
     cld
     stosb
     jmp  KeepGoing
Space:
     mov  al,' '
     stosb
     add  esi,4
     pop  ecx
     loop Testing
     cmp  ecx,0
     je   Finish
KeepGoing:
     cmp  edx,9            
     jg   DoAgain ; if greater than 9
     cmp  edx,0 ; keep going till no remainder
     je   Space
     mov  eax,edx
     add  eax,48 ; convert to ASCII
     cld
     stosb
     jmp  Space
Store:
     add  eax,48
     cld
     stosb
     jmp  Space
Equal:       
     cmp  eax,1
     je   Store
     mov  edx,0
     div  ebx
     add  eax,48 ; convert to ASCII
     cld
     stosb
     jmp  DivideAgain
DivideAgain:
     push ecx
     mov  ecx,edx
     mov  eax,ebx
     mov  ebx,10
     mov  edx,0
     div  ebx
     mov  ebx,eax
     mov  eax,ecx
     pop  ecx
     mov  edx,0
     div  ebx
     add  eax,48
     cld
     stosb
     cmp  ebx,1
     je   Space
     jmp  DivideAgain
Finish:
     displayString array3
     popad
     pop  ebp
     ret  12
WriteVal ENDP

DisplayValues PROC
; Calculate and display the average and sum of the array.
     push ebp
     mov  ebp,esp
     mov  esi,[ebp+16]
     pushad
     call CrLf
     mov  ecx,10
     mov  eax,0
AddSum:
     add  eax,[esi]
     add  esi,4
     loop AddSum
     mov  edx,[ebp+12]     
     call CrLf 
     call WriteString ; sum
     call WriteDec
     call CrLf
     mov  ebx,10
     mov  edx,0
     div  ebx
     mov  edx,[ebp+8]
     call WriteString ; average
     call WriteDec
     call CrLf
     popad
     pop  ebp
     ret  12
DisplayValues ENDP

Farewell PROC
; Display a parting message to the user, thanking them for playing.
     push ebp
     mov  ebp,esp
     push edx
     mov  edx,[ebp+8]
     call CrLf
     call WriteString
     call CrLf
     call CrLf
     pop  edx
     pop  ebp
     ret  4
Farewell ENDP

END main