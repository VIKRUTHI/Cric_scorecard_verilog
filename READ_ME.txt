The step-by-step procedure for simulation in Modelsim and implementation in Quartus Prime using DE-115 FPGA board:

Simulation in Modelsim
1.	Create a new project: Open Modelsim and create a new project for your design.
2.	Add source files: Add the Verilog files for your design to the project. In this case, you will need to add the cric_project.v and cric_project_tb.v files.
3.	Compile the design: Compile the design by clicking on the "Compile" button or by selecting "Compile" from the "Design" menu.
4.	Start the simulation: Start the simulation by clicking on the "Start" button or by selecting "Start" from the "Simulation" menu.
5.	View the waveforms: You can view the waveforms for the signals in your design by double-clicking on the signal name in the "Waveforms" window.
6.	Stop the simulation: Stop the simulation by clicking on the "Stop" button or by selecting "Stop" from the "Simulation" menu.

Implementation in Quartus Prime
1.	Create a new project: Open Quartus Prime and create a new project for your design.
2.	Add source files: Add the Verilog files for your design to the project. In this case, you will need to add the cric_project.v and cric_project_tb.v files.
3.	Set the target device: Select the DE-115 FPGA board as the target device for your design.
4.	Assign pins: Assign the pins for your design to the corresponding pins on the DE-115 FPGA board.
5.	Compile the design: Compile the design by clicking on the "Compile" button or by selecting "Compile" from the "Process" menu.
6.	Generate the programming file: Generate the programming file for your design by clicking on the "Programmer" button or by selecting "Programmer" from the "Tools" menu.
7.	Download the programming file to the FPGA board: Download the programming file to the DE-115 FPGA board using the USB Blaster cable.
8.	Run the design: Run the design by pressing the "Reset" button on the DE-115 FPGA board.
9.	Verify the design: Verify that the design is running correctly by observing the LEDs on the DE-115 FPGA board.

Additional notes:
•	You will need to download and install the Modelsim and Quartus Prime software if you do not already have it.
•	You will need to have a USB Blaster cable to connect the DE-115 FPGA board to your computer.

