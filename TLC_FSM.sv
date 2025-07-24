////////////////////////////////////////////////////////////////////////////////// 
//////////////////////////////////////////////////////////////////////////////////
module TLC_FSM(
        input  logic clk , rst,
        input  logic NS,
        input  logic EW,
        input  logic Pedestrian,
        output logic walk , Dn_walk,
        output logic G_NS , Y_NS , R_NS,
        output logic G_EW , Y_EW , R_EW
    );
  logic is_s6 , is_s6_C ;
  
   typedef enum logic [3:0] {
        s0  = 4'd0,  s1  = 4'd1 , s2  = 4'd2,
        s3  = 4'd3,  s4  = 4'd4 , s5  = 4'd5,
        s6  = 4'd6,  s7  = 4'd7 , s8  = 4'd8,
        s9  = 4'd9,  s10 = 4'd10, s11 = 4'd11,
        s12 = 4'd12, s13 = 4'd13, s14 = 4'd14
   } state;
   
   state C_State , N_State ;
   
  always_ff @(posedge clk , negedge rst)
   begin
     if(!rst)
      C_State <= s0;
     else
      C_State <= N_State;
   end
   
  always_comb
   begin
    is_s6 =1'd0 ; 
    walk = 1'd0 ; Dn_walk = 1'd1;   
    G_NS = 1'd0 ; Y_NS = 1'd0 ; R_NS = 1'd0;
    G_EW = 1'd0 ; Y_EW = 1'd0 ; R_EW = 1'd0;
     
     case(C_State)
       s0: begin N_State = s1;  G_NS = 1'd1 ; R_EW = 1'd1; end         
       s1: begin N_State = s2;   G_NS = 1'd1 ; R_EW = 1'd1;end                 
       s2: begin N_State = s3; G_NS = 1'd1 ; R_EW = 1'd1;  end                        
       s3: begin N_State = s4;  G_NS = 1'd1 ; R_EW = 1'd1; end                          
       s4: begin N_State = s5;  G_NS = 1'd1 ; R_EW = 1'd1; end                                                    
       s5: begin
          G_NS = 1'd1 ; R_EW = 1'd1;
           if (!Pedestrian && !EW)                                     
             N_State = s5;
           else
             N_State = s6;  
         end          
       s6: begin 
         Y_NS = 1'd1 ; R_EW = 1'd1; is_s6 =1'd1 ;
           if(Pedestrian)                                   
             N_State = s13; 
           else
             N_State = s7;  
         end                                              
       s7: begin N_State = s8;  R_NS = 1'd1 ; G_EW = 1'd1; end                      
       s8: begin N_State = s9;  R_NS = 1'd1 ; G_EW = 1'd1; end                                                                                              
       s9: begin N_State = s10; R_NS = 1'd1 ; G_EW = 1'd1; end                    
       s10:begin N_State = s11; R_NS = 1'd1 ; G_EW = 1'd1; end          
       s11: begin
           R_NS = 1'd1 ; G_EW = 1'd1;  
           if(EW && ~NS && ~Pedestrian)                                   
             N_State = s11;
           else
             N_State = s12;
         end 
       s12: begin
           R_NS = 1'd1 ; Y_EW = 1'd1;  
            if(Pedestrian)                                  
              N_State = s13; 
            else
              N_State = s0;    
         end  
      s13: begin 
          is_s6 = (is_s6_C);                                   
          N_State = s14;  R_NS = 1'd1 ; R_EW = 1'd1;
                          walk = 1'd1 ; Dn_walk = 1'd0;   
        end 
      s14: begin 
           R_NS = 1'd1 ; R_EW = 1'd1;   
           walk = 1'd1 ; Dn_walk = 1'd0;
           if(is_s6_C)                                    
            N_State = (EW) ? s7 : s0;
           else
            N_State = s0 ;                           
        end                                                
     endcase
   end
   
  always_ff @(posedge clk , negedge rst)
   begin
    if (!rst)  is_s6_C <= 1'b0 ;      
    else       is_s6_C <= is_s6 ;
   end
      
endmodule
