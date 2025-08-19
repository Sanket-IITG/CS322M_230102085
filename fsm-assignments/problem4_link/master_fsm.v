module master_fsm (
    input  wire       clk,
    input  wire       rst,    // sync reset
    input  wire       ack,
    output reg        req,
    output reg [7:0]  data,
    output reg        done
);

    // States
    parameter IDLE   = 2'b00,
              REQ    = 2'b01,
              WAIT   = 2'b10,
              FINISH = 2'b11;

    reg [1:0] state, next_state;
    reg [1:0] byte_count;   // 4-byte burst counter

    // Sequential state transition
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            byte_count <= 2'b00;
        end else begin
            state <= next_state;
            if (state == WAIT && ack && !req)  // ack seen and req dropped
                byte_count <= byte_count + 1;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        req = 0;
        done = 0;

        case (state)
            IDLE: begin
                next_state = REQ;
            end

            REQ: begin
                req = 1;
                if (ack) next_state = WAIT; // wait for slave
            end

            WAIT: begin
                if (!ack) begin
                    if (byte_count == 2'd3)
                        next_state = FINISH; // 4th byte done
                    else
                        next_state = REQ;    // next byte
                end
            end

            FINISH: begin
                done = 1;
                next_state = IDLE;
            end
        endcase
    end

    // Drive data (simple pattern: A0, A1, A2, A3)
    always @(posedge clk) begin
        if (rst)
            data <= 8'h00;
        else if (state == REQ)
            data <= {6'b1010, byte_count}; // e.g., A0, A1, A2, A3
    end

endmodule
