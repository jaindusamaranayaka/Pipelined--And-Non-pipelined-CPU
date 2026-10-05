module Pwriteback (
    input  logic [23:0] buf3_in,
    output logic [3:0]  wb_rd,
    output logic [15:0] wb_data,
    output logic        wb_en,
    output logic [3:0]  wb_opcode
);
    localparam ADD  = 4'd0;
    localparam ADDI = 4'd1;
    localparam SUB  = 4'd2;
    localparam SUBI = 4'd3;
    localparam AND  = 4'd4;
    localparam ANDI = 4'd5;
    localparam OR   = 4'd6;
    localparam ORI  = 4'd7;
    localparam LW   = 4'd8;

    assign wb_rd     = buf3_in[23:20];
    assign wb_data   = buf3_in[19:4];
    assign wb_opcode = buf3_in[3:0];

    assign wb_en = (wb_opcode == ADD)  |
                   (wb_opcode == ADDI) |
                   (wb_opcode == SUB)  |
                   (wb_opcode == SUBI) |
                   (wb_opcode == AND)  |
                   (wb_opcode == ANDI) |
                   (wb_opcode == OR)   |
                   (wb_opcode == ORI)  |
                   (wb_opcode == LW);
endmodule
