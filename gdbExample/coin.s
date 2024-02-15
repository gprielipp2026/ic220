        .arch armv8-a




	
        .text
strHeads:
        .string "heads"
strTails:
        .string "tails"

        .align 2
        .global main
main:
        // prepare stack
        sub     sp, sp, 16
        stur    lr, [sp, 0]

        // seed random number generator based on current time
        movz    x0, 0
        bl      time
        bl      srand

        // call coin_flip() five times
        movz    x19, 5
loop0_top:
        bl      coin_flip
        sub     x19, x19, 1
        cbnz    x19, loop0_top

        // restore stack and return
        ldur    lr, [sp, 0]
        add     sp, sp, 16
        br      lr
        .size	main, . - main       // gives extra info about where main() ends to gdb


	// function to call rand() and flip a coin
coin_flip:
        // prepare stack
        sub     sp, sp, 16
        stur    lr, [sp, 0]
        // (no real reason to use saved reg, just want to make debugging interesting)
        stur    x19, [sp, 8]

        // get random number
        bl      rand

        // random number mod 2 by AND'ing with 0x1
        and     x19, x0, 1

        // if/else to print heads or tails
        cbz     x19, coin_tails
        adr     x0, strHeads
        b       coin_end
coin_tails:
        adr     x0, strTails
coin_end:

        // actually print out heads or tails here
        bl      puts

        // restore stack and return
        ldur    x19, [sp, 8]
        add     sp, sp, 16
        br      lr
        .size	coin_flip, . - coin_flip       // gives extra info about where coin_flip() ends to gdb
