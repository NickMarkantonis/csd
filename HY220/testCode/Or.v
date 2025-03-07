
module OR(input A,B, output C);
  assign C = A | B;
endmodule // OR

module test_Or;
  reg A,B;
  wire C;
  
  OR uut (.A(A), .B(B), .C(C));
  
  initial begin
    A = 0; B = 0; #10
    $display("A = %b B = %b C = %b",A,B,C);
    
    A = 0; B = 1; #10
    $display("A = %b B = %b C = %b",A,B,C);
    
    A = 1; B = 0; #10
    $display("A = %b B = %b C = %b",A,B,C);
    
    A = 1; B = 1; #10
    $display("A = %b B = %b C = %b",A,B,C);
    
  end
  
endmodule // test_Or


