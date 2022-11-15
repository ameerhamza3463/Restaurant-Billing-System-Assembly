INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 5000

.data
buffer BYTE BUFFER_SIZE DUP(?)
filename BYTE "menu.txt", 0
fileHandle HANDLE ?
item1 BYTE "Chicken Biryani", 0
item2 BYTE "Beef Biryani", 0
item3 BYTE "Chicken Karahi", 0
item4 BYTE "Mutton Karahi", 0
item5 BYTE "White Karahi", 0
item6 BYTE "Chicken Haleem", 0
item7 BYTE "Chicken Tikka", 0
item8 BYTE "Naan", 0
item9 BYTE "Chapati", 0
item10 BYTE "Egg Fried Rice", 0
item11 BYTE "Chicken Macaroni", 0
item12 BYTE "Chicken Manchurian", 0
item13 BYTE "Zinger Burger", 0
item14 BYTE "Chicken Pizza", 0
item15 BYTE "Chicken Shawarma", 0
item16 BYTE "French Fries", 0
item17 BYTE "Coca Cola", 0
item18 BYTE "Sprite", 0
item19 BYTE "Pine Apple Juice", 0
item20 BYTE "Banana Milkshake", 0
item21 BYTE "Chocolate Cake", 0
item22 BYTE "Coconut Cream Pie", 0
item23 BYTE "Apple Pie", 0
item24 BYTE "Vanilla Icecream", 0
items DWORD item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, item11, item12, item13, item14, item15, item16, item17, item18, item19, item20, item21, item22, item23, item24
pricee DWORD 100, 150, 600, 900, 1000, 100, 100, 15, 10, 150, 300, 300,  200, 100, 800, 200, 100, 100, 100, 80, 60, 1000, 600, 300, 200
str1 BYTE "Enter 0 when your order is complete", 0
str2 BYTE "Enter Item Number to place your order: ", 0
str3 BYTE "		Total Bill:		", 0
row BYTE 1 
count BYTE 0
ordered_food WORD 5 DUP(?)
bill DWORD 5 DUP(?)
totalbill DWORD 0

.code
main PROC
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

mov dh, row
mov dl, 65
call Gotoxy
mov edx, OFFSET str1
call WriteString
call crlf

add row, 1
mov dh, row
mov dl, 65
call Gotoxy
mov edx, OFFSET str2
call WriteString
call crlf

add row, 1
mov ax, 1
mov esi, 0
.WHILE(ax != 0)
	mov dh, row
	mov dl, 65
	call Gotoxy
	call ReadDec
	mov ordered_food[esi * TYPE ordered_food], ax
	add esi, 1
	add row, 1
.ENDW
mov ecx, LENGTHOF ordered_food
L2:
	movzx esi, count
	movzx eax, ordered_food[esi * TYPE ordered_food]
	mov esi, eax
	mov eax, pricee[esi * TYPE bill]
	movzx esi, count
	mov bill[esi * TYPE bill], eax
	add totalbill, eax
	add count, 1
loop L2
mov ecx, lENGTHOF bill
mov esi, 0
L3:

	;mov eax, totalbill
	mov dh, row
	mov dl, 65
	call Gotoxy
	mov eax, bill[esi * TYPE bill]
	call WriteDec
	add row, 1
	add esi, 1
loop L3
	call crlf
	call crlf
	mov dh, row
	mov dl, 65
	call Gotoxy
	mov edx, OFFSET str3
	call WriteString
	mov eax, totalbill
	call WriteDec
	;L3:
	;	cmp ordered_food[esi * TYPE ordered_food], count
	;	je equal
	;	add count, 1
	;loop L3
;mov esi, 0
;mov ecx, LENGTHOF ordered_food
;L2:
;	mov dh, row
;	mov dl, 65
;	call Gotoxy
;	mov ax, ordered_food[esi * TYPE ordered_food]
;	call WriteDec
;	add esi, 1
;	add row, 1
;loop L2
jmp endd
;mov ecx, LENGTHOF items
;mov esi, 0
;L1:
;	mov edx, items[esi * TYPE items]
;	call WriteString
;	call crlf
;	inc esi
;loop L1
endd:
mov dh, 44
mov dl, 1
call Gotoxy
exit
main ENDP
END main