TITLE Number Accumulator     (accumulator.asm)

; Author: Andrew Swaim
; Date: 2/11/2018
; Description: Prompts the user to enter numbers from -100 to -1 and displays the
;			number of negative numbers entered, the sum of the negative numbers, and the
;			rounded average of the numbers.

INCLUDE Irvine32.inc

LOWER_LIMIT = -100

.data
program		BYTE	"Welcome to the Integer Accumulator by Andrew Swaim",0
prompt1		BYTE	"What is your name? ",0
userName	BYTE	21 DUP (0)
greeting	BYTE	"Hello, ",0
rules1		BYTE	"Please enter numbers in [-100, -1].",0
rules2		BYTE	"Enter a non-negative number when you are finished to see results.",0
prompt2		BYTE	"Enter number ",0
prompt3		BYTE	": ",0
error		BYTE	"Out of range. Numbers must be greater than -100.",0
noNums		BYTE	"You didn't enter any valid numbers so there is nothing to display :(",0
goodbye1	BYTE	"Thank you for playing Integer Accumulator.",0
goodbye2	BYTE	"It's been a pleasure to meet you, ",0
goodbye3	BYTE	".",0
results1	BYTE	"You entered ",0
results2	BYTE	" valid numbers",0
results3	BYTE	"The sum of your valid numbers is ",0
results4	BYTE	"The rounded average is ",0
numOfTerms	DWORD	0
nextTerm	DWORD	1
sum			SDWORD	0
average		SDWORD	?

.code
main PROC
;Display program and author name
	mov		edx,OFFSET program
	call	WriteString
	call	Crlf
	call	Crlf
;Prompt for user's name
	mov		edx,OFFSET prompt1
	call	WriteString
	mov		edx,OFFSET userName
	mov		ecx,SIZEOF userName
	call	ReadString
;Display greeting to user
	mov		edx,OFFSET greeting
	call	WriteString
	mov		edx,OFFSET userName
	call	WriteString
	call	Crlf
	call	Crlf

;--------------------------------------

;User instructions
	mov		edx,OFFSET rules1
	call	WriteString
	call	Crlf
	mov		edx,OFFSET rules2
	call	WriteString
	call	Crlf

;--------------------------------------

getInput:
;Prompt for and get a number.
	mov		edx,OFFSET prompt2
	call	WriteString
	mov		eax,nextTerm
	call	WriteDec
	mov		edx,OFFSET prompt3
	call	WriteString
	call	ReadInt
;Validate number is >= -100 (lower limit).
	mov		ebx,LOWER_LIMIT
	cmp		eax,ebx
	jl		errorMessage
;If number is >= 0 discard number and stop prompting for numbers.
	mov		ebx,-1
	cmp		eax,ebx
	jg		inputDone
;If validation passed add number to sum, inc number of terms, and loop again.
	add		sum,eax
	inc		numOfTerms
	inc		nextTerm
	jmp		getInput

errorMessage:
;Display error message and prompt for user input again.
	call	Crlf
	mov		edx,OFFSET error
	call	WriteString
	call	Crlf
	mov		edx,OFFSET rules2
	call	WriteString
	call	Crlf
	jmp		getInput

;--------------------------------------

inputDone:
;Check if the user did not enter any terms.
	mov		ebx,numOfTerms
	cmp		ebx,0
	je		noNumbers

;Calculate the average.
	mov		eax,sum
	cdq
	idiv	ebx
	mov		average,eax

;Compare the doubled remainder to the divisor to determine if rounding is needed.
	mov		eax,2
	neg		edx
	mul		edx
	cmp		eax,numOfTerms
	jge		roundUp

printResults:
;Print number of valid terms.
	call	Crlf
	mov		edx,OFFSET results1
	call	WriteString
	mov		eax,numOfTerms
	call	WriteDec
	mov		edx,OFFSET results2
	call	WriteString
	call	Crlf

;Print sum of valid numbers.
	mov		edx,OFFSET results3
	call	WriteString
	mov		eax,sum
	call	WriteInt
	call	Crlf

;Print rounded average.
	mov		edx,OFFSET results4
	call	WriteString
	mov		eax,average
	call	WriteInt
	call	Crlf
	jmp		exitProgram

roundUp:
;Increment the average.
	inc		average
	jmp		printResults

noNumbers:
;If the user did not enter any numbers display a special message.
	call	Crlf
	mov		edx,OFFSET noNums
	call	WriteString
	call	Crlf
	jmp		exitProgram

;--------------------------------------

exitProgram:
;Display the parting message
	call	Crlf
	mov		edx,OFFSET goodbye1
	call	WriteString
	call	Crlf
	mov		edx,OFFSET goodbye2
	call	WriteString
	mov		edx,OFFSET userName
	call	WriteString
	mov		edx,OFFSET goodbye3
	call	WriteString
	call	Crlf
	call	Crlf

	exit	; exit to operating system
main ENDP

END main
