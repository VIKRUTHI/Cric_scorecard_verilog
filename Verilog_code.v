//Cricket_scorecard_verilog_code_top_module
`timescale 1ns/1ns
module cric_project(rst,valid_s,valid_w,valid_b,score1,score2,score3,overs1,overs2,ball,wicket,HEX0,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7);
  input rst; 
  input valid_s; 
  input valid_w; 
  input valid_b;
  output reg [3:0] score1,score2,score3;
  output reg [3:0] overs1,overs2,ball;
  output reg [3:0] wicket;
  output [6:0] HEX0,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;

// Internal registers for score, overs, ball, and wicket
  reg [3:0] score_reg1,score_reg2,score_reg3;
  reg [3:0] overs_reg1,overs_reg2,ball_reg;
  reg [3:0] wicket_reg;

// BCD decoder modules for each digit
  BCD1 c2(.HEX0(HEX0), .SW(ball));
  BCD1 c3(.HEX0(HEX2), .SW(overs2));
  BCD1 c4(.HEX0(HEX3), .SW(overs1));
  BCD1 c5(.HEX0(HEX4), .SW(score3));
  BCD1 c6(.HEX0(HEX5), .SW(score2));
  BCD1 c7(.HEX0(HEX6), .SW(score1));
  BCD1 c1(.HEX0(HEX7), .SW(wicket));

// Always block to update score when valid_s is asserted
always @( valid_s)
begin
  if(rst)
    begin
        score_reg1 = 4'b0000;
        score_reg2 = 4'b0000;
        score_reg3 = 4'b0000; 
	 end
 else
    begin
      if (valid_s)
		 begin
         score_reg3 = score_reg3 + 1;
    
    if (score_reg3 == 4'b1010)
	     begin
        score_reg3 = 4'b0000;
        score_reg2 = score_reg2 + 1'b1;
        
        if (score_reg2 == 4'b1010)
		     begin
            score_reg2 = 4'b0000;
            score_reg1 = score_reg1 + 1'b1;
           end
        end
     end
  end
end

// Always block to update ball when valid_b is asserted  
always @( valid_b) begin
if(rst)
begin
        overs_reg1 = 4'b0000;
        overs_reg2 = 4'b0000;
        ball_reg = 4'b0000;
end
else
begin
     if (valid_b) begin
        ball_reg = ball_reg + 1'b1;
        
        if (ball_reg == 7) begin
            ball_reg = 4'b0001;
            overs_reg2 = overs_reg2 + 1'b1;
            
            if (overs_reg2 == 4'b1010) begin
                overs_reg2 = 4'b0000;
                overs_reg1 = overs_reg1 + 1'b1;
            end
        end
    end
end
end

// Always block to update wicket when valid_w is asserted
  always @( valid_w)
    begin
    if (rst)
	  wicket_reg = 4'b0000;  
	 else
	 begin
	 if (valid_w)
      begin
      wicket_reg = wicket_reg + 1'b1;
      end
   end
	end

// Always block to assign output registers
  always @(posedge valid_s or posedge valid_b or posedge valid_w)
    begin
    score1 = score_reg1;score2 = score_reg2;score3 = score_reg3;
    overs1 = overs_reg1; overs2 = overs_reg2;ball = ball_reg;
    wicket = wicket_reg;
    end

endmodule

// Seven Segment Display
 
module BCD1(HEX0,SW);
input [3:0] SW;
output [6:0] HEX0;
reg [6:0] HEX0;
// seg = {g,f,e,d,c,b,a};
// 0 is on and 1 is off

always @ (SW)
case (SW)
4'h0: HEX0 = 7'b1000000;
4'h1: HEX0 = 7'b1111001; // ---a----
4'h2: HEX0=  7'b0100100; // |       |
4'h3: HEX0 = 7'b0110000; // f       b
4'h4: HEX0 = 7'b0011001; // |       |
4'h5: HEX0 = 7'b0010010; // ---g----
4'h6: HEX0 = 7'b0000010; // |       |
4'h7: HEX0 = 7'b1111000; // e       c
4'h8: HEX0 = 7'b0000000; // |       |
4'h9: HEX0 = 7'b0011000; // ---d----
default : HEX0 = 7'b0111111;
endcase

endmodule


//testbench_for_cricket_scorecard
module cric_project_tb;

  // Inputs
  reg rst;
  reg valid_s;
  reg valid_w;
  reg valid_b;

  // Outputs
  wire [3:0] score1, score2, score3;
  wire [3:0] overs1, overs2, ball;
  wire [3:0] wicket;

  // Variable to store the file descriptor for the output file
  integer info;

  // Instantiate the cric_project module
  cric_project uut (
    .rst(rst),
    .valid_s(valid_s),
    .valid_w(valid_w),
    .valid_b(valid_b),
    .score1(score1),
    .score2(score2),
    .score3(score3),
    .overs1(overs1),
    .overs2(overs2),
    .ball(ball),
    .wicket(wicket)
  );

  // Generate the clock signal
  always #1 valid_b = ~valid_b; // Toggle every 1 time unit
  always #5 valid_s = ~valid_s; // Toggle every 5 time units
  always #100 valid_w = ~valid_w; // Toggle every 50 time units

  // Initialize the file for writing score updates
  initial begin
    info = $fopen("scoreboard.txt"); // Open the file "scoreboard.txt" for writing
  end

  // Initialize inputs
  initial begin
    rst = 1; // Set reset to high for 10 time units
    valid_s = 0; // Initialize valid_s to low
    valid_w = 0; // Initialize valid_w to low
    valid_b = 0; // Initialize valid_b to low

    #10 rst = 0; // Reset the circuit after 10 time units

    #1000 $stop; // Stop the simulation after 10000 time units
  end

  // Monitor score updates and display them on the console
  initial begin
    $monitor($time, "   score=[%d%d%d]  overs=[%d%d]   ball=%d    wicket=%d",
             score1, score2, score3, overs1, overs2, ball, wicket); // Display score updates on the console
  end

  // Write score updates to the file
  initial begin
    $fmonitor(info, $time, "   score=[%d%d%d]  overs=[%d%d]   ball=%d    wicket=%d",
              score1, score2, score3, overs1, overs2, ball, wicket); // Write score updates to the file
    #1000 $stop; // Stop the simulation and close the file after 10000 time units
    $fclose(info); // Close the file
  end

endmodule
