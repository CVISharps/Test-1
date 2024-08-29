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

//`include "SingleDecrementCounter.vh"
//`include "PID.vh"
//`include "../../Custom_Verilog_Headers/Custom_Header_Library.vh"
//`include "Motor_Libraries.vh"


module MotorDriver#(
    parameter C_FREQ  = 100000000
    ) (
input mClk_i,
input reset_i,
input on_off_i,
output reg  [7:0] position_o, //count value
output reg  motor_o,
output setpoint_reached_w); //motor value


parameter HighestPossibleNumber = 50000; // the expected highest possible number (sets counter size)    
parameter FrequencyCount = 4;
parameter MotorSteps = 400-1;

wire  [8:0] motor_out_w;
wire clock_tick_w;
wire freq_tick_w;
//wire reset = ~on_off_i;

wire  [8:0] position;
wire  [8:0] target_frequency_w;
reg [8:0] target_frequency = 10;

wire [8:0] current_error_o;

reg [8:0] min_frequency = 100;
reg [8:0] max_frequency = 0;
reg [8:0] set_frequency = 0;
wire setpoint_reached_w;
wire motor_tick_w;
wire [8:0] current_error;

SingleDecrementCounter f_divide        (mClk_i,reset_i,1'b1,FrequencyCount,clock_tick_w,);

PID pid_controller                      (mClk_i,reset_i,freq_tick_w,min_frequency,set_frequency,target_frequency_w,setpoint_reached_w,current_error_o);

SingleDecrementCounter f_divide_scale   (mClk_i,reset_i,clock_tick_w,target_frequency,freq_tick_w,);
SingleDecrementCounter motor_pos        (mClk_i,reset_i,motor_tick_w,MotorSteps,,motor_out_w);


//assign motor_tick_w = (setpoint_reached_w & ~on_off_i)? 0:freq_tick_w;

assign motor_tick_w = freq_tick_w;
always @(posedge mClk_i) begin


if(on_off_i) set_frequency <= max_frequency;
else set_frequency <= min_frequency;

target_frequency <= target_frequency_w;
motor_o <= motor_out_w[0];
position_o <=motor_out_w[8:1];
end

endmodule
