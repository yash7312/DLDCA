module half_adder(a, b, S, cout);
input   a;
input   b;
output   S;
output   cout;

assign S = a ^ b;
assign cout = a & b;

endmodule



module full_adder(a, b, cin, S, cout);

input   a;
input   b;
inout cin;
inout   S;
output   cout;

//assign S = a ^ b ^ cin;
//assign cout = (a&b)|(b&cin)|(a&cin);
wire S1,C1,C2;
half_adder u0(a,b,S1,C1);
half_adder u1(S1,cin,S,C2);
or ads(cout,C1,C2);
endmodule

module rca_Nbit #(parameter N = 32) (a, b, cin, S, coutt);
//rca_Nbit #(.N(4)) (.a(), .b(), .cin(), .S(), .coutt());

input   [N-1:0]   a;
input   [N-1:0]   b;
input cin;
output   [N-1:0]   S,cout;
output coutt;




full_adder potato(a[0],b[0],cin,S[0],cout[0]);


genvar i;
generate
    
    
    for( i = 1; i < N; i = i + 1) begin

        full_adder u0 (.a(a[i]),.b(b[i]),.cin(cout[i-1]),.S(S[i]),.cout(cout[i]));
        

    end
endgenerate


assign coutt = cout[N-1];

endmodule

module rca_Nbit_subtractor #(parameter N = 32) (a, b, S, coutt);
//rca_Nbit #(.N(4)) (.a(), .b(), .cin(), .S(), .coutt());

input   [N-1:0]   a;
input   [N-1:0]   b, bi;
input cin;
output   [N-1:0]   S,cout;
output coutt;

assign cin = 1'b1;

genvar j;
generate
    
    
    for( j = 0; j < N; j = j + 1) begin

        xor baba(bi[j], b[j], cin);
        

    end
endgenerate



full_adder potato(a[0],bi[0],cin,S[0],cout[0]);


genvar i;
generate
    
    
    for( i = 1; i < N; i = i + 1) begin

        full_adder u0 (.a(a[i]),.b(bi[i]),.cin(cout[i-1]),.S(S[i]),.cout(cout[i]));
        

    end
endgenerate


assign coutt = ~cout[N-1];

endmodule



//multiply 2 bit size

module bit2_mul (a,b,c);
input [1:0]a,b;

input temp1, temp2;
assign temp2 = 1'b0;
output [3:0] c;



//axb

assign c[0] = b[0]&a[0];

full_adder c1(.a(b[0]&a[1]), .b(b[1]&a[0]), .cin(temp2), .S(c[1]), .cout(temp1));
full_adder c2(.a(b[1]&a[1]), .b(temp2), .cin(temp1), .S(c[2]), .cout(c[3]));


endmodule



module bit4_mul (a,b,c);
input [3:0] a,b;
output [7:0] c;
inout [1:0] p,q,r,s;
input null;
assign null = 1'b0;



inout [7:0] cmid, cfull;
// assign cfull = 8'b0;
// assign cmid = 8'b0;

parameter bit4 = 4;
parameter bit8 = 8;

// input [1:0] p,q,r,s

assign p[0] = a[2];
assign p[1] = a[3];

assign q = a[1:0];
assign r[1:0] = b[3:2];
assign s[1:0] = b[1:0];



output [3:0] pr, ps, qr, qs;

bit2_mul ml1 (.a(p), .b(r), .c(pr)); // 1ST USE

input [1:0] p_q, r_s;
input alpha, beta;
parameter bit2 = 2;


// assign alpha = 1'b0;
// assign beta = 1'b0;

rca_Nbit #(.N(bit2)) add1 (.a(p), .b(q), .cin(null), .S(p_q), .coutt(alpha));

rca_Nbit #(.N(bit2)) add2 (.a(r), .b(s), .cin(null), .S(r_s), .coutt(beta));

// 2nd USE

/////////////////////////////////////////////////cfull checkkk////////////////////////////////////////////////////////////////

//rca_Nbit #(.N(4)) (.a(), .b(), .cin(), .S(), .coutt());
////////////
input [7:0] term1, term2,term3, cmid_temp;
output rough_catch;
// assign cmid_temp = 8'b0;
// assign term1 = 8'b0;

////////////


// assign term1[6] = alpha & beta;
and asdnoas(term1[6], alpha, beta);
assign term1[7] = 0;
assign term1[5:0] = 0;



// assign term2 = 8'b0;


rca_Nbit #(.N(bit2)) jane(.a({2{beta}} & p_q), .b({2{alpha}} & r_s), .cin(null), .S(term2[5:4]), .coutt(term2[6]));

assign term2[7] = 0;
assign term2[3:0] = 0;

/////////////////////////////////////////////////term3 zero, suspicousss////////////////////////////////////////////////////////////////

// assign term3 = 8'b0;
bit2_mul bababa(.a(p_q),.b(r_s),.c(term3[5:2])); // 2ND CALL
assign term3[7:6] = 0;
assign term3[1:0] = 0;
//adding all terms

rca_Nbit #(.N(bit8)) t1t2 (.a(term1), .b(term3), .cin(null), .S(cmid_temp));
rca_Nbit #(.N(bit8)) t2t3 (.a(cmid_temp), .b(term2), .cin(null), .S(cmid));

// cmid is ready, now subtract

//////////////////////
input [7:0] pr_shift, qs_shift;
input [7:0] cmid1, cmid2;
/////////////////

// assign cmid1 = 8'b0;
// assign cmid2 = 8'b0;


// assign pr_shift = 8'b0;
// assign qs_shift = 8'b0;


assign pr_shift[5:2] = pr;
assign pr_shift[7:6] = 0;
assign pr_shift[1:0] = 0;

assign qs_shift[5:2] = qs;
assign qs_shift[7:6] = 0;
assign qs_shift[1:0] = 0;

////////////////////////////////////shift is done right/////////////////////////////////////////////////////////////////////////////

rca_Nbit_subtractor #(.N(bit8)) s1 (.a(cmid), .b(pr_shift), .S(cmid1));


rca_Nbit_subtractor #(.N(bit8)) s2 (.a(cmid1), .b(qs_shift), .S(cmid2));

// cmid is done
bit2_mul ml4 (.a(q), .b(s), .c(qs)); // 3RD USEE

// cfull assigned half half

assign cfull[3:0] = qs;
assign cfull[7:4] = pr;

// add both
rca_Nbit #(.N(bit8)) test2 (.a(cfull), .b(cmid2), .cin(null), .S(c));

// assign c = cfull;

// initial begin
//     #10;
//     $display("p=%b,q=%b,r=%b,s=%b",p,q,r_s,alpha);
//     $display("p=%b",term3);
// end


endmodule

module bit8_mul (a,b,c);
input [7:0] a,b;
output [15:0] c;
inout [3:0] p,q,r,s;
input null;
assign null = 1'b0;



inout [15:0] cmid, cfull;
// assign cfull = 8'b0;
// assign cmid = 8'b0;

parameter bit4 = 4;
parameter bit8 = 8;
parameter bit16 = 16;

// input [1:0] p,q,r,s

assign p = a[7:4];
assign q = a[3:0];
assign r = b[7:4];
assign s = b[3:0];



output [7:0] pr, ps, qr, qs;

bit4_mul ml1 (.a(p), .b(r), .c(pr)); // 1ST USE

input [3:0] p_q, r_s;
input alpha, beta;
parameter bit2 = 2;


// assign alpha = 1'b0;
// assign beta = 1'b0;

rca_Nbit #(.N(bit4)) add1 (.a(p), .b(q), .cin(null), .S(p_q), .coutt(alpha));

rca_Nbit #(.N(bit4)) add2 (.a(r), .b(s), .cin(null), .S(r_s), .coutt(beta));

// 2nd USE

/////////////////////////////////////////////////cfull checkkk////////////////////////////////////////////////////////////////

//rca_Nbit #(.N(4)) (.a(), .b(), .cin(), .S(), .coutt());
////////////
input [15:0] term1, term2,term3, cmid_temp;
output rough_catch;
// assign cmid_temp = 8'b0;
// assign term1 = 8'b0;

////////////


// assign term1[6] = alpha & beta;
and asdnoas(term1[12], alpha, beta);
assign term1[15:13] = 0;
assign term1[11:0] = 0;



// assign term2 = 8'b0;


rca_Nbit #(.N(bit4)) jane(.a({4{beta}} & p_q), .b({4{alpha}} & r_s), .cin(null), .S(term2[11:8]), .coutt(term2[12]));

assign term2[15:13] = 0;
assign term2[7:0] = 0;

/////////////////////////////////////////////////term3 zero, suspicousss////////////////////////////////////////////////////////////////

// assign term3 = 8'b0;
bit4_mul bababa(.a(p_q),.b(r_s),.c(term3[11:4])); // 2ND CALL
assign term3[15:12] = 0;
assign term3[3:0] = 0;
//adding all terms

rca_Nbit #(.N(bit16)) t1t2 (.a(term1), .b(term3), .cin(null), .S(cmid_temp));
rca_Nbit #(.N(bit16)) t2t3 (.a(cmid_temp), .b(term2), .cin(null), .S(cmid));

// cmid is ready, now subtract

//////////////////////
input [15:0] pr_shift, qs_shift;
input [15:0] cmid1, cmid2;
/////////////////

// assign cmid1 = 8'b0;
// assign cmid2 = 8'b0;


// assign pr_shift = 8'b0;
// assign qs_shift = 8'b0;


assign pr_shift[11:4] = pr;
assign pr_shift[15:12] = 0;
assign pr_shift[3:0] = 0;

assign qs_shift[11:4] = qs;
assign qs_shift[15:12] = 0;
assign qs_shift[3:0] = 0;

////////////////////////////////////shift is done right/////////////////////////////////////////////////////////////////////////////

rca_Nbit_subtractor #(.N(bit16)) s1 (.a(cmid), .b(pr_shift), .S(cmid1));


rca_Nbit_subtractor #(.N(bit16)) s2 (.a(cmid1), .b(qs_shift), .S(cmid2));

// cmid is done
bit4_mul ml4 (.a(q), .b(s), .c(qs)); // 3RD USEE

// cfull assigned half half

assign cfull[7:0] = qs;
assign cfull[15:8] = pr;

// add both
rca_Nbit #(.N(bit16)) test2 (.a(cfull), .b(cmid2), .cin(null), .S(c));

// assign c = cfull;

// initial begin
//     #10;
//     $display("p=%b,q=%b,r=%b,s=%b",p,q,r_s,alpha);
//     $display("p=%b",term3);
// end




endmodule



module karatsuba_16 (X, Y, Z);

input [15:0] X,Y;
output [31:0] Z;

input [15:0] a,b;
output [31:0] c;
inout [7:0] p,q,r,s;
input null;
assign null = 1'b0;

assign a = X;
assign b = Y;



inout [31:0] cmid, cfull;
// assign cfull = 8'b0;
// assign cmid = 8'b0;

parameter bit4 = 4;
parameter bit8 = 8;
parameter bit16 = 16;
parameter bit32 = 32;
// input [1:0] p,q,r,s

assign p = a[15:8];
assign q = a[7:0];
assign r = b[15:8];
assign s = b[7:0];



output [15:0] pr, ps, qr, qs;

bit8_mul ml1 (.a(p), .b(r), .c(pr)); // 1ST USE

input [7:0] p_q, r_s;
input alpha, beta;
parameter bit2 = 2;


// assign alpha = 1'b0;
// assign beta = 1'b0;

rca_Nbit #(.N(bit8)) add1 (.a(p), .b(q), .cin(null), .S(p_q), .coutt(alpha));

rca_Nbit #(.N(bit8)) add2 (.a(r), .b(s), .cin(null), .S(r_s), .coutt(beta));

// 2nd USE

/////////////////////////////////////////////////cfull checkkk////////////////////////////////////////////////////////////////

//rca_Nbit #(.N(4)) (.a(), .b(), .cin(), .S(), .coutt());
////////////
input [31:0] term1, term2,term3, cmid_temp;
output rough_catch;
// assign cmid_temp = 8'b0;
// assign term1 = 8'b0;

////////////


// assign term1[6] = alpha & beta;
and asdnoas(term1[24], alpha, beta);
assign term1[31:25] = 0;
assign term1[23:0] = 0;



// assign term2 = 8'b0;


rca_Nbit #(.N(bit8)) jane(.a({8{beta}} & p_q), .b({8{alpha}} & r_s), .cin(null), .S(term2[23:16]), .coutt(term2[24]));

assign term2[31:25] = 0;
assign term2[15:0] = 0;

/////////////////////////////////////////////////term3 zero, suspicousss////////////////////////////////////////////////////////////////

// assign term3 = 8'b0;
bit8_mul bababa(.a(p_q),.b(r_s),.c(term3[23:8])); // 2ND CALL
assign term3[31:24] = 0;
assign term3[7:0] = 0;
//adding all terms

rca_Nbit #(.N(bit32)) t1t2 (.a(term1), .b(term3), .cin(null), .S(cmid_temp));
rca_Nbit #(.N(bit32)) t2t3 (.a(cmid_temp), .b(term2), .cin(null), .S(cmid));

// cmid is ready, now subtract

//////////////////////
input [31:0] pr_shift, qs_shift;
input [31:0] cmid1, cmid2;
/////////////////

// assign cmid1 = 8'b0;
// assign cmid2 = 8'b0;


// assign pr_shift = 8'b0;
// assign qs_shift = 8'b0;


assign pr_shift[23:8] = pr;
assign pr_shift[31:24] = 0;
assign pr_shift[7:0] = 0;

assign qs_shift[23:8] = qs;
assign qs_shift[31:24] = 0;
assign qs_shift[7:0] = 0;

////////////////////////////////////shift is done right/////////////////////////////////////////////////////////////////////////////

rca_Nbit_subtractor #(.N(bit32)) s1 (.a(cmid), .b(pr_shift), .S(cmid1));


rca_Nbit_subtractor #(.N(bit32)) s2 (.a(cmid1), .b(qs_shift), .S(cmid2));

// cmid is done
bit8_mul ml4 (.a(q), .b(s), .c(qs)); // 3RD USEE

// cfull assigned half half

assign cfull[15:0] = qs;
assign cfull[31:16] = pr;

// add both
rca_Nbit #(.N(bit32)) test2 (.a(cfull), .b(cmid2), .cin(null), .S(c));

// assign c = cfull;

// initial begin
//     #10;
//     $display("p=%b,q=%b,r=%b,s=%b",p,q,r_s,alpha);
//     $display("p=%b",term3);
// end

assign Z = c;

endmodule
