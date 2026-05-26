
 /////////////// Importing ALL Packages 

                import ALU_PACKAGE::*;
module ALU (
    input logic              clk,            
    input logic              rst,            
    input logic signed [2:0] A,        
    input logic signed [2:0] B,        
    input op                 opcode,   
    input logic              red_op_A,       
    input logic              red_op_B,       
    input logic              bypass_A,       
    input logic              bypass_B,       
    input logic              direction,      
    input logic              serial_in,      

    output logic signed [5:0] out,     
    output logic [15:0]       leds     
);

    

    logic signed [2:0]    A_reg, B_reg;
    op                    opcode_reg;
    logic                 red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg;
    logic                 direction_reg, serial_in_reg;
    logic signed [5:0]    out_next;
    logic        [15:0]   leds_next;
  
    always_ff @(posedge clk or rst) begin
        if (rst) begin
            A_reg <= 3'b0;
            B_reg <= 3'b0;
            opcode_reg <= OR;
            red_op_A_reg <= 1'b0;
            red_op_B_reg <= 1'b0;
            bypass_A_reg <= 1'b0;
            bypass_B_reg <= 1'b0;
            direction_reg <= 1'b0;
            serial_in_reg <= 1'b0;
            out <= 0;
            leds <= 0;
        end else begin
            A_reg <= A;
            B_reg <= B;
            opcode_reg <= opcode;
            red_op_A_reg <= red_op_A;
            red_op_B_reg <= red_op_B;
            bypass_A_reg <= bypass_A;
            bypass_B_reg <= bypass_B;
            direction_reg <= direction;
            serial_in_reg <= serial_in;
            out <= out_next;
            leds <= leds_next;
        end
    end

    always_comb begin
        out_next = 0;
        leds_next = leds;
        if (bypass_A_reg) begin
            out_next = A_reg;
            leds_next = 0;
        end else if (bypass_B_reg) begin
            out_next = B_reg;
            leds_next = 0;
        end else if ((red_op_A_reg || red_op_B_reg) && (opcode_reg != OR && opcode_reg != XOR) ) begin
            out_next = 0;
            leds_next = ~leds;
        end else begin
            case (opcode_reg)
                ADD: begin
                    out_next = A_reg + B_reg;
                    leds_next = 0;
                end
                MULT: begin
                    out_next = A_reg * B_reg;
                    leds_next = 0;
                end
                OR: begin
                    if (red_op_A_reg) out_next = |A_reg;
                    else if (red_op_B_reg) out_next = |B_reg;
                    else out_next = A_reg | B_reg;
                    leds_next = 0;
                end
                XOR: begin
                    if (red_op_A_reg) out_next = ^A_reg;
                    else if (red_op_B_reg) out_next = ^B_reg;
                    else out_next = A_reg ^ B_reg;
                    leds_next = 0;
                end
                SHIFT: begin
                    if (direction_reg) out_next = {A_reg[1:0], serial_in_reg};
                    else out_next = {serial_in_reg, A_reg[2:1]};
                    leds_next = 0;
                end
                ROTATE: begin
                    if (direction_reg) out_next = {A_reg[1:0], A_reg[2]};
                    else out_next = {A_reg[0], A_reg[2:1]};
                    leds_next = 0;
                end
                INVALID_6, INVALID_7: begin
                    out_next = 0;
                    leds_next = ~leds;
                end
                default: begin
                    out_next = 0;
                    leds_next = 0;
                end
            endcase
        end
    end

endmodule
