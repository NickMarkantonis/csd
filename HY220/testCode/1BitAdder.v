
// the adder
module Adder(input A, B, output C);
  assign C = A + B;
endmodule // Adder

// testing
module test_adder;
    reg A, B;
    wire C;

    // Instantiate the Adder module
    Adder uut (.A(A), .B(B), .C(C));

    initial begin
        // Test all combinations of A and B
        A = 0; B = 0; #10;
        $display("A=%b B=%b C=%b", A, B, C);

        A = 0; B = 1; #10;
        $display("A=%b B=%b C=%b", A, B, C);

        A = 1; B = 0; #10;
        $display("A=%b B=%b C=%b", A, B, C);

        A = 1; B = 1; #10;
        $display("A=%b B=%b C=%b", A, B, C);
        
        $finish; // End the simulation
    end
endmodule


