
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
	.string "Enter a number"
strTellNumber:
	.string "Your number, plus 100, is: "
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

	// Set LED 0 to all blue
	// We use this function:
	//    void set_pixel(uint8_t led, uint8_t r, uint8_t g, uint8_t b);
	// [see blinkt.h]
 	mov	x0, 0  		// LED #
	mov	x1, 0  		// red   value
	mov	x2, 0  		// green value 
	mov	x3, 255		// blue  blue vaue
	bl	set_pixel       // call set_pixel
	
	// Set LED 1 to all red and (some) green
 	mov	x0, 1  		// LED #
	mov	x1, 255   	// red   value
	mov	x2, 150		// green value 
	mov	x3, 0		// blue  blue vaue
	bl	set_pixel       // call set_pixel

	// Now actually make the LED changes happen
	// using this function (see blinkt.h):
	//   void show(void);
	bl	show

	// Prompt user to enter long
	adr 	x0, strAskNumber
	bl  	puts
	
	// Now get 'long' from user (goes in x0), then save in safe place (x19)
	// prototype:   long helperGetLong(void);
	bl      helperGetLong
	mov 	x19, x0

	// Print message about the number
	adr 	x0, strTellNumber
	bl 	puts

	// Print that number (from x19), plus 100
	// prototype:   void helperPrintLong(long);
	add	x0, x19, 100
	bl	helperPrintLong

	// Turn off LEDs 0 and 1 before quitting.  Here, we use a simple
	// helper function, setLEDoff(), instead of calling set_pixel() directly
 	mov	x0, 0  		// LED #
	bl	setLEDoff
	mov	x0, 1  		// LED #	
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
	
	
	

	
	
	
