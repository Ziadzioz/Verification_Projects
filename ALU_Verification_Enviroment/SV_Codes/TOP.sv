
module TOP;

  /////////////// Importing ALL Packages 

                import ALU_PACKAGE::*;
                
    // Clock Generation
    bit clk;

        // Instantiate Interface
    ALU_IF vif (.clk(clk));

    parameter clk_period = 10 ;

    initial begin
        clk = 0;
        forever #(clk_period/2) clk = ~clk;     // 10ns period 
    end

    // Instantiate DUT 
    ALU DUT (
                .clk        (clk),
                .rst        (AIF.rst),
                .A          (AIF.A),
                .B          (AIF.B),
                .opcode     (AIF.opcode),
                .cin        (AIF.cin),
                .serial_in  (AIF.serial_in),
                .direction  (AIF.direction),
                .red_op_A   (AIF.red_op_A),
                .red_op_B   (AIF.red_op_B),
                .bypass_A   (AIF.bypass_A),
                .bypass_B   (AIF.bypass_B),
                .out        (AIF.out),
                .leds       (AIF.leds)
           );



    // Instantiate Testbench
     
      ALU_TB TB  (vif);

    // Bind SVA

       bind ALU ALU_SVA SVA (.*);


endmodule
