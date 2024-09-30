`timescale 1ns/1ps

module tb_rca_32_bit;

parameter N = 32;

// declare your signals as reg or wire
reg [3:0] a,b;
wire [7:0] c;
wire [1:0] p,q,r,s;
wire [3:0] subt;
wire coutt;

// wire [1:0] hi, out;
// wire alpha;

// assign alpha = 1;
// assign hi = 2'b01;
// // assign out = 2'b00;

// assign out[0] = hi[0] & alpha;
// assign out[1] = hi[1] & alpha;


initial begin	

// write the stimuli conditions
    // $monitor("a=%b, b=%b, subt=%b, coutt=%b",a,b,subt, coutt);
    // $display("out=%b",out);

    $monitor("a=%b, b=%b, c=%b",a,b,c);
    
    // #10;
    // a = 4'b1011; b = 4'b0001;#5;
    a = 4'b1111; b = 4'b1111;#5;


end

// rca_Nbit_subtractor #(.N(4)) babab(.a(a), .b(b), .S(subt), .coutt(coutt));

bit4_mul hii (.a(a), .b(b), .c(c));


// initial begin
//     $dumpfile("combinational_karatsuba.vcd");
//     $dumpvars(0, tb_rca_32_bit);
// end

endmodule





// 2 bit multiply succesfull
