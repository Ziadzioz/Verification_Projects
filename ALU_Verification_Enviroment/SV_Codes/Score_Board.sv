package ALU_Score_Board;

      ///////////////////////////// Importing required Packages

      import ALU_Transction ::*;
      //////////////////////////// Score_Board Class

    class Score_Board;
            
            
            /// Mail Box To rescive the Transaction Data From Monitor 
             
               mailbox #(Transction) MON2SCB;

             /// Mail Box To rescive the Transaction Data From Driver 
             
               mailbox #(Transction) DRV2SCB;
          
           
             /// Consructor
    
                function new(mailbox #(Transction) MON2SCB, mailbox #(Transction) DRV2SCB);
                        
                        this.MON2SCB = MON2SCB;   //// for passing this mail to the class one
                        this.DRV2SCB = DRV2SCB;

                endfunction 
             
             ////// Defing the Error and Pass Counts

                       int Pass_Count = 0;
                       int Error_Count = 0;

                       bit outt;


             ////////////////////////////////// Run Task for Comparing the Expected Data from the Driver and the one From Monitor the Actual one

                   task  run();

                    forever 
                           begin 
                              Transction tr_actual   = new();     // put the Data comes from the monitor on it
                              Transction tr_expected = new();     // put the Data comes from the driver on it


                               MON2SCB.get(tr_actual);               ////////// Getting the ACTUAL FROM the Monitor
                               DRV2SCB.get(tr_expected);
                               

                              ///////////////// Comparing the Expec Data with the Actual one

                              Compare(outt,tr_actual,tr_expected);
                              if(outt)
                               Pass_Count++;
                              else
                              Error_Count++;
                              
                           end

                                  Score_Board_Report();           ////////////////////// Printing the SCB Report

                       endtask

                              ////////////////////// Deifining the Golden Model
                               
                                task Compare(output  bit returnn, input Transction actual, Transction expected);

                                   logic signed [5:0]  expec_out;
                                   logic signed [2:0]  expec_A,expec_B;
                                   logic        [15:0] expec_leds;

                                   if (expected.bypass_A)
                                    begin
                                         
                                            if(actual.out == expected.A)
                                              returnn = 1;
                                              else
                                              returnn = 0;
                                         
                                    end
                                    
                                    else if (expected.bypass_B)
                                    begin
                                         
                                            if(actual.out == expected.B)
                                              returnn = 1;
                                              else
                                              returnn = 0;
                                         
                                    end

                                    else if ((expected.red_op_A) || (expected.red_op_B))
                                         if((expected.red_op_A))
                                            if(expected.opcode != OR || expected.opcode != XOR)
                                              begin
                                                   if(actual.out == 0 && expected.leds == actual.leds)
                                                    returnn = 1;
                                                    else
                                                    returnn = 0;
                                              end
                                            else if(expected.opcode == OR)
                                              begin
                                                   if(actual.out == |expected.A)
                                                    returnn =1;
                                                    else
                                                    returnn =0;
                                              end
                                              else if(expected.opcode == XOR)
                                              begin
                                                   if(actual.out == ^expected.A)
                                                    returnn = 1;
                                                    else
                                                    returnn = 0;
                                              end
                                              
                                         if( (expected.red_op_B))
                                            if(expected.opcode != OR || expected.opcode != XOR)
                                              begin
                                                   if(actual.out == 0 && expected.leds == actual.leds)
                                                    returnn = 1;
                                                    else
                                                   returnn = 0;
                                              end
                                            else if(expected.opcode == OR)
                                              begin
                                                   if(actual.out == |expected.B)
                                                    returnn = 1;
                                                    else
                                                    returnn =0;
                                              end
                                              else if(expected.opcode == XOR)
                                              begin
                                                   if(actual.out == ^expected.B)
                                                    returnn = 1;
                                                    else
                                                    returnn =0;
                                              end
                                              
                                     else
                                       begin
                                                case (expected.opcode)
                                                   ADD: begin
                                                        expec_out  = expected.B + expected.A;
                                                            if(actual.out == expec_out)
                                                                returnn = 1;
                                                                else
                                                                returnn =0;
                                                         end
                                                   MULT: begin
                                                        expec_out  = expected.B * expected.A;
                                                            if(actual.out == expec_out)
                                                                returnn =1;
                                                                else
                                                                returnn =0;
                                                         end
                                                  OR: begin
                                                        expec_out  = expected.B | expected.A;
                                                            if(actual.out == expec_out)
                                                                returnn =1;
                                                                else
                                                                returnn = 0;
                                                         end
                                                 XOR: begin
                                                        expec_out  = expected.B ^ expected.A;
                                                            if(actual.out == expec_out)
                                                                returnn =1;
                                                                else
                                                                returnn = 0;
                                                         end
                                                 OR: begin
                                                        expec_out  = expected.B | expected.A;
                                                            if(actual.out == expec_out)
                                                                returnn =1;
                                                                else
                                                                returnn = 0;
                                                         end
                                                SHIFT: begin
                                                            if (expected.direction) 
                                                            expec_out = {expected.out[4:0], expected.out};
                                                            else expec_out = {expected.serial_in, expected.out[5:1]};
                                                            if(actual.out == expec_out)
                                                                returnn = 1;
                                                                else
                                                                returnn =0;
                                                        end
                                                ROTATE: begin
                                                            if (expected.direction) 
                                                            expec_out = {expected.out[4:0], expected.out[5]};
                                                            else expec_out = {expected.out[0], expected.out[5:1]};
                                                            if(actual.out == expec_out)
                                                                returnn = 1;
                                                                else
                                                                returnn =0;
                                                        end
                                                default: begin
                                                                if(actual.out == 0 && expected.leds == actual.leds)
                                                                    returnn = 1;
                                                                    else
                                                                    returnn = 0;
                                                            end
                                                endcase
                                        end
 
                                    
                                 endtask 


                    ///////// Task to print out the No of Correct and Failed Times

                    task Score_Board_Report;
                        
                        $display("*************************************************");
                        $display(" The Number OF Correct Operations = 0%d" ,Pass_Count );
                        $display("*************************************************");


                        $display("*************************************************");
                        $display(" The Number OF Failed Operations = 0%d" ,Error_Count );
                        $display("*************************************************");


                    endtask
                             
       endclass                            
    
endpackage
