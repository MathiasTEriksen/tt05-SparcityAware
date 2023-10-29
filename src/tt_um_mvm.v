`default_nettype none

module tt_um_mvm #( parameter MAX_COUNT = 24'd10_000_000 ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Declare next_state as a wire
    wire [7:0] next_state;

    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;
    assign uio_out [7:1] = 7'd0;
    // put bottom 8 bits of second counter out on the bidirectional gpio
    assign uio_out = second_counter[7:0];
    
    // Instantiate lif neuron with next_state connected
    mvm mvm_1(.current(ui_in), .next_state(next_state), .spike(uio_out[0]), .clk(clk), .rst_n(rst_n));
    
    // Output next_state to uo_out
    assign uo_out = next_state;

endmodule
