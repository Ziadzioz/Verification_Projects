        /////////////// Importing ALL Packages 
                import ALU_PACKAGE::*;

  class Generator;

    /// Mail Box To send the Transaction Data From Generator to driver

       mailbox GEN2DRV;
       
    /////  No of Iterations

    int Iterations = 5000;

    /// Consructor
    
    function new(mailbox GEN2DRV);
             
             this.GEN2DRV = GEN2DRV;   //// for passing this mail to the class one

    endfunction 

          ////////// Task for randomization process

          task  run();

              for (int i = 0; i < Iterations ; i++) 
              
                begin
                         Transction  tr_rand = new();   /// Inst from Tran that will be randomized

                              assert (tr_rand.randomize()) 
                                 else   $error(" Randomization Failed");
                          
                                  ////// For passing the rand verion to driver
                               GEN2DRV.put(tr_rand);
                end           
          endtask 
  endclass 
    

