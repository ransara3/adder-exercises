module adder32_pipelined(
    input         clk,
    input  [31:0] a,
    input  [31:0] b,
    input         cin,
    output [31:0] sum,
    output        cout
);
    // ---- Stage 0: add bits [7:0] ----
    wire [7:0] sum0_w;
    wire       c0_w;
    adder8 s0(.a(a[7:0]), .b(b[7:0]), .cin(cin), .sum(sum0_w), .cout(c0_w));

    reg [7:0]  sum0_r;
    reg        c0_r;
    reg [31:8] a1_r, b1_r;

    always @(posedge clk) begin
        sum0_r <= sum0_w;
        c0_r   <= c0_w;
        a1_r   <= a[31:8];
        b1_r   <= b[31:8];
    end

    // ---- Stage 1: add bits [15:8] ----
    wire [7:0] sum1_w;
    wire       c1_w;
    adder8 s1(.a(a1_r[15:8]), .b(b1_r[15:8]), .cin(c0_r), .sum(sum1_w), .cout(c1_w));

    reg [7:0]   sum0_r2, sum1_r;
    reg         c1_r;
    reg [31:16] a2_r, b2_r;

    always @(posedge clk) begin
        sum0_r2 <= sum0_r;
        sum1_r  <= sum1_w;
        c1_r    <= c1_w;
        a2_r    <= a1_r[31:16];
        b2_r    <= b1_r[31:16];
    end

    // ---- Stage 2: add bits [23:16] ----
    wire [7:0] sum2_w;
    wire       c2_w;
    adder8 s2(.a(a2_r[23:16]), .b(b2_r[23:16]), .cin(c1_r), .sum(sum2_w), .cout(c2_w));

    reg [7:0]   sum0_r3, sum1_r2, sum2_r;
    reg         c2_r;
    reg [31:24] a3_r, b3_r;

    always @(posedge clk) begin
        sum0_r3 <= sum0_r2;
        sum1_r2 <= sum1_r;
        sum2_r  <= sum2_w;
        c2_r    <= c2_w;
        a3_r    <= a2_r[31:24];
        b3_r    <= b2_r[31:24];
    end

    // ---- Stage 3: add bits [31:24] ----
    wire [7:0] sum3_w;
    wire       c3_w;
    adder8 s3(.a(a3_r[31:24]), .b(b3_r[31:24]), .cin(c2_r), .sum(sum3_w), .cout(c3_w));

    reg [31:0] sum_r;
    reg        cout_r;

    always @(posedge clk) begin
        sum_r  <= {sum3_w, sum2_r, sum1_r2, sum0_r3};
        cout_r <= c3_w;
    end

    assign sum  = sum_r;
    assign cout = cout_r;

endmodule
