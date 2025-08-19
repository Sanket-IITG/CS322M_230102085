**Vending Machine FSM (Mealy Design)**

This project implements a Vending Machine Finite State Machine (FSM) in Verilog. The vending machine accepts coins of ₹5 and ₹10 denominations to purchase an item worth ₹20.

**🛠 Features**

Accepted coins: 5 or 10 units (coin[1:0])

01 = ₹5

10 = ₹10

00 = Idle (ignored)

11 = Invalid (ignored)

Vend condition: When total ≥ 20, the FSM generates a one-cycle pulse on vend.

Change: If total = 25 (i.e., 20 + 5), the FSM generates a one-cycle pulse on chg5.

Reset: Synchronous, active-high.

FSM Type: Mealy Machine (outputs depend on both state and input).

**⚙ FSM States**

We model the total inserted amount as states:

total_0 → total = 0

total_5 → total = 5

total_10 → total = 10

total_15 → total = 15

**🔍 Why Mealy?**

Mealy FSM generates outputs based on present state + input.

This allows vend and chg5 signals to be triggered immediately in the same cycle when the required total is reached, instead of waiting for a state transition (like in Moore).

This ensures faster response when the target value is hit.
