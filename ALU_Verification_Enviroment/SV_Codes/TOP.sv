`include "Transction.sv"
`include "Driver.sv"
`include "Enviroment.sv"
`include "Generator.sv"
`include "Monitor.sv"
`include "Score_Board.sv"

module TOP;

import ALU_Transction::*;

    // Clock Generation
    bit clk;

    parameter clk_period = 10 ;

    initial begin
        clk = 0;
        forever #(clk_period/2) clk = ~clk;     // 10ns period 
    end

    // Instantiate Interface
    ALU_IF AIF (clk);

    // Instantiate DUT 
    ALU DUT (
                .clk        (clk),
                .rst        (AIF.DUT.rst),
                .A          (AIF.DUT.A),
                .B          (AIF.DUT.B),
                .opcode     (AIF.DUT.opcode),
                .cin        (AIF.DUT.cin),
                .serial_in  (AIF.DUT.serial_in),
                .direction  (AIF.DUT.direction),
                .red_op_A   (AIF.DUT.red_op_A),
                .red_op_B   (AIF.DUT.red_op_B),
                .bypass_A   (AIF.DUT.bypass_A),
                .bypass_B   (AIF.DUT.bypass_B),
                .out        (AIF.DUT.out),
                .leds       (AIF.DUT.leds)
           );



    // Instantiate Testbench
     
      ALU_Testbench TB  (AIF);

    // Bind SVA

       bind ALU ALU_SVA SVA (.*);


endmodule
