
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

/*
module mvm (
    input wire [7:0]    current,
    output wire [7:0]   next_state,
    output wire         spike,
    input wire          clk,
    input wire          rst_n   //low to reset
);

    reg [7:0] state, threshold;
    
    // resting potential and threhold

    assign next_state = current + (spike ? 0 : (state >> 1)); // decay rate 0.5
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

*/


module MVM_Accelerator (
    input [3:0] spike_train,       // 4-input spike train
    input start,                   // Signal to start MVM
    input clk,                     // Clock
    input rst,                     // Reset
    input [1:0] row_pointers[15:0],      // CSR row pointers for 4x4 matrix
    input [15:0] values[15:0],           // CSR values for 4x4 matrix (assuming max 16 non-zero values)
    input [1:0] column_indices[15:0],   // CSR column indices for 4x4 matrix (assuming max 16 non-zero values)
    output reg [15:0] result[3:0],       // Resultant output after MVM
    output reg done
);

parameter [1:0] IDLE    = 2'b00,
                ADD   = 2'b01,
                COMPUTE = 2'b10;

reg [1:0] state = IDLE;
reg [1:0] current_row = 0;  // Current row being processed
reg [3:0] i=0;

reg [15:0] interval;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        current_row <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= COMPUTE;
                    done <= 0;
                end
            end

            COMPUTE: begin
                
                if (row_pointers[i] == current_row) begin
                    interval <= ((spike_train[column_indices[i]])*(values[i])) + interval;
                    i <= i + 1;
                end else if (current_row > 3) begin
                    done <= 1;
                    state <= IDLE;
                end else begin
                    result[current_row] <= interval;
                    interval <= 0;
                    current_row <= current_row + 1;
                end                                               
            end

            default: state <= IDLE;
        endcase
    end
end

endmodule