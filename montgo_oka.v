`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2026 10:27:50 AM
// Design Name: 
// Module Name: montgo_oka
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

(* use_dsp = "no" *)
module montgo_oka #(N = 256 ) (input clk, input [N-1:0]A,B,M,input [N+3:0]M_b, output reg [N-1:0] C);

wire [2*N-1:0]T;
wire [N+1:0]Q;
reg [N+3:0]T_L;
wire [2*N+3:0]S;
reg [2*N+4:0]C_inter;
localparam R_bits = N+2;

reg [N-1:0]A_reg,B_reg,M_reg;
reg [N+1:0]R_reg;
reg [N+3:0]M_b_reg;
reg [N-1:0]C_reg;

reg [2*N-1:0]T_reg;
reg [N+1:0]Q_reg;
reg [2*N+3:0]S_reg;


always@(posedge clk) begin

	A_reg = A;
	B_reg = B;
	M_reg = M;

	M_b_reg = M_b;
	T_reg = T;
	Q_reg = Q;
	S_reg = S;
	C = C_reg;
	
	end
	
(* use_dsp = "no" *)	karatsuba_overlapfree #( N, 4, N/4) inst1 ( .A(A) , .B(B) , .out(T));
    

   
(* use_dsp = "no" *)  karatsuba_lower_overlapfree #(N+4, 4, (N+4)/4,N+2) insta3 (.A({2'b0,T_L}) , .B(M_b_reg) , .out(Q));
    
     karatsuba_upper_overlapfree #(N+4, 4,(N+4)/4, (N/18)) inst2 (.A({1'b0,1'b0,Q_reg}) , .B({1'b0,1'b0,1'b0,1'b0,M_reg}) ,  .q(S));
    
//  (* use_dsp = "no" *)  karatsuba_overlapfree #( N+4, 4,(N+4)/4) inst2 ( .A({1'b0,1'b0,Q_reg}) , .B({4'b0,M_reg}) , .out(S));
//	 assign T = A_reg * B_reg;
	
      //assign T_L = T % R;
    // assign Q = (T_L * M_b_reg) % R_reg;
    
    always@(*) begin
    
        T_L = T_reg[N+1:0];
        
        C_inter = (T_reg + S_reg) ;
        C_reg = C_inter[2*N+4:R_bits];
    
    end
        
 endmodule
 
 
 (* use_dsp = "no" *) module karatsuba_overlapfree #(parameter N=1024, parameter k=4,parameter m=256)(input [N-1:0]A,B, output [2*N-1:0]out);

  
  wire [N/k+1:0] a0[3:0];
  wire [N/k+1:0] a1[3:0];
  wire [N/k+1:0] a2[3:0];
  wire [N/k+1:0] b0[3:0]; 
  wire [N/k+1:0] b1[3:0]; 
  wire [N/k+1:0] b2[3:0];
  reg [ 2*N/k+3:0] e0[3:0]; 
  reg [ 2*N/k+3:0] e1[3:0]; 
  reg [2*N/k+3:0] e2[3:0];
  reg [ 2*N/k+3:0] c0[2:0];
  reg [ 2*N/k+4:0] c1[2:0];  
  reg [ 2*N/k+3:0] c2[2:0];
  reg [2*N-1 :0] temp0[2:0];
  reg [2*N-1 :0] temp1[2:0];
  reg [2*N-1 :0] temp2[2:0];
  wire [(N/k):0]A0,A1,A2,A3,B0,B1,B2,B3;
  wire [N-1:0]r;
  reg [2*N-1:0]G0,G1,G2; 
  

  assign r = 2**m;
  assign A3 = A[(N-1):(N-(N/k))];
  assign A2 = A[(N-(N/k)-1):(N/2)];
  assign A1 = A[((N/2)-1):(N/k)];
  assign A0 = A[((N/k)-1):0];
  
  assign B3 = B[(N-1):(N-(N/k))];
  assign B2 = B[(N-(N/k)-1):(N/2)];
  assign B1 = B[((N/2)-1):(N/k)];
  assign B0 = B[((N/k)-1):0];
  
  
  assign a0[0] = A0;
  assign a0[1] = A2; 
  assign a0[2] = A0; 
  assign a0[3] = A2; 
  
  assign a1[0] = A0 + A1; 
  assign a1[1] = A2 + A3; 
  assign a1[2] = A0 + A1; 
  assign a1[3] = A2 + A3; 
  assign a2[0] = A1;
  assign a2[1] = A3; 
  assign a2[2] = A1;
  assign a2[3] = A3; 
  
  
  assign b0[0] = B0; 
  assign b0[1] = B2; 
  assign b0[2] = B2; 
  assign b0[3] = B0; 
  
  assign b1[0] = B0 + B1; 
  assign b1[1] = B2 + B3; 
  assign b1[2] = B2 + B3; 
  assign b1[3] = B0 + B1; 
  
  assign b2[0] = B1; 
  assign b2[1] = B3; 
  assign b2[2] = B3; 
  assign b2[3] = B1; 
  
  

 integer i =0; 
 integer j =0; 
 
 
 
 
//  booth #(m+2,(2*m)+4) inst0 (a0[0],b0[0],e0[0]);
  
//  booth #(m+2,(2*m)+4) inst1 (a0[1],b0[1],e0[1]);
  
//  booth #(m+2,(2*m)+4) inst2 (a0[2],b0[2],e0[2]);
  
//  booth #(m+2,(2*m)+4) inst3 (a0[3],b0[3],e0[3]);
  
//  booth #(m+2,(2*m)+4) inst4 (a1[0],b1[0],e1[0]);
  
//  booth #(m+2,(2*m)+4) inst5 (a1[1],b1[1],e1[1]);
  
//  booth #(m+2,(2*m)+4) inst6 (a1[2],b1[2],e1[2]);
  
//  booth #(m+2,(2*m)+4) inst7 (a1[3],b1[3],e1[3]);
  
//  booth #(m+2,(2*m)+4) inst8 (a2[0],b2[0],e2[0]);
  
//  booth #(m+2,(2*m)+4) inst9 (a2[1],b2[1],e2[1]);
  
//  booth #(m+2,(2*m)+4) inst10 (a2[2],b2[2],e2[2]);
  
//  booth #(m+2,(2*m)+4) inst11 (a2[3],b2[3],e2[3]);

 
 
 
 always@(*) begin 
 
  for (j = 0; j<4 ; j=j+1) begin 
    e0[j] = $signed (a0[j]) * $signed(b0[j]); 
    end 
   G0=0;
   c0[0] = e0[0];  
   c0[2] = e0[1] ;
   c0[1] = e0[2] + e0[3] ; 
   
   
   
   for (j=0;j<3;j=j+1) 
    begin
        temp0[j] = (c0[j]*(r**(j<<1)));
        G0 = G0 + temp0[j];
    end
  end 
  
    
  always@(*) begin 
  
  for (i = 0; i<4 ; i=i+1) begin 
    e1[i] = $signed (a1[i]) * $signed(b1[i]); 
    end 
   G1=0;
   c1[0] = e1[0]; 
   c1[2] = e1[1];
   c1[1] =e1[2] + e1[3] ; 
   
   
   for (i=0;i<3;i=i+1) 
    begin
        temp1[i] = (c1[i]*(r**(i<<1)));
        G1 = G1 + temp1[i];
    end
  end 
  
  
  always@(*)
    begin
    
    for (i = 0; i<4 ; i=i+1) begin 
    e2[i] = $signed (a2[i]) * $signed(b2[i]); 
    end 
    
   G2=0;
   c2[0] = e2[0];  
   c2[2] = e2[1];
   c2[1] = e2[2] + e2[3] ; 
   
   
   for (i=0;i<3;i=i+1) 
    begin
        temp2[i] = (c2[i]*(r**(i<<1)));
        G2 = G2 + temp2[i];
    end
  end 
  
   
  assign out = (G2*(r**2)) + ((G1 - G0 - G2)*r) + G0;
endmodule


(* use_dsp = "no" *) module karatsuba_upper_overlapfree #(parameter N=1028, parameter k=4,parameter m=257,parameter p =32) (input [N-1:0]A,B, output reg [2*N-1:0]q);

     
  wire [N/k+1:0] a0[2:0];
  wire [N/k+1:0] a1[2:0];
  wire [N/k+1:0] a2[2:0];
  wire [N/k+1:0] b0[2:0]; 
  wire [N/k+1:0] b1[2:0]; 
  wire [N/k+1:0] b2[2:0];
  reg [ 2*N/k+3:0] e0[2:0]; 
  reg [ 2*N/k+3:0] e1[2:0]; 
  reg [2*N/k+3:0] e2[2:0];
  reg [ 2*N/k+3:0] c0[1:0];
  reg [ 2*N/k+4:0] c1[1:0];  
  reg [ 2*N/k+3:0] c2[1:0];
  reg [2*N-1 :0] temp0[1:0];
  reg [2*N-1 :0] temp1[1:0];
  reg [2*N-1 :0] temp2[1:0];
  wire [(N/k):0]A0,A1,A2,A3,B0,B1,B2,B3;
  wire [N-1:0]r;
  reg [2*N-1:0]G0,G1,G2; 
//   reg [2*N-1:0]out;
  

  assign r = 2**m;
  assign A3 = A[(N-1):(N-(N/k))];
  assign A2 = A[(N-(N/k)-1):(N/2)];
  assign A1 = A[((N/2)-1):(N/k)];
  assign A0 = A[((N/k)-1):0];
  
  assign B3 = B[(N-1):(N-(N/k))];
  assign B2 = B[(N-(N/k)-1):(N/2)];
  assign B1 = B[((N/2)-1):(N/k)];
  assign B0 = B[((N/k)-1):0];
  
  
  assign a0[0] = A0;
  assign a0[1] = A2; 
  assign a0[2] = A2; 
  
  assign a1[0] = A0 + A1; 
  assign a1[1] = A2 + A3; 
  assign a1[2] = A2 + A3; 

  assign a2[0] = A1;
  assign a2[1] = A3; 
  assign a2[2] = A3; 
  
  
  assign b0[0] = B2; 
  assign b0[1] = B0; 
  assign b0[2] = B2; 
  
  
  assign b1[0] = B2 + B3; 
  assign b1[1] = B0 + B1;
  assign b1[2] = B2 + B3; 
  
  
  assign b2[0] = B3; 
  assign b2[1] = B1; 
  assign b2[2] = B3; 
  
  
 integer i =0; 
 integer j =0; 
 integer d=0;
 
 
// booth #(m+2,(2*m)+4) inst0 (a0[0],b0[0],e0[0]);
  
//  booth #(m+2,(2*m)+4) inst1 (a0[1],b0[1],e0[1]);
  
//  booth #(m+2,(2*m)+4) inst2 (a0[2],b0[2],e0[2]);
  
 
  
//  booth #(m+2,(2*m)+4) inst4 (a1[0],b1[0],e1[0]);
  
//  booth #(m+2,(2*m)+4) inst5 (a1[1],b1[1],e1[1]);
  
//  booth #(m+2,(2*m)+4) inst6 (a1[2],b1[2],e1[2]);
  
 
  
//  booth #(m+2,(2*m)+4) inst8 (a2[0],b2[0],e2[0]);
  
//  booth #(m+2,(2*m)+4) inst9 (a2[1],b2[1],e2[1]);
  
//  booth #(m+2,(2*m)+4) inst10 (a2[2],b2[2],e2[2]);
  
  
 always@(*) begin 
 
    for (j = 0; j<3 ; j=j+1) begin 
    e0[j] = $signed (a0[j]) * $signed(b0[j]); 
    end 

   G0=0;
   c0[0] = e0[0] + e0[1]; 
   c0[1] = e0[2] ;
  
   for (j=0;j<2;j=j+1) 
    begin
        temp0[j] = (c0[j]*(r**((j+1)<<1)));
        G0 = G0 + temp0[j];
    end
  end 
  
    
  always@(*) begin 
  
  
    for (i = 0; i<3 ; i=i+1) begin 
    e1[i] = $signed (a1[i]) * $signed(b1[i]); 
    end 

   G1=0;
   c1[0] = e1[0] + e1[1]; //   c[1] = e[0] + e[1]; 
   c1[1] = e1[2];
  
   for (i=0;i<2;i=i+1) 
    begin
        temp1[i] = (c1[i]*(r**((i+1)<<1)));
        G1 = G1 + temp1[i];
    end
  end 
  
  
  always@(*) begin
  
  
    for (d = 0; d<3 ; d=d+1) begin 
    e2[d] = $signed (a2[d]) * $signed(b2[d]); 
    end 
    
   G2=0;
   c2[0] = e2[0] + e2[1]; 
   c2[1] = e2[2];
      
   for (d=0;d<2;d=d+1) 
    begin
        temp2[d] = (c2[d]*(r**((d+1)<<1)));
        G2 = G2 + temp2[d];
    end
//     q =  ( ( G1 - G2 - G0) * r ) + (G2 * (r ** 2)) + ( A2 * B2 * (r ** 4))  + ( A1 * B1 * (r ** 2 ) );
    q =  ( ( G1 - G2 - G0) * r ) + ( G2 * (r ** 2)) + ( A2 * B2 * (r ** 4));
    
    
    
//    q = out >> p;
    
  end 
  
   
  
                                              
endmodule


(* use_dsp = "no" *) module karatsuba_lower_overlapfree #(parameter N=1028, parameter k=4,parameter m=257,parameter f = 1026) (input [N-1:0]A,input [N-1:0]B, output [2*N-1:0]out);

 
    
  wire [N/k+1:0] a0[2:0];
  wire [N/k+1:0] a1[2:0];
  wire [N/k+1:0] a2[2:0];
  wire [N/k+1:0] b0[2:0]; 
  wire [N/k+1:0] b1[2:0]; 
  wire [N/k+1:0] b2[2:0];
  reg [ 2*N/k+3:0] e0[2:0]; 
  reg [ 2*N/k+3:0] e1[2:0]; 
  reg [2*N/k+3:0] e2[2:0];
  reg [ 2*N/k+3:0] c0[1:0];
  reg [ 2*N/k+4:0] c1[1:0];  
  reg [ 2*N/k+3:0] c2[1:0];
  reg [2*N-1 :0] temp0[1:0];
  reg [2*N-1 :0] temp1[1:0];
  reg [2*N-1 :0] temp2[1:0];
  wire [(N/k):0]A0,A1,A2,A3;
  wire [(N/k):0]B0,B1,B2,B3;
  wire [N-1:0]r;
  reg [2*N-1:0]G0,G1,G2; 
  wire [2*N-1:0]out_inter;
  

  assign r = 2**m;
  assign A3 = A[(N-1):(N-(N/k))];
  assign A2 = A[(N-(N/k)-1):(N/2)];
  assign A1 = A[((N/2)-1):(N/k)];
  assign A0 = A[((N/k)-1):0];
  
  assign B3 = B[(N-1):(N-(N/k))];
  assign B2 = B[(N-(N/k)-1):(N/2)];
  assign B1 = B[((N/2)-1):(N/k)];
  assign B0 = B[((N/k)-1):0];
  
  
  assign a0[0] = A0;
  assign a0[1] = A2;
  assign a0[2] = A0; 
  
  assign a1[0] = A0 + A1; 
  assign a1[1] = A2 + A3; 
  assign a1[2] = A0 + A1; 

  assign a2[0] = A1;
  assign a2[1] = A3; 
  assign a2[2] = A1; 
  
  assign b0[0] = B0; 
  assign b0[1] = B0; 
  assign b0[2] = B2; 
  
  
  assign b1[0] = B0 + B1; 
  assign b1[1] = B0 + B1; 
  assign b1[2] = B2 + B3;
  
  
  assign b2[0] = B1; 
  assign b2[1] = B1; 
  assign b2[2] = B3;
  
  
 integer i =0; 
 integer j =0; 
 integer d=0;
 
//  booth #(m+2,(2*m)+4) inst0 (a0[0],b0[0],e0[0]);
  
//  booth #(m+2,(2*m)+4) inst1 (a0[1],b0[1],e0[1]);
  
//  booth #(m+2,(2*m)+4) inst2 (a0[2],b0[2],e0[2]);
  
 
  
//  booth #(m+2,(2*m)+4) inst4 (a1[0],b1[0],e1[0]);
  
//  booth #(m+2,(2*m)+4) inst5 (a1[1],b1[1],e1[1]);
  
//  booth #(m+2,(2*m)+4) inst6 (a1[2],b1[2],e1[2]);
  
 
  
//  booth #(m+2,(2*m)+4) inst8 (a2[0],b2[0],e2[0]);
  
//  booth #(m+2,(2*m)+4) inst9 (a2[1],b2[1],e2[1]);
  
//  booth #(m+2,(2*m)+4) inst10 (a2[2],b2[2],e2[2]);
    
 always@(*) begin 
 
   for (j = 0; j<3 ; j=j+1) begin 
    e0[j] = $signed (a0[j]) * $signed(b0[j]); 
    end
    
   G0=0;
   c0[0] = e0[0]; 
   c0[1] =  e0[1] + e0[2] ;
  
   
  
   for (j=0;j<2;j=j+1) 
    begin
        temp0[j] = (c0[j]*(r**(j<<1)));
        G0 = G0 + temp0[j];
    end
  end 
  
    
  always@(*) begin 
  
  for (i = 0; i<3 ; i=i+1) begin 
    e1[i] = $signed (a1[i]) * $signed(b1[i]); 
    end 
   
   G1=0;
   c1[0] = e1[0];  
   c1[1] = e1[1] + e1[2];
  
   for (i=0;i<2;i=i+1) 
    begin
        temp1[i] = (c1[i]*(r**(i<<1)));
        G1 = G1 + temp1[i];
    end
  end 
  
  
  always@(*)
    begin
    
    for (d = 0; d<3 ; d=d+1) begin 
    e2[d] = $signed (a2[d]) * $signed(b2[d]); 
    end 
    
   G2=0;
   c2[0] = e2[0] ; 
   c2[1] = e2[1] + e2[2];
   
   
   for (d=0;d<2;d=d+1) 
    begin
        temp2[d] = (c2[d]*(r**(d<<1)));
        G2 = G2 + temp2[d];
    end
  end 
  
   
  assign out_inter =  ( ( G1 - G2 - G0) * r ) + G0 + (A1*B1*(r**2));
  assign out = out_inter[f-1:0];
                                                
endmodule


//module booth #(parameter REG_WIDTH = 11, parameter OUT_WIDTH = 22)(
  
//    input [REG_WIDTH-1:0] A, B,
//    output reg [OUT_WIDTH-1:0] P
//);
    
//    reg [OUT_WIDTH-1:0] partial_sum;
//    reg [REG_WIDTH:0] booth_reg;
//    integer i;
    
//    always @(*) begin
        
//        booth_reg = {B, 1'b0};
//        partial_sum = 0;
        
//        for (i = 0; i < REG_WIDTH / 2; i = i + 1) begin
//            case (booth_reg[2:0])
//                3'b000, 3'b111: partial_sum = partial_sum;            
//                3'b001, 3'b010: partial_sum = partial_sum + (A << ( i<<1)); 
//                3'b011:          partial_sum = partial_sum + (A << ((i<<1) + 1)); 
//                3'b100:          partial_sum = partial_sum - (A << ((i<<1) + 1)); 
//                3'b101, 3'b110:  partial_sum = partial_sum - (A << ((i<<1))); 
//            endcase
//            booth_reg = booth_reg >> 2; 
//        end
        
//        P = partial_sum;
//    end

//endmodule
 
 
        
       
        
        
	
	
	
	





