        .data
N:      .word  10
str:    .asciiz "Answer: %d !!\n"
fs_addr:   .space  4
y:      .word  0
f:      .word  0, 1

        .text
DADDI   R29, R0, 0x100  ; increase stack size if necessary
        LD      $a0, N($0)      
JAL     FIB
        SD      $v0, y(R0)      ; save the result to y
J       PRINT
        ;; write recursive function here
FIB:    
        ;; increase stack
        DADDI $9, $9, 24
        DADDI $v0, R0, 0
        ;; save some return address and return value
        SD   $ra, 0($9)
        SD   $v0,  16($9)
        ;; check 0 or 1
        beq     R0, $a0, exit
        DADDI   $s1, R0, 1
        beq     $s1, $a0, addOne  
        ;; calculate fib - 1
        DADDI   $a0, $a0, -1
        SD   $a0, 8($9)
        JAL FIB
        DADDI   $9, $9, -24
        LD      $a0, 8($9)
        LD      $s0, 16($9)
        LD      $ra, 0($9)
        DADD    $v0, $v0, $s0
        SD      $v0, 16($9)
        ;; calculate fib - 2
        DADDI   $a0, $a0, -1
        JAL FIB
        DADDI   $9, $9, -24
        LD      $a0, 8($9)
        LD      $s0, 16($9)
        DADD    $v0, $v0, $s0
        LD      $ra, 0($9)
        JR      $ra

addOne: DADDI   $v0, $0, 1  
        J exit
exit:   JR      $ra

        ;; Print the answer (don't delete this)
PRINT:  DADDI   R1, R0, str
        SW      R1, fs_addr(R0)
        DADDI   R14, R0, fs_addr
        SYSCALL 5
