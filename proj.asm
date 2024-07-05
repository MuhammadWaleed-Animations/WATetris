[org 0x0100]
	jmp strt
p1: db 'Muhammad Waleed',0
p2: db 'Armeen Fatima',0
music_length: dw 15644
music_data: incbin "getthem.imf"	
currScore: dw 0
stline: db 'Welcome to the Game',0
endline: db '    GAME OVER    ',0
time: dw 10
sec: dw 0
min: dw 0
endScore: db 'Your Score was',0
oldTisr: dd 0
oldKbisr: dd 0
currShape: dw 0
currRow: dw 0
currCol: dw 0
freq:   incbin "freq.bin"
dura:   incbin "duration.bin"
ticks_left: dw 0
loc: dw 0
rand: dw 0
scrollFlag: dw 0
rotationFlag: dw 0
nextS: dw 1
endFlag: dw 0
sbuffer: times 80*25 dw 0

cbuffer:
	;copy buffer
		push bp
		mov bp,sp
		push es
		push ax
		push cx
		push di
		push si
		push ds
	
		mov di,sbuffer
		mov si,0
		mov cx,2000
		
		push cs
		pop es
		cld
		mov ax,0xb800
		mov ds,ax
		
		rep movsw
	
		pop ds
		pop si
		pop di
		pop cx
		pop ax
		pop es
		mov sp,bp
		pop bp
ret



updateScreen:
		push bp
		mov bp,sp
		push es
		push ax
		push bx
		push cx
		push di
		push si
		push ds
		
		sub sp,2
		mov bx,[bp+4];row
		push bx;row 
		push 0;col
		call calLoc
		pop cx ;address of index
		shr cx,1 ;half for copying words
		
		mov ax,0xb800
		mov es,ax
		
		push cs
		pop ds
		;ds same
		mov di,0
		mov si,sbuffer
		cld
		rep movsw
		
		
		pop ds
		pop si
		pop di
		pop cx
		pop bx
		pop ax
		pop es
		mov sp,bp
		pop bp
 ret 2
	
endscr:
		push bp
		mov bp,sp
		push es
		push ax
		push di
		call speakerOff
		mov ax,0xb800
		mov es,ax
		mov di,0
	c12:mov word[es:di],0x5020
		add di,2
		cmp di,4000
		jne c12
		
		; pop di
		; pop ax
		; pop es
		; mov sp,bp
		; pop bp
		mov ax,1976
		push ax
		push endline
		call printName
		
		; mov ax,2136
		; push ax
		; push endScore
		; call printName
		
		
		mov ax,2142
		push ax
		call score
		
		pop di
		pop ax
		pop es
		mov sp,bp
		pop bp
ret



printName:
		push bp
		mov bp,sp
		push ax
		push cx
		push es
		push di
		push si
		mov ax,0xb800
		mov es,ax
		mov di,[bp+6]
		mov si,[bp+4]
		cmp byte[si],0
		je retPrint
	next1:
		mov al,[si]
		mov ah,0x0E
		mov [es:di],ax
		add di,2
		add si,1
		cmp byte[si],0
		jne next1
	retPrint:
		pop si
		pop di
		pop es 
		pop cx
		pop ax 
		mov sp,bp
		pop bp
ret 4

grid:
		push es
		push ax
		push di
		mov ax,0xb800
		mov es,ax
		mov di,0
		mov cx,0
		mov al,'_'
		mov ah,0xFF   ;82 ;FF ;87
		
	grid1:
		cmp cx,320
		jb next
		mov cx,0
	next:
		cmp cx,160
		jae abov
		mov al,0x20
		mov word[es:di],ax
		add di,2
		mov al,'_'
		mov word[es:di],ax
		add di,2
		add cx,4
		jmp cmdi
	abov:	
		mov al,'|'
		mov word[es:di],ax
			add di,2
		mov al,'_'
		mov word[es:di],ax
		add di,2
		add cx,4
	cmdi:
		cmp di,4000
		jne grid1
		
	return:
		pop di
		pop ax
		pop es
ret


cls:
		push bp
		mov bp,sp
		push es
		push ax
		push di
		
		mov ax,0xb800
		mov es,ax
		mov di,0
	cls1:	mov word[es:di],0x0720
		add di,2
		cmp di,4000
		jne cls1
		
		pop di
		pop ax
		pop es
		mov sp,bp
		pop bp
ret
	
startSrc:
	; push bp
	; mov bp,sp
	; push es
	; push ax
	; push di
	; mov ax,0xb800
	; mov es,ax
	; mov di,0
; sts:	mov word[es:di],0xF12A
	; add di,2
	; cmp di,4000
	; jne sts
	
	; pop di
	; pop ax
	; pop es
	; mov sp,bp
	; pop bp
	push ax
	call grid
	mov ax,1976
	push ax
	push stline
	call printName
	pop ax
ret	
	
music:
		push si
		push dx
		push ax
		push bx
		push cx
		mov si, 200
	.next_note:
		mov dx, 388h
		mov al, [si + music_data + 0]
		out dx, al
		mov dx, 389h
		mov al, [si + music_data + 1]
		out dx, al
		mov bx, [si + music_data + 2]
		add si, 4
	.repeat_delay:
		mov cx, 610
	.delay:
		mov ah, 1
		int 16h
		jnz st
		loop .delay
		dec bx
		jg .repeat_delay
		cmp si, [music_length]
		jb .next_note
	st:
		mov dx, 388h
		mov al, 0xff
		out dx, al
		mov dx, 389h
		mov al, 0xff
		out dx, al
		mov bx, 0
		pop cx
		pop bx
		pop ax
		pop dx
		pop si
ret



bgRight: ;
		push bp
		mov bp,sp
		push es
		push ax
		push di
		mov ax,0xb800
		mov es,ax
		mov di,122
		mov cx,122
	bgr1:	
		mov word[es:di],0x4120
		add di,2
		add cx,2
		cmp cx,160
		jne skip2
		mov cx,122
		add di,122
	skip2:
		cmp di,4000
		jbe bgr1
		
		pop di
		pop ax
		pop es
		mov sp,bp
		pop bp
ret 	
	
bgLeft:
		push bp
		mov bp,sp
		push es
		push ax
		push di
		mov ax,0xb800
		mov es,ax
		mov di,0
		mov cx,0
	bl1:	
		mov word[es:di],0x0020
		add di,2
		add cx,2
		cmp cx,120
		jne skip1
		mov cx,0
		add di,40
	skip1:
		cmp di,4000
		jbe bl1
		
		pop di
		pop ax
		pop es
		mov sp,bp
		pop bp
ret



box:
	;para0 = att
	;para1 = row
	;para2 = col 
	push bp
	mov bp,sp
	push es
	push ax
	push di
	push bx
	mov ax,0xb800
	mov es,ax
	mov di,0
	mov ax, [bp+6]
	mov bl,80
	mul bl
	add ax,word[bp+4]
	shl ax,1
	mov di,ax
	mov ah,[bp+8]   ; ;F5 = purple
	mov al,0x20
	;mov word[es:di],ax
	mov al,'_'
	mov word[es:di+2],ax
	mov al,0x20
	;mov word[es:di+4],ax
	add di,160
	; cmp word[es:di],0x0E7C
	; je sb1
	mov al,'|'
	mov word[es:di],ax
sb1:	
	mov al,'_'
	mov word[es:di+2],ax
	
	; cmp word[es:di+4],0x0E7C
	; je sb2
	mov al,'|'
	mov word[es:di+4],ax
sb2:	
	pop bx
	pop di
	pop ax
	pop es
	mov sp,bp
	pop bp
ret 6
	
	
	
right: 

		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx


		mov cx,[bp+8]	;len
		mov ax,[bp+6]	 ;row
		mov bx,[bp+4]	;col

	r1:
		mov dx,[bp+10]	;att
		push dx
		push ax		
		push bx
		call box
		add bx,2
		sub cx,1
		jnz r1


		pop dx
		pop cx
		pop bx
		pop ax
		mov sp,bp 
		pop bp
ret 8
	  
left:    ;
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx


		mov cx,[bp+8]
		mov ax,[bp+6]	
		mov bx,[bp+4]

	le1:	  
		mov dx,[bp+10]
		push dx
		push ax		
		push bx
		call box
		sub bx,2
		sub cx,1
		jnz le1
        
		pop dx
		pop cx
		pop bx
		pop ax
		mov sp,bp 
		pop bp
ret 8	  
	  
down: 	;
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
        push dx

		mov cx,[bp+8]
		mov ax,[bp+6]	
		mov bx,[bp+4]

	d1:	
		mov dx,[bp+10]
		push dx
		push ax		
		push bx
		call box
		add ax,1
		sub cx,1
		jnz d1


        pop dx
		pop cx
		pop bx
		pop ax
		mov sp,bp 
		pop bp
ret 8
	
up:		;
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx


		mov cx,[bp+8]
		mov ax,[bp+6]	
		mov bx,[bp+4]

	u1:	
		mov dx,[bp+10]
		push dx
		push ax		
		push bx
		call box
		sub ax,1
		sub cx,1
		jnz u1


        pop dx
		pop cx
		pop bx
		pop ax
		mov sp,bp 
		pop bp
ret 8
	

upT: ;partial  
	
	push bp
	mov bp,sp
	push es
	push ax
	push di
	push bx
	push dx
	push cx
	
	
	mov ax,[bp+6]
	mov bx,[bp+4]
	mov cx,3
	mov dx,[bp+8]
	push dx
	push cx
	push ax
	push bx
	call right
	push dx
	mov cx,2
	add bx,2
	push cx
	push ax
	push bx
	call up
	
	pop cx
	pop dx
	pop bx
	pop di
	pop ax
	pop es
	mov sp,bp
	pop bp
ret 6


rightT:
	
	push bp
	mov bp,sp
	push es
	push ax
	push di
	push bx
	push dx
	push cx
	
	mov ax,[bp+6]
	mov bx,[bp+4]
	mov cx,3
	mov dx,[bp+8]
	push dx
	push cx
	push ax
	push bx
	call down
	push dx
	mov cx,2
	add ax,1
	push cx
	push ax
	push bx
	call right
			 
	pop cx
	pop dx
	pop bx
	pop di
	pop ax
	pop es
	mov sp,bp
	pop bp
ret 6


leftT:
	
	push bp
	mov bp,sp
	push es
	push ax
	push di
	push bx
	push dx
	push cx
	
	mov ax,[bp+6]
	mov bx,[bp+4]
	mov cx,3
	mov dx,[bp+8]
	push dx
	push cx
	push ax
	push bx
	call down
	push dx
	mov cx,2
	add ax,1
	push cx
	push ax
	push bx
	call left
		
	pop cx
	pop dx
	pop bx
	pop di
	pop ax
	pop es
	mov sp,bp
	pop bp
ret 6


downT:  
	push bp
	mov bp,sp
	push es
	push ax
	push di
	push bx
	push dx
	push cx
	
	mov dx,[bp+8]
	push dx
	mov ax,[bp+6]
	mov bx,[bp+4]
	mov cx,3
	push cx
	push ax
	push bx
	call right
	push dx
	mov cx,2
	add bx,2
	push cx
	push ax
	push bx
	call down
	
	pop cx
	pop dx
	pop bx
	pop di
	pop ax
	pop es
	mov sp,bp
	pop bp
ret 6


sedhaBox:   ;
	push bp
	mov bp,sp
	push es
	push ax
	push di
	push bx
	push cx
	push dx
	
	mov dx,[bp+8]
	push dx
	mov ax,[bp+6]
	mov bx,[bp+4]
	mov cx,2
	push cx
	push ax
	push bx
	call down
	push dx
	mov cx,2
	add bx,2
	push cx
	push ax
	push bx
	call down
	
	pop dx
	pop cx
	pop bx
	pop di
	pop ax
	pop es
	mov sp,bp
	pop bp
ret 6



hzig:
push bp
	mov bp,sp
	push es
	push ax
	push di
	push bx
	push dx
	push cx
	
	mov dx,[bp+8]
	push dx
	mov ax,[bp+6]
	mov bx,[bp+4]
	mov cx,2
	push cx
	push ax
	push bx
	call right	
	push dx
	mov cx,2
	add ax,1
	add bx,2
	push cx
	push ax
	push bx
	call right
	
	pop cx
	pop dx
	pop bx
	pop di
	pop ax
	pop es
	mov sp,bp
	pop bp
ret 6


Vzig:       ;
	push bp
	mov bp,sp
	push es
	push ax
	push di
	push bx
	push dx
	push cx
	;-----------------------------------
	
	
	
	mov dx,[bp+8]
	push dx
	mov ax,[bp+6]
	mov bx,[bp+4]
	mov cx,2
	push cx
	push ax
	push bx
	call down	
	push dx
	mov cx,2
	add ax,1
	sub bx,2
	push cx
	push ax
	push bx
	call down
	
	pop cx
	pop dx
	pop bx
	pop di
	pop ax
	pop es
	mov sp,bp
	pop bp
ret 6


ultaL: ;partail      ;
	;para1 = row
	;para2 = col 
	push bp
	mov bp,sp
	push es
	push ax
	push di
	push bx
	push dx
	
	
	mov ax,[bp+6]
	mov bx,[bp+4]
	mov cx,3
	mov dx,[bp+8]
	push dx
	push cx
	push ax
	push bx
	call down
	mov cx,2
	add ax,2
	push dx
	push cx
	push ax
	push bx
	call left
	
	pop dx
	pop bx
	pop di
	pop ax
	pop es
	mov sp,bp
	pop bp
ret 6


ulta:        ;
	;para1 = row
	;para2 = col 
	push bp
	mov bp,sp
	push es
	push ax
	push di
	push bx
	push dx
	
	mov dx,[bp+8]
	push dx
	mov ax,[bp+6]
	mov bx,[bp+4]
	mov cx,3
	push cx
	push ax
	push bx
	call right
	mov dx,[bp+8]
	push dx
	mov cx,2
	add bx,6
	push cx
	push ax
	push bx
	call down
	
	pop dx
	pop bx
	pop di
	pop ax
	pop es
	mov sp,bp
	pop bp
ret 6

Vline:  ;
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	mov dx,[bp+8]
	push dx
	mov cx,4
	mov ax,[bp+6]
	mov bx,[bp+4]
	push cx
	push ax
	push bx
	call down
	pop dx
	pop cx
	mov sp,bp
	pop bp
ret 6

Hline:  ;
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	mov dx,[bp+8]
	push dx
	mov cx,4
	mov ax,[bp+6]
	mov bx,[bp+4]
	push cx
	push ax
	push bx
	call right
	pop dx
	pop cx
	mov sp,bp
	pop bp
ret 6


score:
	push bp
	mov bp,sp
	push es
	push ax
	push di
	push si
	push cx
	push bx
	push dx
	
	mov ax,0xb800
	mov es,ax
	;mov ax,2 ;row
	;mov bx,67 ;col
	mov di,[bp+4]
	mov ah,0x40
	mov al,'s'
	mov [es:di],ax
	add di,2
	mov al,'c'
	mov [es:di],ax
	add di,2
	mov al,'o'
	mov [es:di],ax
	add di,2
	mov al,'r'
	mov [es:di],ax
	add di,2
	mov al,'e'
	mov [es:di],ax
	add di,2
	mov al,':'
	mov [es:di],ax
	add di,2
	mov al,' '
	mov [es:di],ax
	add di,2
	
	
	;print num
	mov ax,[currScore]
	mov bx,10
	mov cx,0
nextDigit:
	mov dx,0
	div bx
	add dl,0x30
	push dx
	inc cx
	cmp ax,0
	jnz nextDigit
	
	;mov di,0
	
nextpos:
	pop dx
	mov dh, 0x40
	mov [es:di],dx
	add di,2
	loop nextpos
	
	
	pop dx
	pop bx
	pop cx
	pop si
	pop di
	pop ax
	pop es
	mov sp,bp
	pop bp
ret 2



nextShape:  ;shiiiiiiiii kro
		push bp
		mov bp,sp
		push es
		push ax
		push di
		push si
		push cx
		push bx
		push dx

		mov ax,0xb800
		mov es,ax
		mov di,2368
		mov ax,0x7120 ;leftbg color
	a:	mov cx,12
		cld	
		mov si,di
		rep stosw     ;n1:word[es:di],ax    ;add di,2  ;dec cx
		add si,160
		mov di,si
		cmp di,3520
		jb  a
		;add di,24
		;mov word[es:di],0xFF
		;cmp di,4000
		;jne c1
		
		mov ax,0xFC
		push ax
		mov ax,16 ;row
		mov bx,67 ;col
		
		push ax
		push bx
		
	mov dx,[nextS]	
	; mov [currScore],dx
	; push 290
	; call score
	cmp dx,1
	jne s24
s14:	
	;call endscr	

	call sedhaBox
	push exitScrol
	ret
	

	
	
s24:	cmp dx,2				;Vline
	jne s34
	
	call Vline
	jmp exitScrol
	
s34:	cmp dx,3				;Hline
	jne s44
	call Hline
	
	jmp exitScrol
	
	
	
s44:	cmp dx,4				;Vzig
	jne s54
	call Vzig
	jmp exitScrol
	
	
s54:	cmp dx,5				;hzig
	jne s64
	
	call hzig
	
	jmp exitScrol


	
s64:	cmp dx,6				;upT
	jne s74
	
	call upT
	
	jmp exitScrol
	
	
s74:	cmp dx,7				;leftT
	jne s84
	
	call leftT

	jmp exitScrol
	
	
	
s84:	cmp dx,8				;DownT
	jne s94
	
	call downT
	
	jmp exitScrol
	
	
s94:	cmp dx,9				;RightT
	jne exitScrol
	
	call rightT
	
	jmp exitScrol		
	
	
exitScrol:
		pop dx
		pop bx
		pop cx
		pop si
		pop di
		pop ax
		pop es
		mov sp,bp
		pop bp
ret 2


; nextShape:  ;shiiiiiiiii kro
		; push bp
		; mov bp,sp
		; push es
		; push ax
		; push di
		; push si
		; push cx
		; push bx
		; push dx

		; mov ax,0xb800
		; mov es,ax
		; mov di,2368
		; mov ax,0x7120 ;leftbg color
	; a:	mov cx,12
		; cld	
		; mov si,di
		; rep stosw     ;n1:word[es:di],ax    ;add di,2  ;dec cx
		; add si,160
		; mov di,si
		; cmp di,3520
		; jb  a
		; ;add di,24
		; ;mov word[es:di],0xFF
		; ;cmp di,4000
		; ;jne c1
		
		; mov ax,0xFC
		; push ax
		; mov ax,16 ;row
		; mov bx,67 ;col
		
		; push ax
		; push bx
		; call Vline		
	
	
; exitScrol:
		; pop dx
		; pop bx
		; pop cx
		; pop si
		; pop di
		; pop ax
		; pop es
		; mov sp,bp
		; pop bp
; ret 2

t:
		push bp
		mov bp,sp
		push es
		push ax
		push di
		push si
		push cx
		push bx
		
		mov ax,0xb800
		mov es,ax
		;mov ax,4 ;row
		;mov bx,67 ;col
		mov di,610
		mov ah,0x40
		mov al,'T'
		mov [es:di],ax
		add di,2
		mov al,'i'
		mov [es:di],ax
		add di,2
		mov al,'m'
		mov [es:di],ax
		add di,2
		mov al,'e'
		mov [es:di],ax
		add di,2
		mov al,' '
		mov [es:di],ax
		add di,2
		mov al,':'
		mov [es:di],ax
		add di,2
		mov al,' '
		mov [es:di],ax
		add di,2
		
		
		;print num
		mov ax,[min]
		mov bx,10
		mov cx,0
	nextDigit1:
		mov dx,0
		div bx
		add dl,0x30
		push dx
		inc cx
		cmp ax,0
		jnz nextDigit1
		
		;mov di,0
		
	nextpos1:
		pop dx
		mov dh, 0x40
		mov [es:di],dx
		add di,2
		loop nextpos1
		
		mov dx,0x403A
		mov [es:di],dx
		add di,2
		
		;print num
		mov ax,[sec]
		mov bx,10
		mov cx,0
	nextDigit2:
		mov dx,0
		div bx
		add dl,0x30
		push dx
		inc cx
		cmp ax,0
		jnz nextDigit2
		
		;mov di,0
		
	nextpos2:
		pop dx
		mov dh, 0x40
		mov [es:di],dx
		add di,2
		loop nextpos2
		
		mov dx,0x4020
		mov [es:di],dx
		add di,2
		
		
		pop bx
		pop cx
		pop si
		pop di
		pop ax
		pop es
		mov sp,bp
		pop bp
ret
	
LeftP:
	push bp
	mov bp,sp
	push ax
	mov ax,0x0E    ;attribute
	push ax
	mov ax,24;size
	push ax
	mov ax ,0 ;row
	push ax
	mov ax,[bp+4] ;col
	push ax
	call down
	pop ax
	mov sp,bp
	pop bp
ret 2
	
	

		
	
	

delay:
push cx
mov cx,0x3
dl1:
	push cx
	
	mov cx,0xFFFF
l2:
	sub cx,1
	jnz	l2
	pop cx
	sub cx,1
	jnz	dl1

pop cx	
ret	

scroll1:
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,3
		add bx,1
		
		
		sub sp,2
		push ax
		push bx					;sehda Box
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		je .f1
		
			mov ax,[currRow]
			mov bx,[currCol]
			
			add ax,3
			add bx,3
			
			sub sp,2
			push ax
			push bx					;sehda Box
			call calLoc
			pop di
			
			cmp [es:di],dx
			je .f1
			jmp .sk1
		
	.f1:
		mov byte[bp-2],1
	.sk1:	
		cmp word[scrollFlag],1
		je .ske1
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call sedhaBox
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		add word[currRow],1
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call sedhaBox
		sti
	.ske1:
ret

scroll2:
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,5
		add bx,1
		
		
		sub sp,2
		push ax
		push bx					;Vline
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		je .f1
		jmp .sk1
		
	.f1:
		mov byte[bp-2],1
	.sk1:	
		cmp word[scrollFlag],1
		je .ske1
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call Vline
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		add word[currRow],1
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call Vline
		sti
	
	.ske1:
ret

scroll3:
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,2
		add bx,1
		
		
		sub sp,2
		push ax
		push bx					;Hline
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		je .f1
		
			mov ax,[currRow]
			mov bx,[currCol]
			
			add ax,2
			add bx,3
			
			sub sp,2
			push ax
			push bx					;Hline
			call calLoc
			pop di
			
			cmp [es:di],dx
			je .f1
			
				mov ax,[currRow]
				mov bx,[currCol]
				
				add ax,2
				add bx,5
				
				sub sp,2
				push ax
				push bx					;Hline
				call calLoc
				pop di
				
				cmp [es:di],dx
				je .f1
				
					mov ax,[currRow]
					mov bx,[currCol]
					
					add ax,2
					add bx,7
					
					sub sp,2
					push ax
					push bx					;Hline
					call calLoc
					pop di
					
					cmp [es:di],dx
					je .f1
			jmp .sk1
		
	.f1:
		mov byte[bp-2],1
	.sk1:	
		cmp word[scrollFlag],1
		je .ske1
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call Hline
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		add word[currRow],1
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call Hline
		sti
	.ske1:
ret


scroll4:
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,3
		add bx,1
		
		
		sub sp,2
		push ax
		push bx					;Vzig
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		je .f1
		
			mov ax,[currRow]
			mov bx,[currCol]
			
			add ax,4
			sub bx,1
			
			sub sp,2
			push ax
			push bx					;Vzig
			call calLoc
			pop di
			
			cmp [es:di],dx
			je .f1
			jmp .sk1
		
	.f1:
		mov byte[bp-2],1
	.sk1:	
		cmp word[scrollFlag],1
		je .ske1
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call Vzig
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		add word[currRow],1
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call Vzig
		sti
	.ske1:
ret


scroll5:
		mov ax,[currRow]
		mov bx,[currCol]
		
		add ax,2
		add bx,1
		
		
		sub sp,2
		push ax
		push bx					;hzig
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		je .f1
		
			mov ax,[currRow]
			mov bx,[currCol]
			
			add ax,3
			add bx,3
			
			sub sp,2
			push ax
			push bx					;hzig
			call calLoc
			pop di
			
			cmp [es:di],dx
			je .f1
			
				mov ax,[currRow]
				mov bx,[currCol]
				
				add ax,3
				add bx,5
				
				sub sp,2
				push ax
				push bx					;hzig
				call calLoc
				pop di
				
				cmp [es:di],dx
				je .f1
			jmp .sk1
		
	.f1:
		mov byte[bp-2],1
	.sk1:	
		cmp word[scrollFlag],1
		je .ske1
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call hzig
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		add word[currRow],1
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call hzig
		sti
	.ske1:
ret



scroll6:
		mov ax,[currRow]
		mov bx,[currCol]
		
		add ax,2
		add bx,1
		
		
		sub sp,2
		push ax
		push bx					;upT
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		je .f1
		
			mov ax,[currRow]
			mov bx,[currCol]
			
			add ax,2
			add bx,3
			
			sub sp,2
			push ax
			push bx					;upT
			call calLoc
			pop di
			
			cmp [es:di],dx
			je .f1
			
				mov ax,[currRow]
				mov bx,[currCol]
				
				add ax,2
				add bx,5
				
				sub sp,2
				push ax
				push bx					;upT
				call calLoc
				pop di
				
				cmp [es:di],dx
				je .f1
			jmp .sk1
		
	.f1:
		mov byte[bp-2],1
	.sk1:	
		cmp word[scrollFlag],1
		je .ske1
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call upT
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		add word[currRow],1
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call upT
		sti
	.ske1:
ret


scroll7:
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,4
		add bx,1
		
		
		sub sp,2
		push ax
		push bx					;leftT
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		je .f1
		
			mov ax,[currRow]
			mov bx,[currCol]
			
			add ax,3
			sub bx,1
			
			sub sp,2
			push ax
			push bx					;leftT
			call calLoc
			pop di
			
			cmp [es:di],dx
			je .f1
			jmp .sk1
		
	.f1:
		mov byte[bp-2],1
	.sk1:	
		cmp word[scrollFlag],1
		je .ske1
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call leftT
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		
		cli
		add word[currRow],1
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call leftT
		sti
		.ske1:
ret

scroll8:
		mov ax,[currRow]
		mov bx,[currCol]
		
		add ax,2
		add bx,1
		
		
		sub sp,2
		push ax
		push bx					;downT
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		je .f1
		
			mov ax,[currRow]
			mov bx,[currCol]
			
			add ax,3
			add bx,3
			
			sub sp,2
			push ax
			push bx					;downT
			call calLoc
			pop di
			
			cmp [es:di],dx
			je .f1
			
				mov ax,[currRow]
				mov bx,[currCol]
				
				add ax,2
				add bx,5
				
				sub sp,2
				push ax
				push bx					;downT
				call calLoc
				pop di
				
				cmp [es:di],dx
				je .f1
			jmp .sk1
		
	.f1:
		mov byte[bp-2],1
	.sk1:	
		cmp word[scrollFlag],1
		je .ske1
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call downT
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		add word[currRow],1
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call downT
		sti
	.ske1:
ret



scroll9:
		mov ax,[currRow]
		mov bx,[currCol]
		
		add ax,4
		add bx,1
		
		
		sub sp,2
		push ax
		push bx					;rightT
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		je .f1
		
			mov ax,[currRow]
			mov bx,[currCol]
			
			add ax,3
			add bx,3
			
			sub sp,2
			push ax
			push bx					;rightT
			call calLoc
			pop di
			
			cmp [es:di],dx
			je .f1
			jmp .sk1
		
	.f1:
		mov byte[bp-2],1
	.sk1:	
		cmp word[scrollFlag],1
		je .ske1
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call rightT
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		add word[currRow],1
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call rightT
		sti
	.ske1:
ret


scroll:
	;shape    bp+10
	;att    bp+8
	;row    bp+6
	;col    bp+4
	push bp
	mov bp,sp
	sub sp,2 ;flag
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	push es
	
	cli
	call cbuffer
	sti
;    1,2,3	
;	 _ _
;	|_|_|1
;	|_|_|2
;	|_|_|3
;	|_|_|4
;
;
;
	
	mov si,0
	
	mov word[bp-2],0
	
	mov ax,0xb800
	mov es,ax
	mov ax,[bp+6]
	mov bx,[bp+4]
	mov [currRow],ax
	mov [currCol],bx
	
	mov dx,[bp+10]
	mov cx,24



	cmp dx,1
	jne s2
s1:	
	call delay
	

	 
	call scroll1
	cli
	push word[currRow]
	call updateScreen
	sti 
	
	cmp word[bp-2],1
	je se1
	cmp word[scrollFlag],1
	je se1
	loop s1
	
se1:
	push exitScroll
	ret
	
	; cmp  something
	;je exit
	
	
s2:	cmp dx,2				;Vline
	jne s3
	
s21:	
	call delay
	
	
	cmp word[rotationFlag],1
	jne srh2
	mov word[rotationFlag],0
	mov word[currShape],3
	jmp s31
	srh2:
	
	cli
	cmp word[scrollFlag],1
	je se2
	
	call scroll2
	cli
	push word[currRow]
	call updateScreen
	sti 
	sti
	
	
	cmp word[bp-2],1
	je se2
	cmp word[scrollFlag],1
	je se2
	loop s21
se2:	
	jmp exitScroll
	
s3:	cmp dx,3				;Hline
	jne s4
s31:	
	call delay
	
	cmp word[rotationFlag],1
	jne srh3
	mov word[rotationFlag],0
	jmp s21
	srh3:
	cli
	cmp word[scrollFlag],1
	je se3
	
	call scroll3
	cli
	push word[currRow]
	call updateScreen
	sti 
	sti
	cmp word[bp-2],1
	je se3
	cmp word[scrollFlag],1
	je se3
	loop s31
se3:	
	jmp exitScroll
	
	
	
s4:	cmp dx,4				;Vzig
	jne s5
s41:	
	
	call delay
	
	cmp word[rotationFlag],1
	jne srh4
	mov word[rotationFlag],0
	jmp s51
	srh4:
	
	cli
	cmp word[scrollFlag],1
	je se4
	
	call scroll4
	cli
	push word[currRow]
	call updateScreen
	sti 
	sti
	cmp word[bp-2],1
	je se4
	
	cmp word[scrollFlag],1
	je se4
	loop s41
se4:	
	jmp exitScroll
	
	
s5:	cmp dx,5				;hzig
	jne s6
s51:	
	call delay
	
	cmp word[rotationFlag],1
	jne srh5
	mov word[rotationFlag],0
	jmp s41
	srh5:
	
	cli
	cmp word[scrollFlag],1
	je se5
	
	call scroll5
	cli
	push word[currRow]
	call updateScreen
	sti 
	sti
	
	
	cmp word[bp-2],1
	je se5
	
	cmp word[scrollFlag],1
	je se5
	loop s51
se5:	
	jmp exitScroll


	
s6:	cmp dx,6				;upT
	jne s7
s61:	
	call delay
	
	cmp word[rotationFlag],1
	jne srh6
	mov word[rotationFlag],0
	jmp s71
	srh6:
	
	cli
	cmp word[scrollFlag],1
	je se6
	
	call scroll6
	cli
	dec word[currRow]
	push word[currRow]
	call updateScreen
	inc word[currRow]
	sti 
	sti
	cmp word[bp-2],1
	je se6
	
	cmp word[scrollFlag],1
	je se6
	loop s61
se6:	
	jmp exitScroll
	
	
s7:	cmp dx,7				;leftT
	jne s8
s71:	
	call delay
	
	cmp word[rotationFlag],1
	jne srh7
	mov word[rotationFlag],0
	jmp s81
	srh7:
	cli
	cmp word[scrollFlag],1
	je se7
	
	call scroll7
	cli
	push word[currRow]
	call updateScreen
	sti 
	sti
	cmp word[bp-2],1
	je se7
	
	cmp word[scrollFlag],1
	je se7
	loop s71
se7:	
	jmp exitScroll	
	
	
	
s8:	cmp dx,8				;DownT
	jne s9
s81:	
	
	call delay
	
	cmp word[rotationFlag],1
	jne srh8
	mov word[rotationFlag],0
	jmp s91
	srh8:
	cli
	cmp word[scrollFlag],1
	je se8
	
	call scroll8
	cli
	push word[currRow]
	call updateScreen
	sti 
	sti
	cmp word[bp-2],1
	je se8
	
	cmp word[scrollFlag],1
	je se8
	loop s81
se8:	
	jmp exitScroll
	
	
s9:	cmp dx,9				;RightT
	jne exitScroll
s91:	
	
	call delay
	
	cmp word[rotationFlag],1
	jne srh9
	mov word[rotationFlag],0
	jmp s61
	srh9:
	cli
	cmp word[scrollFlag],1
	je se9
	call scroll9
	cli
	push word[currRow]
	call updateScreen
	sti 
	sti
	cmp word[bp-2],1
	je se9
	
	cmp word[scrollFlag],1
	je se9
	loop s91
se9:	
	jmp exitScroll		
	
	
	
	
	
exitScroll:
	cmp cx,23
	jb exitScroll1
	mov word[endFlag],1
	
exitScroll1:
	call delay
	pop es
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	mov sp,bp
	pop bp
	mov word[currCol],0
	mov word[currRow],0
	mov word[scrollFlag],0
ret 8


calLoc:
	;row
	;col
	push bp
	mov bp,sp
	push ax
	push bx
	mov ax, [bp+6]
	mov bl,80
	mul bl
	add ax,word[bp+4]
	shl ax,1
	mov [bp+8],ax
	
	pop bx
	pop ax
	mov sp,bp
	pop bp
ret 4


; if ( ticks_left > 0 )
;	ticks_left--;
; else {
;		mov ax, [freq + si]
;		ticks_left = word[dura + si]
;		si += 2
;		call speakerOn
; }



sisr:

	push 10
	call LeftP
	push 46
	call LeftP
	
	push ax
	push bx
	push si
	cmp word[ticks_left],0
	ja hehe
	
	
	
	
	mov si,[loc]
	mov ax,[dura + si]
	mov [ticks_left],ax
	mov ax,[freq+si]
	add si,2
	mov [loc],si
	call speakerOn
	
	mov ax,dura
	sub si,2
	mov bx,freq
	add bx,si
	cmp ax,bx
	jae yille
	mov word[loc],0
	mov word[ticks_left],0
	
	jmp yille
hehe:
	dec word[ticks_left]
	
	

yille:
	pop si
	pop bx
	pop ax
	inc word[time]
	;-----------random
	push ax
	push bx
	push dx
	

	
	mov ax,[time]
	xor dx,dx
	mov bx,9
	div bx
	inc dx
	mov [rand],dx
	pop dx
	pop bx
	pop ax
	;---------------------
	cmp word[time],1000
	jb ssk1
	mov word[time],0
	inc word[sec]
ssk1:
	cmp word[sec],60
	jb ssk2
	mov word[sec],0
	inc word[min]
ssk2:	
	call t
	cmp word[min],5
	jb ssk3
	mov al,0x20
	out 0x20,al
	jmp endGame
ssk3:	
	jmp far [cs : oldTisr]
	



kbsir:
	push ax
	push bx
	push dx
	in al,0x60
	mov dx,[currShape]
	
	cmp word[bp-2],1
	jne kb1
	jmp ks2
kb1:	
	cmp al,'3'
	je sl1
	jmp ks1
	;---------------------left

	
	sl1:  								
			cmp dx,1
			jne sl2
			cmp word[currCol],10 
			je sle1
			
			call scroll1L		;sedha box
			
		sle1:
		jmp kend
		
	sl2: cmp dx,2
		 jne sl3
		cmp word[currCol],10
			je sle2
			
			call scroll2L		;Vline
			
		sle2:
		jmp kend
		
	sl3: cmp dx,3
		 jne sl4
		 
		cmp word[currCol],10
			je sle3
			call scroll3L		;Hline
		sle3:
		 
		 
		jmp kend	
		
	sl4: cmp dx,4
		 jne sl5
		 
     		cmp word[currCol],12
			je sle4
			call scroll4L		;Vzig
		sle4:
		
		jmp kend	

	sl5: cmp dx,5
		 jne sl6
		 
		 cmp word[currCol],10
			je sle5
			call scroll5L		;hzig
		sle5:
		 
		jmp kend		
		
	sl6: cmp dx,6
		 jne sl7
		 
		 cmp word[currCol],10
			jbe sle6
			call scroll6L		;upT
		sle6:
		 
		jmp kend	
		
	sl7: cmp dx,7
		 jne sl8
		 
		 cmp word[currCol],10
			jbe sle7
			call scroll7L		;leftT
		sle7:
		 
		jmp kend	

	sl8: cmp dx,8
		 jne sl9
		 
		 
		 cmp word[currCol],10
			je sle8
			call scroll8L		;hzig
		sle8:
		jmp kend

	sl9: cmp dx,9
		 jne sle
		 
		 cmp word[currCol],10
			jbe sle9
			call scroll9L		;rightT
		sle9:
		 
	sle:

	
	;------------------
	jmp kend
ks1:
	
	cmp al,'4'
	je sr1
	jmp ks2
	;---------------------right

	sr1:
			cmp dx,1
			jne sr2
			cmp word[currCol],42
			je sre1
			
			call scroll1R
			
		sre1:
		jmp kend
		
	sr2: cmp dx,2
		 jne sr3
		 
		 
		 
		 cmp word[currCol],44
			je sre2
			
			call scroll2R
			
		sre2:
		jmp kend
		
	sr3: cmp dx,3
		 jne sr4
		
		 cmp word[currCol],38
		 je sre3
			
			call scroll3R
			
		sre3:
		jmp kend
		
	sr4: cmp dx,4
		 jne sr5
		 
		 	 
		 
		 
		 cmp word[currCol],44
			je sre4
			
			call scroll4R
			
		sre4:
		jmp kend
		 
		 
		jmp kend	

	sr5: cmp dx,5
		 jne sr6
		 
		 
		  cmp word[currCol],40
		 je sre5
			
			call scroll5R
			
		sre5:
		 
		jmp kend		
		
	sr6: cmp dx,6
		 jne sr7
		 
		  cmp word[currCol],40
		 je sre6
			
			call scroll6R
			
		sre6:
		 
		 
		jmp kend	
		
	sr7: cmp dx,7
		 jne sr8
		 
		 cmp word[currCol],44
			je sre7
			
			call scroll7R
			
		sre7:
		jmp kend	

	sr8: cmp dx,8
		 jne sr9
		 
		  cmp word[currCol],40
		 je sre8
			
			call scroll8R
			
		sre8:
		 
		jmp kend

	sr9: cmp dx,9
		 jne sre
		 
			cmp word[currCol],42
			je sre
			
			call scroll9R
			
		 
	sre:	
	
	;------------------
	jmp kend
ks2:
	cmp al,'9'
	je sh1
	jmp ks3
	
	
sh1:  ;shape hash table
	cmp dx,1
	jne sh2
	
	;nothing
	
	jmp kend
sh2:
	cmp dx,2
	jne sh3
	
	call rotateSh2
	jmp ks3
	
sh3:
	cmp dx,3
	jne sh4
	
	call rotateSh3
	jmp kend
sh4:
	cmp dx,4
	jne sh5
	call rotateSh4
	jmp kend
sh5:
	cmp dx,5
	jne sh6
	call rotateSh5
	
	jmp kend
sh6:
	cmp dx,6
	jne sh7
	call rotateSh6
	
	jmp kend
sh7:
	cmp dx,7
	jne sh8
	call rotateSh7
	
	jmp kend
sh8:
	cmp dx,8
	jne sh9
	call rotateSh8
	
	jmp kend
sh9:
	cmp dx,9
	jne kend
	
	call rotateSh9
	jmp kend
	
ks3:
	cmp al,01
	jne kend
	jmp endGame
	
kend:	
	pop dx
	pop bx
	pop ax 
	jmp far [cs : oldKbisr]
	
	
;	 _
;   |_|_
;   |_|_|
;   |_|
rotateSh9:
			mov ax,[currRow]
			mov bx,[currCol]

			add ax,2
			sub bx,1
			
			
			sub sp,2
			push ax
			push bx										;rightT
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
				je .f111
				
				jmp .sk1
				
				
				
.f111:
		
		mov word[scrollFlag],1	
		; call endscr
		; mov ah,0x01
		; int 21h
		; mov [currScore],di
		; push 290
		; call score
	 
		mov ax,[currRow]
		mov bx,[currCol] 

		add ax,1
		sub bx,1
		
		sub sp,2
		push ax
		push bx					;rightT
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		je .f11
		jmp .sk1
		.f11:
			mov ax,[currRow]
			mov bx,[currCol]

			add ax,2
			sub bx,2
			
			
			sub sp,2
			push ax
			push bx										;rightT
			call calLoc
			pop di
			mov dx,0x0E7C
			cmp  [es:di],dx
				je .f1
				jmp .sk1
		
		
		
	.f1:
		mov word[scrollFlag],0
		mov dx,9
		ret ;----------------
	.sk1:	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call rightT
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		mov dx,0x0E       ;0x7B   ;old
		push dx
		add	word[currRow],1
		sub	word[currCol],2
		push word[currRow]
		push word[currCol]
		call upT
		mov word[currShape],6
		mov word[rotationFlag],1
		mov dx,6
		sti
	

ret	
	
;  _ _ _
; |_|_|_|
;   |_|
rotateSh8:
			mov ax,[currRow]
			mov bx,[currCol]

			sub ax,1
			add bx,3
			
			
			sub sp,2
			push ax
			push bx										;downT
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
				je .f111
				
				jmp .sk1
				
				
				
.f111:
		
		; mov [currScore],di
		; push 290
		; call score
	 
		mov ax,[currRow]
		mov bx,[currCol] 

		add bx,2
		
		sub sp,2
		push ax
		push bx					;downT
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		je .f11
		jmp .sk1
		.f11:
			mov ax,[currRow]
			mov bx,[currCol]


			add bx,4
			
			
			sub sp,2
			push ax
			push bx										;downT
			call calLoc
			pop di
			mov dx,0x0E7C
			cmp  [es:di],dx
				je .f1
				jmp .sk1
		
		
		
	.f1:
		;mov word[scrollFlag],0
		mov dx,8
		ret ;----------------
	.sk1:	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call downT
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		mov dx,0x0E       ;0x7B   ;old
		push dx
		sub	word[currRow],1
		add	word[currCol],2
		push word[currRow]
		push word[currCol]
		call rightT
		mov word[currShape],9
		mov word[rotationFlag],1
		mov dx,9
		sti
	

ret


;	 _
;  _|_|
; |_|_|
;   |_|
rotateSh7:
			mov ax,[currRow]
			mov bx,[currCol]

			add ax,2
			add bx,3
			
			
			sub sp,2
			push ax
			push bx										;leftT
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
				je .f111
				
				jmp .sk1
				
				
				
.f111:
		
		mov word[scrollFlag],1	
		; mov [currScore],di
		; push 290
		; call score
	 
		mov ax,[currRow]
		mov bx,[currCol] 

		add ax,1
		add bx,3
		
		sub sp,2
		push ax
		push bx					;leftT
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		je .f11
		jmp .sk1
		.f11:
			mov ax,[currRow]
			mov bx,[currCol]

			add ax,2
			add bx,4
			
			
			sub sp,2
			push ax
			push bx										;leftT
			call calLoc
			pop di
			mov dx,0x0E7C
			cmp  [es:di],dx
				je .f1
				jmp .sk1
		
		
		
	.f1:
		mov word[scrollFlag],0
		mov dx,7
		ret ;----------------
	.sk1:	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call leftT
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		mov dx,0x0E       ;0x7B   ;old
		push dx
		add	word[currRow],1
		sub	word[currCol],2
		push word[currRow]
		push word[currCol]
		call downT
		mov word[currShape],8
		mov word[rotationFlag],1
		mov dx,8
		sti
	

ret


;	 _
;  _|_|_
; |_|_|_|

rotateSh6:
			mov ax,[currRow]
			mov bx,[currCol]

			add ax,2
			add bx,3
			
			
			sub sp,2
			push ax
			push bx										;upT
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
				je .f111
				
				jmp .sk1
				
				
				
.f111:

		mov word[scrollFlag],1	
		; mov [currScore],di
		; push 290
		; call score
	 
		mov ax,[currRow]
		mov bx,[currCol] 

		add ax,2
		add bx,2
		
		sub sp,2
		push ax
		push bx					;upT
		call calLoc
		pop di
		mov dx,0x0E7C
		cmp  [es:di],dx
		je .f11
		jmp .sk1
		.f11:
			mov ax,[currRow]
			mov bx,[currCol]

			add ax,2
			add bx,4
			
			
			sub sp,2
			push ax
			push bx										;upT
			call calLoc
			pop di
			mov dx,0x0E7C
			cmp  [es:di],dx
				je .f1
				jmp .sk1
		
		
		
	.f1:
		mov word[scrollFlag],0
		mov dx,6
		ret ;----------------
	.sk1:	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call upT
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		mov dx,0x0E       ;0x7B   ;old
		push dx
		sub	word[currRow],1
		add	word[currCol],2
		push word[currRow]
		push word[currCol]
		call leftT
		mov word[currShape],7
		mov word[rotationFlag],1
		mov dx,7
		sti
	

ret


;	 _
;  _|_|
; |_|_|
; |_|

rotateSh5:
			mov ax,[currRow]
			mov bx,[currCol]

			add ax,2
			add bx,1
			
			
			sub sp,2
			push ax
			push bx										;hzig
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
				je .f111
				jmp .sk1
				
					
				
.f111:
		mov word[scrollFlag],1
		mov ax,[currRow]
		mov bx,[currCol] 

		sub ax,1
		add bx,3
		
		sub sp,2
		push ax
		push bx					;hzig
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		je .f11
		jmp .sk1
		.f11:
			mov ax,[currRow]
			mov bx,[currCol]

			sub ax,1
			add bx,2
			
			
			sub sp,2
			push ax
			push bx										;hzig
			call calLoc
			pop di
			mov dx,0x0E7C
			cmp  [es:di],dx
				je .f1
				jmp .sk1
		
		
		
	.f1:
		mov word[scrollFlag],0
		mov dx,5
		ret ;----------------
	.sk1:	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call hzig
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		mov dx,0x0E       ;0x7B   ;old
		push dx
		sub	word[currRow],1
		add	word[currCol],2
		push word[currRow]
		push word[currCol]
		call Vzig
		mov word[currShape],4
		mov word[rotationFlag],1
		mov dx,4
		sti
ret


rotateSh4:
			mov ax,[currRow]
			mov bx,[currCol]

			add ax,2
			add bx,3
			
			
			sub sp,2
			push ax
			push bx										;Vzig
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
				je .f111
				jmp .sk1
			.f111:	
				mov word[scrollFlag],1	
				

		mov ax,[currRow]
		mov bx,[currCol] 

		add ax,1
		add bx,3
		
		sub sp,2
		push ax
		push bx					;Vzig
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		je .f11
		jmp .sk1
		.f11:
			mov ax,[currRow]
			mov bx,[currCol]

			add ax,2
			add bx,4
			
			
			sub sp,2
			push ax
			push bx										;Vzig
			call calLoc
			pop di
			mov dx,0x0E7C
			cmp  [es:di],dx
				je .f1
				jmp .sk1
		
		
		
	.f1:
		mov word[scrollFlag],0
		mov dx,4
		ret ;----------------
	.sk1:	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call Vzig
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		mov dx,0x0E       ;0x7B   ;old
		push dx
		sub	word[currCol],2
		push word[currRow]
		push word[currCol]
		call hzig
		mov word[currShape],5
		mov word[rotationFlag],1
		mov dx,5
		sti
ret



rotateSh3:
		mov ax,[currRow]
		mov bx,[currCol]

		add ax,2
		add bx,1
		
		
		sub sp,2
		push ax
		push bx					;Hlile
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .f11
		jmp .f1
		.f11:
			mov ax,[currRow]
			mov bx,[currCol]

			add ax,3
			add bx,1
			
			
			sub sp,2
			push ax
			push bx										;Hlile
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
				jne .f13
				jmp .f1
				.f13:
				
			mov ax,[currRow]
			mov bx,[currCol]

			add ax,4
			add bx,1
			
			
			sub sp,2
			push ax
			push bx										;Hlile
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
				jne .sk1
				mov word[scrollFlag],1	
				jmp .sk1
		
	.f1:
		mov dx,3
		ret ;----------------
	.sk1:	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call Hline
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call Vline
		mov word[currShape],2
		mov word[rotationFlag],1
		mov dx,2
		sti
ret

rotateSh2:
		mov ax,[currRow]
		mov bx,[currCol]

		add ax,1
		add bx,4
		
		
		sub sp,2
		push ax
		push bx					;Vline
		call calLoc
		pop di
		mov dx,0x0E7C
		cmp  [es:di],dx
		jne .f11
		jmp .f1
		.f11:
			mov ax,[currRow]
			mov bx,[currCol]

			add ax,1
			add bx,6
			
			
			sub sp,2
			push ax
			push bx					;Vline
			call calLoc
			pop di
			mov dx,0x0E7C
			cmp  [es:di],dx
			jne .f12
			jmp .f1
			.f12:
				mov ax,[currRow]
				mov bx,[currCol]

				add ax,1
				add bx,8
				
				
				sub sp,2
				push ax
				push bx					;Vline
				call calLoc
				pop di
				mov dx,0x0E7C
				cmp  [es:di],dx
				jne .f13
				jmp .f1
				.f13:
					jmp .sk1
		
	.f1:
		mov dx,2
		ret ;----------------
	.sk1:	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call Vline
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call Hline
		mov word[currShape],3
		mov word[rotationFlag],1
		mov dx,3
		sti
ret



scroll7R:
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,1
		add bx,3
		
		
		sub sp,2
		push ax
		push bx					;leftT
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .f11
		jmp .f1
		.f11:
			mov ax,[currRow]
			mov bx,[currCol]

			
			add ax,2
			add bx,3
			
			
			sub sp,2
			push ax
			push bx					;leftT
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
			jne .f12
			jmp .f1
			.f12:

				add ax,1
				
				
				sub sp,2
				push ax
				push bx					;leftT
				call calLoc
				pop di
				mov dx,0x0E5F
				cmp  [es:di],dx
				jne .sk1
				mov word[scrollFlag],1
				mov dx,word[scrollFlag]
				jmp .sk1
		
	.f1:
		ret ;----------------
	.sk1:	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call leftT
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		add word[currCol],2
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call leftT
		sti
	
ret


;    _
;  _|_|
; |_|_|
;   |_|

scroll7L:
		
		mov ax,[currRow]
		mov bx,[currCol] 

		sub bx,1
		
		
		sub sp,2
		push ax
		push bx					;leftT
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .f12
		
		mov ax,[currRow]
		mov bx,[currCol]

		add ax,1
		sub bx,2
		
		
		
		sub sp,2
		push ax
		push bx					;leftT
		call calLoc
		pop di
		mov dx,0x0E7C
		cmp  [es:di],dx
		jne .f12
		jmp .f1
.f12:
	mov ax,[currRow]
		mov bx,[currCol] 

		add ax,3
		sub bx,1
		
		
		sub sp,2
		push ax
		push bx					;leftT
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .f13
		
		mov word[scrollFlag],1
		
		mov ax,[currRow]
		mov bx,[currCol]

		add ax,3
		sub bx,2
		
		
		
		sub sp,2
		push ax
		push bx					;leftT
		call calLoc
		pop di
		mov dx,0x0E7C
		cmp  [es:di],dx
		jne .f13
		jmp .f1

.f13:
		mov ax,[currRow]
		mov bx,[currCol]
		add ax,2
		sub bx,3
		sub sp,2
		push ax
		push bx					;leftT
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .sk1
		mov word[scrollFlag],1
		mov dx,word[scrollFlag]



		
		mov ax,[currRow]
		mov bx,[currCol]

	
		add ax,1
		sub bx,3
		
		
		sub sp,2
		push ax
		push bx					;rightT
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		je .f1
		jmp .sk1	
		
	.f1:
		mov word[scrollFlag],0
		ret ;----------------
	.sk1:	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call leftT
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		sub word[currCol],2
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call leftT
		sti
	
ret


; _ _ _
;|_|_|_|
;  |_|


scroll8R:
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,1
		add bx,7
		
		
		
		sub sp,2
		push ax  
		push bx  				;downT
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .sk11
		mov word[scrollFlag],1
		mov dx,word[scrollFlag]






		mov ax,[currRow]
		mov bx,[currCol]

		
		add bx,7
				
		sub sp,2
		push ax
		push bx					;downT
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .sk11
		
	.f1:
		mov word[scrollFlag],0
		ret ;----------------
		
	.sk11:	
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,2
		add bx,5
		
		
		
		sub sp,2
		push ax  
		push bx  				;downT
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .sk1
		mov word[scrollFlag],1
		mov dx,word[scrollFlag]


		
	.sk1:


	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call downT
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		add word[currCol],2
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call downT
		sti
ret



scroll8L:
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,1
		sub bx,1
		
		
		
		sub sp,2
		push ax  
		push bx  				;downT
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .sk11
		mov word[scrollFlag],1
		mov dx,word[scrollFlag]






		mov ax,[currRow]
		mov bx,[currCol]

		
		sub bx,1
				
		sub sp,2
		push ax
		push bx					;downT
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .sk11
		
	.f1:
		mov word[scrollFlag],0
		ret ;----------------
		
	.sk11:	
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,2
		add bx,1
		
		
		
		sub sp,2
		push ax  
		push bx  				;downT
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .sk1
		mov word[scrollFlag],1
		mov dx,word[scrollFlag]


		
	.sk1:


	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call downT
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		sub word[currCol],2
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call downT
		sti
ret


;  _
; |_|_
; |_|_|
; |_|

scroll9R:
			
			mov ax,[currRow]
			mov bx,[currCol] 

			add bx,3
			
			
			sub sp,2
			push ax
			push bx					;rightT
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
			jne .f12
			
			mov ax,[currRow]
			mov bx,[currCol]

			add ax,1
			add bx,6
			
			
			
			sub sp,2
			push ax
			push bx					;rightT
			call calLoc
			pop di
			mov dx,0x0E7C
			cmp  [es:di],dx
			jne .f12
			jmp .f1
	.f12:
		mov ax,[currRow]
			mov bx,[currCol] 

			add ax,3
			add bx,3
			
			
			sub sp,2
			push ax
			push bx					;rightT
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
			jne .f13
			
			mov word[scrollFlag],1
			
			mov ax,[currRow]
			mov bx,[currCol]

			add ax,3
			add bx,4
			
			
			
			sub sp,2
			push ax
			push bx					;rightT
			call calLoc
			pop di
			mov dx,0x0E7C
			cmp  [es:di],dx
			jne .f13
			jmp .f1

	.f13:
			mov ax,[currRow]
			mov bx,[currCol]
			add ax,2
			add bx,5
			sub sp,2
			push ax
			push bx					;rightT
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
			jne .sk1
			mov word[scrollFlag],1
			mov dx,word[scrollFlag]

	
	
			
			mov ax,[currRow]
			mov bx,[currCol]

		
			add ax,1
			add bx,5
			
			
			sub sp,2
			push ax
			push bx					;rightT
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
			je .f1
			jmp .sk1	
			
		.f1:
			mov word[scrollFlag],0
			ret ;----------------
		.sk1:	
			cli
			mov ax,[currRow]
			mov bx,[currCol]
			mov dx,0x00
			push dx
			push ax
			push bx
			call rightT
			sti
			;mov ax,[bp+6]
			;mov bx,[bp+4]
			
			
			cli
			add word[currCol],2
			mov dx,0x0E       ;0x7B   ;old
			push dx
			push word[currRow]
			push word[currCol]
			call rightT
			sti
		
	ret

scroll9L:
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,1
		sub bx,1
		
		
		sub sp,2
		push ax
		push bx					;;rightT
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .f11
		jmp .f1
		.f11:
			mov ax,[currRow]
			mov bx,[currCol]

			
			add ax,2
			sub bx,1
			
			
			sub sp,2
			push ax
			push bx					;rightT
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
			jne .f12
			jmp .f1
			.f12:
				mov ax,[currRow]
				mov bx,[currCol]

				
				add ax,3
				sub bx,1

				sub sp,2
				push ax
				push bx					;rightT
				call calLoc
				pop di
				mov dx,0x0E5F
				cmp  [es:di],dx
				jne .sk1
				mov word[scrollFlag],1
				mov dx,word[scrollFlag]
				jmp .sk1
		
	.f1:
		ret ;----------------
	.sk1:	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call rightT
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		sub word[currCol],2
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call rightT
		sti
	
ret


;	 _
;  _|_|_
; |_|_|_|



scroll6R:

			
			mov ax,[currRow]
			mov bx,[currCol] 

			sub ax,1
			add bx,5
			
			
			sub sp,2
			push ax
			push bx					;upT
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
			jne .f12
			
			mov ax,[currRow]
			mov bx,[currCol]

			add bx,5
			
			
			
			sub sp,2
			push ax
			push bx					;upT
			call calLoc
			pop di
			mov dx,0x0E7C
			cmp  [es:di],dx
			jne .f12
			jmp .f1
			

	.f12:
			mov ax,[currRow]
			mov bx,[currCol]
			add ax,1
			add bx,7
			sub sp,2
			push ax
			push bx					;upT
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
			jne .sk1
			mov word[scrollFlag],1
			mov dx,word[scrollFlag]

	
	
			
			mov ax,[currRow]
			mov bx,[currCol]

		
			add bx,7
			
			
			sub sp,2
			push ax
			push bx					;upT
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
			je .f1
			jmp .sk1	
			
		.f1:
			mov word[scrollFlag],0
			ret ;----------------
		.sk1:	
			cli
			mov ax,[currRow]
			mov bx,[currCol]
			mov dx,0x00
			push dx
			push ax
			push bx
			call upT
			sti
			;mov ax,[bp+6]
			;mov bx,[bp+4]
			
			
			cli
			add word[currCol],2
			mov dx,0x0E       ;0x7B   ;old
			push dx
			push word[currRow]
			push word[currCol]
			call upT
			sti
		
	ret



scroll6L:

			
			mov ax,[currRow]
			mov bx,[currCol] 

			sub ax,1
			add bx,1
			
			
			sub sp,2
			push ax
			push bx					;upT
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
			jne .f12
			
			mov ax,[currRow]
			mov bx,[currCol]


			
			
			
			sub sp,2
			push ax
			push bx					;upT
			call calLoc
			pop di
			mov dx,0x0E7C
			cmp  [es:di],dx
			jne .f12
			jmp .f1
			

	.f12:
			mov ax,[currRow]
			mov bx,[currCol]
			add ax,1
			sub bx,1
			sub sp,2
			push ax
			push bx					;upT
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
			jne .sk1
			mov word[scrollFlag],1
			mov dx,word[scrollFlag]

	
	
			
			mov ax,[currRow]
			mov bx,[currCol]

		
			sub bx,1
			
			
			sub sp,2
			push ax
			push bx					;upT
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
			je .f1
			jmp .sk1	
			
		.f1:
			mov word[scrollFlag],0
			ret ;----------------
		.sk1:	
			cli
			mov ax,[currRow]
			mov bx,[currCol]
			mov dx,0x00
			push dx
			push ax
			push bx
			call upT
			sti
			;mov ax,[bp+6]
			;mov bx,[bp+4]
			
			
			cli
			sub word[currCol],2
			mov dx,0x0E       ;0x7B   ;old
			push dx
			push word[currRow]
			push word[currCol]
			call upT
			sti
		
	ret




;    _
;  _|_| 
; |_|_|
; |_|


scroll4R:

		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,3
		add bx,1
		
		
		sub sp,2
		push ax
		push bx					;Vzig
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .f12
		mov word[scrollFlag],1
		
		
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,3
		add bx,2
		
		
		sub sp,2
		push ax
		push bx					;Vzig
		call calLoc
		pop di
		mov dx,0x0E7C
		cmp  [es:di],dx
		jne .f12
		jmp .f1
		
		
		



.f12
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,1
		add bx,3
		
		
		sub sp,2
		push ax
		push bx					;Vzig
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		je .f1

			add ax,1
			
			
			sub sp,2
			push ax
			push bx					;Vzig
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
			jne .sk1
			mov word[scrollFlag],1
			mov dx,word[scrollFlag]

			jmp .sk1
		
	.f1:
		ret ;----------------
	.sk1:	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call Vzig
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		add word[currCol],2
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call Vzig
		sti
ret



scroll4L:
		
		mov ax,[currRow]
		mov bx,[currCol] 

		
		sub bx,1
		
		
		sub sp,2
		push ax
		push bx					;Vzig
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .f12
		
		mov ax,[currRow]
		mov bx,[currCol]

		add ax,1
		sub bx,2
		
		
		sub sp,2
		push ax
		push bx					;Vzig
		call calLoc
		pop di
		mov dx,0x0E7C
		cmp  [es:di],dx
		jne .f12
        jmp .f1
		

.f12:
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,2
		sub bx,3
		
		
		sub sp,2
		push ax
		push bx					;Vzig
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		je .f1
			add ax,1
			
			
			sub sp,2
			push ax
			push bx					;Vzig
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
			jne .sk1
			mov word[scrollFlag],1
			mov dx,word[scrollFlag]

			jmp .sk1
		
	.f1:
		ret ;----------------
	.sk1:	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call Vzig
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		sub word[currCol],2
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call Vzig
		sti
	
ret


scroll1R:
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,1
		add bx,5
		
		
		sub sp,2
		push ax
		push bx					;sehda Box
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		je .f1
		
		
			add ax,1
			
			
			sub sp,2
			push ax
			push bx					;sehda Box
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
			jne .sk1
			mov word[scrollFlag],1
			mov dx,word[scrollFlag]

			jmp .sk1
		
	.f1:
		ret ;----------------
	.sk1:	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call sedhaBox
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		add word[currCol],2
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call sedhaBox
		sti
	
ret

;  _ _     
; |_|_|_  
;   |_|_|

scroll5R:
		
		mov ax,[currRow]
		mov bx,[currCol]

		
		add bx,5
		
		
		
		sub sp,2
		push ax  
		push bx  				;hzig
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .f12
		
		mov ax,[currRow]
		mov bx,[currCol]

		add ax,1
		add bx,6
		
		
		
		sub sp,2
		push ax  
		push bx  				;hzig
		call calLoc
		pop di
		mov dx,0x0E7C
		cmp  [es:di],dx
		jne .f12
		jmp .f1
.f12:

		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,2
		add bx,7
		
		
		
		sub sp,2
		push ax  
		push bx  				;hzig
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .sk1
		mov word[scrollFlag],1





		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,1
		add bx,7
				
		sub sp,2
		push ax
		push bx					;hzig
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .sk1
		
	.f1:
		mov word[scrollFlag],0
		ret ;----------------
		
	
		
	.sk1:


	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call hzig
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		add word[currCol],2
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call hzig
		sti
ret


scroll5L:
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,1
		sub bx,1
		
		
		
		sub sp,2
		push ax  
		push bx  				;hzig
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .sk11
		mov word[scrollFlag],1
		mov dx,word[scrollFlag]






		mov ax,[currRow]
		mov bx,[currCol]

		
		sub bx,1
				
		sub sp,2
		push ax
		push bx					;hzig
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .sk11
		
	.f1:
		mov word[scrollFlag],0
		ret ;----------------
		
	.sk11:	
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,2
		add bx,1
		
		
		
		sub sp,2
		push ax  
		push bx  				;hzig
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .sk1
		mov word[scrollFlag],1
		mov dx,word[scrollFlag]

		; mov ax,[currRow]
		; mov bx,[currCol]

		
		; add ax,1
				
		; sub sp,2
		; push ax
		; push bx					;hzig
		; call calLoc
		; pop di
		; mov dx,0x0E7C
		; cmp  [es:di],dx
		; jne .sk1
		
	; .f2:
		; mov word[scrollFlag],0
		; ret ;----------------
		
		
	.sk1:


	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call hzig
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		sub word[currCol],2
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call hzig
		sti
ret


;  _ _ _ _
; |_|_|_|_|
scroll3R:

			mov ax,[currRow]
			mov bx,[currCol]

			
			add ax,1
			add bx,9
			
			
			
			sub sp,2
			push ax  
			push bx  				;Hline
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
			jne .sk1
			mov word[scrollFlag],1
			mov dx,word[scrollFlag]






		mov ax,[currRow]
		mov bx,[currCol]

		
		add bx,9
				
		sub sp,2
		push ax
		push bx					;Hline
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .sk1
		
	.f1:
		mov word[scrollFlag],0
		ret ;----------------
	.sk1:	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call Hline
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		add word[currCol],2
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call Hline
		sti
	
ret



scroll3L:

		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,1
		sub bx,1
		
		
		
		sub sp,2
		push ax  
		push bx  				;Hline
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .sk1
		mov word[scrollFlag],1
		mov dx,word[scrollFlag]






		mov ax,[currRow]
		mov bx,[currCol]

		
		sub bx,1
				
		sub sp,2
		push ax
		push bx					;Hline
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .sk1
		
	.f1:
		mov word[scrollFlag],0
		ret ;----------------
	.sk1:	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call Hline
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		sub word[currCol],2
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call Hline
		sti
	
ret

scroll2R:
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,1
		add bx,3
		
		
		sub sp,2
		push ax
		push bx					;Vline
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .f11
		jmp .f1
		.f11:
			mov ax,[currRow]
			mov bx,[currCol]

			
			add ax,2
			add bx,3
			
			
			sub sp,2
			push ax
			push bx					;Vline
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
			jne .f12
			jmp .f1
			.f12:
				mov ax,[currRow]
				mov bx,[currCol]

				
				add ax,3
				add bx,3
				
				
				sub sp,2
				push ax
				push bx					;Vline
				call calLoc
				pop di
				mov dx,0x0E5F
				cmp  [es:di],dx
				jne .f13
				jmp .f1
				.f13:
					add ax,1
					
					
					sub sp,2
					push ax
					push bx					;Vline
					call calLoc
					pop di
					mov dx,0x0E5F
					cmp  [es:di],dx
					jne .sk1
					mov word[scrollFlag],1
					mov dx,word[scrollFlag]

					jmp .sk1
		
	.f1:
		ret ;----------------
	.sk1:	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call Vline
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		add word[currCol],2
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call Vline
		sti
	
ret

;  _
; |_|
; |_|
; |_|
; |_|
scroll2L:
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,1
		sub bx,1
		
		
		sub sp,2
		push ax
		push bx					;Vline
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		jne .f11
		jmp .f1
		.f11:
			mov ax,[currRow]
			mov bx,[currCol]

			
			add ax,2
			sub bx,1
			
			
			sub sp,2
			push ax
			push bx					;Vline
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
			jne .f12
			jmp .f1
			.f12:
				mov ax,[currRow]
				mov bx,[currCol]

				
				add ax,3
				sub bx,1
				
				
				sub sp,2
				push ax
				push bx					;Vline
				call calLoc
				pop di
				mov dx,0x0E5F
				cmp  [es:di],dx
				jne .f13
				jmp .f1
				.f13:
					add ax,1
					
					
					sub sp,2
					push ax
					push bx					;Vline
					call calLoc
					pop di
					mov dx,0x0E5F
					cmp  [es:di],dx
					jne .sk1
					mov word[scrollFlag],1
					mov dx,word[scrollFlag]
					jmp .sk1
		
	.f1:
		ret ;----------------
	.sk1:	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call Vline
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		sub word[currCol],2
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call Vline
		sti
	
ret



scroll1L:
		mov ax,[currRow]
		mov bx,[currCol]

		
		add ax,1
		sub bx,1
		
		
		sub sp,2
		push ax
		push bx					;sehda Box
		call calLoc
		pop di
		mov dx,0x0E5F
		cmp  [es:di],dx
		je .f1
		
		
			add ax,1
			
			
			sub sp,2
			push ax
			push bx					;sehda Box
			call calLoc
			pop di
			mov dx,0x0E5F
			cmp  [es:di],dx
			jne .sk1
			mov word[scrollFlag],1
			mov dx,word[scrollFlag]
			jmp .sk1
		
	.f1:
		ret ;----------------
	.sk1:	
		cli
		mov ax,[currRow]
		mov bx,[currCol]
		mov dx,0x00
		push dx
		push ax
		push bx
		call sedhaBox
		sti
		;mov ax,[bp+6]
		;mov bx,[bp+4]
		
		
		cli
		sub word[currCol],2
		mov dx,0x0E       ;0x7B   ;old
		push dx
		push word[currRow]
		push word[currCol]
		call sedhaBox
		sti
	
ret

	
Edelay:
push cx
mov cx,0x1
Edl1:
	push cx
	
	mov cx,0xFFF
El2:
	sub cx,1
	jnz	l2
	pop cx
	sub cx,1
	jnz	dl1

pop cx	
ret		
	
bonusEnd:
		push bp
		mov bp,sp
		push es
		push ax
		push di
		push cx
		push dx
		mov ax,0xb800
		mov es,ax
		
		mov ax,0x5020
		mov di,1304
		mov dx,5
BEL1:	
		mov cx,50
el11:		
		mov word[es:di],ax
		add di,2
		call Edelay
		loop el11
		sub di,4
		add di,160
		mov cx,48
el12:
		mov word[es:di],ax
		sub di,2
		call Edelay
		loop el12
		add di,160
		dec dx
		cmp dx,0
		jg BEL1
		
		
		
		
		
		mov ax,1976
		push ax
		push endline
		call printName
		
		; mov ax,2136
		; push ax
		; push endScore
		; call printName
		
		
		mov ax,2142
		push ax
		call score
		
		pop dx
		pop cx
		pop di
		pop ax
		pop es
		mov sp,bp
		pop bp
ret

speakerOn:
        and     ax, 0xfffe
        push    ax
        cli
        mov     al, 0xb6
        out     0x43, al
        pop     ax
        out     0x42, al
        mov     al, ah
        out     0x42, al
        in      al, 0x61
        mov     al, ah
        or      al, 3
        out     0x61, al
        sti
    ret

;;; speakerOff - silences the PC Speaker.
;;; Trashes AX.
speakerOff:
        in      al, 0x61
        and     al, 0xfc
        out     0x61, al
        ret

;;; Note data: The C major scale starting at middle-C.
;scale:  dw      4560, 4063, 3619, 3416, 3043, 2711, 2415, 2280, 0


endBoundary:
	push bp
		mov bp,sp
		push es
		push ax
		push di
		
		mov ax,0xb800
		mov es,ax
		mov di,3860
	eb04:	
		mov word[es:di],0x0E5F
		add di,2
		cmp di,3934
		jne eb04
		
		pop di
		pop ax
		pop es
		mov sp,bp
		pop bp


ret
strt:	

        cli
        mov dx, 0x43
        mov al, 0x36
        out dx, al
        mov dx, 0x40
        mov al, 0xA9 ;(1193180 / 1000) & 0xFF
        out dx, al
        mov al, 0x04 ;(1193180 / 1000) >> 8
        out dx, al
        sti
		
	
	call cls
	push 0x0E
	push 40
	push 24
	push 0
	call right


	
	call startSrc
	

	call music
	mov ah,0x01
	int 21h

; mov dx, 388h ; Set the data port address to 388h
; mov al, 0xff ; Set the value to send to the data port
; out dx, al ; Send the value to the data port





	call cls
	
	call bgLeft
	call bgRight
	call nextShape
	mov ax,290
	push ax
	call score
	
	
	

	; push 1;shape no
	; push 0x7B ; att
	; push 0 ;row
	; push 20 ;col
	; call scroll
	
	
	
	
	
	xor ax,ax
	mov es,ax
	mov ax,[es:8*4]
	mov [oldTisr],ax
	
	mov ax,[es:8*4+2]
	mov [oldTisr+2],ax
	
	
	
	cli
	mov word[es:8*4],sisr
	mov word[es:8*4+2],cs
	sti
	
	
	mov ax,[es:9*4]
	mov [oldKbisr],ax
	mov ax,[es:9*4+2]
	mov [oldKbisr+2],ax
	
	
	
	cli
	mov word[es:9*4],kbsir
	mov word[es:9*4+2],cs
	sti
	
	


	
	
	
	
	
	call endBoundary
	mov ax,10
	push ax
	call LeftP
	mov ax,46
	push ax
	call LeftP
	
	
	; mov ax,0
	; mov bx,12
	; mov dx,0x0E   
	; push dx
	; push ax
	; push bx
	; call downT
	
	
	
	; mov ax,20
	; mov bx,12
	; mov dx,0x0E   
	; push dx
	; push ax
	; push bx
	; call Vline
	
	; mov ax,23
	; mov bx,16
	; mov dx,0x0E   
	; push dx
	; push ax
	; push bx
	; call upT
	
	; mov ax,22
	; mov bx,24
	; mov dx,0x0E   
	; push dx
	; push ax
	; push bx
	; call hzig
	
	
	; mov ax,21
	; mov bx,38
	; mov dx,0x0E   
	; push dx
	; push ax
	; push bx
	; call ultaL
	
	; mov ax,19
	; mov bx,38
	; mov dx,0x0E   
	; push dx
	; push ax
	; push bx
	; call sedhaBox
	
	; mov ax,18
	; mov bx,24
	; mov dx,0x0E   
	; push dx
	; push ax
	; push bx
	; call Vline
	
	; mov ax,17
	; mov bx,32
	; mov dx,0x0E   
	; push dx
	; push ax
	; push bx
	; call ulta
	
	
	
	
	
	
	
	
	
	
	; mov ax,22
	; mov bx,12
	; mov dx,0x0E   
	; push dx
	; push ax
	; push bx
	; call sedhaBox
	
		; mov ax,22
	; mov bx,16
	; mov dx,0x0E   
	; push dx
	; push ax
	; push bx
	; call sedhaBox
	
		; mov ax,22
	; mov bx,20
	; mov dx,0x0E   
	; push dx
	; push ax
	; push bx
	; call sedhaBox
	
		; mov ax,22
	; mov bx,24
	; mov dx,0x0E   
	; push dx
	; push ax
	; push bx
	; call sedhaBox
	
	
		; mov ax,22
	; mov bx,28
	; mov dx,0x0E   
	; push dx
	; push ax
	; push bx
	; call sedhaBox
	
	
		; mov ax,22
	; mov bx,32
	; mov dx,0x0E   
	; push dx
	; push ax
	; push bx
	; call sedhaBox
	
	
		; mov ax,22
	; mov bx,36
	; mov dx,0x0E   
	; push dx
	; push ax
	; push bx
	; call sedhaBox
	
	
	
		; mov ax,22
	; mov bx,38
	; mov dx,0x0E   
	; push dx
	; push ax
	; push bx
	; call sedhaBox
	
	
	
	
	
	
	ourGame:
	;call bgLeft
	call bgRight
	
	mov ax,290
	push ax
	call score
	
	
	
	
	mov ax,[nextS]

	mov bx, word[rand]
	mov word[nextS],bx
	; mov ax, word[rand]
	mov word[currShape],ax
	
	call nextShape
	push ax;shape no
	push 0x0E    ; att
	push 0 ;row
	push 20 ;col
	call scroll
	
	call erase
	cmp word[endFlag],1
	je endGame
	jmp ourGame
	
	
	;call music
	
	
	
	; call endscr

endGame:

	xor ax,ax
	mov es,ax
	mov ax,[oldTisr]
	mov bx,[oldTisr+2]
cli
	mov [es:8*4],ax
	mov [es:8*4+2],bx
sti
	;-------------------
	mov ax,[oldKbisr]
	mov bx,[oldKbisr+2]
cli
	mov [es:9*4],ax
	mov [es:9*4+2],bx
sti

;call bonusEnd	


call bonusEnd

call speakerOff

	mov al,0x20
	out 0x20,al
	call music

	mov ah,01
	int 21h

mov dx, 388h ; Set the data port address to 388h
mov al, 0xff ; Set the value to send to the data port
out dx, al ; Send the value to the data port


mov ax,0x4c00
int 21h





erase:  ; push row=25 initially
	push bp
	mov bp,sp
	push es
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	
	
	mov bx,24
	mov ax,0xb800
	mov es,ax

nexte:
	cmp bx,2
	jle eEnd
	sub bx,1
	
	sub sp,2
	push bx   ;row
	push 11   ;col
	call calLoc
	pop di
	mov cx,18
	
	
	; mov ax,word[es:di+162]
	; mov word[es:0],ax
	
	
.sk2:
	cmp word[es:di],0x0E5F
	jne nexte
	cmp word[es:di+160],0x0E5F
	jne nexte
	cmp word[es:di+162],0x0E7C
	jne nexte
	add di,4
	loop .sk2  
	
	; mov [currScore],bx
	; call endscr
	; push bx
	; mov ah,01
	; int 21h
	; pop bx

	push bx
	call scrolldown
	add word[currScore],10
	
	mov bx,24;--------------------------------------------------------------------------------
	jmp nexte



	eEnd:
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	mov sp,bp
	pop bp 
ret 



scrolldown:
	 push bp 
	 mov bp,sp 
	 push ax 
	 push cx 
	 push si 
	 push di 
	 push es 
	 push ds 
	 push bx
	 
	 
	 ; ;-----------------------
									
	 mov bx,[bp+4]
	 inc bx
	 sub sp,2
	 push bx
	 push 79
	 call calLoc
	 pop bx
	 ;sub bx,2
	 ; mov [currScore],bx
	 ; push 290
	 ; call score
	 
	; push dx
	; mov ah,01
	; int 21h
	; pop dx
	 ;------------------------------
	 
	 mov di,bx
	 sub bx,160
	 mov si,bx
	 
	 mov cx,si
	 shr cx,1
	 
	 ; mov [currScore],di
	 ; push 290
	 ; call score
	 
	; push dx
	; mov ah,01
	; int 21h
	; pop dx
	
	
	 ; mov [currScore],si
	 ; push 290
	 ; call score
	 
	; push dx
	; mov ah,01
	; int 21h
	; pop dx

	 
	 mov cx,320
	 mov ax,0xb800
	 mov es,ax
	
	 
	 ; mov ax, 0x2E20 ; space in red attribute 
	 ; sub di,2
	 ; mov cx,di ; count of positions to clear 
	 ; shr cx,1
	 ; rep stosw ; clear the scrolled space
	 
	 
	; mov [cs:currScore],es
	; push 0
	; call score 
	; mov [cs:currScore],di
	; push 12
	; call score
	 
	; mov [cs:currScore],si
	; push 160+12
	; call score
	
	
	; mov [cs:currScore],es
	; push 2*160+12
	; call score
	
	
	
	
	; mov [cs:currScore],cx
	; push 3*160+12
	; call score
	
	
	; jmp $
.sk1:
	mov ax,[es:si] ;ds:si
	mov [es:di],ax

	 sub si,2
	 sub di,2
	 
	 ;call delay
	 ; mov [currScore],di
	 ; push 290
	 ; call score
	 loop .sk1 ; scroll up 
	 ; std
	 ; mov ax, 0x2E20 ; space in red attribute 
	 ; sub di,2
	 ; mov cx,di ; count of positions to clear 
	 ; shr cx,1
	 
	 ; ;;MEEE
	 
	
	 ; rep stosw ; clear the scrolled space
	 
	 
	 
	 pop bx
	 pop ds 
	 pop es 
	 pop di 
	 pop si 
	 pop cx 
	 pop ax 
	 pop bp 
 ret 2
