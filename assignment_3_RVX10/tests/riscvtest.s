############################################################
#  RISC-V TEST PROGRAM
#  -------------------
#  Purpose:
#     To verify correct operation of the single-cycle RISC-V CPU.
#     If the processor executes correctly, it will store the
#     value 25 at memory address 100 (0x64).
#
#  Instructions:
#     Basic arithmetic, logical, branch, and jump operations.
#     Includes extended custom instructions:
#       ANDN, ORN, XNOR, MIN, MAX, MINU, MAXU, ABS, ROL, ROR
#
#  Success Condition:
#     mem[100] = 25  →  "Simulation succeeded"
#
#  Author: Sanket Daduria
############################################################

#------------------------------------------------------------
# INITIALIZATION SECTION
#------------------------------------------------------------
main:   addi x2, x0, 5           # x2 = 5
        addi x3, x0, 12          # x3 = 12
        addi x7, x3, -9          # x7 = 12 - 9 = 3

#------------------------------------------------------------
# BASIC LOGIC OPERATIONS
#------------------------------------------------------------
        or   x4, x7, x2          # x4 = (3 OR 5) = 7
        and  x5, x3, x4          # x5 = (12 AND 7) = 4
        add  x5, x5, x4          # x5 = 4 + 7 = 11

#------------------------------------------------------------
# BRANCH TESTS
#------------------------------------------------------------
        beq  x5, x7, end         # 11 == 3 ? No → continue
        slt  x4, x3, x4          # x4 = (12 < 7) = 0
        beq  x4, x0, around      # x4 == 0 ? Yes → branch to "around"
        addi x5, x0, 0           # (skipped due to branch)

#------------------------------------------------------------
# BRANCH TARGET (AROUND)
#------------------------------------------------------------
around: slt  x4, x7, x2          # x4 = (3 < 5) = 1
        add  x7, x4, x5          # x7 = (1 + 11) = 12
        sub  x7, x7, x2          # x7 = (12 - 5) = 7

#------------------------------------------------------------
# LOAD/STORE TEST
#------------------------------------------------------------
        sw   x7, 84(x3)          # mem[96] = 7   (12 + 84 = 96)
        lw   x2, 96(x0)          # x2 = mem[96] = 7
        add  x9, x2, x5          # x9 = 7 + 11 = 18
        jal  x3, end             # Jump to "end", store next PC (0x44) in x3
        addi x2, x0, 1           # (skipped by jump)

#------------------------------------------------------------
# FUNCTION END (EXECUTED AFTER JUMP)
#------------------------------------------------------------
end:    add  x2, x2, x9          # x2 = 7 + 18 = 25  ✅ Final expected result

#------------------------------------------------------------
# CUSTOM INSTRUCTION TESTS
#------------------------------------------------------------

# --- Setup registers for custom operations ---
        addi x4, x0, 10          # x4 = 10
        addi x8, x0, 20          # x8 = 20
        addi x6, x0, -20         # x6 = -20

# --- Logical extensions ---
        andn x7, x4, x8          # x7 = x4 & (~x8) = 10 & (~20) = 10
        orn  x7, x4, x8          # x7 = x4 | (~x8) = 10 | (~20) = -21
        xnor x7, x4, x8          # x7 = ~(x4 ^ x8) = ~(10 ^ 20) = -31

# --- Min/Max arithmetic ---
        min  x7, x4, x6          # x7 = min(10, -20) = -20
        max  x7, x4, x6          # x7 = max(10, -20) = 10
        minu x7, x4, x6          # x7 = minu(10, -20) = 10  (unsigned)
        maxu x7, x4, x6          # x7 = maxu(10, -20) = -20 (unsigned wrap)

# --- Absolute value test ---
        abs  x7, x7, x0          # x7 = abs(-20) = 20
        addi x1, x0, -128        # x1 = -128
        abs  x1, x1, x0          # x1 = abs(-128) = 128
        abs  x7, x0, x0          # x7 = abs(0) = 0

#------------------------------------------------------------
# ROTATION (ROL / ROR) TESTS
#------------------------------------------------------------
        addi x0, x0, 10          # x0 = 0 (no effect)
        addi x4, x0, 3           # x4 = 3
        addi x6, x0, 16          # x6 = 16
        rol  x1, x6, x4          # Rotate left: (16 << 3) = 128
        ror  x1, x6, x4          # Rotate right: (16 >> 3) = 2
        ror  x1, x6, x0          # Rotate right by 0: result = 16

#------------------------------------------------------------
# EXTREME ROL TESTS (MSB ROTATION)
#------------------------------------------------------------
        addi x4, x0, 31          # x4 = 31
        addi x6, x0, 1           # x6 = 1
        rol  x1, x6, x4          # x1 = 0x80000000 (bit 0 rotated to MSB)
        addi x1, x1, 1           # x1 = 0x80000001
        addi x4, x0, 3           # x4 = 3
        rol  x1, x1, x4          # x1 = 0x0000000C (rotate left by 3)

#------------------------------------------------------------
# FINAL STORE (SUCCESS FLAG)
#------------------------------------------------------------
        sw   x2, 0x20(x3)        # mem[100] = 25 ✅ success indicator

#------------------------------------------------------------
# ENDLESS LOOP TO HALT EXECUTION
#------------------------------------------------------------
done:   beq  x2, x2, done        # Infinite loop (wait for testbench check)
