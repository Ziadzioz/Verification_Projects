  /////////////// Importing ALL Packages 

                import ALU_PACKAGE::*;


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


     constraint  reset          { rst dist {0 := 100 , 1 := 0};}

     constraint  A_DIST         { A  dist {max_pos := 45 , max_neg := 45 , zero := 5 , [ max_neg + 1 : max_pos - 1] := 5};}
     constraint  B_DIST         { B  dist {max_pos := 45 , max_neg := 45 , zero := 5 , [ max_neg + 1 : max_pos - 1] := 5};}


     constraint  ALU_OPERANDS   { opcode  dist {ADD := 20 , MULT := 20 , XOR := 15 , SHIFT := 10 , OR := 20 , ROTATE := 15 , INVALID_6 := 10 , INVALID_7 := 10};   }   
                                    
     constraint  By_Pass_A   { bypass_A   dist {0 := 95 , 1 := 5};}

     constraint  By_Pass_B   { bypass_B   dist {0 := 85 , 1 := 15};}


     constraint  INVALID_2   { if (!(opcode == OR || opcode == XOR))
                                    {
                                    red_op_A  dist {0 := 95 , 1 := 5};
                                    red_op_B  dist {0 := 95 , 1 := 5};
                                    }   
                                        }

    constraint  sfit_r_l     {(opcode == SHIFT) -> {direction  dist {0 := 50 , 1 := 50};}}

    constraint  rotate_r_l     {(opcode == ROTATE) -> {direction  dist {0 := 40 , 1 := 60};}}

                                                    
    
endclass 
    




