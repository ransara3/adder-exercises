module adder32_cla(
    input  [31:0] a,
    input  [31:0] b,
    input         cin,
    output [31:0] sum,
    output        cout
);
    wire pg0, gg0, pg1, gg1, pg2, gg2, pg3, gg3;
    wire c0, c1, c2, c3;

    assign c0 = cin;

    // Second-level lookahead: all inter-block carries computed in parallel
    assign c1   = gg0 | (pg0 & c0);
    assign c2   = gg1 | (pg1 & gg0) | (pg1 & pg0 & c0);
    assign c3   = gg2 | (pg2 & gg1) | (pg2 & pg1 & gg0) | (pg2 & pg1 & pg0 & c0);
    assign cout = gg3 | (pg3 & gg2) | (pg3 & pg2 & gg1) |
                  (pg3 & pg2 & pg1 & gg0) | (pg3 & pg2 & pg1 & pg0 & c0);

    cla8 blk0(.a(a[7:0]),   .b(b[7:0]),   .cin(c0), .sum(sum[7:0]),   .cout(), .pg(pg0), .gg(gg0));
    cla8 blk1(.a(a[15:8]),  .b(b[15:8]),  .cin(c1), .sum(sum[15:8]),  .cout(), .pg(pg1), .gg(gg1));
    cla8 blk2(.a(a[23:16]), .b(b[23:16]), .cin(c2), .sum(sum[23:16]), .cout(), .pg(pg2), .gg(gg2));
    cla8 blk3(.a(a[31:24]), .b(b[31:24]), .cin(c3), .sum(sum[31:24]), .cout(), .pg(pg3), .gg(gg3));

endmodule
