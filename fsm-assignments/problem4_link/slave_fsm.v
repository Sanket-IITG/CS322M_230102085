module slave_fsm (
    input  wire       clk,
    input  wire       rst,
    input  wire       req,
    input  wire [7:0] data_in,
    output reg        ack,
    output reg [7:0]  last_byte
);

    parameter S_IDLE = 2'b00,
              S_ACK  = 2'b01,
              S_HOLD = 2'b10;

    reg [1:0] state, next_state;
    reg [1:0] ack_count;

    // Sequential logic
    always @(posedge clk) begin
        if (rst) begin
            state <= S_IDLE;
            ack_count <= 2'b00;
        end else begin
            state <= next_state;
            if (state == S_ACK || state == S_HOLD)
                ack_count <= ack_count + 1;
            else
                ack_count <= 0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        ack = 0;

        case (state)
            S_IDLE: begin
                if (req) begin
                    next_state = S_ACK;
                end
            end

            S_ACK: begin
                ack = 1;
                if (ack_count == 2'b01) // hold 2 cycles
                    next_state = S_HOLD;
            end

            S_HOLD: begin
                ack = 1;
                if (!req)
                    next_state = S_IDLE;
            end
        endcase
    end

    // Latch last byte
    always @(posedge clk) begin
        if (req && state == S_IDLE)
            last_byte <= data_in;
    end

endmodule
