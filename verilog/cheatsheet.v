  //7-Segment select lines for MSB and LSB
  assign disp[1] = (spi_state == `DISP_WRITE_MSB);
  assign disp[0] = (spi_state == `DISP_WRITE_LSB);

  //2:1 MUX for sending MSB/LSB data to the 7-segment display
  assign bcd_data = (spi_state == `DISP_WRITE_MSB) ? bcd_msb : bcd_lsb ;

  //BCD to 7-segment decoder
  assign dataSeg[7] = (~bcd_data[2] && ~bcd_data[0]) || bcd_data[1] || bcd_data[0] || (bcd_data[2] && bcd_data[0]); //a
  assign dataSeg[6] = ~bcd_data[2] || (~bcd_data[1] && ~bcd_data[0]) || (bcd_data[1] && bcd_data[0]);  //b
  assign dataSeg[5] = ~bcd_data[1] || bcd_data[0] || bcd_data[2]; //c
  assign dataSeg[4] = (~bcd_data[2] && ~bcd_data[0]) || (~bcd_data[2] && bcd_data[1]) || (bcd_data[2] && ~bcd_data[1] && bcd_data[0]) || (bcd_data[1] && ~bcd_data[0]) || bcd_data[3]; //d
  assign dataSeg[3] = (~bcd_data[2] && ~bcd_data[0]) || (bcd_data[1] && ~bcd_data[0]); //e
  assign dataSeg[2] = (~bcd_data[1] && ~bcd_data[0]) || (bcd_data[2] && ~bcd_data[1]) || (bcd_data[2] && ~bcd_data[0]) || bcd_data[3]; //f
  assign dataSeg[1] = (~bcd_data[2] && bcd_data[1]) || (bcd_data[2] && ~bcd_data[1]) || bcd_data[3] || (bcd_data[2] && ~bcd_data[0]); //g
  assign dataSeg[0] = 1'b0; //DP
  
  //Converting 7-bit binary to BCD value
  //BCD(MSB) = Temp./10 approx= Temp(1/16 + 1/32)
  //NOTE: First add then shift by 4 to avoid truncation error.
  assign bcd_msb = (temp_bin + (temp_bin>>1))>>4;
  
  //BCD(LSB) = temp - 10*MSB = temp - (8*MSB + 2*MSB)
  assign bcd_lsb = temp_bin - ((bcd_msb<<3) + (bcd_msb<<1));

