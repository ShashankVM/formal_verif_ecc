module fpv_top  (input logic [31:0] din_encoder_32,
                 input logic [64:0] din_encoder_64,
                 input logic [5:0] error_pos1_32, error_pos2_32,
                 input logic [6:0] error_pos1_64, error_pos2_64,
                 input logic decoder_en, sed_ded, single_error_inject, double_error_inject);
  rvecc_sva #(32) rvecc_sva_32(.din_encoder(din_encoder_32), .error_pos1(error_pos1_32), .error_pos2(error_pos2_32), 
                               .decoder_en(decoder_en), .sed_ded(sed_ded), .single_error_inject(single_error_inject), .double_error_inject(double_error_inject));
  rvecc_sva #(64) rvecc_sva_64(.din_encoder(din_encoder_64), .error_pos1(error_pos1_64), .error_pos2(error_pos2_64), 
                               .decoder_en(decoder_en), .sed_ded(sed_ded), .single_error_inject(single_error_inject), .double_error_inject(double_error_inject));
endmodule   