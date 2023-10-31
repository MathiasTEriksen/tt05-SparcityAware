`default_nettype none

module tt_um_mvm #( parameter MAX_COUNT = 24'd10_000_000 ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - matrix values
    output wire [7:0] uo_out,   // Dedicated outputs - output vector values
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path -> input, b3 sending_CPU, b4 done_list, b45 col, b67 row 
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path -> b0 FETCH_ready, b1 sending_out
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output), 0b0000 0101
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Declare next_state as wire
    //wire [7:0] next_state;

    // use bidirectionals as outputs
    assign uio_oe = 8'b00000011;
    assign uio_out [7:2] = 6'd0;
    assign uio_in [1:0] = 2'b0;
    // put bottom 8 bits of second counter out on the bidirectional gpio
    // assign uio_out = second_counter[7:0];
    
    // Instantiate lif neuron with next_state connected
    MVM_Accelerator block1( .start(ena),
                            .clk(clk),
                            .rst_n(rst_n),
                            .row_val(uio_in[7:6]),
                            .column_val(uio_in[5:4]),
                            .value(ui_in[7:0]),
                            .sending_CPU(uio_in[3]),
                            .done_list(uio_in[2]),
                            .output_val(uo_out),
                            .sending_out(uio_out[1]),
                            .FETCH_ready(uio_out[0])) ;
    
    // Output next_state to uo_out
    //assign uo_out = next_state;

endmodule
