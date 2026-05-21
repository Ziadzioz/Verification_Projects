package ALU_Coverage;

        /////////////// Importing Transaction Class


        import ALU_Transction::*;

         
        

         ///////////////// Class for Coverage Process

         class  Coverage ;      

                                     //////////////// Taking an INSTANCE from the Transction Class to cover it 
                                                       Transction  ALU_tr_cov;

                                                       

                                                  //// Defining The Cover Group

                           covergroup ALU_Coverage ;

                                             A_CP: coverpoint ALU_tr_cov.A iff(!ALU_tr_cov.rst) {

                                                                                                bins A_Data_0         = {0};
                                                                                                bins A_Data_Max       = {ALU_tr_cov.max_pos};
                                                                                                bins A_Data_Min       = {ALU_tr_cov.max_neg};
                                                                                    //             bins Walking_Ones[]   = {3'b001,3'b010,3'sb100} iff(ALU_tr_cov.red_op_A);
                                                                                                bins others           = {[ALU_tr_cov.max_neg + 1 : ALU_tr_cov.max_pos - 1]};


                                                                                               }

                                             B_CP: coverpoint ALU_tr_cov.B iff(!ALU_tr_cov.rst) {
                                                
                                                                                                bins B_Data_0         = {0};
                                                                                                bins B_Data_Max       = {ALU_tr_cov.max_pos};
                                                                                                bins B_Data_Min       = {ALU_tr_cov.max_neg};
                                                                                            ////    bins Walking_Ones[]   = {3'b001,3'b010,3'sb100} iff(ALU_tr_cov.red_op_B);
                                                                                                bins others           = {[ALU_tr_cov.max_neg + 1 : ALU_tr_cov.max_pos - 1]};

                                                                                               }

                                             OP_CP: coverpoint ALU_tr_cov.opcode iff(!ALU_tr_cov.rst){
                                                
                                                                                              bins         SHIFT           = {SHIFT};
                                                                                              bins         ROTATE          = {ROTATE};
                                                                                              bins         MULT            = {MULT};
                                                                                              bins         ADD             = {ADD};
                                                                                              bins         OR              = {OR};
                                                                                              bins         XOR             = {XOR};


                                                                                              illegal_bins others                = {INVALID_6,INVALID_7};     

                                                                                                    }

                                             
                                             RED_OP_A: coverpoint ALU_tr_cov.red_op_A iff(!ALU_tr_cov.rst);
                                             RED_OP_B: coverpoint ALU_tr_cov.red_op_B iff(!ALU_tr_cov.rst);

                                             BY_PASS_A: coverpoint ALU_tr_cov.bypass_A iff(!ALU_tr_cov.rst);
                                             BY_PASS_B: coverpoint ALU_tr_cov.bypass_B iff(!ALU_tr_cov.rst);

                                             Direction: coverpoint ALU_tr_cov.direction iff(!ALU_tr_cov.rst);

               
               /////////////////////////////////////////////////////////         CROSS  COV          //////////////////////////

 
                                        

                                             ADDTION_OVERFLOW: cross OP_CP,A_CP,B_CP  {
                                                                                       option.cross_auto_bin_max = 0 ; 
                                                                           
                                                                                        bins Positive_over_flow   = binsof (OP_CP.ADD ) &&  binsof (A_CP.A_Data_Max ) &&  binsof (B_CP.B_Data_Max );
                                                                                        bins Negative_over_flow   = binsof (OP_CP.ADD ) &&  binsof (A_CP.A_Data_Min ) &&  binsof (B_CP.B_Data_Min );
                                                             
                                                                                      }



                                             REDUCTION_A: cross OP_CP,RED_OP_A {
                                                                                    option.cross_auto_bin_max = 0 ; 

                                                                                    bins OR_RED_OP_A      = binsof (OP_CP.OR ) &&  binsof (RED_OP_A[1] );
                                                                                    
                                                                                    bins XOR_RED_OP_A     = binsof (OP_CP.XOR ) &&  binsof (RED_OP_A[1] );

                                                                                    }

                                             REDUCTION_B: cross OP_CP,RED_OP_B {
                                                                                    option.cross_auto_bin_max = 0 ; 

                                                                                    bins OR_RED_OP_B      = binsof (OP_CP.OR ) &&  binsof (RED_OP_B[1] );
                                                                                    
                                                                                    bins XOR_RED_OP_B     = binsof (OP_CP.XOR ) &&  binsof (RED_OP_B[1] );

                                                                                    }                                                                                    

                                            
                                             Multi_OVERFLOW: cross OP_CP,A_CP,B_CP  {
                                                                                       option.cross_auto_bin_max = 0 ; 
                                                                           
                                                                                        bins Positive_over_flow   = binsof (OP_CP.MULT) &&  binsof (A_CP.A_Data_Max ) &&  binsof (B_CP.B_Data_Max );
                                                                                        bins Negative_over_flow   = binsof (OP_CP.MULT ) &&  binsof (A_CP.A_Data_Min ) &&  binsof (B_CP.B_Data_Min );
                                                             
                                                                                      }


                                             SHIFT_LEFT_RIGHT: cross OP_CP,Direction {
                                                                                        option.cross_auto_bin_max = 0 ;

                                                                                         bins SHIFT_RIGHT  = binsof (OP_CP.SHIFT) && binsof (Direction[0]);
                                                                                         bins SHIFT_LEFT   = binsof (OP_CP.SHIFT) && binsof (Direction[1]);
                                                                            
                                                                                      }

                                             Rotate_LEFT_RIGHT: cross OP_CP,Direction {
                                                                                        option.cross_auto_bin_max = 0 ;

                                                                                         bins Rotate_RIGHT  = binsof (OP_CP.ROTATE) && binsof (Direction[0]);
                                                                                         bins Rotate_LEFT   = binsof (OP_CP.ROTATE) && binsof (Direction[1]);
                                                                            
                                                                                      }


                                        
                                     endgroup
                                       

                                         // ================== Constructor ==================
                 function new(); 
                                 ALU_tr_cov = new();
                                 ALU_Coverage = new();
                 endfunction



             // ================== Sample Method ==================   FOR Sampling the ROdomized Data  
                

                function  void Sample_DATA(Transction tr);

                   ALU_tr_cov.rst         = tr.rst;
                   ALU_tr_cov.A           = tr.A;
                   ALU_tr_cov.B           = tr.B;
                   ALU_tr_cov.serial_in   = tr.serial_in;
                   ALU_tr_cov.opcode      = tr.opcode;
                   ALU_tr_cov.direction   = tr.direction;
                   ALU_tr_cov.red_op_A    = tr.red_op_A;
                   ALU_tr_cov.red_op_B    = tr.red_op_B;
                   ALU_tr_cov.bypass_A   = tr.bypass_A;
                   ALU_tr_cov.bypass_B   = tr.bypass_B;

                   ALU_tr_cov.out        = tr.out;
                   ALU_tr_cov.leds       = tr.leds;

                   
                                    //////////          it was possible to do  this.ALU_tr_cov = tr; instead

                                     ///////////////// FOR Sampling Cover Group )
                                     ALU_Coverage.sample();
                endfunction


             endclass
    
endpackage






































