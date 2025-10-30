// controller.sv
// Combinational instruction decoder for the ID stage.
// Generates control signals for pipeline stages based on the opcode.

module controller(
    input logic [6:0] opcode,
    output logic RegWrite, MemWrite, MemToReg, ALUSrc, Branch, Jump,
    output logic [1:0] ALUOp, ImmSrc, ResultSrc
);

  always_comb begin
    // Initialize all control signals to safe default values
    RegWrite = 0;
    MemWrite = 0;
    MemToReg = 0;
    ALUSrc = 0;
    Branch = 0;
    Jump = 0;
    ALUOp = 2'b00;
    ImmSrc = 2'b00;
    ResultSrc = 2'b00;

    // Decode main opcode
    case (opcode)
      7'b0000011: begin // Load word instruction
        RegWrite = 1;     // Enable writing to register
        ALUSrc = 1;       // ALU input comes from immediate
        MemToReg = 1;     // Data comes from memory
        ResultSrc = 2'b01; 
        ImmSrc = 2'b00; 
        ALUOp = 2'b00;    // ALU performs addition
      end

      7'b0100011: begin // Store word instruction
        MemWrite = 1;     // Enable memory write
        ALUSrc = 1;       // ALU input comes from immediate
        ImmSrc = 2'b01;   // Use S-type immediate
        ALUOp = 2'b00;    // ALU performs addition
      end

      7'b0110011: begin // Standard R-type instructions
        RegWrite = 1;     // Enable register writeback
        ALUSrc = 0;       // ALU operands from registers
        ALUOp = 2'b10;    // ALU operation determined by funct fields
        ImmSrc = 2'b00;   
        ResultSrc = 2'b00; 
      end

      7'b0010011: begin // I-type arithmetic/logical instructions
        RegWrite = 1;     
        ALUSrc = 1;       // Immediate as second operand
        ALUOp = 2'b10;    
        ImmSrc = 2'b00;   
        ResultSrc = 2'b00; 
      end

      7'b1100011: begin // Conditional branch instructions
        Branch = 1;       // Branch signal active
        ALUOp = 2'b01;    // ALU compares operands
        ImmSrc = 2'b10;   // Use B-type immediate
      end

      7'b1101111: begin // JAL (jump and link)
        RegWrite = 1;     
        Jump = 1;         // Activate jump
        ResultSrc = 2'b10; // Write PC+4 to destination register
        ImmSrc = 2'b11;    // Use J-type immediate
      end

      7'b1100111: begin // JALR (jump and link register)
        RegWrite = 1;     
        Jump = 1;         
        ALUSrc = 1;       
        ResultSrc = 2'b10; 
        ImmSrc = 2'b00;    
        ALUOp = 2'b00;     // ALU adds base + offset
      end

      7'b0001011: begin // CUSTOM-0 RVX10 instructions (treated like R-type)
        RegWrite = 1;     
        ALUSrc = 0;       
        ALUOp = 2'b10;    
        ImmSrc = 2'b00;   
      end

      default: ; // Do nothing for unsupported opcodes
    endcase
  end

endmodule
