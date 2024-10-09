module tb_fifo();

  logic aclk_wr = '0;
  logic aclk_rd = '0;
  logic aresetn_wr = '0;
  logic aresetn_rd = '0;
  logic data_wr = '0;
  logic data_rd = '0;
  logic oflow = '0;
  logic uflow = '0;

  time wr_clk_period = 10ns;
  time rd_clk_period = 5ns;

  fifo #(.PTR_WIDTH(8)) 
  fifo_inst (
    .aclk_wr(aclk_wr),
    .aclk_rd(aclk_rd),
    .aresetn_wr(aresetn_wr),
    .aresetn_rd(aresetn_rd),
    .data_wr(data_wr),
    .data_rd(data_rd),
    .oflow(oflow),
    .uflow(uflow)
  );

  // Clock generation process
  initial begin
    aclk_wr = 1'b0;  // Initialize the clock to low
    aclk_rd = 1'b0;  // Initialize the clock to low
    // Generate clock with 50% duty cycle
    forever #(wr_clk_period / 2) aclk_wr = ~aclk_wr;
    forever #(rd_clk_period / 2) aclk_rd = ~aclk_rd;
  end

  // Write
  initial begin
    // Simulation run for a specific duration
    #(wr_clk_period*40);
    aresetn_wr <= 1'b1;
    #(wr_clk_period*40);
    $display("Ending simulation.");
    $finish;  // Terminate simulation
  end

  // Read
  initial begin
    // Simulation run for a specific duration
    #(rd_clk_period*40);
    aresetn_rd <= 1'b1;
    #(rd_clk_period*40);
    $display("Ending simulation.");
    $finish;  // Terminate simulation
  end

endmodule