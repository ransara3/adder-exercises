# Adder Exercises — Verilog / Vivado

## Structure

```
Ex2a_Cascade/
    adder8.v                  — 8-bit ripple carry adder
    adder32_cascade.v         — 32-bit cascade adder (4x8-bit)
    tb_adder32_cascade.v      — Testbench

Ex2b_Pipelined/
    adder8.v                  — 8-bit adder (reused)
    adder32_pipelined.v       — 32-bit pipelined adder (4 stages)
    tb_adder32_pipelined.v    — Testbench

Ex3_CLA/
    cla8.v                    — 8-bit carry lookahead adder block
    adder32_cla.v             — 32-bit 2-level CLA adder
    tb_adder32_cla.v          — Testbench

Ex4_FP_AddSub/
    fp_addsub.v               — IEEE 754 single precision FP adder/subtractor
    tb_fp_addsub.v            — Testbench
```

## How to use in Vivado

1. Create a new RTL project in Vivado
2. Add the `.v` design files as Design Sources
3. Add the `tb_*.v` files as Simulation Sources
4. Right-click the testbench → Set as Top → Run Behavioral Simulation
5. Right-click the design module → Set as Top → Run Synthesis → Run Implementation
6. Open Utilization Report and Timing Summary for results

## Exercises

- **Ex2a**: 32-bit cascade adder. Total time for 4 pairs = 4 × critical path delay.
- **Ex2b**: 32-bit pipelined adder. Throughput = 1 result/cycle after 4-cycle latency.
- **Ex3**: 32-bit 2-level CLA adder. Compare critical path and LUT usage vs Ex2a.
- **Ex4**: IEEE 754 single precision FP adder/subtractor. Compare resource and timing vs integer adders.
