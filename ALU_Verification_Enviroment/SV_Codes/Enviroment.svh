        /////////////// Importing ALL Packages 

                import ALU_PACKAGE::*;

class Environment;

    // Components
            Generator        GEN;
            Driver           DRV;
            Monitor          MON;
            Score_Board      SCB;

    // Mailboxes

            mailbox GEN2DRV;
            mailbox DRV2SCB;
            mailbox MON2SCB;

    // Constructor

  //  function new(virtual ALU_IF.TEST vif_T, virtual ALU_IF.Monitor vif_M);
       function new(virtual ALU_IF vif);                
       //  this.vif = vif;
         GEN2DRV = new();
         DRV2SCB = new();
         MON2SCB = new();

                        GEN       = new(GEN2DRV);
                        DRV      = new(GEN2DRV, vif, DRV2SCB);
                        MON      = new(MON2SCB, vif);
                        SCB      = new(MON2SCB, DRV2SCB);
    
        endfunction


    task run();

        fork

                    GEN.run();
                    DRV.run();
                    MON.run();
                    SCB.run();

        join_any
                   
    endtask


endclass


