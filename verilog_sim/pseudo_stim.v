module pseudo_stim (
    output reg [7:0] sw_in,
    output reg [7:0] seq_num
);

   parameter delay = 100;
   reg [3:0] count;

   initial begin
      count = 0;
      repeat (4) begin
         case (count)
            4'b0000: begin
                  seq_num <= 8'b00000001;
                  sw_in <= 8'b00000011;
            end

            4'b0001: begin
                  seq_num <= 8'b00000011;
                  sw_in <= 8'b00010001;
            end

            4'b0010: begin
                  seq_num <= 8'b00010001;
                  sw_in <= 8'b00110000;
            end

            4'b0011: begin
                  seq_num <= 8'b00110000;
                  sw_in <= 8'b00100001;
            end

            4'b0100: begin
                  $stop;
            end
         endcase
         #delay count=count+1;
      end
   end

endmodule