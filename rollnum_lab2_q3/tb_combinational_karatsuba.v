`timescale 1ns/1ps

module tb_combinational_karatsuba;

parameter N = 16;

// declare your signals as reg or wire

initial begin

// write the stimuli conditions

end

karatsuba_16 dut (.X(X), .Y(Y), .Z(Z));

initial begin
    $dumpfile("combinational_karatsuba.vcd");
    $dumpvars(0, tb_combinational_karatsuba);
end

endmodule
