module Pexecute (
    input  logic [23:0] buf2_in,
    input  logic [15:0] rs1_val,
    input  logic [15:0] rs2_val,
    input  logic [15:0] dmem_rdata,
    output logic [7:0]  dmem_addr,
    output logic [15:0] dmem_wdata,
    output logic        dmem_wen,
    output logic [23:0] exec_out,
    output logic [3:0]  opcode_out,
    output logic [7:0]  pc_out
);
    logic [7:0] pc_in;
    logic [3:0] opcode;
    logic [3:0] i_rs2, i_rs1, i_rd;

    assign pc_in  = buf2_in[23:16];
    assign opcode = buf2_in[15:12];
    assign i_rs2  = buf2_in[11:8];
    assign i_rs1  = buf2_in[7:4];
    assign i_rd   = buf2_in[3:0];

    assign pc_out     = pc_in;
    assign opcode_out = opcode;

    localparam LOAD  = 4'd0;
    localparam STORE = 4'd1;
    localparam MOVE  = 4'd2;
    localparam ADD   = 4'd3;
    localparam SUB   = 4'd4;
    localparam MUL   = 4'd5;
    localparam JNZ   = 4'd6;

    assign dmem_addr  = rs2_val[7:0];
    assign dmem_wdata = rs1_val;
    assign dmem_wen   = (opcode == STORE);

    logic [15:0] result;
    always_comb begin
        case (opcode)
            LOAD:    result = dmem_rdata;
            MOVE:    result = rs1_val;
            ADD:     result = rs1_val + rs2_val;
            SUB:     result = rs1_val - rs2_val;
            MUL:     result = rs1_val * rs2_val;
            JNZ:     result = rs1_val;
            default: result = 16'h0;
        endcase
    end

    assign exec_out = {i_rd, result, opcode};
endmodule
