module tb_adder32_cascade;
    reg  [31:0] a, b;
    reg         cin;
    wire [31:0] sum;
    wire        cout;

    adder32_cascade uut(.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        $display("Testing 32-bit Cascade Adder");
        cin = 0;

        a = 32'h00000001; b = 32'h00000001; #10;
        $display("Test1: %h + %h = %h (cout=%b) expected=00000002", a, b, sum, cout);

        a = 32'h000000FF; b = 32'h00000001; #10;
        $display("Test2: %h + %h = %h (cout=%b) expected=00000100", a, b, sum, cout);

        a = 32'hFFFFFFFF; b = 32'h00000001; #10;
        $display("Test3: %h + %h = %h (cout=%b) expected=00000000 cout=1", a, b, sum, cout);

        a = 32'hDEADBEEF; b = 32'h12345678; #10;
        $display("Test4: %h + %h = %h (cout=%b) expected=F0E21567", a, b, sum, cout);

        a = 32'h00000000; b = 32'h00000000; #10;
        $display("Test5: %h + %h = %h (cout=%b) expected=00000000", a, b, sum, cout);

        $finish;
    end
endmodule
