`timescale 1ns / 1ps

module lfsr(
    input clk,
    input rst,
    output reg [7:0] lfsr_out
);
always @(posedge clk or posedge rst)
begin
    if(rst)
        lfsr_out <= 8'b10101010;
    else
        lfsr_out <= {lfsr_out[6:0], lfsr_out[7]^lfsr_out[5]};
end
endmodule


// Clock Divider
module clock_divider(
    input clk,
    input rst,
    output reg slow_clk
);
reg [3:0] count;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        count <= 0;
        slow_clk <= 0;
    end
    else
    begin
        count <= count + 1;
        slow_clk <= count[3];
    end
end
endmodule


// Segment Counter
module segment_counter(
    input clk,
    input rst,
    output reg [1:0] segment
);
always @(posedge clk or posedge rst)
begin
    if(rst)
        segment <= 2'b00;
    else
        segment <= segment + 1;
end
endmodule


// Segment Decoder
module segment_decoder(
    input [1:0] segment,
    output reg [3:0] seg_enable
);

always @(*)
begin
    case(segment)
        2'b00: seg_enable = 4'b0001;
        2'b01: seg_enable = 4'b0010;
        2'b10: seg_enable = 4'b0100;
        2'b11: seg_enable = 4'b1000;
        default: seg_enable = 4'b0000;
    endcase
end
endmodule


// Scan Chain
module scan_chain(
    input clk,
    input rst,
    input scan_in,
    input scan_en,
    output scan_out
);

reg [7:0] shift_reg;

always @(posedge clk or posedge rst)
begin
    if(rst)
        shift_reg <= 8'b0;
    else if(scan_en)
        shift_reg <= {shift_reg[6:0], scan_in};
end

assign scan_out = shift_reg[7];

endmodule


// MISR Signature Analyzer
module misr(
    input clk,
    input rst,
    input data_in,
    output reg [7:0] signature
);

always @(posedge clk or posedge rst)
begin
    if(rst)
        signature <= 8'b0;
    else
        signature <= {signature[6:0], data_in ^ signature[7]};
end

endmodule


// Droop Controller
module droop_controller(
    input [3:0] seg_enable,
    output scan_enable
);

assign scan_enable = |seg_enable;

endmodule


// TOP MODULE
module lbist_top(
    input clk,
    input rst,
    output [7:0] signature
);

wire slow_clk;
wire [7:0] pattern;
wire [1:0] segment;
wire [3:0] seg_enable;
wire scan_en;
wire scan_out;

clock_divider cd(
    .clk(clk),
    .rst(rst),
    .slow_clk(slow_clk)
);

lfsr prpg(
    .clk(slow_clk),
    .rst(rst),
    .lfsr_out(pattern)
);

segment_counter sc(
    .clk(slow_clk),
    .rst(rst),
    .segment(segment)
);

segment_decoder sd(
    .segment(segment),
    .seg_enable(seg_enable)
);

droop_controller dc(
    .seg_enable(seg_enable),
    .scan_enable(scan_en)
);

scan_chain chain(
    .clk(slow_clk),
    .rst(rst),
    .scan_in(pattern[0]),
    .scan_en(scan_en),
    .scan_out(scan_out)
);

misr signature_gen(
    .clk(slow_clk),
    .rst(rst),
    .data_in(scan_out),
    .signature(signature)
);

endmodule