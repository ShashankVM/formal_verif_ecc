module channel_model #(DATA_WIDTH=39) (
 input [DATA_WIDTH-1:0] din,
 input sed_ded,
 input [$clog2(DATA_WIDTH-1)-1:0] error_pos1, error_pos2,
 output logic [DATA_WIDTH-1:0] dout
 );

 always_comb begin
   dout             = din;
   if (sed_ded == 0) begin
     dout[error_pos1] = !din[error_pos1];
   end else begin
     dout[error_pos1] = !din[error_pos1];
     dout[error_pos2] = !din[error_pos2];
   end
 end

endmodule
