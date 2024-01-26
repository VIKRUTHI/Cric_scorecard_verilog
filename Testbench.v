
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
