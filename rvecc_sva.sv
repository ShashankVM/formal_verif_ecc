module rvecc_sva  #(
                    parameter DATA_WIDTH = 32,
                    localparam ECC_WIDTH = (DATA_WIDTH == 32) ? ($clog2(DATA_WIDTH) + 2) : ($clog2(DATA_WIDTH) + 1),
                    localparam CHANNEL_WIDTH = DATA_WIDTH + ECC_WIDTH
                    )(
                      input logic [DATA_WIDTH-1:0] din_encoder,
                      input logic [$clog2(CHANNEL_WIDTH)-1:0] error_pos1, error_pos2,
                      input logic decoder_en, sed_ded, single_error_inject, double_error_inject);

    logic [CHANNEL_WIDTH-1:0] encoded_data, received_data, corrected_data;
    logic single_ecc_error, double_ecc_error;

    logic clk;

    default clocking default_clk @(posedge clk);
    endclocking

    top #(DATA_WIDTH) uut(
                                                    .din_encoder(din_encoder),
                                                    .error_pos1(error_pos1), 
                                                    .error_pos2(error_pos2), 
                                                    .decoder_en(decoder_en),
                                                    .sed_ded(sed_ded),
                                                    .single_error_inject(single_error_inject),
                                                    .double_error_inject(double_error_inject),
                                                    .encoded_data(encoded_data), 
                                                    .received_data(received_data), 
                                                    .corrected_data(corrected_data), 
                                                    .single_ecc_error(single_ecc_error), 
                                                    .double_ecc_error(double_ecc_error));    

    property valid_error_pos(error_pos);
      ((error_pos >= 0) && (error_pos <= (CHANNEL_WIDTH-1)));
    endproperty

    ASSUME_VALID_ERROR_POSITION1:        assume property (valid_error_pos(error_pos1));
    ASSUME_VALID_ERROR_POSITION2:        assume property (valid_error_pos(error_pos2));

    ASSUME_UNIQUE_DOUBLE_ERROR_POSITION: assume property (double_error_inject |-> (error_pos1 != error_pos2));
    ASSUME_SINGLE_OR_DOUBLE_ERROR:       assume property (single_error_inject |-> !double_error_inject);

    ASSERT_SINGLE_ERROR_PRESENT:    assert property (single_error_inject |-> (encoded_data != received_data));
    ASSERT_DOUBLE_ERROR_PRESENT:    assert property (double_error_inject |-> (encoded_data != received_data));
    ASSERT_NO_ERROR_PRESENT:        assert property ((!single_error_inject && !double_error_inject) |-> (encoded_data == received_data));

    ASSERT_DECODER_ENABLE_FALSE:    assert property (!decoder_en |-> !single_ecc_error && !double_ecc_error);

    ASSERT_NO_FALSE_DOUBLE_ERROR_DETECTION:              assert property (!single_error_inject && !double_error_inject && decoder_en |-> !double_ecc_error);
    
    ASSERT_NO_FALSE_SINGLE_ERROR_DETECTION:              assert property (!single_error_inject && !double_error_inject && decoder_en |-> !single_ecc_error);
    
    ASSERT_DOUBLE_ERROR_DETECTION:   assert property (double_error_inject && decoder_en |-> double_ecc_error);

    
    genvar i;
     generate
      if (DATA_WIDTH == 32) begin
        ASSERT_NO_SINGLE_ERROR_CORRECTION_IN_SED_DED:   assert property (sed_ded && decoder_en |-> !single_ecc_error);
        ASSERT_SINGLE_ERROR_CORRECTION_IN_NO_SED_DED:   assert property (!sed_ded && single_error_inject && decoder_en |-> single_ecc_error);
        ASSERT_NO_FALSE_SINGLE_ERROR_DETECTION_SINGLE_ERROR: assert property (!single_error_inject && decoder_en && sed_ded |-> !single_ecc_error);
        // TO DO: check https://github.com/chipsalliance/Cores-VeeR-EL2/issues/521 gets fixed and if the (error_pos1 <= 37) condition can be removed
        ASSERT_SINGLE_ERROR_CORRECTION_IN_SED_DED_DOUBLE_ECC_ERROR:   assert property (sed_ded && single_error_inject && decoder_en |-> double_ecc_error);
        
       for (i = 0; i <= CHANNEL_WIDTH-1; i++) begin : loop_error_pos
          ASSERT_DATA_CORRECTION: assert property ((error_pos1 == i) && !sed_ded && decoder_en && single_error_inject |-> (encoded_data == corrected_data));
        end
       
      end else begin
        ASSERT_SINGLE_ERROR_DETECTION:   assert property (single_error_inject && decoder_en |-> double_ecc_error);
      end    
    endgenerate  
    
    // cover data is zero
    COVER_ALL_0: cover property (encoded_data == 0);

    // cover data is non-zero
    COVER_NON_0: cover property (encoded_data != 0);

    // cover a few error position combinations
    COVER_ERROR_0_POS: cover property (error_pos1 ==  0);
    COVER_ERROR_CHANNEL_WIDTH_POS: cover property (error_pos1 == (CHANNEL_WIDTH-1));

    // cover single error detection and correction
    COVER_SED_DED_ZERO: cover property (sed_ded == 1'b0);

    // cover double error detection
    COVER_SED_DED_ONE: cover property (sed_ded == 1'b1);
    
  endmodule
