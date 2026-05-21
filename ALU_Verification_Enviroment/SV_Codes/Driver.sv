package ALU_Driver;

      import ALU_Transction::*;

      class Driver;

           /////// Conecting the driver with the DUT in the TB modport(TEST)
               
               virtual ALU_IF.TEST DIF;

                //// Mail Box for taking the tr_driv_rand from generator

                mailbox #(Transction) GEN2DRV;

                //// Mail Box for taking the tr_driv_rand to Score board (Actual Data)

                mailbox #(Transction) DRV2SCB;

              /// Consructor
    
                function new(mailbox #(Transction) GEN2DRV, virtual ALU_IF.TEST DIF, mailbox #(Transction) DRV2SCB);
                        
                        this.GEN2DRV = GEN2DRV;   //// for passing this mail to the class one
                        this.DIF = DIF;
                        this.DRV2SCB = DRV2SCB;

                endfunction 

        
           ////////// Task for Driving the Randomized tr_drivansction to the Dut
                  
                  task  run();
                    
                    forever 
                       begin
                                         Transction tr_driv = new();       //// for putting the re_rand on it
                                         GEN2DRV.get(tr_driv);

                                       //////////// Passing the Rand_tr_driv to the Dut

                                         @(negedge DIF.cb.clk)
                                           
                                            DIF.cb.rst         <= tr_driv.rst;
                                            DIF.cb.A           <= tr_driv.A;
                                            DIF.cb.B           <= tr_driv.B;
                                            DIF.cb.serial_in   <= tr_driv.serial_in;
                                            DIF.cb.opcode      <= tr_driv.opcode;
                                            DIF.cb.direction   <= tr_driv.direction;
                                            DIF.cb.red_op_A    <= tr_driv.red_op_A;
                                            DIF.cb.red_op_B    <= tr_driv.red_op_B;
                                            DIF.cb.bypass_A    <= tr_driv.bypass_A;
                                            DIF.cb.bypass_B    <= tr_driv.bypass_B;         
                                       
                                       /////////////////  fOR sending the Data to the Score board to compare it with Monitor
                                           
                                           DRV2SCB.put(tr_driv);
 
                        end
                    
                  endtask 

      endclass
    
endpackage
