module Pwriteback (
    input  logic [23:0] buf3_in,
    output logic [3:0]  wb_rd,
    output logic [15:0] wb_data,
    output logic        wb_en,
    output logic [3:0]  wb_opcode
);
    localparam LOAD  = 4'd0;
    localparam STORE = 4'd1;
    localparam MOVE  = 4'd2;
    localparam ADD   = 4'd3;
    localparam SUB   = 4'd4;
    localparam MUL   = 4'd5;
    localparam JNZ   = 4'd6;

    assign wb_rd     = buf3_in[23:20];
    assign wb_data   = buf3_in[19:4];
    assign wb_opcode = buf3_in[3:0];

    assign wb_en = (wb_opcode == LOAD) |
                   (wb_opcode == MOVE) |
                   (wb_opcode == ADD)  |
                   (wb_opcode == SUB)  |
                   (wb_opcode == MUL);
endmodule
