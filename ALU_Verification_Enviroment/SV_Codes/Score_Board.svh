
             /////////////// Importing ALL Packages 

                import ALU_PACKAGE::*;

    class Score_Board;
            
            
            /// Mail Box To rescive the Transaction Data From Monitor 
             
               mailbox MON2SCB;

             /// Mail Box To rescive the Transaction Data From Driver 
             
               mailbox DRV2SCB;
          
           
             /// Consructor
    
                function new(mailbox MON2SCB, mailbox DRV2SCB);
                        
                        this.MON2SCB = MON2SCB;   //// for passing this mail to the class one
                        this.DRV2SCB = DRV2SCB;

                endfunction 
             
             ////// Defing the Error and Pass Counts

                       int Pass_Count = 0;
                       int Error_Count = 0;
                       int i = 0;
                       logic signed [5:0]  expec_outt;

                       bit outt;

             ///////////////////////////// Defining the Queues for SYNC the Mon with Drv

              Transction  tarns_q[$] ;

              parameter   Pipe_line_stages = 2;

          //    Tran_expec_queue.out ;

          Transction tr_expected = new();
          Transction TR_QUEU = new();
          Transction tr_actual   = new();

             ////////////////////////////////// Run Task for Comparing the Expected Data from the Driver and the one From Monitor the Actual one

                   task  run();
                                   for (int r = 0; r < Pipe_line_stages ; r++)
                                       begin
                                             Transction tr_init = new();
                                              tarns_q.push_back(tr_init); 

                                       end   
                    forever 
                           begin 
                                 
                           // put the Data comes from the driver on it
                                DRV2SCB.get(tr_expected);
                                MON2SCB.get(tr_actual);               ////////// Getting the ACTUAL FROM the Monitor

                                tarns_q.push_back(tr_expected);           ///////////////// storing the Expec Values
                                                             
                                 if(tarns_q.size() > 2);       ////////////// Waiting 2 Cycles for SYNC
                                     begin
                                            TR_QUEU = tarns_q.pop_front();
                                    
                                        ///////////////// Comparing the Expec Data with the Actual one
                                        
                                        Compare(outt,expec_outt,tr_actual,TR_QUEU);
                                        i = i + 1;

                                            $display("*************************************************");
                                                    $display(" iteration number = %0d",i);
                                             $display("*************************************************");

                                             $display("***************************************************************************************************************");
                                                    $display("expec_out = %0d & actual_out =  %0d at time ",expec_outt,tr_actual.out,$time);
                                             $display("***************************************************************************************************************");
                                            

                                        if(outt)
                                        Pass_Count = Pass_Count + 1;
                                        else
                                        Error_Count = Error_Count + 1;
                                     end
                           end

                                              $display("***************************************************************************************************************");
                                                               $display(" ******** Total no of Iteration  = %0d *************",i+1);
                                             $display("***************************************************************************************************************");
                                            

                       endtask

                              ////////////////////// Deifining the Golden Model
                               
                                task Compare(   output bit returnn,
                                                output logic signed [5:0] expec_out,
                                                input Transction actual,
                                                input Transction expected);

                                   
                                   logic signed [2:0]  expec_A,expec_B;
                                   logic        [15:0] expec_leds;

                                   if(expected.rst)
                                    begin
                                          expec_out = 0;
                                            if(actual.out == expec_out)
                                              returnn = 1;
                                              else
                                              returnn = 0;
                                         
                                    end
                                  else if (expected.bypass_A)
                                    begin
                                          expec_out = expected.A;
                                            if(actual.out == expec_out)
                                              returnn = 1;
                                              else
                                              returnn = 0;
                                         
                                    end
                                    
                                    else if (expected.bypass_B)
                                    begin
                                           expec_out = expected.B;
                                            if(actual.out == expec_out)
                                              returnn = 1;
                                              else
                                              returnn = 0;
                                         
                                    end

                                    else
                                    begin
        
                                         if((expected.red_op_A))
                                         begin
                                            if(expected.opcode != OR && expected.opcode != XOR)
                                              begin
                                                expec_out = 0;
                                                   if(actual.out == 0)
                                                    returnn = 1;
                                                    else
                                                    returnn = 0;
                                              end
                                            else if(expected.opcode == OR)
                                              begin
                                                  expec_out = |expected.A;
                                                   if(actual.out == expec_out)
                                                    returnn =1;
                                                    else
                                                    returnn =0;
                                              end
                                              else                     //if(expected.opcode == XOR)
                                              begin 
                                                   expec_out = ^expected.A;
                                                   if(actual.out == expec_out)
                                                    returnn = 1;
                                                    else
                                                    returnn = 0;
                                              end
                                           end

                                        else if( (expected.red_op_B))
                                         begin
                                            if(expected.opcode != OR && expected.opcode != XOR)
                                              begin
                                                    expec_out = 0;
                                                   if(actual.out == expec_out)
                                                    returnn = 1;
                                                    else
                                                   returnn = 0;
                                              end
                                            else if(expected.opcode == OR)
                                              begin 
                                                 expec_out = |expected.B;
                                                   if(actual.out == expec_out)
                                                    returnn = 1;
                                                    else
                                                    returnn =0;
                                              end
                                              else //if(expected.opcode == XOR)
                                              begin
                                                  expec_out = ^expected.B;
                                                   if(actual.out == expec_out)
                                                    returnn = 1;
                                                    else
                                                    returnn =0;
                                              end
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
                                                SHIFT: begin
                                                            if (expected.direction) 
                                                            expec_out = {expected.A[1:0], expected.serial_in};
                                                            else expec_out = {expected.serial_in, expected.A[2:1]};
                                                            if(actual.out == expec_out)
                                                                returnn = 1;
                                                                else
                                                                returnn =0;
                                                        end
                                                ROTATE: begin
                                                            if (expected.direction) 
                                                            expec_out = {expected.A[1:0], expected.A[2]};
                                                            else expec_out = {expected.A[0], expected.A[2:1]};
                                                            if(actual.out == expec_out)
                                                                returnn = 1;
                                                                else
                                                                returnn =0;
                                                        end
                                                default: begin
                                                                  expec_out = 0;
                                                                if(actual.out == expec_out)
                                                                    returnn = 1;
                                                                    else
                                                                    returnn = 0;
                                                            end
                                                endcase
                                       end
                                        end
                                    
                                 endtask 


                    ///////// Task to print out the No of Correct and Failed Times

                    task Score_Board_Report;
                        
                        $display("*************************************************");
                        $display(" The Number OF Correct Operations =%0d at time ",Pass_Count,$time );
                        $display("*************************************************");


                        $display("*************************************************");
                        $display(" The Number OF Failed Operations =%0d at time ",Error_Count,$time );
                        $display("*************************************************");


                    endtask
                             
       endclass                            
    


