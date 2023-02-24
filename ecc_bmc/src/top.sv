module top;
  logic [31:0] din_encoder, din_decoder, dout_decoder;
  logic [6:0] ecc_out_encoder, ecc_in_decoder, ecc_out_decoder;
  logic [5:0] error_pos1, error_pos2;
  logic decoder_en, sed_ded, single_ecc_error, double_ecc_error;
  logic [38:0] encoded_data, received_data, corrected_data;

  assign encoded_data = {ecc_out_encoder, din_encoder};
  assign din_decoder = received_data[31:0];
  assign ecc_in_decoder = received_data[38:32];
  assign corrected_data = {ecc_out_decoder, dout_decoder};

  rvecc_encode encoder(.din(din_encoder), .ecc_out(ecc_out_encoder));
  channel_model #(39) channel(.din(encoded_data), .dout(received_data), .*);
  rvecc_decode decoder(.en(decoder_en), .din(din_decoder), .ecc_in(ecc_in_decoder), .dout(dout_decoder), .ecc_out(ecc_out_decoder), .*);

  always_comb begin
    ASSUME_VALID_ERROR_POS1: assume ((error_pos1 <= 38) && (error_pos1 >= 0));
    ASSUME_VALID_ERROR_POS2: assume ((error_pos2 <= 38) && (error_pos2 >= 0) && (error_pos1 != error_pos2));
    ASSUME_DECODER_ENABLE:   assume (decoder_en == 1'b1);
    ASSERT_ERROR_PRESENT:    assert (encoded_data != received_data);

    if (sed_ded == 0) begin
      ASSERT_DATA_RECOVERED: assert (corrected_data == encoded_data);
      ASSERT_SINGLE_ECC:     assert (single_ecc_error == 1'b1);
      ASSERT_NO_DOUBLE_ED:   assert (double_ecc_error == 1'b0);
    end else begin
      ASSERT_DATA_NOT_RECOVERED: assert (corrected_data != encoded_data);
      ASSERT_NO_SINGLE_ECC:      assert (single_ecc_error == 1'b0);
      ASSERT_DOUBLE_ED:          assert (double_ecc_error == 1'b1);
    end

    COVER_ALL_0: cover (encoded_data == 32'h0000);
    COVER_NON_0: cover (encoded_data != 32'h0000);
    COVER_ERROR_0_POS: cover (error_pos1 ==  6'd0);
    COVER_ERROR_38_POS: cover (error_pos1 == 6'd38);
    COVER_ERROR_9_POS: cover (error_pos1 == 6'd9);
    COVER_ERROR_24_POS: cover (error_pos1 == 6'd24);
    COVER_SED_DED_ZERO: cover (sed_ded == 1'b0);
  end

endmodule
