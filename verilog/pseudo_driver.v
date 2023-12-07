module pseudo_driver;

    wire A, B, Y;

    // Generate the Stimulus 
    nand2_Stim stim(A,B);

    // Test the circuit using the stimulus 
    nand2 n0(A,B,Y);

    initial begin
        // Will print the values out at the bottom of the Simulation
        $monitor ("@ time=%d A=%b, B=%b, Y=%d", $time, A, B, Y);
    end 

endmodule