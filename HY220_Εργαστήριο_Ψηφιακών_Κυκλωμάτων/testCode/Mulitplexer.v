module And(output C, input A,B);
  assign C = A & B;
endmodule; // And

module Or(output C, input A,B);
  assign C = A | B;
endmodule; // Or

module Not(output B, input A);
  assign B = ~A;
endmodule // Not

module OneBitMultiplexer(output C,input A,B,I);
  wire NotI;
  wire And1, And2;
  wire Or1;
  
  And and1(And1,B,I);
  
  Not not1(NotI,I);
  And and2(And2,A,NotI);
  
  Or or1(Or1, And1, And2);
  assign C = Or1;
endmodule; // OneBitMultiplexer


module test_Mult;
  reg A,B,I;
  wire C;
 
  OneBitMultiplexer uut (.C(C), .A(A), .B(B), .I(I));
  
  initial begin
    A = 1; B = 0;
    I = 0; #10;
    $display("A = %b B = %b I = %b C = %b",A,B,I,C);
    I = 1; #10;
    $display("A = %b B = %b I = %b C = %b",A,B,I,C);
    
    $finish;
  end
endmodule; // test_Mult

