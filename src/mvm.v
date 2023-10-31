module MVM_Accelerator (
    //input [3:0] spike_train,       // 4-input spike train
    input start,                   // Signal to start MVM
    input clk,                     // Clock
    input rst_n,                     // Reset
    input [1:0] row_val,            // CSR row pointers for 4x4 matrix
    input [7:0] value,              // CSR values for 4x4 matrix (assuming max 16 non-zero values)
    input [1:0] column_val,         // CSR column indices for 4x4 matrix (assuming max 16 non-zero values)
    input sending_CPU,
    input done_list,

    output reg [7:0] output_val,               // Resultant output after MVM
    output reg sending_out,
    output reg FETCH_ready
);

reg [1:0] row_pointers[15:0];      // CSR row pointers for 4x4 matrix
reg [7:0] values[15:0];           // CSR values for 4x4 matrix (assuming max 16 non-zero values)
reg [1:0] column_indices[15:0];   // CSR column indices for 4x4 matrix (assuming max 16 non-zero values)
reg [7:0] result[3:0];       // Resultant output after MVM
reg [3:0] spike_train = 4'b0000;       // 4-input spike train

parameter [2:0] IDLE        = 3'b000,
                TRANSMIT    = 3'b001,
                COMPUTE     = 3'b010,
                FETCH_CSR   = 3'b011,
                FETCH_TRAIN = 3'b100;

reg [1:0] state = IDLE;
reg [1:0] current_row = 0;  // Current row being processed
reg [3:0] i = 0;
reg [1:0] j = 0;  
  
reg [7:0] interval;

always @(posedge clk or posedge rst_n) begin
    if (rst_n) begin
        state <= IDLE;
        current_row <= 0;
        i <= 0;
        j <= 0;
        spike_train = 4'b0000;
    end else begin
        case (state)

            IDLE: begin
                if (start) begin
                    state <= FETCH_CSR;
                  
                end
            end

            FETCH_CSR: begin
                
                 FETCH_ready <= 1;
                if (sending_CPU) begin
                    FETCH_ready <= 0;
                    row_pointers[i] <= row_val;
                    column_indices[i] <= column_val;
                    values[i] <= value;
                    i <= i+1;                
                end else if (done_list) begin
                     FETCH_ready <= 0;
                    state <= FETCH_TRAIN;
                    i <= 0;
                end   
            end     

            FETCH_TRAIN: begin
                if (sending_CPU) begin
                    spike_train <= value[3:0];
                    FETCH_ready <= 1;
                    state <= COMPUTE;
                end            
            end

            COMPUTE: begin                
                if (row_pointers[i] == current_row) begin
                    interval <= ((spike_train[column_indices[i]])*(values[i])) + interval;
                    i <= i + 1;
                end else if (current_row > 3) begin
                    i <= 0;
                    sending_out <= sending_out ^ 1'b1;
                    state <= TRANSMIT;
                end else begin
                    result[current_row] <= interval;
                    interval <= 0;
                    current_row <= current_row + 1;
                end                                                 
            end

            TRANSMIT: begin               
              output_val <= result[j];
                sending_out <= sending_out^1'b1;
                j <= j+1;

                if (i>3) begin
                    state <= IDLE;  
                    j <= 0; 
               end 
            end 

            default: state <= IDLE;
        endcase
    end
end

endmodule