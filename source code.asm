title (exe) Graphics System Calls 

.model small 
.stack 64   

.data 
     start_col dw   150 
     start_row dw   50
     finish_col dw  ?
     finish_row dw  ?
     
     current_col dw  150
     current_row dw  50
     
     main_col dw  150
     main_row dw  50
     
     check_row dw ?
     check_row1 dw ?
     tmp_c dw ?
     row1 dw ?
     remove_row dw ?
     tmp dw ?
     c_tmp dw ?
     are_black dw 0
     black_count dw 2
     
     square_length dw  5
     square_length_ dw  -5
     
     square_lengthx2 dw  10
     square_lengthx2_ dw  -10
     square_lengthx3 dw  15
     square_lengthx3_ dw  -15
     
     square_length1 dw  6
     square_length1_ dw  -6
     
     zero dw 0
     rand_5 dw ?
     dir dw 0
     score dw 0
     added_score dw 0
     added_score1 dw 0
     color dw ?
     color_temp dw ?
     color1 dw ?
     
     left_flag dw ?
     right_flag dw ?
     down_flag dw ?
     rotate_flag dw 1
     
     compare db 1
     valid dw ?
     move db ?
     count dw 0
     score_msg dw "SCORE: $"
     gameover_msg dw "GAME OVER!$"
     

.code

 


main proc far
    mov ax, @data
    mov ds, ax
    
       
    call clear_screen    
    call set_graphic_mode
    
    ;mov ah, 01h
    ;int 16
    
    call draw_screen         
    jmp new_shape1
    
    new_shape:
    
    call check_lines
    call check_gameover  
    
    mov al, 0         ; clear keyboard buffer
    mov ah, 0Ch
    int 21h
    
    new_shape1:
    
    call show_score
    call delay
    mov main_col, 150
    mov main_row, 50
    
    call get_rand_5
    call get_rand_color
    mov dir, 0
    
    mov cx, color
    mov color_temp, cx
    
    call draw_randomly
    
    continue:
        
        mov ah, 01h
        int 16h
        jnz pop_buffer     
    
        call delay
        call delay
        call delay
        call delay         ; wait
        call can_move_down
        
        cmp down_flag, 1
        jne new_shape
        
        call move_down
        
        ;mov ah , 6   ; get char from keyboard
        ;int 21h
        ;cmp ZF, 1
        ;jnz continue
        
        mov ah, 01h
        int 16h
        jnz pop_buffer
        jmp continue
        
        pop_buffer:
        mov ah, 00h
        int 16h
        mov move, al
 
                              
        cmp move,'s'
        jnz next_char
        
        call can_move_down
        
        cmp down_flag, 1
        jne new_shape
        
        call move_down 
        
        jmp continue
    
    
        next_char:
            cmp move,'a'
            jnz next_char2  
            
            call can_move_left

            cmp left_flag, 1
            jne continue
            call move_left 

            jmp continue
        
     
        next_char2:
            cmp move,'d'
            jnz next_char3
            
            call can_move_right
            
            cmp right_flag, 1
            jne continue
            call move_right 

            jmp continue
    
        
        next_char3:
            cmp move,'w'
            jnz next_char4
            
            call can_rotate

            cmp rotate_flag, 1
            jne continue 
            call rotate  
            
            jmp continue 
       
       
        next_char4:
            cmp move,'f'
            jnz continue
            
            call go_down
            
            jmp new_shape
    
    
   ; mov ah, 00h
   ; int 16    
    
    
    
;    
;set_pixel:
;    mov ah, 0ch
;    mov dx, 10
;    mov cx, 100
;    mov al, 1
;    int 10h     
;    
;    call draw_square    
;    
;my_loop:
;    call shift_rectangle
;    call delay      
;    cmp  finish_col, 200
;    jnz my_loop
;    
    ;call clear_screen    
    

                       
    
     

    mov ax, 4c00h ; exit to operating system.
    int 21h    

main endp

clear_screen proc
    mov al, 06h ; scroll down
    mov bh, 00h
    mov cx, 0000h
    mov dx, 184fh
    int 10h
                 
    ret                    
endp clear_screen 

set_graphic_mode proc
    mov ah, 00h
    mov al, 13h
    int 10h 
    
    ret
endp set_graphic_mode


draw_square proc 
    mov ah, 0ch 
    mov al, color
      
    mov dx, current_row
    add dx, square_length
    mov finish_row, dx
    mov dx, current_row
     
loop1:
    mov cx, current_col
    add cx, square_length
    mov finish_col, cx
    mov cx, current_col

loop2:
    int 10h
    inc cx
    cmp cx, finish_col
    jnz loop2
    
    inc dx
    cmp dx, finish_row
    jnz loop1
    
    ret
    
endp draw_square

clear_square proc 
    mov ah, 0ch 
    mov al, 0
      
    mov dx, current_row
    add dx, square_length
    mov finish_row, dx
    mov dx, current_row
     
loop1_:
    mov cx, current_col
    add cx, square_length
    mov finish_col, cx
    mov cx, current_col

loop2_:
    int 10h
    inc cx
    cmp cx, finish_col
    jnz loop2
    
    inc dx
    cmp dx, finish_row
    jnz loop1
    
    ret
    
endp clear_square
                            

draw_screen proc
    mov ah, 0ch 
    mov al, 1111b
      
    mov dx, 45
    mov cx, 129 
    
ds1:
    cmp dx, 150
    je ds2
    int 10h
    inc dx
    jmp ds1
ds2:
    cmp cx, 180
    je ds3
    int 10h
    inc cx
    jmp ds2
ds3:
    cmp dx, 45
    je ds4
    int 10h
    dec dx
    jmp ds3
ds4:
    
    ret
endp draw_screen

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            
;   initial drawing of shapes is handled in this part
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

draw_randomly proc
    mov dx, rand_5
    cmp dx, 0
    je draw_london_0
    cmp dx, 1
    je draw_windy
    cmp dx, 2
    je draw_lonley_0
    cmp dx, 3
    je draw_frog_0
    cmp dx, 4
    je draw_ghost_0
        
    ret
endp draw_randomly


draw_london_0 proc
    mov cx, main_row
    mov current_row, cx
    mov cx, main_col
    mov current_col, cx
    call draw_square 
    
    
    add current_col, 5
    call draw_square
    
    add current_col, 5
    call draw_square
    
    add current_col, 5    
    call draw_square

    ret
endp draw_london_0

draw_london_1 proc
    mov cx, main_row
    mov current_row, cx
    mov cx, main_col
    mov current_col, cx
    call draw_square 
    
    add current_row, 5
    call draw_square
    
    add current_row, 5
    call draw_square
    
    add current_row, 5
    call draw_square

    ret
endp draw_london_1

draw_windy proc
    mov cx, main_row
    mov current_row, cx
    mov cx, main_col
    mov current_col, cx
    call draw_square 
    
    mov ax, square_length
    add current_col, ax
    call draw_square
    
    mov ax, square_length
    add current_row, ax
    call draw_square
    
    mov ax, square_length_ 
    add current_col, ax
    call draw_square

    ret
endp draw_windy


draw_lonley_0 proc
    mov cx, main_row
    mov current_row, cx
    mov cx, main_col
    mov current_col, cx
    call draw_square 
    
    mov ax, square_length
    add current_row, ax
    call draw_square
    
    mov ax, square_length
    add current_row, ax
    call draw_square
    
    mov ax, square_length 
    add current_col, ax
    call draw_square
    
    ret
endp draw_lonley_0

draw_lonley_1 proc
    mov cx, main_row
    mov current_row, cx
    mov cx, main_col
    mov current_col, cx
    call draw_square     
    
    add current_row, 5
    call draw_square
    
    add current_row, -5
    add current_col, 5
    call draw_square    

    add current_col, 5
    call draw_square
    
    ret
endp draw_lonley_1

draw_lonley_2 proc
    mov cx, main_row
    mov current_row, cx
    mov cx, main_col
    mov current_col, cx
    call draw_square     
    
    add current_col, 5
    call draw_square
    
    add current_row, 5
    call draw_square    

    add current_row, 5
    call draw_square
    
    ret
endp draw_lonley_2

draw_lonley_3 proc
    mov cx, main_row
    mov current_row, cx
    mov cx, main_col
    mov current_col, cx
    call draw_square     
    
    add current_col, 5
    call draw_square
    
    add current_col, 5
    call draw_square    

    add current_row, -5
    call draw_square
    
    ret
endp draw_lonley_3


draw_frog_0 proc
    mov cx, main_row
    mov current_row, cx
    mov cx, main_col
    mov current_col, cx
    call draw_square 
    
    mov ax, square_length
    add current_row, ax
    call draw_square
    
    mov ax, square_length
    add current_col, ax
    call draw_square
    
    mov ax, square_length 
    add current_row, ax
    call draw_square
    
    ret
endp draw_frog_0

draw_frog_1 proc
    mov cx, main_row
    mov current_row, cx
    mov cx, main_col
    mov current_col, cx
    call draw_square     
    
    add current_col, 5
    call draw_square
    
    add current_row, -5
    call draw_square    

    add current_col, 5
    call draw_square
    
    ret
endp draw_frog_1


draw_ghost_0 proc
    mov cx, main_row
    mov current_row, cx
    mov cx, main_col
    mov current_col, cx
    call draw_square 
    
    mov ax, square_length
    add current_col, ax
    call draw_square
    
    mov ax, square_length
    add current_col, ax
    call draw_square
    
    mov ax, square_length_ 
    add current_col, ax
    mov ax, square_length 
    add current_row, ax
    call draw_square

    ret
endp draw_ghost_0

draw_ghost_1 proc
    mov cx, main_row
    mov current_row, cx
    mov cx, main_col
    mov current_col, cx
    call draw_square     
    
    add current_row, 5
    call draw_square
    
    add current_col, -5
    call draw_square    

    add current_col, 5
    add current_row, 5
    call draw_square

    ret
endp draw_ghost_1

draw_ghost_2 proc
    mov cx, main_row
    mov current_row, cx
    mov cx, main_col
    mov current_col, cx
    call draw_square     
    
    add current_col, 5
    call draw_square
    
    add current_row, -5
    call draw_square    

    add current_col, 5
    add current_row, 5
    call draw_square

    ret
endp draw_ghost_2

draw_ghost_3 proc
    mov cx, main_row
    mov current_row, cx
    mov cx, main_col
    mov current_col, cx
    call draw_square     
    
    add current_row, 5
    call draw_square
    
    add current_col, 5
    call draw_square    

    add current_col, -5
    add current_row, 5
    call draw_square

    ret
endp draw_ghost_3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            
;   moving left is handled in this part
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_left proc
    mov dx, rand_5
    cmp dx, 0
    je move_left_london
    cmp dx, 1
    je move_left_windy
    cmp dx, 2
    je move_left_lonley
    cmp dx, 3
    je move_left_frog
    cmp dx, 4
    je move_left_ghost
    
    ret
endp move_left

move_left_london proc
    
    cmp dir, 0
    je ML_0_0
    cmp dir, 1
    je ML_0_1

ML_0_0:
    mov color, 0
    call draw_london_0
    mov cx, color_temp
    mov color, cx
    add main_col, -5
    call draw_london_0
    ret
    
ML_0_1:    
    mov color, 0
    call draw_london_1
    mov cx, color_temp
    mov color, cx
    add main_col, -5
    call draw_london_1
    
    ret
endp move_left_london
      
      
      
move_left_windy proc
    
    mov color, 0
    call draw_windy
    mov cx, color_temp
    mov color, cx
    add main_col, -5
    call draw_windy
    
    ret
endp move_left_windy
                     
                     
move_left_lonley proc
    
    cmp dir, 0
    je ML_2_0
    cmp dir, 1
    je ML_2_1
    cmp dir, 2
    je ML_2_2
    cmp dir, 3
    je ML_2_3
    ret

ML_2_0:
    mov color, 0
    call draw_lonley_0
    mov cx, color_temp
    mov color, cx
    add main_col, -5
    call draw_lonley_0
    ret
    
ML_2_1:    
    mov color, 0
    call draw_lonley_1
    mov cx, color_temp
    mov color, cx
    add main_col, -5
    call draw_lonley_1
    ret
    
ML_2_2:
    mov color, 0
    call draw_lonley_2
    mov cx, color_temp
    mov color, cx
    add main_col, -5
    call draw_lonley_2
    ret
    
ML_2_3:    
    mov color, 0
    call draw_lonley_3
    mov cx, color_temp
    mov color, cx
    add main_col, -5
    call draw_lonley_3    

    
    ret
endp move_left_lonley


move_left_frog proc
    
    cmp dir, 0
    je ML_3_0
    cmp dir, 1
    je ML_3_1

ML_3_0:
    mov color, 0
    call draw_frog_0
    mov cx, color_temp
    mov color, cx
    add main_col, -5
    call draw_frog_0
    ret
    
ML_3_1:    
    mov color, 0
    call draw_frog_1
    mov cx, color_temp
    mov color, cx
    add main_col, -5
    call draw_frog_1
    
    ret
endp move_left_frog


move_left_ghost proc
    
    cmp dir, 0
    je ML_4_0
    cmp dir, 1
    je ML_4_1
    cmp dir, 2
    je ML_4_2
    cmp dir, 3
    je ML_4_3

ML_4_0:
    mov color, 0
    call draw_ghost_0
    mov cx, color_temp
    mov color, cx
    add main_col, -5
    call draw_ghost_0
    ret
    
ML_4_1:    
    mov color, 0
    call draw_ghost_1
    mov cx, color_temp
    mov color, cx
    add main_col, -5
    call draw_ghost_1
    ret
    
ML_4_2:
    mov color, 0
    call draw_ghost_2
    mov cx, color_temp
    mov color, cx
    add main_col, -5
    call draw_ghost_2
    ret
    
ML_4_3:    
    mov color, 0
    call draw_ghost_3
    mov cx, color_temp
    mov color, cx
    add main_col, -5
    call draw_ghost_3
    
    ret
endp move_left_ghost

;   move
;   move left
;   move right
;   move down
;   can move left
;   can move right
;   can move down

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            
;   moving right is handled in this part
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    

move_right proc
    mov dx, rand_5
    cmp dx, 0
    je move_right_london
    cmp dx, 1
    je move_right_windy
    cmp dx, 2
    je move_right_lonley
    cmp dx, 3
    je move_right_frog
    cmp dx, 4
    je move_right_ghost
    
    ret
endp move_right


move_right_london proc
    
    cmp dir, 0
    je MR_0_0
    cmp dir, 1
    je MR_0_1

MR_0_0:
    mov color, 0
    call draw_london_0
    mov cx, color_temp
    mov color, cx
    add main_col, 5
    call draw_london_0
    ret
    
MR_0_1:    
    mov color, 0
    call draw_london_1
    mov cx, color_temp
    mov color, cx
    add main_col, 5
    call draw_london_1
    
    ret
endp move_right_london
      
      
      
move_right_windy proc
    
    mov color, 0
    call draw_windy
    mov cx, color_temp
    mov color, cx
    add main_col, 5
    call draw_windy
    
    ret
endp move_right_windy
                     
                     
move_right_lonley proc
    
    cmp dir, 0
    je MR_2_0
    cmp dir, 1
    je MR_2_1
    cmp dir, 2
    je MR_2_2
    cmp dir, 3
    je MR_2_3
    ret

MR_2_0:
    mov color, 0
    call draw_lonley_0
    mov cx, color_temp
    mov color, cx
    add main_col, 5
    call draw_lonley_0
    ret
    
MR_2_1:    
    mov color, 0
    call draw_lonley_1
    mov cx, color_temp
    mov color, cx
    add main_col, 5
    call draw_lonley_1
    ret
    
MR_2_2:
    mov color, 0
    call draw_lonley_2
    mov cx, color_temp
    mov color, cx
    add main_col, 5
    call draw_lonley_2
    ret
    
MR_2_3:    
    mov color, 0
    call draw_lonley_3
    mov cx, color_temp
    mov color, cx
    add main_col, 5
    call draw_lonley_3    

    
    ret
endp move_right_lonley


move_right_frog proc
    
    cmp dir, 0
    je MR_3_0
    cmp dir, 1
    je MR_3_1

MR_3_0:
    mov color, 0
    call draw_frog_0
    mov cx, color_temp
    mov color, cx
    add main_col, 5
    call draw_frog_0
    ret
    
MR_3_1:    
    mov color, 0
    call draw_frog_1
    mov cx, color_temp
    mov color, cx
    add main_col, 5
    call draw_frog_1
    
    ret
endp move_right_frog


move_right_ghost proc
    
    cmp dir, 0
    je MR_4_0
    cmp dir, 1
    je MR_4_1
    cmp dir, 2
    je MR_4_2
    cmp dir, 3
    je MR_4_3

MR_4_0:
    mov color, 0
    call draw_ghost_0
    mov cx, color_temp
    mov color, cx
    add main_col, 5
    call draw_ghost_0
    ret
    
MR_4_1:    
    mov color, 0
    call draw_ghost_1
    mov cx, color_temp
    mov color, cx
    add main_col, 5
    call draw_ghost_1
    ret
    
MR_4_2:
    mov color, 0
    call draw_ghost_2
    mov cx, color_temp
    mov color, cx
    add main_col, 5
    call draw_ghost_2
    ret
    
MR_4_3:    
    mov color, 0
    call draw_ghost_3
    mov cx, color_temp
    mov color, cx
    add main_col, 5
    call draw_ghost_3
    
    ret
endp move_right_ghost  


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            
;   moving down is handled in this part
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    

move_down proc
    mov dx, rand_5
    cmp dx, 0
    je move_down_london
    cmp dx, 1
    je move_down_windy
    cmp dx, 2
    je move_down_lonley
    cmp dx, 3
    je move_down_frog
    cmp dx, 4
    je move_down_ghost
    
    ret
endp move_down

move_down_london proc
    
    cmp dir, 0
    je MD_0_0
    cmp dir, 1
    je MD_0_1

MD_0_0:
    mov color, 0
    call draw_london_0
    mov cx, color_temp
    mov color, cx
    add main_row, 5
    call draw_london_0
    ret
    
MD_0_1:    
    mov color, 0
    call draw_london_1
    mov cx, color_temp
    mov color, cx
    add main_row, 5
    call draw_london_1
    
    ret
endp move_down_london
      
      
      
move_down_windy proc
    
    mov color, 0
    call draw_windy
    mov cx, color_temp
    mov color, cx
    add main_row, 5
    call draw_windy
    
    ret
endp move_down_windy
                     
                     
move_down_lonley proc
    
    cmp dir, 0
    je MD_2_0
    cmp dir, 1
    je MD_2_1
    cmp dir, 2
    je MD_2_2
    cmp dir, 3
    je MD_2_3
    ret

MD_2_0:
    mov color, 0
    call draw_lonley_0
    mov cx, color_temp
    mov color, cx
    add main_row, 5
    call draw_lonley_0
    ret
    
MD_2_1:    
    mov color, 0
    call draw_lonley_1
    mov cx, color_temp
    mov color, cx
    add main_row, 5
    call draw_lonley_1
    ret
    
MD_2_2:
    mov color, 0
    call draw_lonley_2
    mov cx, color_temp
    mov color, cx
    add main_row, 5
    call draw_lonley_2
    ret
    
MD_2_3:    
    mov color, 0
    call draw_lonley_3
    mov cx, color_temp
    mov color, cx
    add main_row, 5
    call draw_lonley_3    

    
    ret
endp move_down_lonley


move_down_frog proc
    
    cmp dir, 0
    je MD_3_0
    cmp dir, 1
    je MD_3_1

MD_3_0:
    mov color, 0
    call draw_frog_0
    mov cx, color_temp
    mov color, cx
    add main_row, 5
    call draw_frog_0
    ret
    
MD_3_1:    
    mov color, 0
    call draw_frog_1
    mov cx, color_temp
    mov color, cx
    add main_row, 5
    call draw_frog_1
    
    ret
endp move_down_frog


move_down_ghost proc
    
    cmp dir, 0
    je MD_4_0
    cmp dir, 1
    je MD_4_1
    cmp dir, 2
    je MD_4_2
    cmp dir, 3
    je MD_4_3

MD_4_0:
    mov color, 0
    call draw_ghost_0
    mov cx, color_temp
    mov color, cx
    add main_row, 5
    call draw_ghost_0
    ret
    
MD_4_1:    
    mov color, 0
    call draw_ghost_1
    mov cx, color_temp
    mov color, cx
    add main_row, 5
    call draw_ghost_1
    ret
    
MD_4_2:
    mov color, 0
    call draw_ghost_2
    mov cx, color_temp
    mov color, cx
    add main_row, 5
    call draw_ghost_2
    ret
    
MD_4_3:    
    mov color, 0
    call draw_ghost_3
    mov cx, color_temp
    mov color, cx
    add main_row, 5
    call draw_ghost_3
    
    ret
endp move_down_ghost

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            
;   rotation is handled in this part
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

rotate proc
    mov dx, rand_5
    cmp dx, 0
    je if_0
    cmp dx, 2
    je if_2
    cmp dx, 3
    je if_3
    cmp dx, 4
    je if_4
    jmp return
    
    
if_0:
    ;check if possible
    mov dx, dir
    cmp dir, 0
    je rot_0_0
    jmp rot_0_1
    
rot_0_0:
    mov cx, color
    mov color_temp, cx
    mov color, 0
    call draw_london_0
    mov cx, color_temp
    mov color, cx
    add main_col, 10
    add main_row, -5
    call draw_london_1
    
    mov dir, 1
    jmp return

rot_0_1: 
    mov cx, color
    mov color_temp, cx
    mov color, 0
    call draw_london_1
    mov cx, color_temp
    mov color, cx
    add main_col, -10
    add main_row, 5
    call draw_london_0
    
    mov dir, 0
    jmp return
     
if_2:
    ;check if possible
    mov dx, dir
    cmp dir, 0
    je rot_2_0
    cmp dir, 1
    je rot_2_1
    cmp dir, 2
    je rot_2_2
    cmp dir, 3
    je rot_2_3
    
rot_2_0:
    mov cx, color
    mov color_temp, cx
    mov color, 0
    call draw_lonley_0
    mov cx, color_temp
    mov color, cx
    add main_row, 10
    call draw_lonley_1
    
    mov dir, 1
    jmp return
    
rot_2_1:
    mov cx, color
    mov color_temp, cx
    mov color, 0
    call draw_lonley_1
    mov cx, color_temp
    mov color, cx
    add main_col, -5
    call draw_lonley_2
    
    mov dir, 2
    jmp return
    
rot_2_2:
    mov cx, color
    mov color_temp, cx
    mov color, 0
    call draw_lonley_2
    mov cx, color_temp
    mov color, cx
    add main_col, -5
    call draw_lonley_3
    
    mov dir, 3
    jmp return
    
rot_2_3:
    mov cx, color
    mov color_temp, cx
    mov color, 0
    call draw_lonley_3
    mov cx, color_temp
    mov color, cx
    add main_col, 10
    add main_row, -10
    call draw_lonley_0
    
    mov dir, 0
    jmp return
    

if_3:
    ;check if possible
    mov dx, dir
    cmp dir, 0
    je rot_3_0
    jmp rot_3_1
    
rot_3_0:
    mov cx, color
    mov color_temp, cx
    mov color, 0
    call draw_frog_0
    mov cx, color_temp
    mov color, cx
    add main_row, 5
    call draw_frog_1
    
    mov dir, 1
    jmp return
    
rot_3_1:
    mov cx, color
    mov color_temp, cx
    mov color, 0
    call draw_frog_1
    mov cx, color_temp
    mov color, cx
    add main_row, -5
    call draw_frog_0
    
    mov dir, 0
    jmp return
    

if_4:
    ;check if possible
    mov dx, dir
    cmp dir, 0
    je rot_4_0
    cmp dir, 1
    je rot_4_1
    cmp dir, 2
    je rot_4_2
    cmp dir, 3
    je rot_4_3
    
rot_4_0:
    mov cx, color
    mov color_temp, cx
    mov color, 0
    call draw_ghost_0
    mov cx, color_temp
    mov color, cx
    add main_row, -5
    add main_col, 5
    call draw_ghost_1
    
    mov dir, 1
    jmp return
rot_4_1:
    mov cx, color
    mov color_temp, cx
    mov color, 0
    call draw_ghost_1
    mov cx, color_temp
    mov color, cx
    add main_row, 5
    add main_col, -5
    call draw_ghost_2
    
    mov dir, 2
    jmp return
rot_4_2:
    mov cx, color
    mov color_temp, cx
    mov color, 0
    call draw_ghost_2
    mov cx, color_temp
    mov color, cx
    add main_row, -5
    add main_col, 5
    call draw_ghost_3
    
    mov dir, 3
    jmp return
rot_4_3:
    mov cx, color
    mov color_temp, cx
    mov color, 0
    call draw_ghost_3
    mov cx, color_temp
    mov color, cx
    add main_row, 5
    add main_col, -5
    call draw_ghost_0
    
    mov dir, 0
    jmp return
    

return:           
    ret
endp rotate

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            
;   moving left validation is handled in this part
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  


can_move_left proc
    
    mov compare, 1
    mov left_flag, 1
    mov ah, 0Dh
    mov cx, main_col
    mov dx, main_row
    mov current_row, dx
    mov current_col, cx
    
    cmp rand_5, 0
    je left_0
    cmp rand_5, 1
    je left_1
    cmp rand_5, 2
    je left_2
    cmp rand_5, 3
    je left_3
    cmp rand_5, 4
    je left_4

left_0:
    cmp dir, 0
    je L0_0
    cmp dir, 1
    je L0_1            
    
L0_0:
    add current_col, -5
    
    cmp current_col, 130
    jl left_not_valid
    
    call get_pixel_color
    
    cmp compare, 0
    je left_not_valid
    
    ret   
     
L0_1:
    add current_col, -5
    
    cmp current_col, 130
    jl left_not_valid
    
    call get_pixel_color
    
    add current_row, 5   
    call get_pixel_color
    
    add current_row, 5   
    call get_pixel_color
    
    add current_row, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  left_not_valid
    
    ret

left_1:
    add current_col, -5
    
    cmp current_col, 130
    jl left_not_valid
    
    call get_pixel_color
    
    add current_row, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  left_not_valid
    
    ret
    

left_2:
    cmp dir, 0
    je L2_0
    cmp dir, 1
    je L2_1
    cmp dir, 2
    je L2_2
    cmp dir, 3
    je L2_3
    
L2_0:
    add current_col, -5
    
    cmp current_col, 130
    jl left_not_valid
    
    call get_pixel_color
    
    add current_row, 5   
    call get_pixel_color
    
    add current_row, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  left_not_valid
    
    ret
L2_1:
    add current_col, -5
    
    cmp current_col, 130
    jl left_not_valid
    
    call get_pixel_color
    
    add current_row, 5   
    call get_pixel_color
    
    ;add current_row, 5   
    ;call get_pixel_color
    
    cmp compare, 0
    je  left_not_valid
    
    ret
L2_2:
    add current_col, -5
    
    cmp current_col, 130
    jl left_not_valid
    
    call get_pixel_color
    
    add current_col, 5   
    add current_row, 5   
    call get_pixel_color
    
    add current_row, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  left_not_valid
    
    ret
    
L2_3:
    add current_col, -5
    
    cmp current_col, 130
    jl left_not_valid
    
    call get_pixel_color
    
    add current_col, 10   
    add current_row, -5   
    call get_pixel_color
    
    cmp compare, 0
    je  left_not_valid
    
    ret

left_3:
    cmp dir, 0
    je L3_0
    cmp dir, 1
    je L3_1
L3_0:
    add current_col, -5
    
    cmp current_col, 130
    jl left_not_valid
    
    call get_pixel_color
       
    add current_row, 5   
    call get_pixel_color
    
    add current_row, 5
    add current_col, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  left_not_valid
    
    ret
    
L3_1:
    add current_col, -5
    
    cmp current_col, 130
    jl left_not_valid
    
    call get_pixel_color
       
    add current_row, -5
    add current_col, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  left_not_valid
    
    ret

left_4:
    cmp dir, 0
    je L4_0
    cmp dir, 1
    je L4_1
    cmp dir, 2
    je L4_2
    cmp dir, 3
    je L4_3
L4_0:
    add current_col, -5
    
    cmp current_col, 130
    jl left_not_valid
    
    call get_pixel_color
       
    add current_row, 5
    add current_col, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  left_not_valid
    
    ret
L4_1:
    add current_col, -10
    
    cmp current_col, 130
    jl left_not_valid
    
    add current_col, 5
    call get_pixel_color
       
    add current_col, -5
    add current_row, 5   
    call get_pixel_color
    
    add current_col, 5
    add current_row, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  left_not_valid
    
    ret
L4_2:
    add current_col, -5
    
    cmp current_col, 130
    jl left_not_valid
    
    call get_pixel_color
       
    add current_row, -5
    add current_col, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  left_not_valid
    
    ret
L4_3:
    add current_col, -5
    
    cmp current_col, 130
    jl left_not_valid
    
    call get_pixel_color
       
    add current_row, 5  
    call get_pixel_color
    
    add current_row, 5  
    call get_pixel_color
    
    cmp compare, 0
    je  left_not_valid
    
    ret    

left_not_valid:
    mov left_flag, 0
    ret 
    
    ret
endp can_move_left

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            
;   moving right validation is handled in this part
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

can_move_right proc
    
    mov compare, 1
    mov right_flag, 1
    mov ah, 0Dh
    mov cx, main_col
    mov dx, main_row
    mov current_row, dx
    mov current_col, cx
    
    cmp rand_5, 0
    je right_0
    cmp rand_5, 1
    je right_1
    cmp rand_5, 2
    je right_2
    cmp rand_5, 3
    je right_3
    cmp rand_5, 4
    je right_4

right_0:
    cmp dir, 0
    je R0_0
    cmp dir, 1
    je R0_1            
    
R0_0:
    add current_col, 20
    
    cmp current_col, 180
    jge right_not_valid
    
    call get_pixel_color
    
    cmp compare, 0
    je right_not_valid
    
    ret   
     
R0_1:
    add current_col, 5
    
    cmp current_col, 180
    jge right_not_valid
    
    call get_pixel_color
    
    add current_row, 5   
    call get_pixel_color
    
    add current_row, 5   
    call get_pixel_color
    
    add current_row, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  right_not_valid
    
    ret

right_1:
    add current_col, 10
    
    cmp current_col, 180
    jge right_not_valid
    
    call get_pixel_color
    
    add current_row, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  right_not_valid
    
    ret
    

right_2:
    cmp dir, 0
    je R2_0
    cmp dir, 1
    je R2_1
    cmp dir, 2
    je R2_2
    cmp dir, 3
    je R2_3
    
R2_0:
    add current_col, 10
    
    cmp current_col, 180
    jge right_not_valid
    
    add current_col, -5
    call get_pixel_color
    
    add current_row, 5   
    call get_pixel_color
    
    add current_row, 5
    add current_col, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  right_not_valid
    
    ret
R2_1:
    add current_col, 15
    
    cmp current_col, 180
    jge right_not_valid
    
    call get_pixel_color
    
    add current_row, 5
    add current_col, -10   
    call get_pixel_color
    
    cmp compare, 0
    je  right_not_valid
    
    ret
R2_2:
    add current_col, 10
    
    cmp current_col, 180
    jge right_not_valid
    
    call get_pixel_color
       
    add current_row, 5   
    call get_pixel_color
    
    add current_row, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  right_not_valid
    
    ret
    
R2_3:
    add current_col, 15
    
    cmp current_col, 180
    jge right_not_valid
    
    call get_pixel_color
       
    add current_row, -5   
    call get_pixel_color
    
    cmp compare, 0
    je  right_not_valid
    
    ret

right_3:
    cmp dir, 0
    je R3_0
    cmp dir, 1
    je R3_1
R3_0:
    add current_col, 10
    
    cmp current_col, 180
    jge right_not_valid
    
    add current_col, -5
    call get_pixel_color
 
    add current_col, 5      
    add current_row, 5   
    call get_pixel_color
    
    add current_row, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  right_not_valid
    
    ret
    
R3_1:
    add current_col, 15
    
    cmp current_col, 180
    jge right_not_valid
    
    add current_row, -5
    call get_pixel_color
       
    add current_row, 5
    add current_col, -5   
    call get_pixel_color
    
    cmp compare, 0
    je  right_not_valid
    
    ret

right_4:
    cmp dir, 0
    je R4_0
    cmp dir, 1
    je R4_1
    cmp dir, 2
    je R4_2
    cmp dir, 3
    je R4_3
R4_0:
    add current_col, 15
    
    cmp current_col, 180
    jge right_not_valid
    
    call get_pixel_color
       
    add current_row, 5
    add current_col, -5   
    call get_pixel_color
    
    cmp compare, 0
    je  right_not_valid
    
    ret
R4_1:
    add current_col, 5
    
    cmp current_col, 180
    jge right_not_valid
    
    call get_pixel_color
       
    add current_row, 5   
    call get_pixel_color
    
    add current_row, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  right_not_valid
    
    ret
R4_2:
    add current_col, 15
    
    cmp current_col, 180
    jge right_not_valid
    
    call get_pixel_color
       
    add current_row, -5
    add current_col, -5   
    call get_pixel_color
    
    cmp compare, 0
    je  right_not_valid
    
    ret
R4_3:
    add current_col, 10
    
    cmp current_col, 180
    jge right_not_valid
    
    add current_col, -5
    call get_pixel_color
       
    add current_row, 5
    add current_col, 5  
    call get_pixel_color
    
    add current_row, 5
    add current_col, -5  
    call get_pixel_color
    
    cmp compare, 0
    je  right_not_valid
    
    ret    

right_not_valid:
    mov right_flag, 0
    ret 
    
    ret
endp can_move_right

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            
;   moving down validation is handled in this part
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

can_move_down proc
    
    mov compare, 1
    mov down_flag, 1
    mov ah, 0Dh
    mov cx, main_col
    mov dx, main_row
    mov current_row, dx
    mov current_col, cx
    
    cmp rand_5, 0
    je down_0
    cmp rand_5, 1
    je down_1
    cmp rand_5, 2
    je down_2
    cmp rand_5, 3
    je down_3
    cmp rand_5, 4
    je down_4

down_0:
    cmp dir, 0
    je D0_0
    cmp dir, 1
    je D0_1            
    
D0_0:
    add current_row, 5
    
    cmp current_row, 150
    jge down_not_valid
    
    call get_pixel_color
    
    add current_col, 5
    call get_pixel_color
    
    add current_col, 5
    call get_pixel_color
    
    add current_col, 5
    call get_pixel_color
    
    cmp compare, 0
    je down_not_valid
    
    ret   
     
D0_1:
    add current_row, 20
    
    cmp current_row, 150
    jge down_not_valid
    
    call get_pixel_color
    
    cmp compare, 0
    je  down_not_valid
    
    ret

down_1:
    add current_row, 10
    
    cmp current_row, 150
    jge down_not_valid
    
    call get_pixel_color
    
    add current_col, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  down_not_valid
    
    ret
    

down_2:
    cmp dir, 0
    je D2_0
    cmp dir, 1
    je D2_1
    cmp dir, 2
    je D2_2
    cmp dir, 3
    je D2_3
    
D2_0:
    add current_row, 15
    
    cmp current_row, 150
    jge down_not_valid
    
    call get_pixel_color
    
    add current_col, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  down_not_valid
    
    ret
D2_1:
    add current_row, 10
    
    cmp current_row, 150
    jge down_not_valid
    
    call get_pixel_color
    
    add current_row, -5
    add current_col, 5   
    call get_pixel_color 
    
    add current_col, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  down_not_valid
    
    ret
D2_2:
    add current_row, 15
    
    cmp current_row, 150
    jge down_not_valid
    
    add current_col, 5
    call get_pixel_color
    
    add current_col, -5   
    add current_row, -10   
    call get_pixel_color
    
    cmp compare, 0
    je  down_not_valid
    
    ret
    
D2_3:
    add current_row, 5
    
    cmp current_row, 150
    jge down_not_valid
    
    call get_pixel_color
       
    add current_col, 5   
    call get_pixel_color
    
    add current_col, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  down_not_valid
    
    ret

down_3:
    cmp dir, 0
    je D3_0
    cmp dir, 1
    je D3_1
D3_0:
    add current_row, 15
    
    cmp current_row, 150
    jge down_not_valid
    
    add current_row, -5
    call get_pixel_color
 
    add current_col, 5      
    add current_row, 5   
    call get_pixel_color
       
    cmp compare, 0
    je  down_not_valid
    
    ret
    
D3_1:
    add current_row, 5
    
    cmp current_row, 150
    jge down_not_valid
    
    call get_pixel_color
    
    add current_col, 5
    call get_pixel_color
       
    add current_row, -5
    add current_col, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  down_not_valid
    
    ret

down_4:
    cmp dir, 0
    je D4_0
    cmp dir, 1
    je D4_1
    cmp dir, 2
    je D4_2
    cmp dir, 3
    je D4_3
D4_0:
    add current_row, 10
    
    cmp current_row, 150
    jge down_not_valid
    
    add current_row, -5
    call get_pixel_color
       
    add current_row, 5
    add current_col, 5   
    call get_pixel_color
    
    add current_row, -5
    add current_col, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  down_not_valid
    
    ret
D4_1:
    add current_row, 15
    
    cmp current_row, 150
    jge down_not_valid
    
    call get_pixel_color
       
    add current_row, -5
    add current_col, -5   
    call get_pixel_color
       
    cmp compare, 0
    je  down_not_valid
    
    ret
D4_2:
    add current_row, 5
    
    cmp current_row, 150
    jge down_not_valid
    
    call get_pixel_color
       
    add current_col, 5   
    call get_pixel_color
    
    add current_col, 5   
    call get_pixel_color
    
    cmp compare, 0
    je  down_not_valid
    
    ret
D4_3:
    add current_row, 15
    
    cmp current_row, 150
    jge down_not_valid
    
    call get_pixel_color
       
    add current_row, 5
    add current_col, 5  
    call get_pixel_color
    
    add current_row, -5
    add current_col, 5  
    call get_pixel_color
    
    cmp compare, 0
    je  down_not_valid
    
    ret    

down_not_valid:
    mov down_flag, 0
    ret 
    
    ret
endp can_move_down 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            
;   rotation validation is handled in this part
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

can_rotate proc
    
    mov compare, 1
    mov rotate_flag, 1
    mov ah, 0Dh
    mov cx, main_col
    mov dx, main_row
    mov current_row, dx
    mov current_col, cx
    
    cmp rand_5, 0
    je rotate_0
    
    cmp rand_5, 2
    je rotate_2
    cmp rand_5, 3
    je rotate_3
    cmp rand_5, 4
    je rotate_4
    
    ret

rotate_0:
    cmp dir, 0
    je E0_0
    cmp dir, 1
    je E0_1            
    
E0_0:
    add current_row, 15
    
    cmp current_row, 150
    jge rotate_not_valid
    
    add current_col, 10
    add current_row, -5
    
    call get_pixel_color
    
    add current_row, -5
    call get_pixel_color
    
    cmp compare, 0
    je rotate_not_valid
    
    ret   
     
E0_1:
    add current_col, 10
    
    cmp current_col, 180
    jge rotate_not_valid
    
    add current_col, -25
    cmp current_col, 130
    jl rotate_not_valid
    
    add current_col, 5
    add current_row, 5
    call get_pixel_color
    
    add current_col, 5
    call get_pixel_color
    
    add current_col, 10
    call get_pixel_color
    
    cmp compare, 0
    je  rotate_not_valid
    
    ret


rotate_2:
    cmp dir, 0
    je E2_0
    cmp dir, 1
    je E2_1
    cmp dir, 2
    je E2_2
    cmp dir, 3
    je E2_3
    
E2_0:
    add current_col, 15
    
    cmp current_col, 180
    jg rotate_not_valid
    
    add current_row, 20
    
    cmp current_row, 150
    jge rotate_not_valid
    
    add current_col, -15
    add current_row, -5
    call get_pixel_color
    
    add current_col, 10
    add current_row, -5
    call get_pixel_color
    
    cmp compare, 0
    je  rotate_not_valid
    
    ret
E2_1:
    add current_col, -5
    
    cmp current_col, 130
    jl rotate_not_valid
    
    call get_pixel_color
    
    add current_row, 10
    cmp current_row, 150
    jge rotate_not_valid
    
    add current_col, 5
    call get_pixel_color
     
    cmp compare, 0
    je  rotate_not_valid
    
    ret
E2_2:
    ;add current_col, -5
    
    cmp current_col, 130
    jle rotate_not_valid
    
    ;call get_pixel_color
    
    add current_col, -5
    call get_pixel_color
    
    cmp compare, 0
    je  rotate_not_valid
    
    ret
    
E2_3:
    add current_col, 20
    
    cmp current_col, 180
    jge rotate_not_valid
    
    add current_col, -5
    call get_pixel_color
       
    cmp compare, 0
    je  rotate_not_valid
    
    ret

rotate_3:
    cmp dir, 0
    je E3_0
    cmp dir, 1
    je E3_1
E3_0:
    add current_col, 15
    
    cmp current_col, 180
    jge rotate_not_valid
    
    add current_col, -5
    call get_pixel_color
 
    add current_col, -5
    call get_pixel_color
    
    cmp compare, 0
    je  rotate_not_valid
    
    ret
    
E3_1:
    add current_row, 10
    
    cmp current_row, 150
    jge rotate_not_valid
    
    add current_row, -5
    add current_col, 5
    call get_pixel_color
    
    cmp compare, 0
    je  rotate_not_valid
    
    ret

rotate_4:
    cmp dir, 0
    je E4_0
    cmp dir, 1
    je E4_1
    cmp dir, 2
    je E4_2
    cmp dir, 3
    je E4_3
E4_0:
    
    ret
    
E4_1:
    add current_col, 10
    
    cmp current_col, 180
    jge rotate_not_valid
    
    add current_row, 5
    add current_col, -5
    call get_pixel_color
       
    cmp compare, 0
    je  rotate_not_valid
    
    ret
E4_2:
    add current_row, 10
    
    cmp current_row, 150
    jge rotate_not_valid
     
    add current_row, -5
    add current_col, 5
    call get_pixel_color
    
    cmp compare, 0
    je  rotate_not_valid
    
    ret
E4_3:
    add current_col, -10
    
    cmp current_col, 130
    jl rotate_not_valid
    
    call get_pixel_color
       
    add current_row, 5
    add current_col, 5  
    call get_pixel_color
    
    cmp compare, 0
    je  rotate_not_valid
    
    ret    

rotate_not_valid:
    mov rotate_flag, 0
    ret 
    
    ret
endp can_rotate

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            
;   checking line and removing it is handled in this part
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_lines proc
    
    mov added_score, 0
    cmp rand_5, 0
    jne set_check
    cmp dir, 1
    jne set_check
    
    mov cx, main_row
    mov check_row, cx
    mov check_row1, cx
    add check_row, 15
    jmp set_up1
    
set_check:
    mov cx, main_row
    mov check_row, cx
    mov check_row1, cx
        
    add check_row, 10
    cmp check_row, 150
    jl set_up
    
    mov check_row, 145
    
set_up:
    add check_row1, -5
    cmp check_row1, 50
    jge set_up1
        
    mov check_row1, 50
        
set_up1:
    mov c_tmp, 130
set_up2:
    mov dx, check_row1
    cmp check_row, dx
    jl done    
set_up3:
    cmp c_tmp, 180
    jge cont2
    
    mov dx, check_row
    mov cx, c_tmp
    int 10h
    cmp al, 0
    je cont1
    
    add c_tmp, 5
    jmp set_up3
    
cont2:
    mov cx, check_row
    inc added_score
    push cx
    ;call remove_line
    
cont1:
    add check_row, -5
    jmp set_up1

    
done:
    mov ax, added_score
    mov added_score1, ax 
heh:
    cmp added_score, 0
    je sth
    dec added_score
    pop ax
    mov remove_row, ax
    call remove_line
    jmp heh
    
sth:
    ret
endp check_lines



remove_line proc
    
    mov tmp, 130
g2: 
    mov cx, remove_row
    mov row1, cx
    
    cmp tmp, 175
    jg done1
g3:    
    cmp row1, 55
    jl g1
    
    add row1, -5     ;get pixel color
    mov dx, row1
    mov cx, tmp
    mov ah, 0Dh
    int 10h
    mov color1, al
    
    ;cmp color1, 0
    ;;je check_black1
    
check_black2:
    ;cmp are_black, 1
    ;je g1
    
    add row1, 5
    mov dx, row1
    mov current_row, dx
    mov dx, tmp
    mov current_col, dx
    mov dx, color1
    mov color, dx
    call draw_square
    
    add row1, -5
    jmp g3
     
    
g1: 
    mov black_count, 2
    add tmp, 5
    jmp g2
    
    
    
done1:    
    
    ret
endp remove_line

check_black1:
    call check_black
    jmp check_black2

check_black proc
    
    dec black_count
    cmp black_count, 0
    jne set_ret
    
    mov are_black, 1
    mov bx, row1
ll2:    
    add bx, -5              ;get pixel color
    mov dx, bx
    mov cx, tmp
    mov ah, 0Dh
    int 10h
    cmp al, 0
    jne set_ret
    cmp bx, 45
    je rett
    jmp ll2

set_ret:
    mov are_black, 0
rett:
    ret
endp check_black
    
show_score proc
    
    
    ; print "SCORE: " 
    mov ah, 02h      ; set cursor position
    mov bh, 00       ; page number
    mov dh, 80        ; row
    mov dl, 30       ; column
    int 10h
    
    mov ah, 09h      ; output of a string
    lea dx, score_msg
    int 21h
    
    cmp added_score1, 0
    je divvv
    
    mov ax, added_score1
    mov cx, 20
    mul cx
    add ax, -10
    ;mov ax, added_score1
    add score, ax  ;;;;;;;;;;;;;;;;;
    mov added_score1, 0
divvv:    
    mov count, 0
    mov ax, score
divv:    
    mov dx, 0
    mov cx ,10
    div cx
    push dx
    inc count
    
    cmp ax, 0
    jne divv

ret8:       
    dec count          
           
    pop dx
    add dx, 30h       ; convert int to char
    mov ah, 02h       ; print char
    int  21h
    
    cmp count, 0
    je ret9
    
    jmp ret8
    
ret9:

    mov ax, score ; show Score on *** LED ***
    out 199, ax
        
    ret
endp show_score    
    


get_pixel_color proc
    mov dx, current_row
    mov cx, current_col
    int 10h
    cmp al, 0
    jne Rset
    ret
Rset:
    mov compare, 0
    ret
endp get_pixel_color 

check_gameover proc
    
    mov ah, 0Dh
    mov dx, 50
    mov cx, 130
end_go0:    
    cmp cx, 180
    jge end_go1
     
    int 10h
    cmp al, 0
    jne end_go
    
    add cx, 5
    jmp end_go0
    
end_go:   
     
    call show_score
    ; print "GAME OVER" 
    mov ah, 02h      ; set cursor position
    mov bh, 00       ; page number
    mov dh, 90        ; row
    mov dl, 30       ; column
    int 10h
    
    mov ah, 09h      ; output of a string
    lea dx, gameover_msg 
    int 21h

    mov ah, 4Ch         ; stop program and give control to OS
    int 21h
        
end_go1:    
    ret
endp check_gameover

go_down proc

go_loop:
    call can_move_down
    cmp down_flag, 0
    je down_ret
    
    call move_down
    jmp go_loop
    
down_ret:
    ret
endp go_down



get_rand_5 proc
    
    mov AH, 00h  ; interrupts to get system time        
    int 1Ah      ; CX:DX now hold number of clock ticks since midnight      

    mov  ax, dx
    mov  dx, 0
    mov  cx, 10    
    div  cx  
    
    mov ax, dx
    mov dx, 0
    mov cx, 5
    div cx
    mov rand_5, dx      ; dx now holds a random number of 0 to 4
    ;mov rand_5, 0 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;?????
          
    ret
endp get_rand_5
               
               
get_rand_color proc
    
    mov AH, 00h  ; interrupts to get system time        
    int 1Ah      ; CX:DX now hold number of clock ticks since midnight      

    mov  ax, dx
    mov  dx, 0
    mov  cx, 10    
    div  cx
    mov ax, dx
    mov dx, 0
    mov cx, 5
    div cx
    add  dx, 1
    mov color, dx      ; dx now holds a random color of 1 to 5
          
    ret
endp get_rand_color
     
      
delay proc 
    mov ax, 65530
delay_loop:
    dec ax
    cmp ax, zero
    jnz delay_loop
    
    mov ax, 65530
delay_loop2:
    dec ax
    cmp ax, zero
    jnz delay_loop2
    
    mov ax, 65530
delay_loop3:
    dec ax
    cmp ax, zero
    jnz delay_loop3
      
    ret
endp delay


end main