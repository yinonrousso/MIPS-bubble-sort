.data
    v: .word 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1 #array v of length 16
.text
    swap:
        sll $t1, $a1, 2
        add $t1, $a0, $t1
        lw $t0, 0($t1)
        lw $t2, 4($t1)
        sw $t2, 0($t1)
        sw $t0, 4($t1)
        jr		$ra					# jump to return address
    
    # taken and slightly modified from Computer Organization and Design, John L. Hennessy
    # Chapter 2.13
    sort:
        addi	$sp, $sp, -20			# allocate space on stack for 5 reg
        sw      $ra, 16($sp)            #save $ra on stack
        sw      $s3, 12($sp)            #save s3 to stack
        sw      $s2, 8($sp)             #save s2
        sw      $s1, 4($sp)             #save s1
        sw      $s0, 0($sp)             #save s0

        move 	$s2, $a0	        	# $s0   = $t1
        move 	$s3, $a1		        # $s3 = $a1
        
        move 	$s0, $zero		    # $s0 = $zero

    for1tst:
        slt     $t0, $s0, $s3       #set on less than, $t0 = 1 if $s1<0(j<0)
        beq		$t0, $zero, exit1	# if $t0 == $zero then exit1
        
        addi    $s1, $s0, -1        #j = i - 1

    for2tst:
        slti    $t0, $s1, 0         #set on less than immideate $t0 = 1 if $s1 < 0 (j<0)
        bne     $t0, $zero, exit2   # go to exit2 if $s1 < 0 (j < 0)
        sll     $t1, $s1, 2         # $t1 = j * 4
        add     $t2, $s2, $t1       # $t2 = $s2 + $s1 = v + (j * 4)
        lw		$t3, 0($t2)		    # $t3 = v[j]
        lw      $t4, 4($t2)         # $t4 = v[j + 1]
        slt     $t0, $t4, $t3       # t0 = 0 if $t4 < $t3
        beq		$t0, $zero, exit2	# if $t0 == $zero then exit2

        move 	$a0, $s2		    # $a0 = $s2, first parameter of swap is v (old $a0)
        move 	$a1, $s1		    # $a1 = $s1, second parameter of swap is j
        jal		swap				# jump to swap and save position to $ra

        addi	$s1, $s1, -1			# $s1 = $s1 + -1
        j		for2tst				# jump to for2tst
        
    exit2:
        addi	$s0, $s0, 1			# $s0 = $s0 + 1, i += 1
        j		for1tst				# jump to for1tst

    exit1:
        lw		$s0, 0($sp)		    # restore $s0 from stack
        lw      $s1, 4($sp)         # restore $s1 from stack
        lw      $s2, 8($sp)         
        lw      $s3, 12($sp)
        lw      $ra, 16($sp)        #restore return address from stack
        addi	$sp, $sp, 20		# $sp = $sp + 20, restore stack pointer
        
        jr		$ra					# jump to $ra

    main:
        la $t0, v
        li $v0, 1

        lw $a0, 0($t0)
        syscall

        lw $a0, 4($t0)
        syscall

        lw $a0, 8($t0)
        syscall

        la $a0, ($t0)           # a0 should hold address of v
        li $a1, 16              # load size of v into a1 (parameter n)

        jal		sort			# jump to sort and save position to $ra

        la $t0, v
        li $v0, 1

        lw $a0, ($t0)
        syscall

        lw $a0, 4($t0)
        syscall

        lw $a0, 8($t0)
        syscall

        li $v0, 10              #exit program
        syscall

