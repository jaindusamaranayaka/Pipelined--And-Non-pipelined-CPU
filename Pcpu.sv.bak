module Pcpu (
    input  logic        clk, reset,
    output logic [7:0]  imem_addr,  dmem_addr,
    input  logic [15:0] imem_rdata, dmem_rdata,
    output logic [15:0] dmem_wdata,
    output logic        dmem_wen
);
    logic [7:0]  pc;
    logic [15:0] regs [16];

    localparam JNZ = 4'd6;

    logic [23:0] fetch_out;
    logic [23:0] buf1_out;
    logic [3:0]  de_opcode, de_rs1, de_rs2, de_rd, de_reg;
    logic [7:0]  de_addr, de_pc;
    logic [23:0] de_bundle;
    logic [23:0] buf2_out;
    logic [23:0] exec_out;
    logic [7:0]  ex_dmem_addr;
    logic [15:0] ex_dmem_wdata;
    logic        ex_dmem_wen;
    logic [3:0]  ex_opcode;
    logic [7:0]  ex_pc;
    logic [23:0] buf3_out;
    logic [3:0]  wb_rd, wb_opcode;
    logic [15:0] wb_data;
    logic        wb_en;

    Pfetch fetch (
        .clk        (clk),
        .reset      (reset),
        .pc         (pc),
        .imem_addr  (imem_addr),
        .imem_rdata (imem_rdata),
        .fetch_out  (fetch_out)
    );

    Pbuffer #(.WIDTH(24)) buffer1 (
        .clk      (clk),
        .reset    (reset),
        .data_in  (fetch_out),
        .data_out (buf1_out)
    );

    Pdecode decode (
        .buf1_in    (buf1_out),
        .decode_out (de_bundle),
        .opcode     (de_opcode),
        .i_rs1      (de_rs1),
        .i_rs2      (de_rs2),
        .i_rd       (de_rd),
        .i_reg      (de_reg),
        .addr       (de_addr),
        .pc_out     (de_pc)
    );

    Pbuffer #(.WIDTH(24)) buffer2 (
        .clk      (clk),
        .reset    (reset),
        .data_in  (de_bundle),
        .data_out (buf2_out)
    );

    Pexecute execute (
        .buf2_in    (buf2_out),
        .rs1_val    (regs[buf2_out[7:4]]),
        .rs2_val    (regs[buf2_out[11:8]]),
        .dmem_rdata (dmem_rdata),
        .dmem_addr  (ex_dmem_addr),
        .dmem_wdata (ex_dmem_wdata),
        .dmem_wen   (ex_dmem_wen),
        .exec_out   (exec_out),
        .opcode_out (ex_opcode),
        .pc_out     (ex_pc)
    );

    assign dmem_addr  = ex_dmem_addr;
    assign dmem_wdata = ex_dmem_wdata;
    assign dmem_wen   = ex_dmem_wen;

    Pbuffer #(.WIDTH(24)) buffer3 (
        .clk      (clk),
        .reset    (reset),
        .data_in  (exec_out),
        .data_out (buf3_out)
    );

    Pwriteback writeback (
        .buf3_in   (buf3_out),
        .wb_rd     (wb_rd),
        .wb_data   (wb_data),
        .wb_en     (wb_en),
        .wb_opcode (wb_opcode)
    );

    always_ff @(posedge clk) begin
        if (reset) begin
            pc <= 8'b0;
            for (int i = 0; i < 16; i++) regs[i] <= '0;
        end else begin
            if ((ex_opcode == JNZ) && (regs[buf2_out[3:0]] != 16'h0))
                pc <= ex_pc;
            else
                pc <= pc + 8'b1;

            if (wb_en)
                regs[wb_rd] <= wb_data;
        end
    end

endmodule
