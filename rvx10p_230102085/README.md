# 🧠 RVX10-P: 5-Stage Pipelined RISC-V Core

A high-efficiency **5-stage pipelined processor** based on the **RISC-V RV32I** instruction set, extended with **RVX10 custom operations** for advanced bitwise and arithmetic performance.

---

## ⚙️ Overview

### 🧩 Processor Architecture
- **5-Stage Pipeline:** `IF → ID → EX → MEM → WB`
- **Instruction Set:** RV32I (32-bit integer base)
- **Register File:** 32 general-purpose registers (`x0–x31`, with `x0` hardwired to zero)
- **Memory Model:** Harvard architecture (separate instruction and data memories)

### ⚡ Hazard Handling
- ✅ **Data forwarding** from MEM/WB to EX stage  
- ✅ **Automatic one-cycle stall** for load-use dependencies  
- ✅ **Store data forwarding** for memory consistency  
- ✅ **Branch prediction:** predict-not-taken (1-cycle penalty)  
- ✅ **Pipeline flush** on taken branches or jumps  

### 🧮 RVX10 Custom ALU Extensions
Implements **10 new instructions** under the **RISC-V CUSTOM-0** opcode:

| Category     | Instructions                |
|---------------|-----------------------------|
| **Bitwise**   | `andn`, `orn`, `xnor`       |
| **Comparison**| `min`, `max`, `minu`, `maxu`|
| **Rotation**  | `rol`, `ror`                |
| **Arithmetic**| `abs`                       |

### 🚀 Performance Metrics
- **Typical CPI:** 1.2 – 1.3  
- **Pipeline Utilization:** 77% – 83%  
- **Target Clock:** ~500 MHz (≈2 ns period)  
- **Peak Throughput:** ~400 MIPS  

---

## 🗂️ Directory Layout


rvx10_P/
├── src/
│ ├── datapath.sv # Main datapath (pipeline structure)
│ ├── riscvpipeline.sv # Top-level integration module
│ ├── controller.sv # Instruction decode and control signals
│ ├── forwarding_unit.sv # Forwarding logic for hazards
│ └── hazard_unit.sv # Load-use hazard detection/stall unit
├── tb/
│ ├── tb_pipeline.sv # Simple testbench
│ └── tb_pipeline_hazard.sv # Extended hazard verification
├── tests/
│ ├── rvx10_pipeline.hex # Functional test program
│ └── rvx10_hazard_test.hex # Intensive hazard validation
├── docs/
│ └── REPORT.md # Full design documentation
└── README.md # This file


**🔧 Setup Guide**
Requirements

Icarus Verilog (iverilog): Verilog simulation

**GTKWave:** Waveform viewer (optional)

**Make:** Automation support (optional)

**Installation – Ubuntu/Debian**
sudo apt update
sudo apt install iverilog gtkwave

**Installation – macOS**
brew install icarus-verilog gtkwave

**▶️ Quick Start**

1. Clone the Repository

git clone https://github.com/yourusername/rvx10_P.git
cd rvx10_P


2. Build the Design

iverilog -g2012 -o pipeline_tb src/*.sv tb/tb_pipeline.sv


3. Run Simulation

vvp pipeline_tb


4. Sample Output

STORE @ 96 = 0x00000000 (t=55000)
WB stage: Writing 5 to x10  t=75000
WB stage: Writing 3 to x11  t=85000
...
RVX10 EX stage: ALU result = 4 -> x5  t=105000
FORWARDING: EX-to-EX detected for x5 at t=120000
...
STORE @ 100 = 0x00000019 (t=325000)
Simulation succeeded
CHECKSUM (x28) = 25 (0x00000019)

========== PIPELINE PERFORMANCE SUMMARY ==========
Total cycles:        30
Instructions retired: 25
Stall cycles:        0
Flush cycles:        0
Average CPI:         1.20
Pipeline efficiency: 83.3%
==================================================

**🧩 Testing**
Basic Functionality

Evaluates base pipeline operation and all RVX10 custom instructions.

iverilog -g2012 -o pipeline_tb src/*.sv tb/tb_pipeline.sv
vvp pipeline_tb


**Program:** tests/rvx10_pipeline.hex

**Expected Results:**

Load-use stalls:    3
Forwarding events:  18
Total stores:       8
Average CPI:        1.35

**📈 Waveform Visualization**

To generate and view simulation waveforms:

iverilog -g2012 -o pipeline_tb src/*.sv tb/tb_pipeline.sv
vvp pipeline_tb -vcd
gtkwave dump.vcd
