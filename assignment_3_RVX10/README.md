# ⚙️ RISC-V RVX10 — Single-Cycle Extension (RV32I Custom Instructions)

Welcome! 🎉  
This project extends a **single-cycle RISC-V RV32I CPU** with **10 new custom single-cycle instructions (RVX10)** using the `CUSTOM-0` opcode space.  
It includes source code, a testbench, and a memory image for simulation.

---

## 📁 Files Included

- `riscvsingle.sv` — SystemVerilog source with the **CPU + testbench**.  
  The top testbench module is `testbench`, which instantiates `top` (the CPU).
- `rvx10.hex` — **Instruction memory image** loaded using `$readmemh`.  
  Contains all test programs for the new RVX10 instructions.
- `rvx10.s` — (optional) **Assembly source** for `rvx10.hex` (for reference).
- `Makefile` — simple build and run commands.
- `README.md` — this file 😄

✅ **Simulation passes** when the CPU stores the value **25 (0x19)** to **address 100 (0x64)** — this triggers the message **“Simulation succeeded”** in the console.

---

## 🧠 New RVX10 Instructions

All 10 instructions are **R-type** and use opcode `0x0B` (`CUSTOM-0`):

| Instruction | Description | Operation |
|--------------|--------------|------------|
| ANDN  | Bitwise AND with inverted rs2 | `rd = rs1 & ~rs2` |
| ORN   | Bitwise OR with inverted rs2  | `rd = rs1 | ~rs2` |
| XNOR  | Bitwise XNOR                  | `rd = ~(rs1 ^ rs2)` |
| MIN   | Signed minimum                | `rd = (rs1 < rs2) ? rs1 : rs2` |
| MAX   | Signed maximum                | `rd = (rs1 > rs2) ? rs1 : rs2` |
| MINU  | Unsigned minimum              | `rd = (rs1 <u rs2) ? rs1 : rs2` |
| MAXU  | Unsigned maximum              | `rd = (rs1 >u rs2) ? rs1 : rs2` |
| ROL   | Rotate left                   | `rd = (rs1 << sh) | (rs1 >> (32-sh))` |
| ROR   | Rotate right                  | `rd = (rs1 >> sh) | (rs1 << (32-sh))` |
| ABS   | Absolute value (rs2 ignored)  | `rd = (rs1[31]) ? -rs1 : rs1` |

📝 *All execute in a single cycle and reuse the existing ALU datapath.*

---

## 🧰 Requirements

- **Icarus Verilog** (`iverilog` and `vvp`)
  - Ubuntu / Debian → `sudo apt install iverilog`
  - macOS → `brew install icarus-verilog`
  - Windows → install from official site or MSYS2  
- (Optional) **GTKWave** for waveform viewing → `sudo apt install gtkwave` or `brew install gtkwave`

---

## 📂 Folder Structure



