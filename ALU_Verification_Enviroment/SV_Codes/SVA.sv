  /////////////// Importing ALL Packages 

                import ALU_PACKAGE::*;

///////////////////////////////////////////////////////// REquierd for testing the protocals and timing info and the corner cases in the design

module ALU_SVA (ALU_IF SVA_IF);
     
   
     ////////////////////////////////////////// Writing the Properties for the Concarnt Assertions

       ////// TESTING ALU_Main Operations
        
          //////// ADDTION
   
          property  ADDER;
                @(posedge SVA_IF.clk) disable iff(SVA_IF.rst || (SVA_IF.bypass_A) || (SVA_IF.bypass_B))
                  
                 (((SVA_IF.opcode == ADD ) && (!SVA_IF.red_op_A) && (!SVA_IF.red_op_B)))
                                                                                       |-> ##2 ((SVA_IF.out == $past(SVA_IF.A,2) + $past(SVA_IF.B,2)) && (SVA_IF.leds == 0));
          endproperty


          //////// Multiplication

          property  MULTER;
                @(posedge SVA_IF.clk)  disable iff(SVA_IF.rst)
                  
                   ((!SVA_IF.bypass_A) && (!SVA_IF.bypass_B) && (SVA_IF.opcode == MULT ) && (!SVA_IF.red_op_A) && (!SVA_IF.red_op_B))
                                                                                       |-> ##2 (SVA_IF.out == $past(SVA_IF.A,2) * $past(SVA_IF.B,2) )
                                                                                               &&(SVA_IF.leds == 0);
          endproperty
                      
                         

          //////// Oring

          property  ORER;
                @(posedge SVA_IF.clk)   disable iff(SVA_IF.rst)
                  
                  ((!SVA_IF.bypass_A) && (!SVA_IF.bypass_B) && (SVA_IF.opcode == OR ) && (!SVA_IF.red_op_A) && (!SVA_IF.red_op_B) )
                                                                                       |-> ##2  (SVA_IF.out == $past(SVA_IF.A,2) | $past(SVA_IF.B,2) )
                                                                                                &&(SVA_IF.leds == 0);
          endproperty


          //////// Reduction

          property  RED_OR_AER;
                @(posedge SVA_IF.clk)  disable iff(SVA_IF.rst)
                  
                  ((!SVA_IF.bypass_A) && (!SVA_IF.bypass_B) && (SVA_IF.opcode == OR ) && (SVA_IF.red_op_A)) 
                                                                  |-> ##2  (SVA_IF.out == | $past(SVA_IF.A,2) )
                                                                           &&(SVA_IF.leds == 0);
          endproperty


          property  RED_OR_BER;
                @(posedge SVA_IF.clk)  disable iff(SVA_IF.rst)
                  
                  ((!SVA_IF.bypass_A) && (!SVA_IF.bypass_B) && (SVA_IF.opcode == OR ) && (!SVA_IF.red_op_A) && (SVA_IF.red_op_B))
                                                                                       |-> ##2  (SVA_IF.out == | $past(SVA_IF.B,2) )
                                                                                                &&(SVA_IF.leds == 0);
          endproperty





          //////// Xoring

          property  XORER;
                @(posedge SVA_IF.clk) disable iff(SVA_IF.rst)
                  
                  ((!SVA_IF.bypass_A) && (!SVA_IF.bypass_B) && (SVA_IF.opcode == XOR ) && (!SVA_IF.red_op_A) && (!SVA_IF.red_op_B))
                                                                                       |-> ##2  (SVA_IF.out == $past(SVA_IF.A,2) ^ $past(SVA_IF.B,2) )
                                                                                                &&(SVA_IF.leds == 0);
          endproperty


          //////// Reduction

          property  RED_XOR_AER;
                @(posedge SVA_IF.clk) disable iff(SVA_IF.rst)
                  
                  ((!SVA_IF.bypass_A) && (!SVA_IF.bypass_B) && (SVA_IF.opcode == XOR ) && (SVA_IF.red_op_A))  
                                                                  |-> ##2  (SVA_IF.out == ^ $past(SVA_IF.A,2) )
                                                                           &&(SVA_IF.leds == 0);
          endproperty


          property  RED_XOR_BER;
                @(posedge SVA_IF.clk) disable iff(SVA_IF.rst)
                  
                   ((!SVA_IF.bypass_A) && (!SVA_IF.bypass_B) && (SVA_IF.opcode == XOR ) && (!SVA_IF.red_op_A) && (SVA_IF.red_op_B)) 
                                                                                       |-> ##2  ((SVA_IF.out == ^ $past(SVA_IF.B,2) )
                                                                                                &&(SVA_IF.leds == 0));
          endproperty



          //////// SHIFTING

          property  SHIFT_RER;
                @(posedge SVA_IF.clk) disable iff(SVA_IF.rst)
                  
                   ((!SVA_IF.bypass_A) && (!SVA_IF.bypass_B) && (SVA_IF.opcode == SHIFT) && (!SVA_IF.direction) && (!SVA_IF.red_op_A) && (!SVA_IF.red_op_B))
                                                                                                              |-> ##2  (SVA_IF.out == {$past(SVA_IF.serial_in,2),(($past(SVA_IF.A[2:1],2)))})
                                                                                                                       &&(SVA_IF.leds == 0);
          endproperty


          property  SHIFT_LER;
                @(posedge SVA_IF.clk)  disable iff(SVA_IF.rst)
                  
                  ((!SVA_IF.bypass_A) && (!SVA_IF.bypass_B) && (SVA_IF.opcode == SHIFT) && (SVA_IF.direction) && (!SVA_IF.red_op_A) && (!SVA_IF.red_op_B))
                                                                                                              |-> ##2  (SVA_IF.out == {$past(SVA_IF.A[1:0],2),$past(SVA_IF.serial_in,2)} )
                                                                                                                       &&(SVA_IF.leds == 0);
          endproperty





           //////// Rotating

          property  Rotate_RER;
                @(posedge SVA_IF.clk)  disable iff(SVA_IF.rst || SVA_IF.bypass_A || SVA_IF.bypass_B)
                  
                   (SVA_IF.opcode == ROTATE) && (!SVA_IF.direction) && (!SVA_IF.red_op_A) && (!SVA_IF.red_op_B) 
                                                                                                               |-> ##2  (SVA_IF.out == {$past(SVA_IF.A[0],2),$past(SVA_IF.A[2:1],2)} )
                                                                                                                         &&(SVA_IF.leds == 0)
          endproperty


          property  Rotate_LER;
                @(posedge SVA_IF.clk) disable iff(SVA_IF.rst || SVA_IF.bypass_A || SVA_IF.bypass_B)
                  
                   (SVA_IF.opcode == ROTATE) && (SVA_IF.direction) && (!SVA_IF.red_op_A) && (!SVA_IF.red_op_B) 
                                                                                                              |-> ##2  (SVA_IF.out == {$past(SVA_IF.A[1:0],2),$past(SVA_IF.A[2],2)} )
                                                                                                                       &&(SVA_IF.leds == 0)
          endproperty




     
             ///// Testing BY Pass Feature

              property  BY_PASS_AER;
                @(posedge SVA_IF.clk) disable iff(SVA_IF.rst )
                  
                   (SVA_IF.bypass_A) 
                                    |-> ##2  (SVA_IF.out == $past(SVA_IF.A,2))
                                             &&(SVA_IF.leds == 0)
              endproperty
          

              property  BY_PASS_BER;
                @(posedge SVA_IF.clk) disable iff(SVA_IF.rst && SVA_IF.bypass_A )
                  
                   (SVA_IF.bypass_B) 
                                    |-> ##2  (SVA_IF.out == $past(SVA_IF.B,2))
                                             &&(SVA_IF.leds == 0)
              endproperty  
          
              
               ////////////////// Invalid Property
               
                property  InvalidER;
                  @(posedge SVA_IF.clk) disable iff(SVA_IF.rst || SVA_IF.bypass_A || SVA_IF.bypass_B)
                  
                   (SVA_IF.opcode == INVALID_6 || SVA_IF.opcode == INVALID_7 ) || ((SVA_IF.red_op_A || SVA_IF.red_op_B) && (SVA_IF.opcode != OR && SVA_IF.opcode != XOR))
                                                                                                                                                                        |-> ##2  (SVA_IF.out == 0)
                                                                                                                                                                              
                endproperty 


          
           ///////////////////////////////////////////////// Writing the Assert Properties
             
                ADDTION: assert property (ADDER) 
                                                else $error (" Testing the Addtion has Failed") ;


                MULTIPLICATION: assert property (MULTER) 
                                                else $error (" Testing the MULTIPLICATION has Failed") ;
                
                ORR: assert property (ORER) 
                                                else $error (" Testing the ORING has Failed") ;

                REDUCTION_OR_A: assert property (RED_OR_AER) 
                                                else $error (" Testing the REDUCTION_OR_A has Failed") ;

                REDUCTION_OR_B: assert property (RED_OR_BER) 
                                                else $error (" Testing the REDUCTION_OR_B has Failed") ;
                
                XORR: assert property (XORER) 
                                                else $error (" Testing the XORING has Failed") ;

                REDUCTION_XOR_A: assert property (RED_XOR_AER) 
                                                else $error (" Testing the REDUCTION_XOR_A has Failed") ;

                REDUCTION_XOR_B: assert property (RED_XOR_BER) 
                                                else $error (" Testing the REDUCTION_XOR_B has Failed") ;


                SHIFTING_RIGHT: assert property (SHIFT_RER) 
                                                else $error (" Testing the SHIFTING_RIGHT has Failed") ;

                SHIFTING_LEFT: assert property (SHIFT_LER) 
                                                else $error (" Testing the SHIFTING_LEFT has Failed") ;


                Rotate_Right: assert property (Rotate_RER) 
                                                else $error (" Testing the Rotate_Right has Failed") ;
                Rotate_Left: assert property (Rotate_LER) 
                                                else $error (" Testing the Rotate_Left has Failed") ;
                

                BY_Pass_A: assert property (BY_PASS_AER) 
                                                else $error (" Testing the BY_PASS_A has Failed") ;
                BY_Pass_B: assert property (BY_PASS_AER) 
                                                else $error (" Testing the BY_PASS_A has Failed") ;
                

                INVALID: assert property (InvalidER) 
                                                else $error (" Testing the INVALID has Failed") ;
                                                                
               

                /////////////////////// Writing the Cover properties for the Concarnt Assertion

                 ADDTION_COV: cover property (ADDER) ;
                                                
                 MULTIPLICATION_COV: cover property (MULTER) ;
                                              
                 ORR_COV: cover property (ORER) ;
                                                
                 REDUCTION_OR_A_COV: cover property (RED_OR_AER) ;
                                               
                 REDUCTION_OR_B_COV: cover property (RED_OR_BER) ;
                                                
                 XORR_COV: cover property (XORER) ;
                                               
                 REDUCTION_XOR_A_COV: cover property (RED_XOR_AER) ;
                                              
                 REDUCTION_XOR_B_COV: cover property (RED_XOR_BER) ;
                                                
                 SHIFTING_RIGHT_COV: cover property (SHIFT_RER) ;
                                            
                 SHIFTING_LEFT_COV: cover property (SHIFT_LER) ;
                                               
                 Rotate_Right_COV: cover property (Rotate_RER) ;
                                               
                 Rotate_Left_COV: cover property (Rotate_LER) ;
                                                
                 BY_Pass_A_COV: cover property (BY_PASS_AER) ;
                                               
                 BY_Pass_B_COV: cover property (BY_PASS_AER) ;

                INVALID_COV: cover property (InvalidER) ;
                
                                                              
  
              
                 /////////////////////////// Writing the Final (combinantional)
                   
                    always_comb
                       begin
                                if (SVA_IF.rst)
                                   begin
                                              Reset_for_Out: assert final (SVA_IF.out == 0)
                                                                 else $error (" Testing the ASYNC Reset for OUT has Failed") ;
                                              
                                              Reset_for_LEDS: assert final (SVA_IF.leds == 0)
                                                                 else $error (" Testing the ASYNC Reset for LEDS has Failed") ;
                                   end
                       end


endmodule
