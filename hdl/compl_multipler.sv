module compl_multipler (
    input clk_i,
    input srst_n,

    input logic signed [17:0] data_a_i_i,
    input logic signed [17:0] data_a_q_i,

    input logic signed [17:0] data_b_i_i,
    input logic signed [17:0] data_b_q_i,

    output logic signed [(18*2)-1:0] data_i_o,
    output logic signed  [(18*2)-1:0] data_q_o
);

    assign data_i_o = data_a_i_i * data_b_i_i - data_a_q_i * data_b_q_i;
    assign data_q_o = data_a_i_i * data_b_q_i + data_a_q_i * data_b_i_i;
    
endmodule