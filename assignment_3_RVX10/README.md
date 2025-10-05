# RVX10 — Add 10 New Single-Cycle Instructions to the RV32I Core

**Short:** this project implements the RVX10 extension — 10 single-cycle instructions encoded in the RISC-V `CUSTOM-0` space — by adding decode, ALU logic, and tests to an RV32I single-cycle core. The goal is an end-to-end implementation: RTL changes, encodings document, testplan, and a self-checking testbench that stores `25` to address `100` on success. (See the full assignment specification for details.) :contentReference[oaicite:1]{index=1}

---

## Table of contents

- [Overview](#overview)  
- [Instruction set (summary)](#instruction-set-summary)  
- [Repository layout](#repository-layout)  
- [Prerequisites](#prerequisites)  
- [Build & Run (recommended)](#build--run-recommended)  
- [Encoding examples (worked)](#encoding-examples-worked)  
- [Testing & verification](#testing--verification)  
- [Deliverables](#deliverables)  
- [Checklist & notes](#checklist--notes)  
- [Troubleshooting](#troubleshooting)  
- [License & contact](#license--contact)

---

## Overview

This project extends an RV32I single-cycle core with the **RVX10** instruction set (in the `CUSTOM-0` opcode space). The extension must:

- Use only existing datapath blocks (adder/shifter/comparator/logic) and single-cycle semantics.
- Not add architectural state beyond registers (no new CSRs or flags).
- Add decode logic, ALU operations, and a self-checking test program.
- On successful simulation the testbench should store the value `25` to memory address `100` (the provided harness prints “Simulation succeeded”).

See the assignment spec for the canonical encoding table, operation semantics, and test harness details. :contentReference[oaicite:2]{index=2}

---

## Instruction set (summary)

All RVX10 instructions use the **R-type** shape with `opcode = 0x0B` (`CUSTOM-0`) and are single-cycle ALUtoRD operations:

| Name | Semantics (32-bit) | Type | funct7 | funct3 |
|------|---------------------|------|--------|--------|
| ANDN | `rd = rs1 & ~rs2` | R | `0000000` | `000` |
| ORN  | `rd = rs1 | ~rs2` | R | `0000000` | `001` |
| XNOR | `rd = ~(rs1 ^ rs2)` | R | `0000000` | `010` |
| MIN  | signed min | R | `0000001` | `000` |
| MAX  | signed max | R | `0000001` | `001` |
| MINU | unsigned min | R | `0000001` | `010` |
| MAXU | unsigned max | R | `0000001` | `011` |
| ROL  | rotate left by `rs2[4:0]` | R | `0000010` | `000` |
| ROR  | rotate right by `rs2[4:0]` | R | `0000010` | `001` |
| ABS  | absolute value (rs2 = x0) | R (unary) | `0000011` | `000` |

**Notes:**
- Encode ABS as R-type with `rs2 = x0`. Hardware should ignore `rs2` for `funct7 = 0000011`.
- Define rotate-by-0 to return `rs1` (avoid 32-bit shifts).
- `ABS(INT_MIN)` (`0x80000000`) returns `0x80000000` (two’s complement wrap).
- Writes to `x0` must be ignored.

(Full spec — semantics, sketches, and examples — are in the assignment doc.) :contentReference[oaicite:3]{index=3}

---

## Repository layout (recommended)

