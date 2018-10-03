;; implement read n by yourself
        .data
N:      .word 10
cnt:    .word 2
str:    .asciiz "Answer: %d !!\n"
fs_addr:   .space  4
y:      .word  0
f:      .word  0, 1

        .text
        ;; my algo get a, b, c then c = a + b; and continue;
        ;; check if n == 1
        LD      $s2, cnt(R0)
        LD      $s5, N(R0)
        DADDI   $s1, R0, 1
        beq     $s5, $s1, exit
        ;; get c which is f[cnt]
loop:   LD      $s2, cnt(R0) ;; 
        DSLL    $s2, $s2, 3  ;; $s2 is pointer for f[cnt]
        DADDI   $t2, R0, 0 ;; $t2 is value for f[cnt]
        ;; get b which is f[cnt-1]
        LD      $s1, cnt(R0) 
        DADDI   $s1, $s1, -1 
        DSLL    $s1, $s1, 3 ;; $s1 is pointer for f[cnt - 1]
        LD      $t1, f($s1) ;; $t1 is pointer for f[cnt - 1]
        ;; get a which is f[cnt-2]
        LD      $s0, cnt(R0)
        DADDI   $s0, $s0, -2
        DSLL    $s0, $s0, 3 ;; $s0 is pointer for f[cnt - 2]
        LD      $t0, f($s0) ;; $t0 is pointer for f[cnt - 2]
        DADD    $t2, $t1, $t0
        SD      $t2, f($s2)
        ;; check cnt == n
        LD      $s2, cnt(R0)
        beq     $s2, $s5, exit
        DADDI   $s2, $s2, 1
        SD      $s2, cnt(R0)
        j loop
exit:   LD      $s2, N(R0)
        DSLL    $s2, $s2, 3
        ;;LD      R2, f($s2)
        SD      R2, y(R0)
        ;; Store your answer in "y" like above.
        
        ;; Print the answer (don't delete this)
        DADDI   R1, R0, str
        SW      R1, fs_addr(R0)
        DADDI   R14, R0, fs_addr
        SYSCALL 5