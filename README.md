# formal_verif_ecc
Formal Verification of Error Correcting Code
---
**Click on the image to view the full image**

Waveform of trace of cover for single error correction for a non-zero encoded input
![Waveform of trace of cover for single error correction for a non-zero encoded input](https://github.com/ShashankVM/formal_verif_ecc/blob/main/ecc_non_zero_encoded.png)
Waveform of trace of cover for single error correction for a zero encoded input
![Waveform of trace of cover for single error correction for a zero encoded input](https://github.com/ShashankVM/formal_verif_ecc/blob/main/ecc_zero_encoded.png)
- Formal Verification of Error Correcting Code, RTL design files copied with attribution from https://github.com/westerndigitalcorporation/swerv_eh1/blob/03f31d2f3ca06ef4bd71c7963aeb1cdee0d0fbc4/design/lib/beh_lib.sv
- **Tools & Technologies:** SystemVerilog, SystemVerilog Assertions, Yosys, Tabby CAD Suite
- **Results:** Verified single error correction and double error detection using both Bounded Model Checking and Full Proof using induction engine. Covers were written and traces viewed in GTKWave.
- **Files:**
   * rvecc_encode.sv: ECC Encoder 
   * rvecc_decode.sv: ECC Decoder
   * channel_model.sv: Channel with error injection functionality
   * top.sv: Top module which instantiates encoder, decoder, channel and contains properties and covers.
   
