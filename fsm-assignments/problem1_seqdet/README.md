# Sequence Detector (Mealy FSM)

## Design
This project implements a **Mealy FSM sequence detector** in Verilog.  
The detector looks for the bit-pattern:


- Overlaps are allowed (e.g., input `1101101` will detect two sequences).
- Output `y` goes HIGH (`1`) for **one cycle** when the pattern is recognized.

---

## Testbench
The testbench (`tb_seq_detect_mealy.v`) drives a fixed bitstream into the DUT and logs waveforms using `$dumpfile`/`$dumpvars`.

### Clock
- Frequency: 100 MHz  
- Period: 10 ns  

### Reset
- Held at `0` throughout (FSM is always active).

### Input Bitstream
11011011101

**###Expected Output**
00010010001
Output 1 at the 4th , 7th , 11th clock pulses

