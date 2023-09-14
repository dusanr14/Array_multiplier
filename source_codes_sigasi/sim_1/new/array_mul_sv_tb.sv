`timescale 1ns/1ps

module array_multiplier_sv_tb;

  // Parameters
  localparam WIDTHM = 4;
  localparam WIDTHQ = 4;
  localparam WIDTHP = 8;

  // Inputs
  logic clk;
  logic rstN;
  logic [WIDTHM-1:0] m_i;
  logic [WIDTHQ-1:0] q_i;

  // Outputs
  logic [WIDTHP-1:0] product_o;

  logic [WIDTHP-1:0] product_expected [$] = {0,0,0};
  logic [WIDTHP-1:0] product_expected_s;
  // Instantiate the DUT (Design Under Test)
  array_multiplier dut (
    .clk(clk),
    .rstN(rstN),
    .m_i(m_i),
    .q_i(q_i),
    .product_o(product_o)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // Reset generation
  initial begin
    rstN = 0;
    #50 rstN = 1;
  end

  // Test case
  initial begin
    // Provide some inputs
    bit [WIDTHM+WIDTHQ-1:0] m_i_rnd;
    
    m_i <= 6; // Assign the randomized value to m_i
    q_i <= 14;
        
    for(int i = 0; i < 2^WIDTHP; i++) begin
        m_i_rnd <= i; // Randomize m_i_rnd
        m_i <= m_i_rnd[WIDTHM+WIDTHQ-1 : WIDTHM]; // Assign the randomized value to m_i
        q_i <= m_i_rnd[WIDTHM-1 : 0];
        #5
        //product_expected.push_front(m_i * q_i);
        product_expected_s = m_i * q_i;
//        assert(product_expected_s == product_o) begin
//            $display("Good!");
//            $display("\expected = %0d, real = %0d", product_expected_s,product_o);
//        end
//        else begin
//            $display(" Error, ");
//            $display("\expected = %0d, real = %0d", product_expected_s,product_o);
//            $finish;
//        end
    // Wait a few cycles for the computation to complete
    #100;
    end;
    // Display the output
    //$display("Product: %h", product_o);

    // Add more test cases here if needed
    // ...

    // Terminate the simulation
    $finish;
  end

endmodule
