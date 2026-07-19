module tb_fp_addsub;
    reg  [31:0] a, b;
    reg         sub;
    wire [31:0] result;

    fp_addsub uut(.a(a), .b(b), .sub(sub), .result(result));

    initial begin
        $display("Testing IEEE 754 FP Add/Subtract");

        // Test 1: 1.0 + 1.0 = 2.0
        a = 32'h3F800000; b = 32'h3F800000; sub = 0; #10;
        $display("1.0 + 1.0 = %h (expected 40000000)", result);

        // Test 2: 1.5 + 2.5 = 4.0
        a = 32'h3FC00000; b = 32'h40200000; sub = 0; #10;
        $display("1.5 + 2.5 = %h (expected 40800000)", result);

        // Test 3: 4.0 - 2.0 = 2.0
        a = 32'h40800000; b = 32'h40000000; sub = 1; #10;
        $display("4.0 - 2.0 = %h (expected 40000000)", result);

        // Test 4: 1.0 - 1.0 = 0.0
        a = 32'h3F800000; b = 32'h3F800000; sub = 1; #10;
        $display("1.0 - 1.0 = %h (expected 00000000)", result);

        // Test 5: -1.0 + 2.0 = 1.0
        a = 32'hBF800000; b = 32'h40000000; sub = 0; #10;
        $display("-1.0 + 2.0 = %h (expected 3F800000)", result);

        $finish;
    end
endmodule
