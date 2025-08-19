**Master–Slave Handshake FSM
📌 Overview**

Implements a 4-phase req/ack handshake between a Master and Slave over an 8-bit data bus. Master sends 4 bytes (A0..A3), Slave latches each, and Master asserts done for 1 cycle at the end.

**🔄 Protocol (per byte)**

Master drives data, raises req.

Slave latches data, asserts ack (2 cycles).

Master sees ack, drops req.

Slave sees req=0, drops ack.

Repeat for 4 bytes → Master pulses done.

**🏗️ FSMs**
**Master**: IDLE → SEND_REQ → WAIT_ACK → DROP_REQ → WAIT_ACK_LOW → (repeat) → DONE.

**Slave**: WAIT_REQ → ASSERT_ACK → HOLD_ACK(2 cycles) → DROP_ACK → WAIT_REQ.

⏱️ Expected Waveform
req:   ____████____████____████____████____
ack:   ________███_____███_____███_____███_
data:  A0   A1   A2   A3
done:  _____________________________█_______

**▶️ How to Run**

Compile with Icarus/ModelSim:

iverilog -o sim tb_link_top.v link_top.v master_fsm.v slave_fsm.v
vvp sim
gtkwave dump.vcd


Observe 4 handshakes and done pulse in GTKWave.

✅ Expected Behavior

Slave latches 4 bytes (A0..A3).

ack held 2 cycles per handshake.

Master asserts done=1 after 4th transfer.
