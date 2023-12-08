# Digital Integrated Circuits Final Project

CSE 30342 - Digital Integrated Circuits - University of Notre Dame

Project Name: Cool Ranch

Varun Taneja       | vtaneja@nd.edu

Brendan McGinn     | bmcginn2@nd.edu

Sean Froning       | sfroning@nd.edu

Antonio Karam      | akaram@nd.edu

Our final project is an implementant of a Linear Shift Feedback Register (LSFR) in verilog.

An LSFR acts as a pseudorandom number generator.

inputs:			switches [7:0], seq_num [7:0], start

outputs:		num[7:0], busy

internal variables:	tap0[3:0], tap1[3:0], i[3:0], j[7:0], switch_shift[7:0]


An N-bit linear feedback shift register (LFSR) produces an N-bit pseudo random number. 

The pseudorandom number is a product of the LSFR taps and the starting value stored in the registers. 

For example, in L17, the registers were initialized to 0001 and the taps were on q[3] and q[0].

The verilog emulates as if the inputs were switches on an FGPA board, from SW0 - SW15.
