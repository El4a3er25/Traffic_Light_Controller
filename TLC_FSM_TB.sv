`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module TLC_FSM_TB();

      logic clk , rst;         
      logic NS;                
      logic EW;                
      logic Pedestrian;        
      logic walk , Dn_walk;    
      logic G_NS , Y_NS , R_NS;
      logic G_EW , Y_EW , R_EW;
      
    TLC_FSM TLC_FSM_DUT (.*);
    
   always #5 clk = ~clk;
   
  initial 
   begin
     clk = 1'b0;
     rst = 1'b0;
     NS  = 1'b1;
     EW  = 1'b0;
     Pedestrian = 1'b0;
     #5
     rst = 1'b1;
     wait(TLC_FSM_DUT.C_State == 4'd5)
     EW = 1'b0 ; Pedestrian = 1'b0;
     repeat(2) @(negedge clk);
     EW = 1'b1;
     wait(TLC_FSM_DUT.C_State == 4'd11)
     EW = 1'b1; NS = 1'b0; Pedestrian = 1'b0;
     repeat(2) @(negedge clk);
     NS = 1'b1; 
     wait(TLC_FSM_DUT.C_State == 4'd12)
     Pedestrian = 1'b1;
     repeat(3) @(TLC_FSM_DUT.C_State == 4'd13);
     Pedestrian = 1'b0;
//     repeat(15) @(posedge clk);
     repeat(3) @(TLC_FSM_DUT.C_State == 4'd0);
     $stop;
   end 
endmodule
