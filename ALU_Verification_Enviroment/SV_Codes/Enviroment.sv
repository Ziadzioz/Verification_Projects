package ALU_Environment;


        /////////////// Importing ALL Packages 

import ALU_Transction::*;
import ALU_Generator::*;
import ALU_Driver::*;
import ALU_Monitor::*;
import ALU_Score_Board::*;
import ALU_Coverage::*;

class Environment;

    // Virtual Interfaces
        virtual ALU_IF     EIF;
    //    virtual ALU_IF.TEST     EIF_T;
    //    virtual ALU_IF.Monitor  EIF_M;

    // Components
            Generator        GEN;
            Driver           DRV;
            Monitor          MON;
            Score_Board      SCB;
            Coverage         COV;

    // Mailboxes

            mailbox #(Transction) GEN2DRV = new();
            mailbox #(Transction) DRV2SCB = new();
            mailbox #(Transction) MON2SCB = new();

    // Constructor

  //  function new(virtual ALU_IF.TEST EIF_T, virtual ALU_IF.Monitor EIF_M);
       function new(virtual ALU_IF EIF);                
         this.EIF = EIF;
     //   this.EIF_T    = EIF_T;
     //  this.EIF_M    = EIF_M;

        endfunction

    // Build all components and connect them

                function void  Build_ENV();
                        GEN      = new(GEN2DRV);
                        DRV      = new(GEN2DRV, EIF, DRV2SCB);
                        MON      = new(MON2SCB, EIF.Monitor);
                        SCB      = new(MON2SCB, DRV2SCB);
                        COV      = new();

                endfunction

    // Run all components in parallel
    task run();

        fork

                    GEN.run();
                    DRV.run();
                    MON.run();
                    SCB.run();

        join_any

    endtask


endclass

endpackage
