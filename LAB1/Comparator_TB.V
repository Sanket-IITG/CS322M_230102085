`timescale 1ns/1ns
`include "comparator.v"

module tb();

  reg a,b; 
  wire greater, equal, lower; 

  Comparator Comparator1(
    .A(a),
    .B(b),
    .Y1(OP1), //Case A is greater than B
    .Y2(OP2), //Case A is equal than B
    .Y3(OP3) //Case A is less than B
  );

  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);

    // Start of simulation
    a = 0; b = 0; //A = 0, B = 0
    #10; //delay of 10 ns

    a = 0; b = 1; //A = 0, B = 1
    #10; //delay of 10 ns

    a = 1; b = 0; //A = 1, B = 0
    #10; //delay of 10 ns

    a = 1; b = 1; //A = 1, B = 1
    #10; //delay of 10 ns

    // End of simulation - display message
    $display("Test is succesfully completed...");
  end

endmodule
