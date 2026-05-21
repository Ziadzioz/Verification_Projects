package ALU_Monitor;
      
      ///////////////////////////// Importing required Packages

    import ALU_Transction ::*;
    import ALU_Coverage ::*;

 //////////////////////////// Monitor Class

    class Monitor;
            
            ////// Conecting the Monitor with the DUT in the Montior modport
               
           
               virtual ALU_IF MONITOR_IF;

            /// Mail Box To send the Transaction Data From Monitor to Score Board
             
               mailbox #(Transction) MON2SCB;

            ////      Defining an Coverage Object to sample the Data 
             
             Coverage cov;
              

             /// Consructor
    
                function new(mailbox #(Transction) MON2SCB, virtual ALU_IF MONITOR_IF);
                        
                        this.MON2SCB = MON2SCB;   //// for passing this mail to the class one
                        this.MONITOR_IF = MONITOR_IF;
                        this.cov = new();

                endfunction 

             ////////////////////////////////// Run Task for Sampling and sending the Data from DUT to SCB and Cov

                   task  run();
                    
                    forever 
                           begin 
                                 
                             Transction tr_mon = new();
                                        
                                        repeat(2) @(posedge MONITOR_IF.clk) ;           /////// Waiting 2 cycles one cause in rtl we sample the input and the output is reg
                                         ///////////////////// Sampling the Inputs

                                            tr_mon.rst         = MONITOR_IF.rst;
                                            tr_mon.serial_in   = MONITOR_IF.serial_in;
                                            tr_mon.opcode      = MONITOR_IF.opcode;
                                            tr_mon.direction   = MONITOR_IF.direction;
                                            tr_mon.red_op_A    = MONITOR_IF.red_op_A;
                                            tr_mon.red_op_B    = MONITOR_IF.red_op_B;
                                            tr_mon.bypass_A    = MONITOR_IF.bypass_A;
                                            tr_mon.bypass_B    = MONITOR_IF.bypass_B;
                                            tr_mon.A           = MONITOR_IF.A;
                                            tr_mon.B           = MONITOR_IF.B;
                                            
                                         ///////////////////// Sampling the Ouputs

                                            tr_mon.out            = MONITOR_IF.out;
                                            tr_mon.leds           = MONITOR_IF.leds;

                                        ////////////   Passing tr_m to score board
                                           
                                           MON2SCB.put(tr_mon);

                                         ////////////   Passing tr_m to Coverage Calss to Sample

                                          cov.Sample_DATA(tr_mon);

                            end
                    
                   endtask          
     
    endclass 
    
endpackage
