module hockey_tb();


  parameter HP = 5;       // Half period of our clock signal
  parameter FP = (2*HP);  // Full period of our clock signal

  reg clk, rst, BTNA, BTNB;
  reg [1:0] DIRA;
  reg [1:0] DIRB;
  reg [2:0] YA;
  reg [2:0] YB;
  
  wire [6:0] SSD0,SSD1,SSD2,SSD3,SSD4,SSD5,SSD6,SSD7;

  wire LEDA;
  wire LEDB;
  wire [4:0] LEDX;

  wire [2:0] Y;
  wire [2:0] X;

  // Our design-under-test is the DigiHockey module
  hockey dut(clk, rst, BTNA, BTNB, DIRA, DIRB, YA, YB,LEDA,LEDB,LEDX, SSD7,SSD6,SSD5,SSD4,SSD3,SSD2,SSD1,SSD0, Y,X);

  // This always statement automatically cycles between clock high and clock low in HP (Half Period) time. Makes writing test-benches easier.
  always #HP clk = ~clk;

  initial
  begin
	$dumpfile("DigiHockey.vcd"); //  * Our waveform is saved under this file.
    $dumpvars(0,hockey_tb); // * Get the variables from the module.
	$display("Simulation started.");

  clk = 0;
  #HP
  rst = 1;
  #FP
  rst = 0;
  YA = 0;
  BTNA = 1;
  BTNB = 0;
  #FP
  #FP
  BTNA = 0; 
  #30
  BTNA = 1;
  #30
  BTNA =0;
  #5000

  
  // Here, you are asked to write your test scenario.



	$display("Simulation finished.");
    $finish(); // Finish simulation.
  end



endmodule

