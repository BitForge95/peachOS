ORG 0
BITS 16
_start:
    jmp short start ;short jmps to the start label 
    nop ;no operation

 times 33 db 0 ; this is our BIOS parameter    


start:
    jmp 0x7c0:step2
  

step2:
    cli ; clears all the interupts
    mov ax,0x7c0
    mov ds,ax
    mov es,ax
    mov ax,0x00
    mov ss,ax
    mov sp,0x7c00
    sti ; enables all interrupts

    mov ah,2 ;READ SECTOR CMD
    mov al,1 ;ONE SECTOR TO READ 
    mov ch,0 ;Cylinder is zero i.e. is low 8 bits
    mov cl,2 ;Sector number - 2
    mov dh,0 ;Head number
    mov bx,buffer
    int 0x13 ;Disk interrupt
    jc error

    mov si,buffer ;Loads the message.txt into buffer and lodsb it 
    call print 

    jmp $

error:
    mov si,error_message
    call print    
    jmp $

print:
    mov bx,0
.loop:
    lodsb
    cmp al,0
    je .done
    call print_char
    jmp .loop

.done:
    ret

print_char:
    mov ah,0eh
    int 0x10
    ret


error_message: db "Failed to load sector",0

times 510-($-$$) db 0
dw 0xAA55    

buffer: