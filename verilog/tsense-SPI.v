//DEFINES
`define RST_COUNT       5'b00000
`define MAX_COUNT       5'b11100
`define SPI_IDLE	1'b0
`define SPI_READ	1'b1
`define CS_LOW_COUNT    5'd4
`define CS_HIGH_COUNT   5'd20

//Verilog code for continous SPI read of LM07
//
module LM07_read(SYSCLK, RSTN, CS, SCK, SIO, outreg);
  input SYSCLK;		//System clock from the testbench
  input RSTN;		//Active-low reset signal
  input SIO;		//Serial data output from the temp sensor.
  output CS;	//Generate the Chip select for temp sensor
  output reg SCK;	//Generate the SPI clock for temp sensor
  output [7:0] outreg;	//the 8-bit data is latched for display
  
  reg SYSCLK_HALF;
  reg [4:0] count;
  wire sysclk_gated;
  reg [7:0] shift_reg;
  reg state_spi;
  
  //Latch the shift register at the end of read.
  // [CODE HERE]

  assign outreg = shift_reg;

  //shift register for the input (SIO)
  always @(posedge SCK or negedge RSTN)
    if (~RSTN)
      shift_reg <= 8'h00;
    else begin
      shift_reg[0] <= SIO;
      shift_reg[1] <= shift_reg[0];
      shift_reg[2] <= shift_reg[1];
      shift_reg[3] <= shift_reg[2];
      shift_reg[4] <= shift_reg[3];
      shift_reg[5] <= shift_reg[4];
      shift_reg[6] <= shift_reg[5];
      shift_reg[7] <= shift_reg[6];
    end
  
  //SPI CLOCK SCK generator
  always @(posedge SYSCLK or negedge RSTN)
    if (~RSTN)
      SCK <= 1'b0;
    else if (state_spi == `SPI_IDLE)
      SCK <= 1'b0;
    else
      SCK <= ~SCK;

  assign CS = ~state_spi;

  // Chip Select CS generator
  always @(negedge SYSCLK or negedge RSTN)
    if (~RSTN)
      state_spi <= `SPI_IDLE;
    else if (count == `CS_LOW_COUNT) 
      state_spi <= `SPI_READ;
    else if (count == `CS_HIGH_COUNT) 
      state_spi <= `SPI_IDLE;
       

  //5b Counter
  always @(posedge SYSCLK or negedge RSTN)
    if (~RSTN)
       count <= `RST_COUNT;
    else if (count == `MAX_COUNT)
       count <= `RST_COUNT;
    else
       count <= count + 1'b1;

endmodule
