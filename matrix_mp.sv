`define bus_width 8

`include "sum.sv"

module matrix_mp(
  input  logic [`bus_width - 1:0] inp1,
  input  logic [`bus_width - 1:0] inp2,
  output logic [`bus_width - 1:0] out1
);
  
  logic [`bus_width - 1:0][`bus_width - 1:0] in1;
  logic [`bus_width - 1:0][`bus_width - 1:0] in2;
  logic [`bus_width - 1:0][`bus_width - 1:0] out;
  
     generate       
       genvar genindex; 
       for (genindex = 0; genindex < `bus_width - 1; genindex++) 
        begin 
        sum u1(
            .in1(in1[genindex]),
            .in2(in2[genindex]),
            .out(out[genindex])
           );
	   end
	 endgenerate
	 
	 
	 logic [`bus_width - 1:0][`bus_width - 1:0] num;
	 logic [`bus_width - 1:0][`bus_width - 1:0] shift_num;
  
  always_comb
    begin 
     for (int num_index = 0; num_index < `bus_width; num_index++) 
      begin
	   for (int num_reg_index = 0;num_reg_index < `bus_width; num_reg_index++)
	   num[num_index][num_reg_index] = inp1[num_reg_index] && inp2[num_index];
      end
	  
     for (int shift_index = 0; shift_index < `bus_width; shift_index++)
      shift_num[shift_index] = num[shift_index] << shift_index;
	 
	 for (int sum1_index = 0; sum1_index < `bus_width/2; sum1_index++)
	  begin
	   in1[sum1_index] = shift_num[sum1_index];
       in2[sum1_index] = shift_num[`bus_width - sum1_index - 1];
      end	  
	 
      for (int sum_index = 0; sum_index < `bus_width - 1; sum_index = sum_index + 2)
	   begin
	    in1[sum_index/2+`bus_width/2 ] = out[sum_index];
        in2[sum_index/2+`bus_width/2 ] = out[sum_index + 1];		 
       end
	  
	  out1 = out[`bus_width - 2];
	 
	end
  
endmodule
