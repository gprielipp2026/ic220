	.arch armv8-a
	.text
	.global main
main:
	// prepare the stack, save breadcrumbs to get back
	sub	sp, sp, 16
	stur	lr, [sp, 0]

	// read first digit from stdin
	bl	getchar
	// convert from ascii to numeric, store on the stack
	// (ASCII 0 = 48)
	sub	x9, x0, 48
	stur	x9, [sp, 8]

	// read plus sign from stdin
	bl	getchar

	// read second digit from stdin, store in temporary
	bl	getchar
	sub	x9, x0, 48

	// load first digit and add them
	ldur	x10, [sp, 8]
	add	x9, x9, x10

	// divide by 10 to get tens digit in x11
	movz	x10, 10
	sdiv	x11, x9, x10

	// subtract 10 times quotient to get ones digit in x9
	mul	x12, x11, x10
	sub	x9, x9, x12

	// store ones digit on the stack
	stur	x9, [sp, 8]

	// convert x11 (tens digit) to ascii and print with putchar
	add	x0, x11, 48
	bl putchar

	// load ones digit, convert to ascii and print with putchar
	ldur	x0, [sp, 8]
	add	x0, x0, 48
	bl	putchar

	// print newline (ASCII 10)
	movz	x0, 10
	bl	putchar

	// restore the stack
	ldur	lr, [sp, 0]
	add	sp, sp, 16

	// return 0
	movz	x0, 0
	br	lr



