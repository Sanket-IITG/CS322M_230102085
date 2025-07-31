module Comparator(
  input A; // 1 Bit Input
  input B; // 1 Bit Input
  output Y1; // 1 Bit Output
  output Y2; // 1 Bit Output
  output Y3; // 1 Bit Output
); //module instantiation

Y1 = A & ~B;   // Y1 is 1 when A is 1 and B is 0, i.e., A is greater than B
Y2 = ~(A ^ B);   // Y2 is 1 when A and B are equal (bitwise XNOR)
Y3 = ~A & B;   // Y3 is 1 when A is 0 and B is 1, i.e., A is less than B

//end of module
endmodule 
