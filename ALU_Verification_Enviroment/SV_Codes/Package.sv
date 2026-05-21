package ALU_PACKAGE ; 


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

class static ALU_rand;
 
    rand bit                  rst,red_op_A,red_op_B,bypass_A,bypass_B,direction,serial_in;
    rand bit signed [2 : 0 ]  A,B;
    rand op                   opcode;


    int         max_pos = 3, max_neg = - 4, zero = 0;
 

///////////////// Writing Constrains for Rondomization 


     constraint  reset          { rst dist {0 := 99 , 1 := 1};}

     constraint  ALU_OPERANDS   { if (opcode == ADD || opcode == MULT)
                                    {
                                    A  dist {max_pos := 30 , max_neg := 30 , zero := 30 , [ max_neg + 1 : max_pos - 1] := 10};
                                    B  dist {max_pos := 30 , max_neg := 30 , zero := 30 , [ max_neg + 1 : max_pos - 1] := 10};
                                    }   
                                        }


     constraint  A_XOR_OR   { if ((opcode == OR || opcode == XOR) && red_op_A) 
                                    {
                                    B == 0;
                                    A  dist {1 := 30 , 2 := 30 , -4 := 30 , [ max_neg + 1 : max_pos - 1] := 10};
                                    }   
                                        }
     constraint  B_XOR_OR   { if ((opcode == OR || opcode == XOR) && red_op_B && !red_op_A) 
                                    {
                                    A == 0;
                                    B  dist {1 := 30 , 2 := 30 , -4 := 30 , [ max_neg + 1 : max_pos - 1] := 10};
                                    }   
                                        }

     constraint  Invalid     { 
                                    opcode  dist {ADD := 15 , MULT := 15 , XOR := 15 , SHIFT := 15 , OR := 15 , ROTATE := 15 , INVALID_6 := 5 , INVALID_7 := 5};                                       
                             }

     constraint  By_Pass_A   { bypass_A   dist {0 := 99 , 1 := 1};}

     constraint  By_Pass_B   { bypass_B   dist {0 := 99 , 1 := 1};}

     constraint  Shift_Rotate { (opcode == SHIFT ||opcode == ROTATE) ->   A inside {[ max_neg : max_pos]};}

     constraint  INVALID_2   { if (!(opcode == OR || opcode == XOR))
                                    {
                                    red_op_A  dist {0 := 95 , 1 := 5};
                                    red_op_B  dist {0 := 95 , 1 := 5};
                                    }   
                                        }


    
endclass 
    
endpackage

