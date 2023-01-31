//DEFINES
`define RST_COUNT       5'b00000
`define MAX_COUNT       5'b11100
//`define CS_LOW_COUNT    5'b00100
//`define CS_HIGH_COUNT   5'b10100

//Verilog code for continous SPI read of LM07
//
module LM07_read(SYSCLK, RSTN, CS, SCK, SIO, outreg);
  input SYSCLK;		//System clock from the testbench
  input RSTN;		//Active-low reset signal
  input SIO;		//Serial data output from the temp sensor.
  output reg CS;	//Generate the Chip select for temp sensor
  output reg SCK;	//Generate the SPI clock for temp sensor
  output reg [7:0] outreg;	//the 8-bit data is latched for display
  
  reg SYSCLK_HALF;
  reg [4:0] count;
  wire sysclk_gated;
  reg [7:0] shift_reg;
  
  //Latch the shift register at the end of read.
  // [CODE HERE]

  //shift register for the input (SIO)
  // [CODE HERE]
  
  //SPI CLOCK SCK generator
  // [CODE HERE]

  // Chip Select CS generator
  // [CODE HERE]

  //5b Counter
  always @(posedge SYSCLK or negedge RSTN)
    if (~RSTN)
       count <= `RST_COUNT;
    else if (count == `MAX_COUNT)
       count <= `RST_COUNT;
    else
       count <= count + 1'b1;

endmodule
