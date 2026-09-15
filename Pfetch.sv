module Pfetch (
    input  logic        clk,
    input  logic        reset,
    input  logic [7:0]  pc,
    output logic [7:0]  imem_addr,
    input  logic [15:0] imem_rdata,
    output logic [23:0] fetch_out
);
    assign imem_addr = pc;
    assign fetch_out = {pc, imem_rdata};
endmodule
