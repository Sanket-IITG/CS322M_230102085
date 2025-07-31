module 4BitComp(
  input [3:0] A; //4 Bit
  input [3:0] B; //4 Bit
  output C; // output of 1 bit
); //module instantiation
 
C = (A == B) ? 1 : 0; // Conditional operator: assigns 1 to C if all 3 bits of A are equal to all 3 bits of B; otherwise, assigns 0.

endmodule //end of module
