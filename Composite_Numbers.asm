TITLE Program 3			(Program3.asm)

; Program Description: This program calculates composite numbers.  
;	The program takes an integer from the user as the number of composite
;	numbers to print. THe results are displayed 10 composites per line with
;	at least 3 spaces between the numbers.	
;
;	Note: This program performs data validation.  The user must input a
;			number between 1-400. If the input is invalid a error message will
;			be displayed and the user will be prompted for the input again. 
; Author: Alex Marsh
; Date Created: July 24, 2015
; Last Modification Date: July 25, 2015

INCLUDE Irvine32.inc

; (insert symbol definitions here)

.data
userInput   DWORD    ?      ;number of composite numbers to print
numToPrint  DWORD    ?		;number to print 
UPPERLIMIT = 400		;upperlimit
LOWERLIMIT = 1		;lowerlimit
remainder   DWORD    ?       ;remainder to determine if number is composite
count      DWORD     ?		;count for isComposite procedure 
maxCount	DWORD    ?		;limit for count in isComposite procedure
numToDiv	DWORD    ?		;number to divide by numToPrint 
loopCount  DWORD	?

programTitle    BYTE	"Program 3: Composite Numbers",0
myName     BYTE    "Programmed by Alex Marsh",0
extraCredit   BYTE   "**EC: the output columns are aligned.",0
intro1   BYTE	"How many composite numbers you would like to see?",0
intro2   BYTE    "Make sure the number you enter is between 1 and 400.",0
inputPrompt  BYTE  "Please enter the number of composites to display[1...400]: ",0
invalid  BYTE	"Sorry, that number is out of range. Try again.",0
resultsCert   BYTE	"Results certified by Alex Marsh. ",0
goodBye	  BYTe	"Thank you for playing!  Until next time, goodbye!",0

here1   BYTE "Here1  ",0
here2   BYTE "Here2  ",0
here3   BYTE "Here3  ",0
here4   BYTE "Here4  ",0
here5   BYTE "Here5  ",0
	  
 

; (insert variables here)

.code
main PROC

; (insert executable instructions here)
	call introduction			;introduce the program
 
	call getUserData			;get number from user

	call showComposites			;print the composite

	call farewell				;	say thank you and goodbye 

	exit		; exit to operating system
main ENDP

; (insert additional procedures here)



;procedure to introduce the program
;recieves: none
;returns: none
;preconditions: none
;registers changed: edx

introduction PROC
	;Display title "Program 3: Composite Numbers"
		mov	edx,OFFSET programTitle
		call WriteString
		call Crlf

	;Display programmer name "Programmed By Alex Marsh"
		mov	edx,OFFSET myName
		call WriteString
		call Crlf
		call Crlf

	;Display programmer name "**EC: the out columns are aligned"
		mov	edx,OFFSET extraCredit
		call WriteString
		call Crlf
		call Crlf

	;Display intro1 "How many composite numbers you would like to see?"
		mov	edx,OFFSET intro1
		call WriteString
		call Crlf

	;Display intro2 "Make sure the number you enter is between 1 and 400."
		mov	edx,OFFSET intro2
		call WriteString
		call Crlf
		call Crlf
		
		ret
introduction ENDP	

;procedure to get the number of composite numbers
;to calculate
;Implementation note: this program calls the function 'validate' and this
;		procedure access its parameters as global variables
;recieves:none
;returns: user input value for number of composite values to be calculated
;preconditions: none
;registers changed: 	edx, eax	
getUserData PROC
	

	;get the integer from the user "Please enter the number of composites to display[1...400]: "
	
	mov  edx,OFFSET inputPrompt
	call WriteString
	call ReadInt
	mov userInput,eax			;store user input at address in userInput

	call validate			;check to make sure input is in range

	ret 

getUserData ENDP	

;procedure to validate user input is in range [1...400]
;recieves: none
;returns: none
;preconditions: none
;registers changed: eax, edx

validate PROC

top:
	;validate the input is higher than 1
	mov eax, userInput
	mov ebx, LOWERLIMIT
	cmp eax, ebx
	jb Notvalid

	;validate the input is lower then 400
	mov eax, userInput
	mov ebx, UPPERLIMIT
	cmp eax, ebx
	ja Notvalid
	jmp endNow

Notvalid: 
	;display invalid message "Sorry, that number is out of range. Try again."
	call Crlf
	mov edx,OFFSET invalid
	call WriteString
	call Crlf

	;display prompt "Please enter the number of composites to display[1...400]: "
	call Crlf
	mov  edx,OFFSET inputPrompt
	call WriteString
	call ReadInt
	mov userInput,eax	
	loop top

endNow:
	ret
validate ENDP

;procedure that prints the composites 
;recieves: none
;returns: none
;preconditions: none
;registers changed: eax, ecx

showComposites PROC
	call Crlf
	mov numToPrint, 3     ;start numbers at 4
	mov ecx, userInput	  ;set users number of comp wanted to loop counter	
	mov esi, 4

startComp1:
	mov  loopCount, ecx
	call isComposite
	mov ecx, loopCount
	mov eax, numToPrint
	call WriteDec
	mov al, TAB
	call WriteChar
	;dec esi
	.if Sign?
		mov al, 13
		call WriteChar
		mov al, 10
		call WriteChar
		mov esi, 5
	.endif
	
	loop startComp1

	call Crlf

	ret
showComposites ENDP

;procedure that checks if number is composite 
;recieves: none
;returns: none
;preconditions: none
;registers changed: eax, ebx, edx

isComposite PROC
	
	inc numToPrint

isCompTop:
	mov ebx, 2 
	mov numToDiv, ebx

	mov eax, numToPrint
	sub eax, 1
	mov maxCount, eax
	mov eax, 1
	mov count, eax

startComp2:	
	mov edx, 0
	mov ebx, numToDiv
	mov eax, numToPrint
	div ebx
	mov remainder, edx	
	
	mov eax, 0
	cmp eax, remainder	
	je isCompositeEnd
	
	
	mov eax, maxCount
	cmp eax, count
	je countReached

	mov ebx, numToDiv
	cmp eax, ebx
	je countReached

isNotComposite:				;number not composite
	inc numToDiv			;increment number to divide
	inc count				;increment count
	loop startComp2

countReached: 
	inc numToPrint
	loop isCompTop
	 
isCompositeEnd:
   ret

isComposite ENDP

;procedure to say goodbye to the user
;recieves: none
;returns: none
;preconditions: none
;registers changed: edx

farewell PROC
	;Display title "Results certified by Alex Marsh."
		call Crlf
		mov	edx,OFFSET resultsCert
		call WriteString
		call Crlf

	;Display intro1 "Thank you for playing!  Until next time, goodbye"
		mov	edx,OFFSET goodBye
		call WriteString
		call Crlf
		call Crlf
		
		ret
farewell ENDP	




END main	