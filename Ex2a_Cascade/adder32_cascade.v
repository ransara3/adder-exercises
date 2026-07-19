module adder32_cascade(
    input  [31:0] a,
    input  [31:0] b,
    input         cin,
    output [31:0] sum,
    output        cout
);
    wire c1, c2, c3;

    adder8 s0(.a(a[7:0]),   .b(b[7:0]),   .cin(cin), .sum(sum[7:0]),   .cout(c1));
    adder8 s1(.a(a[15:8]),  .b(b[15:8]),  .cin(c1),  .sum(sum[15:8]),  .cout(c2));
    adder8 s2(.a(a[23:16]), .b(b[23:16]), .cin(c2),  .sum(sum[23:16]), .cout(c3));
    adder8 s3(.a(a[31:24]), .b(b[31:24]), .cin(c3),  .sum(sum[31:24]), .cout(cout));
endmodule
