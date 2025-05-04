// `timescale 1ns/10ps //with line Vivado Sim run with error

module tb;

    parameter int CLK_PERIOD = 10;
    parameter int AMOUNT_DATASETS = 50;

    class complex_num;
        rand longint re;
        rand longint im;

        constraint re_c {
            im <= 131072; // 2**(18-1)
            im >= -131072;
        };

        constraint im_c {
            im <= 131072;
            im >= -131072;
        };
    endclass

    function void compl_mult_ref(complex_num a_in, complex_num b_in, complex_num out);
        out.re = (18'(a_in.re)) * (18'(b_in.re)) - (18'(a_in.im)) * (18'(b_in.im));
        out.im = (18'(a_in.re)) * (18'(b_in.im)) + (18'(a_in.im)) * (18'(b_in.re));   
    endfunction

    logic clk_i;
    logic srst_n;

    logic signed [17:0] data_a_i_i;
    logic signed [17:0] data_a_q_i;

    logic signed [17:0] data_b_i_i;
    logic signed [17:0] data_b_q_i;

    logic signed [(18*2)-1:0] data_i_o;
    logic signed  [(18*2)-1:0] data_q_o;

    compl_multipler dut (
        .*
    );

    task reset();
        $display("RESET!, %0t", $time());
        srst_n <= 0;
        #(CLK_PERIOD * 8);
        srst_n <= 1;
    endtask;

    initial begin : clk_config
        clk_i <= 'b0;
        forever begin
            #(CLK_PERIOD/2) clk_i <= ~clk_i;
        end
    end

    initial begin : main
        fork
            reset();
        join_none;
        fork begin
            complex_num a = new;
            complex_num b = new;
            complex_num res = new;

            wait(~srst_n);
            data_a_i_i <= 'b0;
            data_a_q_i <= 'b0;
            data_b_i_i <= 'b0;
            data_b_q_i <= 'b0;
            wait(srst_n)

            repeat (AMOUNT_DATASETS) begin
                @(posedge clk_i);
                compl_mult_ref(a, b, res);
                if (data_i_o != res.re || data_q_o != res.im) begin
                    $error(
                        "%0t Invalid res!!! True: %d, %d; Expec: %d, %d;",
                        $time(),
                        res.re,
                        res.im,
                        data_i_o,
                        data_q_o
                    );
                end
                if(!a.randomize()) begin
                    $error("Can't randomize a dataset!");
                    $finish();
                end
                if(!b.randomize()) begin
                    $error("Can't randomize b dataset!");
                    $finish();
                end
                data_a_i_i <= a.re;
                data_a_q_i <= a.im;
                data_b_i_i <= b.re;
                data_b_q_i <= b.im;
            end
        end join
        $display("Test was finished!");
        $finish();
    end

endmodule