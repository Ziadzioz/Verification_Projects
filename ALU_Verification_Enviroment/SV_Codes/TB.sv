module ALU_TB;
         
           import ALU_PACKAGE::*;
                
    // Clock Generation
    bit clk;

        // Instantiate Interface
    ALU_IF vif (.clk(clk));


// Instantiate DUT 
    ALU DUT (
                .clk        (clk),
                .rst        (vif.rst),
                .A          (vif.A),
                .B          (vif.B),
                .opcode     (vif.opcode),
                .serial_in  (vif.serial_in),
                .direction  (vif.direction),
                .red_op_A   (vif.red_op_A),
                .red_op_B   (vif.red_op_B),
                .bypass_A   (vif.bypass_A),
                .bypass_B   (vif.bypass_B),
                .out        (vif.out),
                .leds       (vif.leds)
           );

     // Bind SVA

     ALU_SVA SVA (vif);


    parameter clk_period = 10 ;

    initial begin
        clk = 0;
        forever #(clk_period/2) clk = ~clk;     // 10ns period 
    end
          ////////////////// Inst from ENV

                  Environment ENV = new(vif);
        
        /////////////// inital Block

        initial begin
                   vif.rst = 1;
    #(clk_period) vif.rst = 0;
             end
                initial
                   begin

                     $dumpvars ;
                     $dumpfile("ALU.vcd");
                     
                            ENV.run();

                          
#500000;                // Run long enough
                          
                  ENV.SCB.Score_Board_Report();
                    $stop;
                 end

endmodule
