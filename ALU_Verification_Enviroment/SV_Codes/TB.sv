module ALU_Testbench (ALU_IF TIF);
         
         //// Caliing the Mon modport 
          
    //           virtual            ALU_IF.Monitor  MIF ; 
    //           virtual            ALU_IF.TEST     TESTIF ;  


          /////////////// Importing ALU_Environment Package

            import ALU_Environment::*;

          ////////////////// Inst from ENV

                  Environment ENV;
        
        /////////////// inital Block
                initial
                   begin

                     $dumpvars ;
                     $dumpfile("ALU.vcd");

                      //         MIF    = TIF;
                      //         TESTIF = TIF;

                            ENV = new(TIF);     // Pass both modports
                            ENV.Build_ENV();
                            ENV.run();

                            #5000000;                // Run long enough
                
                    $stop;
                 end

endmodule
