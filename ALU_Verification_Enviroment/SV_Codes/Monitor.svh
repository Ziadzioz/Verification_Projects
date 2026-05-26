        /////////////// Importing ALL Packages 

                import ALU_PACKAGE::*;

 //////////////////////////// Monitor Class

    class Monitor;
            
            ////// Conecting the Monitor with the DUT in the Montior modport
               
               virtual ALU_IF vif;

            /// Mail Box To send the Transaction Data From Monitor to Score Board
             
               mailbox MON2SCB;

            ////      Defining an Coverage Object to sample the Data 
             
             Coverage cov;
              
             
             /// Consructor
    
                function new(mailbox MON2SCB, virtual ALU_IF vif);
                        
                        this.MON2SCB = MON2SCB;   //// for passing this mail to the class one
                        this.vif = vif;
                        this.cov = new();

                endfunction 

             ////////////////////////////////// Run Task for Sampling and sending the Data from DUT to SCB and Cov

                   task  run();
                    
                    forever 
                           begin 
                                 
                             Transction tr_mon = new();
                                        
                                   //     repeat(2) 
                                    @(negedge vif.clk) ;           /////// Waiting 2 cycles one cause in rtl we sample the input and the output is reg
                                         ///////////////////// Sampling the Inputs

                                            tr_mon.rst         = vif.rst;
                                            tr_mon.serial_in   = vif.serial_in;
                                            tr_mon.opcode      = vif.opcode;
                                            tr_mon.direction   = vif.direction;
                                            tr_mon.red_op_A    = vif.red_op_A;
                                            tr_mon.red_op_B    = vif.red_op_B;
                                            tr_mon.bypass_A    = vif.bypass_A;
                                            tr_mon.bypass_B    = vif.bypass_B;
                                            tr_mon.A           = vif.A;
                                            tr_mon.B           = vif.B;
                                            
                                         ///////////////////// Sampling the Ouputs
                                           
                                        @(posedge vif.clk) ;
                                            tr_mon.out            = vif.out;
                                            tr_mon.leds           = vif.leds;

                                        ////////////   Passing tr_m to score board
                                           
                                           MON2SCB.put(tr_mon);

                                         ////////////   Passing tr_m to Coverage Calss to Sample

                                          cov.Sample_DATA(tr_mon);

                            end
                    
                   endtask          
     
    endclass 
    

