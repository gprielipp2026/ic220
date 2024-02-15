
	// Note -- this file relies upon other files, including:
	//   blinkt.c (for set_pixel(), show() )
	//   helper.s (for helperGetLong(), helperPrintLong() )
	
	// ********************
	// Specify the instruction set to generate for
	.arch armv8-a

	// ******************
	// Define all necessary strings
	.text	
	.section	.rodata
	.align	3
	
	//*********************
	// allocate memory for my colors
	.section	.data
R:	.space  64
G:	.space 	64
B:	.space	64
	
	// *****************************
	// *****************************
	// *****************************
	// *****************************
	// main() really starts here
	// *****************************
	// *****************************
	// *****************************
	// *****************************
	.text
	.align	2
	.global	main
	.type	main, %function
main:
        // Save return address to stack -- needed to return from main()
	// NOTE -- we only need 8 bytes of space on stack for this
	// BUT --  must move $sp in increments of 16, or get 'bus error' on use
	sub     sp, sp,  16
	stur    lr,[sp, 0]

	// Initialize the LEDs (code from in blinkt.c)
	bl	start
	
	// initialize the arrays with the necessary data
	adr	x0, R		// store address of array R in x0
	adr	x1, G		// store address of array G in x1
	adr	x2, B		// store address of array B in x2
	
	mov	x3, 250
	stur	x3, [x0,8]
	stur	x3, [x2,40]
	
	mov	x3, 255
	stur	x3, [x0,0]
	stur	x3, [x0,16]
	stur	x3, [x0,56]
	stur	x3, [x2,32]
	stur	x3, [x2,56]
	stur	x3, [x1,16]
	stur	x3, [x1,24]
	
	mov	x3, 25
	stur	x3, [x0,24]
	stur	x3, [x0,32]
	
	mov	x3, 30 
	stur	x3, [x1,8]
	stur	x3,  [x2,8]
	
	mov	x3, 195
	stur	x3, [x0,40]
	
	mov	x3, 165
	stur	x3, [x0,48]

	mov	x3, 0
	stur	x3, [x1,0]
	stur	x3, [x2,0]
	stur	x3, [x2,16]
	
	mov	x3, 210
	stur	x3, [x1,32]

	mov	x3, 90
	stur	x3, [x1,40]

	mov	x3, 15
	stur	x3, [x1,48]
	
	mov	x3, 100
	stur	x3, [x1,56]

	mov	x3, 75
	stur	x3 , [x2,24]
	
	mov	x3, 205
	stur	x3, [x2,48]

	// infinitely loop over this rainbow
	// set up initial counter variables
	mov 	x4, 0 	// offset
	mov	x5, 0	// index
	adr	x20,R	// array "R" < red pixels
	adr	x21,G	// array "G" < green pixels
	adr	x22,B	// array "B" < blue pixels
	mov	x23,0	// off counter
infinite:
	add	x4, x4, 1 // offset++
	sub	x19, x4, 8 // offset == 8 ?
	cbnz	x19, goodOffset
	mov	x4, 0 // offset = 0 (%8=0)
goodOffset:
	
	// "for" loop through the indexes and set each pixel
	// according to what is stored in the Arrays
	mov	x5, 0	//for index=0
forLoop:
	sub	x19, x5, 8 // index == 8?
	cbz	x19, preOffLoop  // index = 8, exit loop
	add	x6, x4, x5 // offset + index (%8 soon)
	subs	x19, x6, 8 // %8 if needed
	b.LT	goodIndex	
	sub 	x6, x6, 8 
goodIndex:
	lsl	x7, x6, 3 // (index+offset%8)*8 <-- offset into array
	mov	x0, x5      // set the LED address
	add	x8, x20, x7 // R[i] address
	ldur	x9, [x8, 0] // R[i] value
	mov	x1, x9	    // set the Red pixel for set_pixel
	add	x8, x21, x7 // G[i] address
	ldur	x9, [x8, 0] // G[i] value
	mov	x2, x9	    // set the Green pixel for set_pixel
	add	x8, x22, x7 // B[i] address
	ldur	x9, [x8, 0] // B[i] value
	mov	x3, x9	    // set the Blue pixel for set_pixel
	bl	set_pixel
	add	x5, x5, 1   // index++
	b	forLoop	    // go back up to the forloop
preOffLoop:
	mov	x24, 0 // = loop for the offLoop
offLoop:
	// turn off up to 8 pixels
	sub	x19, x23, x24	// x24=x23?
	cbz	x19, doneOff	
	mov	x0, x24		// set up for turning off
	add	x24, x24, 1	// x24++
	bl	setLEDoff
	b	offLoop
doneOff:
	add	x23, x23, 1// # off +++
	sub	x19, x23, 8 	// x23 == 8?
	cbnz	x19, goodOffNumber
	mov	x23, 0		// x23 = 0
goodOffNumber:
	// wait for .25s
	bl 	show
	mov 	x11, 2      // do this (x11-1) times
waitLoop:
	sub	x11, x11, 1 // x11--
	cbz	x11, infinite	
	mov	x10, 536870911   
wait:	
	sub	x10, x10, 1 // timer--
	cbz	x10, waitLoop 
	b	wait	

	// Reload return address and fix-up stack pointer
	ldur    lr,[sp, 0]
	add     sp, sp, 16

	// Actually return from main(), with return value 0
	br      lr

    	// For IC220, every function MUST end with a directive like this (tells the debugger where the function ends)
	// In other places, replace 'main' with the actual name of the function in question
 	.size	main, . - main

	// *****************************************
	// FUNCTION DEFINITIONS
	// *****************************************

	// This simple function takes a LED number (0-7), in x0
	// and sets the RGB values for that LED to zero.
	// NOTE: the caller must still call show() in order to see the effects!!
setLEDoff:	
        // Save return address to stack -- needed to return from this function back to caller 
	sub     sp, sp,  16
	stur    lr, [sp, 0]

	// The LED# is already in x0, but set RGB values to zero (x1/x2/x3)
	mov	x1, 0      	// red   value
	mov	x2, 0  		// green value 
	mov	x3, 0		// blue  blue vaue
	bl 	set_pixel  

	// Reload return address and fix-up stack pointer
	ldur    lr, [sp, 0]
	add     sp, sp, 16

	// Actually return 
	br      lr

    	// For IC220, every function MUST end with a directive like this (tells the debugger where the function ends)
 	.size	setLEFoff, . - setLEDoff
	
	
	

	
	
	
