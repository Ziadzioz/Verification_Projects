package ALU_Transction ; 


/////////////// Definig the new DATA TYPES we will use it 


typedef enum logic [2:0] {  OR       = 3'b000,
                            XOR      = 3'b001,
                            ADD      = 3'b010,
                            MULT     = 3'b011,
                            SHIFT    = 3'b100,
                            ROTATE   = 3'b101,
                            INVALID_6 = 3'b110,
                            INVALID_7 = 3'b111 } op;


/////////////////// deifing Classes for Rondomization Process

class static Transction;
 

   
// ================== Inputs (Randomized) ==================

    rand bit                           rst;
    rand logic signed [2:0]            A, B;
    rand op                            opcode;
    rand bit                           serial_in;
    rand bit                           direction;
    rand bit                           red_op_A;
    rand bit                           red_op_B;
    rand bit                           bypass_A;
    rand bit                           bypass_B;
    


  //////////// For Obseriving the output Signals


     logic signed [5:0]           out;
     logic        [15:0]          leds;

   
  



///////////// Internal Signals Will be uesed in Transcation Class

    int         max_pos = 3, max_neg = - 4, zero = 0;
 

///////////////// Writing Constrains for Rondomization 


     constraint  reset          { rst dist {0 := 99 , 1 := 1};}

     constraint  A_DIST         { A  dist {max_pos := 30 , max_neg := 30 , zero := 10 , [ max_neg + 1 : max_pos - 1] := 30};}

     constraint  ALU_OPERANDS   { opcode  dist {ADD := 20 , MULT := 20 , XOR := 20 , SHIFT := 10 , OR := 20 , ROTATE := 10 , INVALID_6 := 0 , INVALID_7 := 0};   }   
                                    

     constraint  red_A       { if (red_op_A) 
                                    
                                       { (opcode == OR) || (opcode == XOR)  }  ; 

                                }   


     constraint  red_B       { if (red_op_B) 
                                    
                                       { (opcode == OR) || (opcode == XOR)  }  ; 

                                }        


     constraint  By_Pass_A   { bypass_A   dist {0 := 99 , 1 := 1};}

     constraint  By_Pass_B   { bypass_B   dist {0 := 99 , 1 := 1};}

/*
     constraint  INVALID_2   { if (!(opcode == OR || opcode == XOR))
                                    {
                                    red_op_A  dist {0 := 95 , 1 := 5};
                                    red_op_B  dist {0 := 95 , 1 := 5};
                                    }   
                                        }
*/

    
endclass 
    
endpackage


