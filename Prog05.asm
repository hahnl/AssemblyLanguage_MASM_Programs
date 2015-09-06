TITLE Sorting Random Integers     (Prog05.asm)

; Author: Larissa Hahn
; Email: hahnl@onid.oregonstate.edu
; Course / Project ID: CS 271-400 Program #5       Due Date: 5-26-15 (2 Grace Days Used)
; Description: This program generates random numbers in the range 100-999,
; displays the original list, sorts the list, and calculates the median
; value. Finally, it displays the list sorted in descending order.

INCLUDE Irvine32.inc

MIN = 10
MAX = 200
LOWER_RANGE = 100
UPPER_RANGE = 999

.data ; Variable Definitions:
number      DWORD   ?             ; user input number
arrayRand   DWORD   MAX DUP(?)    ; array of random numbers
progTitle   BYTE    "Sorting Random Integers             Programmed by Larissa Hahn",0
prompt_1    BYTE    "This program generates random numbers in the range [100 .. 999],",0dh,0ah
            BYTE    "displays the original list, sorts the list, and calculates the",0dh,0ah
            BYTE    "median value. Finally, it displays the list sorted in descending order.",0dh,0ah,0
main_prompt BYTE    "How many numbers should be generated? [10 .. 200]: ",0
outRange    BYTE    "Invalid input.",0
list_msg    BYTE    "The unsorted random numbers:",0
sorted_msg  BYTE    "The sorted list: ",0
median_msg  BYTE    "The median is ",0

.code ; Instruction Code:
main PROC
; Seed the random number generator with a unique value.
     call Randomize

; Display program title and programmer's name.
; Display instructions for the user.
     push OFFSET progTitle
     push OFFSET prompt_1
     call IntroFunct

; Repeatedly prompt the user to enter how many numbers and validate input.
     push OFFSET outRange
     push OFFSET main_prompt
     push OFFSET number
     call getUserData

; Create random number array.
     push OFFSET arrayRand
     push number
     call createArray

; Display random number array.
     push OFFSET arrayRand
     push number
     push OFFSET list_msg
     call displayArray

; Sort random number array.
     push OFFSET arrayRand
     push number
     call sortArray

; Display median of array.
     push OFFSET arrayRand
     push number
     push OFFSET median_msg
     call displayMedian

; Display random number array (now sorted) again.
     push OFFSET arrayRand
     push number
     push OFFSET sorted_msg
     call displayArray

; Terminate the program.
     exit ; exit to Operating System
main ENDP

IntroFunct PROC
; Display program title and programmer's name.
; Display instructions for the user.
     pushad
     mov  ebp,esp
     mov  edx,[ebp+40]
     call WriteString    
     call CrLf
     mov  edx,[ebp+36]
     call WriteString 
     call CrLf
     popad
     ret  8
IntroFunct ENDP

getUserData PROC
; Repeatedly prompt the user to enter how many numbers and validate input.
     pushad
     mov ebp,esp
enter_again:
     mov  edx,[ebp+40]
     mov  ebx,[ebp+36]
     call WriteString    
     call ReadInt        
     cmp  eax,MAX
     jg   out_of_range
     cmp  eax,MIN
     jl   out_of_range
     jmp  continue
out_of_range:
     mov  edx,[ebp+44]
     call WriteString    
     call CrLf
     jmp  enter_again
continue:
     call CrLf
     mov  [ebx],eax
     popad
     ret  12
getUserData ENDP

createArray PROC
; Create random number array.
     pushad
     mov  ebp,esp
     mov  ecx,[ebp+36]
     mov  edi,[ebp+40]
generateArray:
     call makeRandom     ; For each number
     add  edi,4
     loop generateArray
     popad
     ret  8
createArray ENDP

makeRandom PROC
; Helper procedure for createArray:
; generate a random number in range.
     mov  eax,UPPER_RANGE 
     sub  eax,LOWER_RANGE
     inc  eax            
     call RandomRange     
     add  eax,LOWER_RANGE  ; Maintain lower boundary
     mov  [edi],eax
     ret
makeRandom ENDP

displayArray PROC
; Display random number array.
     pushad
     mov  ebp,esp
     mov  edx,[ebp+36]
     call WriteString
     call CrLf
     mov  ecx,[ebp+40]
     mov  edi,[ebp+44]
     mov  ebx,0
generate_rows:             
     inc  ebx
     mov  eax,[edi]
     call WriteDec
     add  edi,4
     cmp  ebx,10           ; 10 numbers per row
     jne  not_end_of_row   ; Need a tab between numbers
     call CrLf
     mov  ebx,0
     jmp  new_row          ; Need a new row
not_end_of_row:
     mov  al,TAB
     call WriteChar
new_row:
     loop generate_rows
     call CrLf
     popad
     ret  12
displayArray ENDP

sortArray PROC
; Sort random number array.
     pushad
     mov  ebp,esp
     mov  ecx,[ebp+36]
     mov  edi,[ebp+40]
     dec  ecx
     mov  ebx,0           ; Index is 0
main_loop:
     mov  eax,ebx         ; Synchronize Loops
     mov  edx,eax
     inc  edx             ; nested_loop Index is main_loop Index+1
     push ecx
     mov  ecx,[ebp+36]
nested_loop:
     mov  esi,[edi+edx*4]
     cmp  esi,[edi+eax*4]
     jle  keep_going
     mov  eax,edx
keep_going:
     inc  edx
     loop nested_loop
     lea  esi,[edi+ebx*4]
     push esi
     lea  esi,[edi+eax*4]
     push esi
     call swapNumbers      ; Helper procedure for swap
     pop  ecx
     inc  ebx
     loop main_loop
     popad
     ret  8
sortArray ENDP

swapNumbers PROC
; Helper procedure for sortArray:
; swap first number pushed with second number pushed.
     pushad
     mov  ebp,esp
     mov  eax,[ebp+40]     ; Smaller
     mov  ecx,[eax]
     mov  ebx,[ebp+36]     ; Bigger
     mov  edx,[ebx]
     mov  [eax],edx
     mov  [ebx],ecx
     popad
     ret  8
swapNumbers ENDP

displayMedian PROC
; Display median of array.
     pushad
     mov  ebp,esp
     mov  edi,[ebp+44]
     mov  edx,[ebp+36]
     call CrLf
     call WriteString
     mov  eax,[ebp+40]
     cdq
     mov  ebx,2
     div  ebx
     shl  eax,2
     add  edi,eax
     cmp  edx,0
     je   even_number
     mov  eax,[edi]    ; Must be odd array
     call WriteDec     
     jmp  now_done     
even_number:           ; Must be even array, average middles
     mov  eax,[edi]
     add  eax,[edi-4]
     cdq
     mov  ebx,2
     div  ebx
     call WriteDec
now_done:
     call CrLf
     call CrLf
     popad
     ret  12
displayMedian ENDP

END main
