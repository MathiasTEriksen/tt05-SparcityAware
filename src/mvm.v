module MVM_Accelerator (
    input start,                    // Signal to start MVM
    input clk,                      // Clock
    input rst_n,                    // Reset
    input [1:0] row_val,            // CSR row pointers for 4x4 matrix
    input [7:0] value,              // CSR values for 4x4 matrix (assuming max 16 non-zero values)
    input [1:0] column_val,         // CSR column indices for 4x4 matrix (assuming max 16 non-zero values)
    input sending_CPU,
    input done_list,

    output reg [7:0] output_val,    // Resultant output after MVM
    output reg sending_out,
    output reg FETCH_ready
);

reg [1:0] row_pointers[8:0];       // CSR row pointers for 4x4 matrix
reg [7:0] values[8:0];             // CSR values for 4x4 matrix (assuming max 16 non-zero values)
reg [1:0] column_indices[8:0];     // CSR column indices for 4x4 matrix (assuming max 16 non-zero values)
reg [7:0] result[2:0];              // Resultant output after MVM
reg [2:0] spike_train = 3'b000;    // 4-input spike train

parameter [2:0] IDLE        = 3'b000,   // states
                TRANSMIT    = 3'b001,   // transmit computed vector
                COMPUTE     = 3'b010,   // compute matrix vectormultiplication
                FETCH_CSR   = 3'b011,   // fetch CSR formatted matrix
                FETCH_TRAIN = 3'b100;   // fetch spiketrain

reg [2:0] state = IDLE;
reg [1:0] current_row = 0;  // Current row being processed
reg [3:0] i = 0;    
reg [1:0] j = 0;            // counters
  
reg [7:0] interval;         // intermediate value for calculation


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;          // reset register values on reset
        current_row <= 0;
        i <= 0;
        j <= 0;
        spike_train <= 3'b000;
    end else begin
        case (state)

            IDLE: begin
                current_row <= 0;
                i <= 0;
                j <= 0;
                spike_train <= 3'b000;
                sending_out <= 1;
                interval <= 0;
                if (start) begin                    // use start(ena) to begin loading data from CPU
                    state <= FETCH_CSR;
                  
                end
            end

            FETCH_CSR: begin
                
                FETCH_ready <= 1;   
                if (done_list) begin         // if done sending CSR matrix (flag from CPU)
                    FETCH_ready <= 0;                   // not ready for spiketrain yet
                    state <= FETCH_TRAIN;               // go to get the spike train
                    i <= 0;                             // reset index counter
                end                         // CPU done loading flag
                else if (sending_CPU) begin                  // if CPU is sending new data
                    FETCH_ready <= 0;                   // not ready for new data
                    row_pointers[i] <= row_val;         // load values in CSR format (row) (col) (value)
                    column_indices[i] <= column_val;    
                    values[i] <= value;
                    i <= i+1;                           // iterate index for arrays
                end  
            end     

            FETCH_TRAIN: begin

                FETCH_ready <= 1;                       // ready for new data
                if (sending_CPU) begin
                    spike_train <= value[3:0];          // load in spike train
                    FETCH_ready <= 1;                   // ready to get data again
                    state <= COMPUTE;                   // compute 
                end            
            end

            COMPUTE: begin                
                if (row_pointers[i] == current_row) begin
                    interval <= ((spike_train[column_indices[i]])*(values[i])) + interval;
                    i <= i + 1;
                end else if (current_row > 2) begin
                    i <= 0;
                    interval <= 0;
                    current_row <= 0;
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

                if (j>2) begin
                    state <= IDLE;  
                    j <= 0; 
               end 
            end 

            default: state <= IDLE;
        endcase
    end
end

endmodule
