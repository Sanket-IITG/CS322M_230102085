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

## 📁 Directory Layout

Put the three files in one folder (example):
```
riscv_single/
├── riscvsingle.sv
├── riscvtest.txt
└── riscvtest.s        (optional)
```



---


 ⚠️ Important: The simulation reads riscvtest.txt using a relative path.
Run the simulator from the folder that contains the file (or edit the path inside riscvsingle.sv).

## 🧰 Build & Run (Terminal)
🐧 Linux / 🍎 macOS
```bash
cd /path/to/riscv_single

# Compile (enable SystemVerilog-2012 support)
iverilog -g2012 -o cpu_tb riscvsingle.sv

# Run
vvp cpu_tb
```

# Compile (enable SystemVerilog-2012 support)
iverilog -g2012 -o cpu_tb riscvsingle.sv

# Run
vvp cpu_tb

## 🪟 Windows (PowerShell or CMD)
```bat
cd C:\path\to\riscv_single
iverilog -g2012 -o cpu_tb riscvsingle.sv
vvp cpu_tb
```


 ✅ Expected console output

Simulation succeeded

## 🧱 Makefile (optional)

You can also use the included Makefile:

```bash
make run        # build + run
make waves      # build + run + open wave.vcd in GTKWave
make clean      # remove generated files
```


If you prefer not to use Make, just run the iverilog/vvp commands shown above.

## 📊 Waveforms (Optional, with GTKWave)

The testbench is set up to dump wave.vcd. To open it:

 after running the simulation:
gtkwave wave.vcd


If you don’t see a VCD file, ensure the following block exists inside `module testbench;` in `riscvsingle.sv`:
```systemverilog
initial begin
  $dumpfile("wave.vcd");
  $dumpvars(0, testbench);
end
```


Rebuild and run again to regenerate the VCD 🔁

## 🧠 Notes for Students

This is a single-cycle RV32I subset implementation aimed at instructional use.

The provided program image exercises ALU ops, load/store, and *branches.

✅ Success criterion: a store of value 25 to memory address 100, which triggers the “Simulation succeeded” message from the testbench.

## 📜 License / Credits

This teaching setup is adapted for course use.
Original single-cycle RISC-V example design is based on standard educational resources for RV32I.



