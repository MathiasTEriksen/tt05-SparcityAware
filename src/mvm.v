module MVM_Accelerator (
    input [3:0] spike_train,       // 4-input spike train
    input start,                   // Signal to start MVM
    input clk,                     // Clock
    input rst,                     // Reset
    input [1:0] row_val,            // CSR row pointers for 4x4 matrix
    input [7:0] value,              // CSR values for 4x4 matrix (assuming max 16 non-zero values)
    input [1:0] column_val,   // CSR column indices for 4x4 matrix (assuming max 16 non-zero values)
    output reg [7:0],       // Resultant output after MVM
    output reg done
);

parameter [1:0] IDLE    = 2'b00,
                ADD   = 2'b01,
                COMPUTE = 2'b10;

reg [1:0] state = IDLE;
reg [1:0] current_row = 0;  // Current row being processed
reg [3:0] i=0;

reg [7:0] interval;

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
                
                if (row_val == current_row) begin
                    interval <= (spike_train[i]*value) + interval;
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