module fp_addsub(
    input  [31:0] a,
    input  [31:0] b,
    input         sub,
    output [31:0] result
);
    // Unpack
    wire        sign_a  = a[31];
    wire        sign_b  = sub ? ~b[31] : b[31];
    wire [7:0]  exp_a   = a[30:23];
    wire [7:0]  exp_b   = b[30:23];
    wire [23:0] mant_a  = (exp_a == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] mant_b  = (exp_b == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    // Step 1: Exponent alignment
    wire [7:0]  exp_diff_ab = exp_a - exp_b;
    wire [7:0]  exp_diff_ba = exp_b - exp_a;
    wire        a_larger    = (exp_a > exp_b) || ((exp_a == exp_b) && (mant_a >= mant_b));

    wire [7:0]  common_exp  = a_larger ? exp_a : exp_b;
    wire [26:0] mant_a_sh   = a_larger ? {mant_a, 3'b000} : ({mant_a, 3'b000} >> exp_diff_ba);
    wire [26:0] mant_b_sh   = a_larger ? ({mant_b, 3'b000} >> exp_diff_ab) : {mant_b, 3'b000};

    // Step 2: Add or subtract mantissas
    wire        eff_sub  = sign_a ^ sign_b;
    wire [27:0] mant_sum = eff_sub ? (a_larger ? mant_a_sh - mant_b_sh
                                                : mant_b_sh - mant_a_sh)
                                   : mant_a_sh + mant_b_sh;

    // Result sign
    wire res_sign = a_larger ? sign_a : sign_b;

    // Step 3: Normalize
    reg [27:0] mant_norm;
    reg [7:0]  exp_norm;

    always @(*) begin
        mant_norm = mant_sum;
        exp_norm  = common_exp;

        if (mant_sum[27]) begin
            mant_norm = mant_sum >> 1;
            exp_norm  = common_exp + 1;
        end else begin
            if      (mant_norm[26]) begin mant_norm = mant_sum;        exp_norm = common_exp;      end
            else if (mant_norm[25]) begin mant_norm = mant_sum << 1;   exp_norm = common_exp - 1;  end
            else if (mant_norm[24]) begin mant_norm = mant_sum << 2;   exp_norm = common_exp - 2;  end
            else if (mant_norm[23]) begin mant_norm = mant_sum << 3;   exp_norm = common_exp - 3;  end
            else if (mant_norm[22]) begin mant_norm = mant_sum << 4;   exp_norm = common_exp - 4;  end
            else if (mant_norm[21]) begin mant_norm = mant_sum << 5;   exp_norm = common_exp - 5;  end
            else if (mant_norm[20]) begin mant_norm = mant_sum << 6;   exp_norm = common_exp - 6;  end
            else if (mant_norm[19]) begin mant_norm = mant_sum << 7;   exp_norm = common_exp - 7;  end
            else if (mant_norm[18]) begin mant_norm = mant_sum << 8;   exp_norm = common_exp - 8;  end
            else if (mant_norm[17]) begin mant_norm = mant_sum << 9;   exp_norm = common_exp - 9;  end
            else if (mant_norm[16]) begin mant_norm = mant_sum << 10;  exp_norm = common_exp - 10; end
            else if (mant_norm[15]) begin mant_norm = mant_sum << 11;  exp_norm = common_exp - 11; end
            else if (mant_norm[14]) begin mant_norm = mant_sum << 12;  exp_norm = common_exp - 12; end
            else if (mant_norm[13]) begin mant_norm = mant_sum << 13;  exp_norm = common_exp - 13; end
            else if (mant_norm[12]) begin mant_norm = mant_sum << 14;  exp_norm = common_exp - 14; end
            else if (mant_norm[11]) begin mant_norm = mant_sum << 15;  exp_norm = common_exp - 15; end
            else if (mant_norm[10]) begin mant_norm = mant_sum << 16;  exp_norm = common_exp - 16; end
            else if (mant_norm[9])  begin mant_norm = mant_sum << 17;  exp_norm = common_exp - 17; end
            else if (mant_norm[8])  begin mant_norm = mant_sum << 18;  exp_norm = common_exp - 18; end
            else if (mant_norm[7])  begin mant_norm = mant_sum << 19;  exp_norm = common_exp - 19; end
            else if (mant_norm[6])  begin mant_norm = mant_sum << 20;  exp_norm = common_exp - 20; end
            else if (mant_norm[5])  begin mant_norm = mant_sum << 21;  exp_norm = common_exp - 21; end
            else if (mant_norm[4])  begin mant_norm = mant_sum << 22;  exp_norm = common_exp - 22; end
            else if (mant_norm[3])  begin mant_norm = mant_sum << 23;  exp_norm = common_exp - 23; end
            else                    begin mant_norm = 28'b0;            exp_norm = 8'b0;            end
        end
    end

    // Step 4: Pack result
    wire [22:0] mant_final = mant_norm[25:3];
    wire [7:0]  exp_final  = exp_norm;
    wire        sign_final = res_sign;

    // Step 5: Zero check
    wire result_zero = (mant_sum == 0);

    assign result = result_zero ? 32'b0 : {sign_final, exp_final, mant_final};

endmodule
