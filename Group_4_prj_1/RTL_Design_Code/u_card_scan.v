
module u_card_scan
    #(parameter CNS = 64, CIS = 4,DBD=16 ,Pass_width=16,balance_width=14)//CNS: Credit number size  ,CIS: card_index , DBD:Data base depth
	(
	input  wire   [CNS-1:0]            credit_number,
	
    output wire   [CIS-1:0]            card_index,
    output wire   [Pass_width-1:0]     card_pass,
	output wire   [balance_width-1:0]  card_balance,
    output reg                         card_found_flag	
    );

    integer i;
    reg [CNS-1:0] credit_number_bank [0:DBD-1];
	reg [Pass_width-1:0] credit_pass [0:DBD-1];
	reg [balance_width-1:0] credit_balance [0:DBD-1];
			
/************************ Data base virtual **********************/
/*****************************************************************/
       initial begin
	    $display("Welcome to the ATM System");
        credit_number_bank[0] = 'd100;
        credit_number_bank[1] = 'd200;
        credit_number_bank[2] = 'd300;
        credit_number_bank[3] = 'd400;
        credit_number_bank[4] = 'd500;
        credit_number_bank[5] = 'd600;
        credit_number_bank[6] = 'd700;
        credit_number_bank[7] = 'd800;
        credit_number_bank[8] = 'd900;
        credit_number_bank[9] = 'd1000;
        credit_number_bank[10] = 'd1003;
        credit_number_bank[11] = 'd1006;
        credit_number_bank[12] = 'd1009;
        credit_number_bank[13] = 'd1012;
        credit_number_bank[14] = 'd1015;
		credit_number_bank[15] = 'd1018;
    end
	//Password
    initial begin
        credit_pass[0] = 'd0;
        credit_pass[1] = 'd1;
        credit_pass[2] = 'd2;
        credit_pass[3] = 'd3;
        credit_pass[4] = 'd4;
        credit_pass[5] = 'd5;
        credit_pass[6] = 'd6;
        credit_pass[7] = 'd7;
        credit_pass[8] = 'd8;
        credit_pass[9] = 'd9;
        credit_pass[10] = 'd10;
        credit_pass[11] = 'd11;
        credit_pass[12] = 'd12;
        credit_pass[13] = 'd13;
        credit_pass[14] = 'd14;
		credit_pass[15] = 'd15;
    end
		//Balance
    initial begin
        credit_balance[0] = 'd1500;
        credit_balance[1] = 'd2000;
        credit_balance[2] = 'd2500;
        credit_balance[3] = 'd3000;
        credit_balance[4] = 'd3500;
        credit_balance[5] = 'd4000;
        credit_balance[6] = 'd4500;
        credit_balance[7] = 'd5000;
        credit_balance[8] = 'd5500;
        credit_balance[9] = 'd6000;
        credit_balance[10] = 'd6500;
        credit_balance[11] = 'd7000;
        credit_balance[12] = 'd7500;
        credit_balance[13] = 'd8000;
        credit_balance[14] = 'd8500;
		credit_balance[15] = 'd9000;
    end
/******************** Search for credit_number @ Data base ******************/	
    reg [CIS-1:0] index_temp;
	
    always @(credit_number) begin// looking for index when credit_number changes
        card_found_flag <= 1'b0;
        for (i = 0; i < DBD; i = i + 1) begin
            if (credit_number == credit_number_bank[i]) begin
                index_temp <= i;
                card_found_flag <= 1'b1;
            end
        end
    end
/*****************************************************************/	
 assign   card_index = index_temp;
 assign   card_pass= credit_pass[card_index];
 assign   card_balance= credit_balance[card_index];		
		
endmodule