`timescale 1ns / 1ps

module tagger_generator_tb();

    reg [31:0] data;
    reg [15:0] key;
    wire [7:0] tag;
    tag_generator DUT(data, key, tag);

    initial begin
        data = 32'b01000011010011110100110101010000;
        key = 16'b1101110000100001;
    end

endmodule
