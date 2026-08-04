# Documentation
https://www.hackster.io/shashank-v-m/formal-verification-of-rvecc-error-correcting-code-hardware-81648f

# Run command: 

`ebmc --z3 --k-induction --bound 1 --systemverilog --top fpv_top fpv_top.sv rvecc_sva.sv top.sv channel_model.sv beh_lib.sv --trace --vcd cover`

# Waveform snapshot
1. Single Error Correction
   <img width="1600" height="852" alt="image" src="https://github.com/user-attachments/assets/cb2566dd-3e9e-41b5-8717-55dfe8606e1b" />
2. Double Error Detection
   <img width="1600" height="825" alt="image" src="https://github.com/user-attachments/assets/14683b72-0d80-4317-b18c-1c49594143ed" />
