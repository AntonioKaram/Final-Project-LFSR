# LFSR Chip for Google GFMPW-1 Shuttle - Digital Integrated Circuits

CSE 30342 - Digital Integrated Circuits - University of Notre Dame

Project Name: Cool Ranch

Antonio Karam      | akaram@nd.edu

Varun Taneja       | vtaneja@nd.edu

Brendan McGinn     | bmcginn2@nd.edu

Sean Froning       | sfroning@nd.edu


Our final project is an implementant of a Linear Shift Feedback Register (LSFR) in verilog.
An N-bit linear feedback shift register (LFSR) produces an N-bit pseudo random number. The pseudorandom number is a product of the LSFR taps and the starting value stored in the registers. We will be generating an 8-bit pseudo random number. The pseudorandom number is a product of the LSFR taps and the starting value stored in the registers. Taps for the LFSR will be set via the SW input.  SW[0] indicates one of the taps is on bit 0, SW[1] indicates a tap on bit 1 … SW[7] indicates a tap on bit 7. The output for our chip is a 9-bit number. Out[0] will be our busy signal, which indicates that our HLSM is currently running and there is no output. The other 8 bits will be the randomly generated number.

inputs:			switches [7:0], seq_num [7:0], start

outputs:		num[7:0], busy => concatenated into 1 output where out[0] = busy.

internal variables:	tap0[3:0], tap1[3:0], i[3:0], j[7:0], switch_shift[7:0]

Note: This project is OPEN SOURCE.

