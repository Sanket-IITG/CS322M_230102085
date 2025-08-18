**Traffic Light Controller (Verilog)
📌 Overview**

This project implements a traffic light controller FSM in Verilog.
The controller manages North-South (NS) and East-West (EW) traffic lights using a Moore finite state machine (FSM).

**The design ensures:**

Mutual exclusivity → Only one road has green/yellow at a time.

Timing sequence → NS and EW lights alternate between green → yellow → red.

Controlled by a 1 Hz tick (1-second pulse) derived from the FPGA clock.

**FSM Logic
States**
**State	      Duration    	NS Lights	        EW Lights**
  S_NS_G	    5 sec        	Green	             Red
  S_NS_Y	    2 sec	        Yellow	           Red
  S_EW_G	    5 sec	        Red	               Green
  S_EW_Y	    2 sec	        Red	               Yellow
  ## 🎬 Expected Behavior

Simulation runs for **30 seconds**.  
The sequence of lights observed on **North-South (NS)** and **East-West (EW)** is:

| Time (sec) | NS Light | EW Light |
|------------|----------|----------|
| 0–4        | 🟢 Green | 🔴 Red   |
| 5–6        | 🟡 Yellow | 🔴 Red   |
| 7–11       | 🔴 Red   | 🟢 Green |
| 12–13      | 🔴 Red   | 🟡 Yellow |
| 14–18      | 🟢 Green | 🔴 Red   |
| 19–20      | 🟡 Yellow | 🔴 Red   |
| 21–25      | 🔴 Red   | 🟢 Green |
| 26–27      | 🔴 Red   | 🟡 Yellow |
| 28–30      | 🟢 Green | 🔴 Red (cycle repeats) |

  
