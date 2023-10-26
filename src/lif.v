
/*
    U(t+1) = Bu(t)+I

    S(t) -> 1 u(t) > V
         -> 0, otherwise

    I --> (+) --> u(t+1)
           ^    ^
           |   | |<-- CLK
           |    | <-- u(t)
           ----(X)<--- B   

    Comparator for spike

    --> wire
    --> assign (combinational logic)

    -> reg } a <= b
*/

module lif_neuron (
    input wire [7:0]    current,
    output wire [7:0]   next_state,
    output wire         spike,
    input wire          clk,
    input wire          rst_n   //low to reset
);

    reg [7:0] state, threshold;
    
    // resting potential and threhold

    assign next_state = current + (state >> 1); // decay rate 0.5
    assign spike = (state >= threshold);

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 32;
        end else begin
            state <= next_state;
        end
    end
    
endmodule

