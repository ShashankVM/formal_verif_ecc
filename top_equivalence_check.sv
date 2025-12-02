module top_equivalence_check;
 logic [31:0] din;
 logic [6:0] ecc_out, ecc_out_mutated;
 rvecc_encode encoder(.din(din), .ecc_out(ecc_out));
 rvecc_encode_mutated encoder2(.din(din), .ecc_out(ecc_out_mutated));

 assert property (ecc_out == ecc_out_mutated);

endmodule: top_equivalence_check
