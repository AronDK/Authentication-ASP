`timescale 1ns / 1ps

module block_tagger #(
    parameter TAG_WIDTH = 8
)(
    input [TAG_WIDTH-1:0] block_data,
    input inv,
    input [2:0] rls,
    output [TAG_WIDTH-1:0] block_tag
);

    // Flips block_data bits if inv == 1
    wire [TAG_WIDTH-1:0] block_data_bf;
    assign block_data_bf = inv ? ~block_data : block_data;

    // Performs RLS by setting each tag bit to its corresponding data bit + RLS
    wire [3:0] index[TAG_WIDTH-1:0];
    genvar i;
    for (i = 0; i < TAG_WIDTH; i = i + 1) begin
        assign index[i] = i - rls;
        assign block_tag[i] = block_data_bf[index[i][2:0]];
    end

endmodule
