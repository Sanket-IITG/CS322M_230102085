`timescale 1ns/1ps

module tb_link_top;

    reg clk, rst;
    wire done;

    link_top dut(.clk(clk), .rst(rst), .done(done));

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz
    end

    // Reset
    initial begin
        rst = 1;
        #12 rst = 0;
    end

    // Run simulation until done
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_link_top);

        wait(done); // wait until done pulse
        #10 $finish;
    end

    // Monitor internal signals
    initial begin
        $monitor("Time=%0t | req=%b ack=%b data=%h done=%b",
                 $time,
                 dut.u_master.req,
                 dut.u_slave.ack,
                 dut.u_master.data,
                 done);
    end

endmodule
