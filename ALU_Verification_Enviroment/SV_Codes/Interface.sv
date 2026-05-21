interface ALU_IF(clk);
 
 input bit clk;

  ////////////////////////////////////// defining Signals //////////////////

          /////// defining new Data types

     typedef enum logic [2:0] {  OR       = 3'b000,
                            XOR      = 3'b001,
                            ADD      = 3'b010,
                            MULT     = 3'b011,
                            SHIFT    = 3'b100,
                            ROTATE   = 3'b101,
                            INVALID_6 = 3'b110,
                            INVALID_7 = 3'b111 } op;

       //////////  Input Signals

     bit                            rst;
     logic signed [2:0]             A;
     logic signed [2:0]             B;
     op                             opcode;
     bit                            serial_in;
     bit                            direction;
     bit                            red_op_A;
     bit                            red_op_B;
     bit                            bypass_A;
     bit                            bypass_B;


       //////////  Output Signals 

     logic signed [5:0]       out;
     logic        [15:0]      leds;


  

  ///////////// Clocking Blocks
  
       clocking cb @(posedge clk);

          default input #1step       output #0;

          input out,leds;

          output rst,A,B,opcode,red_op_A,red_op_B,bypass_A,bypass_B,direction,serial_in;


       endclocking

///////////  ModPorts


                      ///////// For Testing (Driver && TB)

            modport TEST (
                            clocking cb,
                            input  clk,out,leds,

                            output rst,A,B,opcode,red_op_A,red_op_B,bypass_A,bypass_B,direction,serial_in
                            
                         );

                      ///////// For DUT

            modport DUT (
                
                            input  clk,rst,A,B,opcode,red_op_A,red_op_B,bypass_A,bypass_B,direction,serial_in,

                            output  out,leds
                         );


                       ///////// For Monitor (Passive Element)
/*
            modport Monitor (
                
                            input  clk,rst,A,B,opcode,red_op_A,red_op_B,bypass_A,bypass_B,direction,serial_in,out,leds

                            );

*/

    
endinterface 

