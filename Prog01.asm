; ***************************************************************************
; Name: Larissa Hahn
; E-mail: hahnl@onid.oregonstate.edu
; Class number-section: CS271-400
; Assignment Number: Program #1
; Assignment Due Date: 04-12-15
; Last Modifcation Date: 04-11-15
; Program Name: Prog01.asm
; Program Description: User enters 2 numbers. Sum, difference, product,
; quotient, and remainder are values calculated and displayed to the console.
; There is also the option to repeat the program again or quit.
; ***************************************************************************

; Personal Notes
; I experimented with some stuff in this assignment, but the program still
; works as desired. Hope you don't mind. =)

; Include Library for Assignment Files
INCLUDE Irvine32.inc

; DATA ALLOCATION
.data
; Number Variables
diff DWORD ? ; subtraction result
divis DWORD ? ; division result
mult DWORD ? ; multiplication result
numOne DWORD ? ; first number entered by user
numTwo DWORD ? ; second number entered by user
remaind DWORD ? ; remainder result
runAgain DWORD ? ; user input
sum DWORD ? ; addition result

; Program Info Strings
programName BYTE "Elementary Arithmetic by Larissa J. Hahn",0
extraCredit BYTE "**EC: Program repeats until user decides to quit.",0
programDescription BYTE "Please enter two numbers to be added, subtracted, multiplied, and divided.",0

; Prompt for User Input Strings
numberFirst BYTE "Enter first number: ",0
numberSecond BYTE "Enter second number: ",0

; RESULTS Header String
results BYTE "RESULTS:",0

; Calculation Output Format Strings; what a lot of work to piece variables inside of sentences!
addition BYTE " - Addition of ",0
andstring BYTE " and ",0
bystring BYTE " by ",0
division BYTE " - Division of ",0
fromstring BYTE " from ",0
is BYTE " is ",0
multiplication BYTE " - Multiplication of ",0
period BYTE ".",0
remainder BYTE " with a remainder of ",0
subtraction BYTE " - Subtraction of ",0

; Program End Strings
programEnd BYTE "Enter 1 to run program again. Otherwise press enter to quit.",0
finalWords BYTE "Thank you! Goodbye!",0

.code
; Main Procedure
main PROC

; INTRODUCTION
; Begin Loop for Run Program Again by Creating Label
RunProgramAgain:
     Call ClrScr

; Write Program Name to Console
     mov  edx,OFFSET programName
     call WriteString
	call CrLf

; Write Extra Credit to Console
     mov  edx,OFFSET extraCredit
     call WriteString
     call CrLf
     call CrLf

; Write Program Description to Console
	mov  edx,OFFSET programDescription
	call WriteString
	call CrLf

; GET THE DATA
; Request First Number
     call CrLf
	mov  edx,OFFSET numberFirst
	call WriteString
	call ReadInt
	mov  numOne, eax

; Request Second Number
	mov  edx,OFFSET numberSecond
	call WriteString
	call ReadInt
	mov  numTwo,eax
     call CrLf

; CALCULATE THE REQUIRED VALUES
; Add Two Numbers
	mov  eax,numOne
	add  eax,numTwo
	mov  sum,eax

; Subtract Second Number from First Number
	mov  eax,numOne
	sub  eax,numTwo
	mov  diff,eax

; Multiply Two Numbers
	mov  eax,numOne
	mov  ebx,numTwo
	mul  ebx
	mov  mult,eax

; Divide First Number by Second Number
	mov  eax,numOne
	mov  ebx,numTwo
     mov  edx,0
	div  ebx
	mov  divis,eax
	mov  remaind,edx

; DISPLAY THE RESULTS
; Results Output
     mov  edx,OFFSET results
     call WriteString
	call CrLf

; Addition Output
	mov  edx,OFFSET addition
	call WriteString
     mov  eax,numOne
	call WriteDec
     mov  edx,OFFSET andstring
	call WriteString
     mov  eax,numTwo
	call WriteDec
     mov  edx,OFFSET is
	call WriteString
     mov  eax,sum
     call WriteDec
     mov  edx,OFFSET period
	call WriteString
	call CrLf

; Subtraction Output
	mov  edx,OFFSET subtraction
	call WriteString
     mov  eax,numTwo
	call WriteDec
     mov  edx,OFFSET fromstring
	call WriteString
     mov  eax,numOne
	call WriteDec
     mov  edx,OFFSET is
	call WriteString
     mov  eax,diff
     call WriteDec
     mov  edx,OFFSET period
	call WriteString
	call CrLf

; Multiplication Output
	mov  edx,OFFSET multiplication
	call WriteString
     mov  eax,numOne
	call WriteDec
     mov  edx,OFFSET andstring
	call WriteString
     mov  eax,numTwo
	call WriteDec
     mov  edx,OFFSET is
	call WriteString
     mov  eax,mult
     call WriteDec
     mov  edx,OFFSET period
	call WriteString
	call CrLf

; Division Output
	mov  edx,OFFSET division
	call WriteString
     mov  eax,numOne
	call WriteDec
     mov  edx,OFFSET bystring
	call WriteString
     mov  eax,numTwo
	call WriteDec
     mov  edx,OFFSET is
	call WriteString
     mov  eax,divis
     call WriteDec

 ; Remainder Output
     mov  edx,OFFSET remainder
	call WriteString
     mov  eax,remaind
     call WriteDec
     mov  edx,OFFSET period
	call WriteString
	call CrLf
     call CrLf

; SAY GOODBYE
; Run Program Again Prompt
	mov  edx,OFFSET programEnd
	call WriteString
     call CrLf
	call ReadInt
	mov  runAgain,eax

; End Loop for Run Program Again
     mov  eax,runAgain
     cmp  eax, 1
     je   RunProgramAgain

; If Program Truly Ends
     mov  edx,OFFSET finalWords
     call WriteString
     call CrLf
     call CrLf

; Important Closing Code
     INVOKE ExitProcess,0
main ENDP
END main
