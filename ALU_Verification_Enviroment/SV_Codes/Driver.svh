        /////////////// Importing ALL Packages 

                import ALU_PACKAGE::*;

      class Driver;

           /////// Conecting the driver with the DUT in the TB modport(TEST)
               
               virtual ALU_IF vif;

                //// Mail Box for taking the tr_driv_rand from generator

                mailbox  GEN2DRV;

                //// Mail Box for taking the tr_driv_rand to Score board (Actual Data)

                mailbox  DRV2SCB;

              /// Consructor
    
                function new(mailbox GEN2DRV, virtual ALU_IF vif, mailbox DRV2SCB);
                        
                        this.GEN2DRV = GEN2DRV;   //// for passing this mail to the class one
                        this.vif = vif;
                        this.DRV2SCB = DRV2SCB;

                endfunction 

        
           ////////// Task for Driving the Randomized tr_drivansction to the Dut
                  
                  task  run();
                    
                    forever 
                       begin
                                         Transction tr_driv = new();       //// for putting the re_rand on it
                                         GEN2DRV.get(tr_driv);

                                       //////////// Passing the Rand_tr_driv to the Dut

                                         @(negedge vif.clk)
                                           
                                            vif.rst         <= tr_driv.rst;
                                            vif.A           <= tr_driv.A;
                                            vif.B           <= tr_driv.B;
                                            vif.serial_in   <= tr_driv.serial_in;
                                            vif.opcode      <= tr_driv.opcode;
                                            vif.direction   <= tr_driv.direction;
                                            vif.red_op_A    <= tr_driv.red_op_A;
                                            vif.red_op_B    <= tr_driv.red_op_B;
                                            vif.bypass_A    <= tr_driv.bypass_A;
                                            vif.bypass_B    <= tr_driv.bypass_B;         
                                       
                                       /////////////////  fOR sending the Data to the Score board to compare it with Monitor     
                                           DRV2SCB.put(tr_driv);
 
                        end
                    
                  endtask 

      endclass
    


