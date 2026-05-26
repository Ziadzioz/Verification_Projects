package ALU_PACKAGE;


/////////////// Definig the new DATA TYPES we will use it 


typedef enum logic [2:0] {  OR       = 3'b000,
                            XOR      = 3'b001,
                            ADD      = 3'b010,
                            MULT     = 3'b011,
                            SHIFT    = 3'b100,
                            ROTATE   = 3'b101,
                            INVALID_6 = 3'b110,
                            INVALID_7 = 3'b111 } op;

`include "Transaction.svh"
`include "Coverage.svh"
`include "Driver.svh"
`include "Generator.svh"
`include "Monitor.svh"
`include "Score_Board.svh"
`include "Enviroment.svh"

endpackage