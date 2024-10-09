module fifo #(parameter int PTR_WIDTH = 8)
(
  input  wire  aclk_wr,
  input  wire  aclk_rd,
  input  wire  aresetn_wr,
  input  wire  aresetn_rd,
  input  logic data_wr,
  input  logic data_rd,
  output logic oflow,
  output logic uflow
);

  logic [PTR_WIDTH-1:0] wr_ptr;
  logic [PTR_WIDTH-1:0] rd_ptr;
  logic overflow, underflow;
  logic [PTR_WIDTH-1:0] rd_ptr_s0, rd_ptr_s1, rd_ptr_sync;
  logic [PTR_WIDTH-1:0] wr_ptr_s0, wr_ptr_s1, wr_ptr_sync;

  assign oflow = overflow;
  assign uflow = underflow;
  assign overflow  = (bin2gray(wr_ptr) == bin2gray(rd_ptr_sync + 1)) ? 1 : 0;
  assign underflow = (bin2gray(rd_ptr) == bin2gray(wr_ptr_sync)) ? 1 : 0;

  // Binary to Gray conversion
  function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] binary);
    bin2gray = binary ^ (binary >> 1);
  endfunction

  always_ff @(posedge aclk_wr) begin
    if (!aresetn_wr) begin
      rd_ptr_s0   <= 'b0;
      rd_ptr_sync <= 'b0;
    end
    else begin
      rd_ptr_s0   <= rd_ptr;
      rd_ptr_sync <= rd_ptr_s0;
    end
  end

  always_ff @(posedge aclk_rd) begin
    if (!aresetn_rd) begin
      wr_ptr_s0   <= 'b0;
      wr_ptr_sync <= 'b0;
    end
    else begin
      wr_ptr_s0   <= wr_ptr;
      wr_ptr_sync <= wr_ptr_s0;
    end
  end

  always_ff @(posedge aclk_wr) begin
    if  (!aresetn_wr) begin
      wr_ptr <= 'b0;
    end
    else begin
      if (data_wr & !overflow) begin
        wr_ptr++;
      end
    end
  end

  always_ff @(posedge aclk_wr) begin
    if  (!aresetn_rd) begin
      rd_ptr <= 'b0;
    end
    else begin
      if (data_rd & !underflow) begin
          rd_ptr++;
      end
    end
  end

endmodule : fifo