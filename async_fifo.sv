module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(FIFO_DEPTH)
)(
    input  logic                  wr_clk,
    input  logic                  rd_clk,
    input  logic                  rst_n,
    input  logic                  wr_en,
    input  logic [DATA_WIDTH-1:0] wr_data,
    input  logic                  rd_en,
    output logic [DATA_WIDTH-1:0] rd_data,
    output logic                  full,
    output logic                  empty
);
    // Memory storage
    logic [DATA_WIDTH-1:0] fifo_mem[FIFO_DEPTH-1:0];

    // Read and write pointers
    logic [ADDR_WIDTH:0] wr_ptr = 0;
    logic [ADDR_WIDTH:0] rd_ptr = 0;

    // Synchronization of pointers across clock domains
    logic [ADDR_WIDTH:0] rd_ptr_sync1, rd_ptr_sync2;
    logic [ADDR_WIDTH:0] wr_ptr_sync1, wr_ptr_sync2;

    // Pointer increment logic and read/write pointer synchronization
    always_ff @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
            rd_ptr_sync1 <= 0;
            rd_ptr_sync2 <= 0;
        end else if (wr_en && !full) begin
            wr_ptr <= wr_ptr + 1;
            rd_ptr_sync1 <= rd_ptr;
            rd_ptr_sync2 <= rd_ptr_sync1;
        end
    end

    always_ff @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= 0;
            wr_ptr_sync1 <= 0;
            wr_ptr_sync2 <= 0;
        end else if (rd_en && !empty) begin
            rd_ptr <= rd_ptr + 1;
            wr_ptr_sync1 <= wr_ptr;
            wr_ptr_sync2 <= wr_ptr_sync1;
        end
    end

    // FIFO memory write logic
    always_ff @(posedge wr_clk) begin
        if (wr_en && !full) begin
            fifo_mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data;
        end
    end

    // FIFO memory read logic
    always_ff @(posedge rd_clk) begin
        if (rd_en && !empty) begin
            rd_data <= fifo_mem[rd_ptr[ADDR_WIDTH-1:0]];
        end
    end

    // Full and empty logic
    assign full = ((wr_ptr[ADDR_WIDTH]     != rd_ptr_sync2[ADDR_WIDTH]) &&
                   (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr_sync2[ADDR_WIDTH-1:0]));
    assign empty = (wr_ptr_sync2 == rd_ptr);

endmodule
