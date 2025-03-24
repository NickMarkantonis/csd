module task_example;
    
    // Declare variables
    reg [7:0] a, b, result;

    // Define a task for addition
    task add;
        input [7:0] x, y;
        output [7:0] sum;
        begin
            sum = x + y;
        end
    endtask

    // Initial block to call the task
    initial begin
        a = 8'd10;  // Assign decimal 10 to 'a'
        b = 8'd15;  // Assign decimal 15 to 'b'
        
        // Call the task
        add(a, b, result);
        
        // Display the result
        $display("The sum of %d and %d is %d", a, b, result);
        
        #10 $finish;  // End simulation after 10 time units
    end

endmodule

