module tb_adder32_pipelined;
    reg        clk, cin;
    reg [31:0] a, b;
    wire[31:0] sum;
    wire       cout;

    adder32_pipelined uut(.clk(clk), .a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    always #5 clk = ~clk;  // 10ns clock = 100MHz

    initial begin
        clk = 0; cin = 0;
        $display("Testing 32-bit Pipelined Adder");
        $display("Note: output valid after 4 clock cycles (pipeline depth = 4)");

        // Feed pair 1
        a = 32'h00000001; b = 32'h00000001; @(posedge clk);
        // Feed pair 2
        a = 32'hDEADBEEF; b = 32'h12345678; @(posedge clk);
        // Feed pair 3
        a = 32'hFFFFFFFF; b = 32'h00000001; @(posedge clk);
        // Feed pair 4
        a = 32'hAAAAAAAA; b = 32'h55555555; @(posedge clk);

        // Drain the pipeline
        repeat(5) begin
            @(posedge clk); #1;
            $display("sum=%h cout=%b", sum, cout);
        end

        $finish;
    end
endmodule
