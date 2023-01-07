INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 5000
TotalItems = 24

.data
count BYTE 0
row BYTE 1 
two BYTE 2												; Just a variable to divide register(s)/vaiable(s) without disturbing other registers
col BYTE 65
maxX BYTE ?												; Maximun size with respect to X
maxY BYTE ?												; Maximun size with respect to Y
CenterX BYTE ?											; Center with respect to X
CenterY BYTE ?											; Center with respect to Y

buffer BYTE BUFFER_SIZE DUP(?)
filename BYTE "menu.txt", 0
filename2 BYTE "bill.txt", 0
fileHandle HANDLE ?

item1 BYTE "Chicken Biryani    ", 0
item2 BYTE "Beef Biryani       ", 0
item3 BYTE "Chicken Karahi     ", 0
item4 BYTE "Mutton Karahi      ", 0
item5 BYTE "White Karahi       ", 0
item6 BYTE "Chicken Haleem     ", 0
item7 BYTE "Chicken Tikka      ", 0
item8 BYTE "Naan               ", 0
item9 BYTE "Chapati            ", 0
item10 BYTE "Egg Fried Rice    ", 0
item11 BYTE "Chicken Macaroni  ", 0
item12 BYTE "Chicken Manchurian", 0
item13 BYTE "Chowmein          ", 0
item14 BYTE "Zinger Burger     ", 0
item15 BYTE "Chicken Pizza     ", 0
item16 BYTE "Chicken Shawarma  ", 0
item17 BYTE "French Fries      ", 0
item18 BYTE "Coca Cola         ", 0
item19 BYTE "Sprite            ", 0
item20 BYTE "Pine Apple Juice  ", 0
item21 BYTE "Banana Milkshake  ", 0
item22 BYTE "Chocolate Cake    ", 0
item23 BYTE "Coconut Cream Pie ", 0
item24 BYTE "Apple Pie         ", 0
item25 BYTE "Vanilla Icecream  ", 0

items DWORD item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, item11, item12, item13, item14, item15, item16, item17, item18, item19, item20, item21, item22, item23, item24, item25
price DWORD 100, 150, 600, 900, 1000, 100, 100, 15, 10, 150, 300, 300,  200, 100, 800, 200, 100, 100, 100, 80, 60, 1000, 600, 300, 200
Order SWORD TotalItems DUP(-1)
Quantity WORD TotalItems DUP(1)


LoadingScreenBar BYTE "___",0
LoadingScreenText01 BYTE "Have you lost weight?",0
LoadingScreenText02 BYTE "Life was supposed to be great ......",0
LoadingScreenText03 BYTE " Warning: Don't set yourself on fire",0
LoadingScreenText04 BYTE "Would you prefer chicken, steak, or tofu?",0
LoadingScreenText05 BYTE "Don't you think that the bits are flowing slowly today ?",0
str1 BYTE "Enter -1 when your order is complete", 0
str2 BYTE "Enter Item Number to place your order: ", 0
str3 BYTE "		Total Bill:		", 0
str4 BYTE "			BILL DETAIL", 0
str5 BYTE "Enter quantity: ",0
str6 BYTE "ID     ITEM     PRICE     QTY",0
space BYTE "     ", 0
IdHeading BYTE "ID",0
ItemHeading BYTE "ITEM",0
PriceHeading BYTE "PRICE",0
QuantityHeading BYTE "QTY",0
TIPHeading BYTE "TOTAL ITEM PRICE",0
TotalHeading BYTE "TOTAL",0

.code
main PROC

call PrintMenu
call GetOrder
call RemoveEndingLines
exit
main ENDP

GetOrder PROC
;Local variables to store input's cursor positions
LOCAL i_row : BYTE
LOCAL i_col : BYTE

	mov dh, row
	mov dl, col
	call Gotoxy
	mov edx, OFFSET str4
	call WriteString

	inc col
	inc row
	
	mov dh, row
	mov dl, col
	call Gotoxy

	;Printing dashes for design
	mov esi, 0
	mov ecx, 52
	PrintingDash:
		mov eax, '-'
		call WriteChar
	loop PrintingDash

	inc row

	mov dh, row
	mov dl, col
	call Gotoxy
	mov edx, OFFSET str1
	call WriteString

	inc row
	mov dh, row
	mov dl, col
	call Gotoxy
	mov edx, OFFSET str2
	call WriteString
	
	;Storing input's cursor positions in local variables
	mov al, row
	mov i_row, al
	add col, 39
	mov dl, col
	mov i_col, dl
	sub col, 39

	
	inc row
	inc row
	inc row
	mov dh, row
	mov dl, col
	call Gotoxy
	mov edx, OFFSET str6
	call WriteString

	

	mov esi, 0
	add row, 1
	;Condition for invalid inputs
	BreakkButUp:
	mov ax, 1
	.WHILE(ax != -1 && ax != 0 && ax < 25)
		;Moving cursor to the input position
		mov dh, i_row
		mov dl, i_col
		call gotoxy
		call ReadInt
		;Checking for printing bill
		.IF(eax == -1)
			call GeneratingBill
			jmp BreakMeDown
		.ELSEIF(eax == 0 || eax > 24)
			jmp BreakkButUp
		.ENDIF
		;Input for taking item's ID
		mov Order[esi * TYPE WORD], ax
		
		inc i_row
		mov dh, i_row
		mov dl, col
		call gotoxy
		mov edx, OFFSET str5
		call WriteString
		call ReadDec
		.IF(eax == 0)
			mov eax, 1
		.ENDIF

		;Input for taking item's quantity
		mov Quantity[esi * TYPE WORD], ax
		dec i_row

		add row,1
		mov dh, row
		mov dl, col
		call Gotoxy

		; Printing items' id and then space.
		movzx eax, Order[esi * TYPE WORD]
		call WriteDec
		mov edx, OFFSET space
		call WriteString


		; Printing items' name and then space.
		movzx eax, Order[esi * TYPE WORD]
		dec eax
		mov edx, items[eax* TYPE DWORD]
		call WriteString
		mov edx, OFFSET space
		call WriteString
		
		
		; Printing items' price and then space.
		movzx eax, Order[esi * TYPE WORD]
		dec eax
		mov eax, price[eax* TYPE DWORD]
		call WriteDec
		mov edx, OFFSET space
		call WriteString

		; Printing items' quantity and then space.
		movzx eax, Quantity[esi * TYPE WORD]
		call WriteDec
		mov edx, OFFSET space
		call WriteString
		
		inc esi
		mov ax, 1
	.ENDW
	BreakMeDown:
	ret
GetOrder ENDP

GeneratingBill PROC
	mov eax, white*(16+black)
	call SetTextColor
	call ReadMyScreenDetails
	call clrscr
	call LoadingScreen
	call clrscr
	call PrintBill
	ret
GeneratingBill ENDP

PrintBill PROC
	LOCAL NewX : BYTE
	LOCAL NewY : BYTE
	LOCAL totalBill : DWORD
	LOCAL tempPrice : WORD

	mov totalBill, 0
	;Seting new cursor position for bill
	mov al, CenterX 
	SHR al, 1
	mov bl, CenterY
	SHR bl, 2
	mov NewX, al
	mov NewY, bl


	mov dh, NewY
	mov dl, NewX
	call Gotoxy
	;mov edx, OFFSET space
	;call WriteString
	mov edx, OFFSET str4
	call WriteString
	
	add NewY, 2
	sub NewX, 6
	mov dh, NewY
	mov dl, NewX
	call Gotoxy
	
	mov edx, OFFSET IdHeading
	call WriteString
	mov edx, OFFSET space
	call WriteString
	call WriteString

	mov edx, OFFSET ItemHeading
	call WriteString
	mov edx, OFFSET space
	call WriteString
	call WriteString
	call WriteString

	
	mov edx, OFFSET PriceHeading
	call WriteString
	mov edx, OFFSET space
	call WriteString

	
	mov edx, OFFSET QuantityHeading
	call WriteString
	mov edx, OFFSET space
	call WriteString
	call WriteString

	mov edx, OFFSET TIPHeading
	call WriteString
	
	mov esi, 0

	.WHILE(Order[esi * TYPE WORD] != -1) 
		inc NewY
		mov dh, NewY
		mov dl, NewX
		call Gotoxy
		; Printing items' id and then space.
		movzx eax, Order[esi * TYPE WORD]
		call WriteDec
		mov edx, OFFSET space
		call WriteString


		; Printing items' name and then space.
		movzx eax, Order[esi * TYPE WORD]
		dec eax
		mov edx, items[eax* TYPE DWORD]
		call WriteString
		mov edx, OFFSET space
		call WriteString
		
		
		; Printing items' price and then space.
		movzx eax, Order[esi * TYPE WORD]
		dec eax
		mov eax, price[eax* TYPE DWORD]
		call WriteDec
		mov tempPrice, ax
		mov edx, OFFSET space
		call WriteString
		call WriteString

		; Printing items' quantity and then space.
		movzx eax, Quantity[esi * TYPE WORD]
		call WriteDec
		mov edx, OFFSET space
		call WriteString
		call WriteString

		mul tempPrice
		add totalBill, eax
		call WriteDec
		inc esi
	.ENDW
	add NewY, 2
	add NewX, 34
	mov dh, NewY
	mov dl, NewX
	call Gotoxy
	mov edx, OFFSET TotalHeading
	call WriteString
	mov edx, OFFSET space
	call WriteString
	call WriteString
	call WriteString
	mov eax, totalBill
	call WriteDec
	ret
PrintBill ENDP

;Printing Menu
PrintMenu PROC
	pushad
	mov edx,OFFSET filename
	call OpenInputFile
	mov fileHandle,eax

	; Read the file into a buffer.
	mov edx,OFFSET buffer
	mov ecx,BUFFER_SIZE
	call ReadFromFile
	mov buffer[eax],0 

	; Display the buffer.
	mov edx,OFFSET buffer 
	call WriteString
	call Crlf
	mov eax,fileHandle
	call CloseFile
	popad
	ret
PrintMenu ENDP

; Move the cursor at the end of the screen. 
RemoveEndingLines PROC
	mov dh, 44
	mov dl, 1
	call Gotoxy
	ret
RemoveEndingLines ENDP


ReadMyScreenDetails PROC
	;***********************
	; NOTES
	; MAX X = 120d or 78h & MAX Y = 29d or 1Dh
	;***********************

	;Getting max screen size & center of the screen
		mov dh, 1Dh		; Should be obtained from GetMaxXY
		mov dl, 78h		; Should be obtained from GetMaxXY

	;Saving max sizes of X & Y
		mov maxX, dl
		mov maxY, dh

	;Saving the center values into vaiables
		movzx ax, maxX
		div two
		mov CenterX, al
		movzx ax, maxY
		div two
		mov CenterY, al
	ret
ReadMyScreenDetails ENDP

LoadingScreen PROC
	;***********************
	;CAUTION:	It should be called or after any important working with register. OItherwise, it'll change registers
	;ARGUMENTS:	NONE
	;RETURN:	?
	;***********************
	
	mov ecx, 0
	.WHILE(ecx <= 100)
		mov dh, CenterY
		mov dl, CenterX
		sub dh, 2
		.IF (ecx == 0)
			sub dl , 15
			call GotoXY
			mov edx, OFFSET LoadingScreenBar
			call WriteString
		.ELSEIF (ecx == 10)
			sub dl , 12
			call GotoXY
			mov edx, OFFSET LoadingScreenBar
			call WriteString
		.ELSEIF (ecx == 20)
			sub dl , 9
			call GotoXY
			mov edx, OFFSET LoadingScreenBar
			call WriteString
		.ELSEIF (ecx == 30)
			sub dl , 6
			call GotoXY
			mov edx, OFFSET LoadingScreenBar
			call WriteString
		.ELSEIF (ecx == 40)
			sub dl , 3
			call GotoXY
			mov edx, OFFSET LoadingScreenBar
			call WriteString
		.ELSEIF (ecx == 50)
			call GotoXY
			mov edx, OFFSET LoadingScreenBar
			call WriteString
		.ELSEIF (ecx == 60)
			add dl , 3
			call GotoXY
			mov edx, OFFSET LoadingScreenBar
			call WriteString
		.ELSEIF (ecx == 70)
			add dl , 6
			call GotoXY
			mov edx, OFFSET LoadingScreenBar
			call WriteString
		.ELSEIF (ecx == 80)
			add dl , 9
			call GotoXY
			mov edx, OFFSET LoadingScreenBar
			call WriteString
		.ELSEIF (ecx == 90)
			add dl , 12
			call GotoXY
			mov edx, OFFSET LoadingScreenBar
			call WriteString
		.ELSEIF (ecx == 100)
			add dl , 15
			call GotoXY
			mov edx, OFFSET LoadingScreenBar
			call WriteString
		.ENDIF
		


		mov dh, CenterY
		mov dl, CenterX
		call GotoXY
		mov eax, ecx
		call WriteDec
		mov eax, '%'
		call WriteChar
	
		.IF(ecx <= 20)
			mov eax, LENGTHOF LoadingScreenText01
			sub eax, 1
			SHR eax, 1
			mov dh, CenterY
			mov dl, CenterX
			add dh, 1
			sub dl, al
			call GotoXY
			mov edx, OFFSET LoadingScreenText01 
			mov eax, 80
		.ELSEIF(ecx <= 50)
			mov eax, LENGTHOF LoadingScreenText02
			sub eax, 1
			SHR eax, 1
			mov dh, CenterY
			mov dl, CenterX
			add dh, 1
			sub dl, al
			call GotoXY
			mov edx, OFFSET LoadingScreenText02
			mov eax, 90
		.ELSEIF(ecx <=70)
			mov eax, LENGTHOF LoadingScreenText03
			sub eax, 1
			SHR eax, 1
			mov dh, CenterY
			mov dl, CenterX
			add dh, 1
			sub dl, al
			call GotoXY
			mov edx, OFFSET LoadingScreenText03
			mov eax, 180
		.ELSEIF(ecx <=93)
			mov eax, LENGTHOF LoadingScreenText04
			sub eax, 1
			SHR eax, 1
			mov dh, CenterY
			mov dl, CenterX
			add dh, 1
			sub dl, al
			call GotoXY
			mov edx, OFFSET LoadingScreenText04
			mov eax, 150
		.ELSE
			mov eax, LENGTHOF LoadingScreenText05
			sub eax, 1
			SHR eax, 1
			mov dh, CenterY
			mov dl, CenterX
			add dh, 1
			sub dl, al
			call GotoXY
			mov edx, OFFSET LoadingScreenText05
			mov eax, 500
		.ENDIF
		call WriteString
		add ecx, 1
		call Delay
		;call Clrscr
	.ENDW
	ret
LoadingScreen ENDP

END main
