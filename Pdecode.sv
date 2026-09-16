module Pdecode (
    input  logic [23:0] buf1_in,
    output logic [27:0] decode_out,
    output logic [3:0]  instruction,
    output logic [3:0]  function_code,
    output logic [3:0]  i_rs1,
    output logic [3:0]  i_rs2,
    output logic [3:0]  i_rd,
    output logic [3:0]  i_reg,
    output logic [7:0]  addr,
    output logic [7:0]  pc_out
);
    logic [15:0] instr;
    logic [7:0]  pc_in;

    assign pc_in  = buf1_in[23:16];
    assign instr  = buf1_in[15:0];
    assign pc_out = pc_in;

    assign instruction  = instr[15:12];
    assign function_code = instr[3:0];
    assign i_rs1        = instr[11:8];
    assign i_rs2        = instr[7:4];
    assign i_rd         = instr[7:4];
    assign i_reg        = instr[7:4];
    assign addr   = instr[15:8];

    assign decode_out = {pc_in, instruction, function_code, i_rs1, i_rs2, i_rd};
endmodule
