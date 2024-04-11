`timescale 1ns / 1ps

module tag_generator #(
    parameter DATA_WIDTH = 32,
    parameter TAG_WIDTH = 8
)(
    input [DATA_WIDTH-1:0] data,
    input [15:0] key,
    output reg [TAG_WIDTH-1:0] tag
);

    // Partitions secret key into seperate fields
    wire [3:0] bf;
    wire [2:0] rls[0:3];
    assign bf = key[15:12];
    assign rls[0] = key[2:0];
    assign rls[1] = key[5:3];
    assign rls[2] = key[8:6];
    assign rls[3] = key[11:9];

    localparam NUM_BLOCK_TAGGERS = DATA_WIDTH / TAG_WIDTH;
    localparam BLOCK_DATA_WIDTH = DATA_WIDTH / NUM_BLOCK_TAGGERS;

    // Partitions data into num_block_taggers equally sized blocks of data
    wire [BLOCK_DATA_WIDTH-1:0] block_data[0:NUM_BLOCK_TAGGERS-1];
    wire [TAG_WIDTH-1:0] block_tag[0:NUM_BLOCK_TAGGERS-1];
    genvar i;
    for (i = 0; i < NUM_BLOCK_TAGGERS; i = i + 1)
        assign block_data[i] = data[(i + 1)*BLOCK_DATA_WIDTH-1:i*BLOCK_DATA_WIDTH];

    // Instantiates the block_tagger modules
    genvar n;
    for (n = 0; n < NUM_BLOCK_TAGGERS; n = n + 1) begin : block_tag_gen
        block_tagger #(TAG_WIDTH) block_tag_gen (
            .block_data(block_data[n]),
            .inv(bf[n]),
            .rls(rls[n]),
            .block_tag(block_tag[n])
        );
    end

    // XORs the block_tags together
    integer m;
    always @* begin
        tag = 0;

        for (m = 0; m < NUM_BLOCK_TAGGERS; m = m + 1)
            tag = tag ^ block_tag[m];
    end

endmodule
