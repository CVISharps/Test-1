`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2024 03:55:29 PM
// Design Name: 
// Module Name: TestBench
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


module TestBench();
parameter bits = 8;
  // default interfaces (32 bit)
reg         _reset; 
reg         _On_off; 
reg         _sys_clock;            // master clock
reg         _Direction_In;
wire [bits-1:0]        _Position;

Block_Design_wrapper block_dut
     (_Direction_In,
    _Direction_out,
    _LED_Direction,
    _LED_Motor,
    _Led_Position,
    _MotorDrive,
    _On_off,
    _Position,
    _reset,
    _sys_clock);
/*
      (Direction_In,
    Direction_out,
    Inc_dec,
    LED_Direction,
    LED_Motor,
    Led_Position,
    MotorDrive,
    Position,
    reset,
    sys_clock);
  */
// clock
initial begin 
_On_off = 0;
_sys_clock=0;
_Direction_In = 0;
forever #5 _sys_clock=~_sys_clock;
end


// test procedure
initial begin                     
_reset = 1;            
   

#20;
_reset = 0;
//#100;
//inc_dec   = 0; 
//#300;
//inc_dec   = 1; 
#4999999
_On_off = ~_On_off;
end

endmodule
