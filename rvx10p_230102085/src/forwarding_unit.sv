// forwarding_unit.sv
// Determines data forwarding for EX stage to resolve read-after-write (RAW) hazards.
// Checks whether source operands in EX stage need to take values from MEM or WB stages.

module forwarding_unit(
    input logic [4:0] Rs1E, Rs2E,   // Source register numbers from EX stage
    input logic [4:0] RdM, RdW,     // Destination register numbers from MEM and WB stages
    input logic RegWriteM, RegWriteW, // Indicates whether MEM or WB stage will write to the register file
    output logic [1:0] ForwardA, ForwardB // Forwarding control signals for ALU inputs
);

  always_comb begin
    // Default: no forwarding
    ForwardA = 2'b00; 
    ForwardB = 2'b00;

    // Check EX stage source 1
    if (RegWriteM && (RdM != 5'd0) && (RdM == Rs1E)) 
        ForwardA = 2'b01; // Forward from MEM stage
    else if (RegWriteW && (RdW != 5'd0) && (RdW == Rs1E)) 
        ForwardA = 2'b10; // Forward from WB stage

    // Check EX stage source 2
    if (RegWriteM && (RdM != 5'd0) && (RdM == Rs2E)) 
        ForwardB = 2'b01; // Forward from MEM stage
    else if (RegWriteW && (RdW != 5'd0) && (RdW == Rs2E)) 
        ForwardB = 2'b10; // Forward from WB stage
  end

endmodule
