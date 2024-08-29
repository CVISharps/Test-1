`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2024 05:06:42 PM
// Design Name: 
// Module Name: MotorDriver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////
// note D not used yet
module PID #(parameter real P = 0.05,parameter real I = 0.005,parameter real D = 0.0)(
input aclk_i,
input reset_i,
input update_i,
input [Bits-1:0] current_position_i,
input [Bits-1:0] setpoint_i,
output next_position_o,
output setpoint_reached_o,
output current_error
); //motor value
reg setpoint_reached_o = 0;
reg reset = 1;
reg signed [Bits*2-1:0] p_calc = 0;
reg signed [Bits*2-1:0] i_calc = 0;
reg signed [Bits*2-1:0] d_calc = 0;
reg signed [Bits*2-1:0] i_total = 0;
reg signed [Bits*2-1:0] current_error = 0;
reg signed [Bits*2-1:0] last_error = 0;
reg signed [Bits*2-1:0] delta_error = 0;

reg signed [Bits*2-1:0] current_error_o = 1;

reg signed [Bits*2-1:0] clamp_min = 0;
reg signed [Bits*2-1:0] clamp_max = 0;

parameter Bits = 8;
parameter BitShift = 9;
parameter Deadband = 2;

reg [2:0] state = 0;
localparam signed PScaled = $rtoi(P* 2** BitShift); // converts to a real type
localparam signed IScaled = $rtoi(I* 2** BitShift); // converts to a real type
localparam signed DScaled = $rtoi(D* 2** BitShift); // converts to a real type

reg signed [Bits:0] delta =0;
reg signed [Bits:0] next_position_o = 0;
reg signed [Bits:0] current_position =0;
reg signed [Bits:0] setpoint =0;
reg signed [Bits*2-1:0] max_i = 1024;
reg signed [Bits*2-1:0] min_i = -1024;
reg valid = 0;
parameter ExternalFeedback = 0;

wire signed [Bits*2-1:0] delta_w = p_calc + i_total;
wire signed [Bits*2-1:0] new_i = i_calc + i_total;

 always @(posedge aclk_i) begin
 reset <= reset_i;
 if (current_error == 0 && valid) setpoint_reached_o <=1;
 else setpoint_reached_o <=0;
 
 if (state == 'b101) begin 
 if (update_i) state <= 0;
 valid <= 1;
 end else state <= state +1;

 case(state)
 3'b000: begin
 if(valid & !ExternalFeedback)  current_position <= next_position_o[Bits-1:0];
 else current_position <= current_position_i[Bits-1:0];
 
 if(!valid) next_position_o <= current_position_i[Bits-1:0];  // clean up later
 setpoint <= setpoint_i[Bits-1:0];
 
 //i_total <= i_total>> BitShift;
 end
 3'b001: begin
 current_error <= setpoint - current_position;  
 last_error <= current_error;
 //
 end
 3'b010:begin
 
 p_calc <= current_error * PScaled;
 i_calc <= current_error * IScaled;
 delta_error = current_error - last_error;
 
 end
 3'b011:begin
 if (new_i< min_i  ) i_total <= min_i;
 else if( new_i> max_i) i_total <= max_i;
// else if( current_error == 0 ) i_total<=0;  // clear intigral at zero or zero crossing
 else if( current_error <Deadband && current_error > -Deadband ) i_total<=0;  // clear intigral
 
 //else if( current_error == 0 || current_error[Bits-1] != last_error[Bits-1]) i_total<=0;  // clear intigral at zero or zero crossing
 else i_total <= new_i;
 
  d_calc <= delta_error * DScaled;
 end
  3'b100:begin
  delta <=  delta_w>>>BitShift;
 end
  3'b101:begin
    
    next_position_o <=  current_position + delta;
 end
 
 endcase
 end
endmodule
