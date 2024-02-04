
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
strNewline:	
	.string "\n"
strHello:
	.string "Welcome to Simon!"
strWhatRounds:
	.string "Enter a number (max rounds): "
strWhatSeed:
	.string "Enter a number (seed): "
	
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

	// Do some necessary setup for IC220 (includes initializing the LEDs)
	// Note: if running with gdb, you probably want to skip over this function call (use "next")
	bl	setupIC220	

	// Print welcome message
	adr	x0, strHello
	bl	puts
	
	// Set a default for 'maxRounds' and 'seed' (may be over-written below)
	// Note that we store these variables into a safe location (a "saved"/"preseved" register), so they don't get clobbered,
	// but if a function needs these values, we must PASS these values as arguments (in x0, x1, etc.)
	// E.g., functions may NOT access 'maxRounds' by directly looking at x20!!!!!
	mov	x20, 5   // maxRounds = 5
	mov	x19, 1   // seed      = 1

	// ********************************************************************
	//      LEAVE THIS SECTION HERE FOR LATER USE (start of section)
	// ********************************************************************
	// Get game settings from user:  maxRounds and seed.
	// HOWEVER, leave this commented out for now, until the project instructions tell you to change it.
	// For now, just use the value of maxRounds that is already set above (in x20)
	//    and the 'seed' value set above (in x19)
	//
	// Get max rounds from user
	//adr 	x0, strWhatRounds
	//bl	puts
	//bl 	helperGetLong
	//mov	x20, x0       	// x20 = maxRounds	
	// Get random seed from user, use for srand()
	//adr 	x0, strWhatSeed
	//bl	puts
	//bl 	helperGetLong
	//mov	x19, x0         // x19 = seed
	// ********************************************************************
	//      LEAVE THIS SECTION HERE FOR LATER USE (end of section)
	// ********************************************************************

	// Initialize random number generator
	mov 	x0, x19   // set argument = 'seed' (seed value set above)
	bl	srand
	
	// Calling nobufin() changes the terminal so that getchar() will immediately give us
	// the typed character, without waiting for <Enter>
	// We want to do this AFTER possible calls to helperGetLong() above
	bl 	nobufin 

	
	
	// *************************************
	// *************************************
	// *************************************
	// *************************************
	// *************************************
	// *************************************
	// *************************************
	// *************************************
	// *************************************
	//  START YOUR CODE HERE

	
	// *************************************
	// Exit from main()
	// *************************************
Exit:	
	// Reload return address and fix-up stack pointer
	ldur    lr,[sp, 0]
	add     sp, sp, 16

	// Actually return from main(), with return value 0
	br      lr
	
	.size	main,  . - main     // tell gdb where this function ends


	// *****************************************
	// *****************************************
	// *****************************************
	// *****************************************
	// *****************************************
	// *****************************************
	// *****************************************
	// *****************************************
	// *****************************************
	// *****************************************
	// *****************************************
	// FUNCTION DEFINITIONS
	// *****************************************
	// *****************************************
	// *****************************************
	// *****************************************
	// *****************************************
	// *****************************************
	// *****************************************
	// *****************************************
	// *****************************************
	// *****************************************
	// *****************************************
	// *****************************************



	// function:  void setupIC220()
	// *************************************
	// *************************************
	// Some necessary startup steps for IC220 -- don't change these!
setupIC220:
        // Save return address to stack -- needed to return from this function back to caller 
	sub     sp, sp,  16
	stur    lr, [sp, 0]
	
	// 1. Initialize the LEDs (code from in blinkt.c)
	bl	start 
	// 2. Set terminal output (stdout) to *not* buffer, so we can
	// see results right away (important for debugging)
	adrp    x0, :got:stdout
	ldr     x0, [x0, #:got_lo12:stdout]
	ldr     x0, [x0]    // arg0 = stdout
	mov  	x1, 0       // arg1 = NULL
	bl      setbuf      // call setbuf(stdout, NULL)

	// Reload return address and fix-up stack pointer
	ldur    lr, [sp, 0]
	add     sp, sp, 16

	// Actually return 
	br      lr
	.size	setupIC220,  . - setupIC220     // tell gdb where this function ends
	
	// End IC220 setup steps
	// *************************************
	// *************************************


	
	// function: void setLEDoff(long ledNumber)
	// This simple function takes a LED number (0-7), in x0
	// and sets the RGB values for that LED to zero.
	// The caller must still call show() in order to see the effects
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
	.size	setLEDoff,  . - setLEDoff     // tell gdb where this function ends


	


	
