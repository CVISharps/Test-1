`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Canon
// Engineer: Jeff Sharps
// 
// Create Date: 08/06/2024 05:06:42 PM
// Design Name: 
// Module Name: SingleDecrementCounter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: none
// 
// Revision:
// Revision 1.0 released
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module SingleDecrementCounter#(parameter BITS = 32)(
 input mClk_i,                      
 input Rst_i,
 input Enable_i,           
 input [BITS-1:0] Max_Value_i,       
 output reg Carry_Flag_o,
 output Count_o
);

// this strips the sign bit from the counter and puts it on the output
reg signed [BITS:0] count;
wire [BITS-1:0] Count_o;
assign Count_o = count;

reg [BITS:0] max_value;


wire signed [BITS:0] next_count = count - 1;
wire carry_flag_w = next_count[BITS];

wire [2:0] state_w; //{Rst_i,Enable_i,carry_flag_w};

assign state_w[2] = Rst_i;
assign state_w[1] = Enable_i;
assign state_w[0] = carry_flag_w;

initial begin
Carry_Flag_o <=0;
count = 0;
end

integer ii;

always @(posedge mClk_i) begin //: stuff

// casts the bits as 1 or 0 in the event that a X or Z are used
for( ii=0; ii<BITS; ii=ii+1) begin
    if(Max_Value_i[ii]) max_value[ii]<=1;
    else max_value[ii]<=0;
end

case (state_w) //{Rst_i,Enable_i,carry_flag_w};
    3'b011: Carry_Flag_o <= 1;     // set the carry flag high when the count underflows and not reset
    default: Carry_Flag_o <= 0;
endcase

case (state_w) //{Rst_i,Enable_i,carry_flag_w};
    3'b1??: count <= max_value;     // reset counter when reset
    3'b010: count <= next_count;    // next  count when clock enable is high
    3'b011: count <= max_value;     // reset counter when the count underflows 
endcase

end
endmodule