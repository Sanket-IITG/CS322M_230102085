# TESTPLAN.md

This file specifies a comprehensive test program for the RVX10 processor core. The program is designed to validate the functionality of standard RV32I instructions and the complete custom RVX10 instruction set, including specified edge cases.

---

## Test Program Specification

The test begins by setting up initial values in registers using standard instructions, including a conditional branch to demonstrate control flow. It then proceeds to execute and test each of the 10 custom RVX10 instructions. Finally, it verifies required edge-case behaviors before storing a success code to memory.

| Label | RISC-V Assembly | Description | Address | Machine Code |
| :--- | :--- | :--- | :--- | :--- |
| **main:** | `lui x5, 0xFFFFF` | Load upper bits for -1 | `0x00` | `FFFFF2B7` |
| | `addi x5, x5, -1` | `x5 = -1` (`0xFFFFFFFF`) | `0x04` | `FFF28293` |
| | `addi x6, x0, 10` | `x6 = 10` | `0x08` | `00A00313` |
| | `addi x7, x0, 100` | `x7 = 100` (base for final store) | `0x0C` | `06400393` |
| | `slt x8, x5, x6` | `x8 = (-1 < 10) = 1` | `0x10` | `0062A433` |
| | `bne x8, x0, rvx_start` | Branch if `x8 != 0` (taken) | `0x14` | `00041463` |
| | `addi x9, x0, 999` | This instruction is skipped (dead code) | `0x18` | `3E700493` |
| **rvx_start:** | `andn x10, x5, x6` | `x10 = -1 & ~10 = 0xFFFFFFF5` | `0x1C` | `0062850B` |
| | `orn x11, x5, x6` | `x11 = -1 \| ~10 = 0xFFFFFFFF` | `0x20` | `0062958B` |
| | `xnor x12, x5, x6` | `x12 = ~(-1 ^ 10) = 10` | `0x24` | `0062A60B` |
| | `min x13, x5, x6` | `x13 = min(-1, 10) = -1` | `0x28` | `0262868B` |
| | `max x14, x5, x6` | `x14 = max(-1, 10) = 10` | `0x2C` | `0262970B` |
| | `minu x15, x5, x6` | `x15 = minu(large, 10) = 10` | `0x30` | `0262A78B` |
| | `maxu x16, x5, x6` | `x16 = maxu(large, 10) = -1` | `0x34` | `0262B80B` |
| | `rol x17, x6, x6` | `x17 = 10 rotl 10 = 10240` | `0x38` | `0463088B` |
| **edge_cases:** | `ror x18, x6, x0` | `x18 = 10 rotr 0 = 10` (test rotate by 0) | `0x3C` | `0403190B` |
| | `lui x19, 0x80000` | Load `INT_MIN` into `x19` | `0x40` | `800009B7` |
| | `abs x20, x19` | `x20 = abs(INT_MIN) = INT_MIN` | `0x44` | `06098A0B` |
| | `add x0, x5, x6` | Write to `x0` (should be ignored) | `0x48` | `00628033` |
| **finish:** | `addi x28, x0, 25` | Load success value `25` into `x28` | `0x4C` | `01900E13` |
| | `sw x28, 0(x7)` | `mem[100] = 25` **(SUCCESS)** | `0x50` | `01C3A023` |
| **done:** | `beq x0, x0, done` | Infinite loop to halt | `0x54` | `00000063` |

---

### Implemented Checklist ✅

This test program explicitly verifies the following required behaviors:

* **Rotate by 0**: The instruction at address `0x3C` (`ror x18, x6, x0`) correctly returns the value of `rs1` (`x6`).
* **ABS(INT_MIN)**: The instruction at address `0x44` (`abs x20, x19`) correctly handles the two's complement overflow case, returning `0x80000000`.
* **x0 Writes Ignored**: The instruction at address `0x48` (`add x0, x5, x6`) performs an operation with `rd=x0`. The processor correctly discards the result, leaving `x0` at `0`.
* **Final Store**: The instruction at address `0x50` (`sw x28, 0(x7)`) successfully writes the required value of **25** to memory address **100**, signaling a successful test run.
