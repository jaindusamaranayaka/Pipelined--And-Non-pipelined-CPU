module Pexecute (
    input  logic [27:0] buf2_in,
    input  logic [15:0] rs1_val,
    input  logic [15:0] rs2_val,
    input  logic [15:0] dmem_rdata,
    output logic [7:0]  dmem_addr,
    output logic [15:0] dmem_wdata,
    output logic        dmem_wen,
    output logic [23:0] exec_out,
    output logic [3:0]  function_out,
    output logic [7:0]  pc_out
);
    logic [7:0] pc_in;
    logic [3:0] instruction;
    logic [3:0] function_code;
    logic [3:0] i_rs2, i_rs1, i_rd;

    assign pc_in  = buf2_in[27:20];
    assign instruction = buf2_in[19:16];
    assign function_code = buf2_in[15:12];
    assign i_rs1 = buf2_in[11:8];
    assign i_rs2 = buf2_in[7:4];
    assign i_rd  = buf2_in[3:0];

    assign pc_out     = pc_in;
    assign function_out = function_code;

    localparam ADD  = 4'd0;
    localparam ADDI = 4'd1;
    localparam SUB  = 4'd2;
    localparam SUBI = 4'd3;
    localparam AND  = 4'd4;
    localparam ANDI = 4'd5;
    localparam OR   = 4'd6;
    localparam ORI  = 4'd7;
    localparam LW   = 4'd8;
    localparam SW   = 4'd9;
    localparam BEQ  = 4'd10;
    localparam BNQ  = 4'd11;

    assign dmem_addr  = rs2_val[7:0];
    assign dmem_wdata = rs1_val;
    assign dmem_wen   = (function_code == SW);

    logic [15:0] result;
    always_comb begin
        case (function_code)
            ADD:     result = rs1_val + rs2_val;
            ADDI:    result = rs1_val + {{12{buf2_in[3]}}, buf2_in[3:0]};
            SUB:     result = rs1_val - rs2_val;
            SUBI:    result = rs1_val - {{12{buf2_in[3]}}, buf2_in[3:0]};
            AND:     result = rs1_val & rs2_val;
            ANDI:    result = rs1_val & {{12{buf2_in[3]}}, buf2_in[3:0]};
            OR:      result = rs1_val | rs2_val;
            ORI:     result = rs1_val | {{12{buf2_in[3]}}, buf2_in[3:0]};
            LW:      result = dmem_rdata;
            BEQ, BNQ: result = rs1_val;
            default: result = 16'h0;
        endcase
    end

    assign exec_out = {i_rd, result, function_code};
endmodule
