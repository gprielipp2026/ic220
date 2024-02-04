
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
strHello:
	.string "Hello!"
strAskNumber:
	.string "Which LED? (0-7)"
strAskRedAmount:
	.string "How much red? (0-255)"
strBye:
	.string "\nGoodbye."
	
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
	
	// Print hello message
	adr	x0, strHello    // put address of strHello string into x0
	bl	puts

	// ask which led (0-7) to get
	// store the value in x20
	adr	x0, strAskNumber // put address of strAskNumber into x0
	bl	puts
	bl	helperGetLong
	mov	x20, x0		// store return of helperGetLong in x20

	// ask how much red (0-255) to display
	// store it in x21
	// make sure it actually is between 0 and 255
numBtwnColorBounds:
	adr	x0, strAskRedAmount // put address of strAskRedAmount into x0
	bl	puts
	bl	helperGetLong
	mov	x21, x0		// store return of helperGetLong into x20 (is the red value)
	subs	xzr, x21, #255	// make sure RED <= 255
	b.GT	numBtwnColorBounds
	subs 	xzr, x21, #0	// make sure RED >= 0
	b.LT	numBtwnColorBounds	

	// set the pixel color
	// set_pixel(ledNumber, redAmount, 0, 255)
	mov	x0, x20		// ledNumber
	mov 	x1, x21		// redAmount
	mov	x2, #0		// 0
	mov	x3, #255	// 255
	bl	set_pixel
	bl	show		// push to pixels

	// waste about .5s
	mov	x18, #3			// makes sure this code runs 2 times
redo:	mov	x19, #2147483647	// loop 2147483647 times
	sub	x18, x18, #1
wasteTime:
	sub	x19, x19, #1	// x19--
	cbnz	x19, wasteTime	// while(x19 > 0)
	cbnz	x18, redo	// do that loop x18(initial)-1  times

	

	// Turn off LEDs 0 and 1 before quitting.  Here, we use a simple
	// helper function, setLEDoff(), instead of calling set_pixel() directly
 	mov	x0, x20		// LED # (stored in x20)
	bl	setLEDoff
	bl	show	 	// Show the updated LED states
	
	// Print farewell message
	adr	x0, strBye
	bl 	puts
	
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
	
	
	

	
	
	
