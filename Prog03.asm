TITLE Welcome to the Integer Accumulator     (Prog03.asm)

; Author: Larissa Hahn
; Course / Project ID: CS 271 Program #3           Date: 5-02-15
; Description: This program displays the number of negative numbers
; entered, the sum of negative numbers entered, the average, rounded
; to the nearest integer (e.g. -20.5 rounds to -20), and a parting
; message (with the user's name).

INCLUDE Irvine32.inc

LOWER_LIMIT = -100

.data ; Variable Definitions:
userName    BYTE	33 DUP(0)
upperLimit  DWORD   ?
n           DWORD   ?    ; user input number
total       DWORD   ?    ; total numbers entered
sum         DWORD   ?    ; sum of negative numbers entered
average     DWORD   ?    ; the rounded average
progTitle   BYTE    "Welcome to the Integer Accumulator by ",0
progName    BYTE    "Larissa Hahn",0
prompt_1    BYTE    "What is your name? ",0
greeting_1  BYTE    "Hello, ",0
prompt_2    BYTE    "Please enter numbers in [-100, -1].",0
prompt_3    BYTE    "Enter a non-negative number when you are finished to see results.",0
main_prompt BYTE    "Enter number: ",0
outRange    BYTE    "Out of range. Enter a number in [-100 ... -1].",0
result_msg1 BYTE    "You entered ",0
result_msg2 BYTE    " valid numbers.",0
sum_msg     BYTE    "The sum of your valid numbers is ",0
avg_msg     BYTE    "The rounded average is ",0
early_msg   BYTE    "No negative integers were entered, sorry.",0
final_msg   BYTE    "Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ",0
period_str  BYTE    ". ",0
extra_cr1   BYTE    "**EC: Number the lines during user input.",0
extra_cr3   BYTE    "**EC: Being astoundingly creative!",0
caption     BYTE    "Welcome to my program!!",0
question    BYTE    "If you're here, you love Assembly language too! I hope you enjoy!"
  BYTE 0dh,0ah
  BYTE "Would you like to offer me extra credit for being extra creative? =)",0

.code ; Instruction Code:
main PROC
; MsgBox for Creativity
     mov  ebx,OFFSET caption
     mov  edx,OFFSET question
     call MsgBoxAsk

; Initialize accumulator
     mov  total,0

; Display program title and programmer's name.
     mov  edx,OFFSET progTitle
     call WriteString
     mov  edx,OFFSET progName
     call WriteString
     call CrLf
     mov  edx,OFFSET extra_cr1
     call WriteString
     call CrLf
     mov  edx,OFFSET extra_cr3
     call WriteString
     call CrLf
     call CrLf

; Get the user's name and greet the user.
     mov  edx,OFFSET prompt_1
     call WriteString
     mov  edx,OFFSET userName
     mov  ecx,32
     call ReadString
     mov  edx,OFFSET greeting_1
     call WriteString
     mov  edx,OFFSET userName
     call WriteString
     call CrLf
     call CrLf

; Display instructions for the user.
     mov  edx,OFFSET prompt_2
     call WriteString
     call CrLf
     mov  edx,OFFSET prompt_3
     call WriteString
     call CrLf

; Repeatedly prompt the user to enter a number. Validate the user input to be in [-100,-1]
; (inclusive). Count and accumulate the valid user numbers until a non-negative number
; is entered. (The non-negative number is discarded.)
prompt_again:
     mov  eax,total
     add  eax,1
     call WriteDec
     mov  edx,OFFSET period_str
     call WriteString
     mov  edx,OFFSET main_prompt
     call WriteString
     call ReadInt
     mov	n,eax
     cmp  eax,0
     jge  complete       ; end user input
     mov  eax,n
     mov  ebx,LOWER_LIMIT
     cmp  eax,ebx
     jl   out_of_range
     jmp  within_range
out_of_range:
     mov  edx,OFFSET outRange
     call WriteString
     call CrLf
     jmp  prompt_again
within_range:
     inc  total         ; calculate total
     mov  eax,sum       ; calculate sum
     add  eax,n
     mov  sum,eax
     jmp  prompt_again

; Calculate the (rounded integer) average of the negative numbers.
complete:
     mov  eax,total
     cmp  eax,0
     je   finished_early
     mov  edx,0
     mov  eax,sum      ; calculate average
     cdq
     mov  ebx,total
     idiv ebx
     mov  average,eax

; Display the number of negative numbers entered.
     ; If no negative numbers were entered, display a special message and skip to parting msg.
     mov  edx,OFFSET result_msg1
     call WriteString
     mov  eax,total
     cmp  eax,0
     je   now_done
     call WriteDec
     mov  edx,OFFSET result_msg2
     call WriteString
     call CrLf

; Display the sum of negative numbers entered.
     mov  edx,OFFSET sum_msg
     call WriteString
     mov  eax,sum
     call WriteInt
     call CrLf

; Display the average, rounded to the nearest integer (e.g. -20.5 rounds to -20)
     mov  edx,OFFSET avg_msg
     call WriteString
     mov  eax,average
     call WriteInt
     call CrLf
     jmp  now_done

; Special message if no negative numbers are entered
finished_early:
     mov  edx,OFFSET early_msg
     call WriteString
     call CrLf

; Display a parting message that includes the user's name
now_done:
     call CrLf
     call CrLf
     mov  edx,OFFSET final_msg
     call WriteString
     mov  edx,OFFSET userName
     call WriteString
     call CrLf
     call CrLF

; Terminate the program
     exit	; Exit to operating system
main ENDP

END main
