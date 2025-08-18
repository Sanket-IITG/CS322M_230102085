`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2025 19:37:21
// Design Name: 
// Module Name: seq_detect_mealy_
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// Sequence detector (Mealy) for pattern 1101
// Start state: S0, synchronous active-high reset
module seq_detect_mealy(
    input  wire clk,
    input  wire rst,   // sync active-high reset
    input  wire din,   // serial input bit per clock
    output wire y      // 1-cycle pulse when "1101" is seen
);

    // ---- State encoding (plain Verilog, no typedef/enum) ----
    localparam [1:0]
        S0 = 2'b00,    // no relevant bits yet
        S1 = 2'b01,    // saw '1'
        S2 = 2'b10,    // saw "11"
        S3 = 2'b11;    // saw "110"

    reg [1:0] state, next_state;  // flip-flops for current/next state

    // ---- State register (sequential) ----
    always @(posedge clk) begin
        if (rst)
            state <= S0;          // go to start on reset
        else
            state <= next_state;  // normal state update
    end

    // ---- Next-state logic (combinational) ----
    always @(*) begin
        case (state)
            S0:  next_state = (din) ? S1 : S0;  // 1 ? S1, 0 ? stay
            S1:  next_state = (din) ? S2 : S0;  // 11 ? S2, 10 ? restart
            S2:  next_state = (din) ? S2 : S3;  // 111… stay, 110 ? S3
            S3:  next_state = (din) ? S1 : S0;  // 1101 ? overlap from S1; 1100 ? reset
            default: next_state = S0;           // safety default
        endcase
    end

    // ---- Mealy output (continuous assign keeps y as wire) ----
    // Output goes high exactly when we are in S3 and the current input is 1 ? "1101".
    assign y = (state == S3) & din;

endmodule
