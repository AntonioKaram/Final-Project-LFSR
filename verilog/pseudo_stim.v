module pseudo_stim (
    output reg        clk,
    output reg        start,
    output reg  [7:0] sw_in,
    output reg  [7:0] seq_num
);

    reg [3:0] count;

    always #5 clk <= ~clk;

    always #10 begin
        count <= count + 1;

        case (count)
            4'b0000: begin
                start <= 1;
                seq_num <= 8'b00000001;
                sw_in <= 8'b00000011;
            end

            4'b0001: begin
                start <= 0;
                seq_num <= 8'b00000011;
                sw_in <= 8'b00010001;
            end

            4'b0010: begin
                start <= 1;
                seq_num <= 8'b00010001;
                sw_in <= 8'b00110000;
            end

            4'b0011: begin
                start <= 0;
                seq_num <= 8'b00110000;
                sw_in <= 8'b00100001;
            end

            4'b0100: begin
                $stop;
            end
        endcase
    end

endmodule