	// This file defines the following functions:
	//    long    helperGetLong();
	//    void    helperPrinLong(long value);
	//
	//    double  helperGetDouble();
	//    void    helperPrintDouble(double value);
	//
	//    long    helperGetChar();

	
	.arch armv8-a

	// Define all necessary strings
	.text	
	.section	.rodata
	.align	3
strNewlineLocal:
	.string "\n"
strFormatLong:
	.string "%li"   // format code for long integer
strFormatDouble:
	.string "%lf"   // format code for double (long float)
strFormatChar:
	.string " %c"   // format code for char.  Extra space is needed here to skip whitespace first


	// Start function definitions
	.text
	.align	2

// Use scanf to read an "long" from stdin, return that in x0
helperGetLong:
	.global	helperGetLong
	// Make space on stack to store (a) return address and (b) scanf result
	sub     sp, sp,  16
	stur    lr, [sp, 0]	

	// Call scanf to get the long
	adr  x0, strFormatLong
	add  x1, sp, 8           // Resulting long will go in location sp+8
	bl scanf                 // call scanf("%li", &myLongOnStack)

	// Get the long from stack, use as return value from this function
	ldur x0, [sp, 8]

	// Reload return address, fixup stack, and return
	ldur    lr, [sp, 0]
	add     sp, sp, 16
	br 	lr
 	.size	helperGetLong, . - helperGetLong    // tell gdb where this function ends


// Use printf to print a "long" (from x0) to stdout
helperPrintLong:
	.global	helperPrintLong
	// Make space on stack to storereturn address
	sub     sp, sp,  16
	stur    lr, [sp, 0]	

	// Make the call to prinf
	mov  x1, x0              // Save value to print (x0) in desired spot
	adr x0, strFormatLong
	bl printf

	// Reload return address, fixup stack, and return
	ldur    lr, [sp, 0]
	add     sp, sp, 16
	br 	lr
 	.size	helperPrintLong, . - helperPrintLong    // tell gdb where this function ends





// Use scanf to read an "double" from stdin, return that in d0
helperGetDouble:
	.global	helperGetDouble
	// Make space on stack to store (a) return address and (b) scanf result
	sub     sp, sp,  16
	stur    lr, [sp, 0]	

	// Call scanf to get the double
	adr x0, strFormatDouble
	add  x1, sp, 8           // Resulting double will go in location sp+8
	bl scanf                 // call scanf("%li", &myDoubleOnStack)

	// Get the double from stack, use as return value from this function
	ldur d0, [sp, 8]

	// Reload return address, fixup stack, and return
	ldur    lr, [sp, 0]
	add     sp, sp, 16
	br 	lr
 	.size	helperGetDouble, . - helperGetDouble    // tell gdb where this function ends


// Use printf to print a "double" (from d0) to stdout
helperPrintDouble:
	.global	helperPrintDouble
	// Make space on stack to storereturn address
	sub     sp, sp,  16
	stur    lr, [sp, 0]	

	// Make the call to printf
	// Note that we do NOT need to move the number (from d0)
	// in this case, b/c the format string pointer goes in x0, the value in d0
	adr x0, strFormatDouble
	bl printf

	// Reload return address, fixup stack, and return
	ldur    lr, [sp, 0]
	add     sp, sp, 16
	br 	lr
 	.size	helperPrintDouble, . - helperPrintDouble    // tell gdb where this function ends


// Use scanf to read a "char" from stdin, return that in x0
// Note that we intentionally skip any whitespace before reading the character
// Result is returned in least significant 8 bits of x0 (other bits set to zero)	
helperGetChar:
	.global	helperGetChar
	// Make space on stack to store (a) return address and (b) scanf result
	sub     sp, sp,  16
	stur    lr, [sp, 0]	

	// Zero out the space for the character to go, since it will only take up 1 byte
	stur    xzr, [sp, 8]
	
	// Call scanf to get the character
	adr  x0, strFormatChar
	add  x1, sp, 8           // Resulting char will go in location sp+8
	bl scanf                 // call scanf("%c", &myCharOnStack)
	
	// Get the char from stack, use as return value from this function
	ldur x0, [sp, 8]
	
	// Reload return address, fixup stack, and return
	ldur    lr, [sp, 0]
	add     sp, sp, 16
	br 	lr
 	.size	helperGetChar, . - helperGetChar    // tell gdb where this function ends

	
	
