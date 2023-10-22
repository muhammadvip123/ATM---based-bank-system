
module u_atm_fsm
    #(parameter CNS = 64, CIS = 4,DBD=16 ,Pass_width=16,balance_width=14 )
	(
    input wire	                        clk,
	input wire                          rst,
	input wire                          ic,//insert card
	input wire                          mt,//more transaction
    input wire     [CNS-1:0]            credit_number, destination_number, 
	input wire     [Pass_width-1:0]     en_password, new_password,
	input wire     [15:0]               en_ammount_money,
    input wire     [2:0]                option,
	input wire     [3:0]                keyboard,
	input 								enter,


	output reg                          card_accepted,
	output reg    [balance_width-1:0]                account_balance,
	output reg 						    Insuffucient_flag,
	output reg                          y0,y1,y2,y3,y4,y5,y6,y7,y11,y10,y8,y12
	);


	

reg [balance_width-1:0]  source_server_balance_reg ;
reg [Pass_width-1:0]     source_server_pass_reg ;
reg [balance_width-1:0]  destination_server_balance_reg ;
reg [Pass_width-1:0]     destination_server_pass_reg ;





wire                          source_exists;
wire                          destination_exists;
wire     [balance_width-1:0]  source_server_balance;
wire     [balance_width-1:0]  destination_server_balance;
wire     [Pass_width-1:0]     source_server_pass;
wire     [Pass_width-1:0]     destination_server_pass;
wire     [CIS-1:0]            SINDEX;
wire     [CIS-1:0]            DINDEX;
u_card_scan check_source_account_exist(.credit_number(credit_number),.card_pass(source_server_pass),.card_index(SINDEX), .card_balance(source_server_balance),.card_found_flag(source_exists) );
u_card_scan check_destination_account_exist(.credit_number(destination_number),.card_pass(destination_server_pass),.card_index(DINDEX) ,.card_balance(destination_server_balance),.card_found_flag(destination_exists) );
 
 /***************************** Intial Blocks ****************************/
 reg [2:0] wrong_tries;
 initial begin
 wrong_tries =0;
 end
 
 /********************************* assign ******************************/
 wire [2:0]   trials;
 wire [12:0]  deposit_max_val;
 assign trials='d5;
 assign deposit_max_val='d5000;
/********************************* States *******************************/	
localparam [3:0]      idle=4'b0000,             //s0
                      balance_check=4'b0001,     //s1
					  withdraw=4'b0010,         //s2
					  deposit=4'b0011,          //s3
					  transfer=4'b0100, 		//s4
					  exit=4'b0101,             //s5
					  new_pass=4'b0110,         //s6
					  lang_used=4'b0111,        //s7
					  scan_card=4'b1000,         //s8
					  enter_pass=4'b1001,       //s9
					  option_select=4'b1010,    //s10 
					  anything_else=4'b1011;    //s11
                     
					  
/*****************************************************************************/	
reg [3:0] current_state, next_state;

/**************************** States Transition *****************************/	
always @(posedge clk or negedge rst)
begin
	if(!rst)
	begin
		current_state<= idle;
		
		end
	else
		current_state<=next_state;
end				  

/*****************************************************************************/
/*******************************  Timer **************************************/
reg [5:0] counter;
always @(posedge clk or negedge rst)
begin
	if(!rst)
	begin
		counter<= 0;	
	end
	else
	if(current_state==next_state)
	counter<=counter+1'd1;
	else
		counter<=0;
end	     

    
/*****************************************************************************/
always @(*)
begin
case(current_state)
		idle:begin
					$display("Insert Card!\n");	
					if(ic)//insert  card
							begin
								next_state =  scan_card;	
								end									

					else
						begin
						next_state =  idle;							
						end
			 end

	scan_card:begin
	$display("Scan  Card !\n");
				if(source_exists==1)//card scan
					begin	
						$display("Card 	 exist!\n");											
						source_server_balance_reg = source_server_balance;
						source_server_pass_reg = source_server_pass;							 
						card_accepted =1;	
						wrong_tries='d0;											
						next_state = lang_used;
					end
				else
					begin																					
						$display("Card 	Not exist!\n");											
						source_server_balance_reg = 0;
						source_server_pass_reg = 0;							 
						card_accepted =0;
						wrong_tries='d0;
						next_state =  scan_card;																											
					end							
				end	
					  				  
	lang_used:   begin
					   $display("Language used!\n");		          
					  if(counter <5 )begin
							   if(keyboard != 0)				  
								next_state = enter_pass;
								else
								 next_state = lang_used;
					  end else
						next_state = idle;
							
				 end			
				 
		enter_pass: begin
		$display("Enter Card Password!\n " );
		    if(counter <5 )begin
				if(enter) begin
							if(en_password == source_server_pass_reg)
								begin
									next_state = option_select;
									wrong_tries='d0;
								   $display("Correct password!\n");
								end
							else
								begin
									if ((wrong_tries != trials) )
										begin
										 $display("Not Correct Password!\n");
											wrong_tries=wrong_tries+1'd1;
											next_state = enter_pass;
										end
									else 
									  begin
										wrong_tries='d0;
										$display("Invalid!...\n");									
										next_state = idle;
									  end
								end	
							end
			else	begin
				next_state=enter_pass;
					end
						end 
							  else begin
								next_state = idle;end				
					  end
					  
		option_select:begin
					 $display("Menu!\n");
					if(option==0)
					begin
						if(counter<5) begin
						$display("Enter Option !\n");
						next_state = option_select;
						end else 
						next_state = idle;
						
					end else
					begin
								  
							if(option == 'b10)
								begin
								next_state = withdraw;
								end
							else if(option == 'b01)
								begin
								next_state = balance_check;
								end
							else if(option == 'b11)
								begin
								next_state = deposit;
								end
							else if(option == 'b100)
								begin
								next_state = transfer;
								end
							else if(option == 'b110)
								begin
								next_state = new_pass;
								end	
							else if(option == 'b101)
								begin
								next_state = exit;

								end
							else //comment : if option selected wrong remain at Menu panel.
								begin
								next_state = option_select;
								
								end
					end

			  end
		withdraw: begin
				    /*******************************/
						$display("Withdraw  Operation!\n");
				        Insuffucient_flag=0;
				    /*******************************/
		    if(counter <10)begin
						if(enter) begin
								if((en_ammount_money <= source_server_balance_reg)&&(en_ammount_money!=0)) //check ammount entered is less that blance in account
									begin
										$display("Withdraw  Operation succ!\n");
										 source_server_balance_reg=source_server_balance_reg-en_ammount_money;
										 $display("New Balance: %d\n", source_server_balance_reg);
										 account_balance=source_server_balance_reg;
										next_state = anything_else;
										end
								else
									begin
										if(en_ammount_money==0) 
										begin
											$display("Enter Money Valu!\n");
											  next_state = withdraw;
										end
										else 
											begin													
											$display("Insuffucient balance!\n");
											next_state = option_select;
											/*******************************/
												 Insuffucient_flag=1;
											/*******************************/
											end
									end
									end
							else begin
							next_state=withdraw;
								end
						end
			 else begin
					    next_state = idle;
					end		
		
					 end
		balance_check:begin
						$display("Blance check  Operation!\n");
						account_balance=source_server_balance_reg; 
						 if(counter<5)
							begin
							next_state =balance_check ;
							 $display("Balance: %d\n", source_server_balance_reg);
							end 
						  else 
							begin
								 next_state = anything_else;
							 end		
					 end

		deposit: begin
		 $display("Deposit Operation!\n");
		         if(counter <10 )begin		
						if(enter) begin				 
								if((en_ammount_money <= deposit_max_val)&& (en_ammount_money!=0)) 
										begin
											 $display("Deposit Operation succ!\n");
											 source_server_balance_reg=source_server_balance_reg+en_ammount_money;
											 $display("New Balance: %d\n", source_server_balance_reg);
											 account_balance=source_server_balance_reg;
											next_state = anything_else;
											end
									else
										begin
											if(en_ammount_money==0)
											begin
													$display("Enter Money Value!\n");										
												   next_state = deposit;
											end
											else begin
											$display("Enter value less than 5K!\n");
											next_state = option_select;
											end
										end
							     end
								else begin
									next_state=deposit;
									end
								end
					             else
					             next_state = idle;		
			   end 
		anything_else: begin
		$display("More Transaction ?  !\n");
		 if(counter <5 )begin
								if(mt)//More transaction
									begin
									next_state = option_select;
									end
								else
									begin
									next_state =  anything_else;
									end
				end
								else
									begin
									next_state =  exit;
									end
							end
		exit:begin				
                    $display("Exited!\n");
                     next_state =  idle;					
					  end
	/*********************************************************************/				  
		new_pass:begin		
				$display("Enter New Password !\n");
                if(counter<10)begin
					if (enter)begin
							$display("New Password operation!\n");
							source_server_pass_reg = new_password;
							next_state = anything_else;	
							end
                   else	begin	
                     next_state = new_pass;					
					  end	
				end
				   else begin
				    next_state=idle;end
				end
	/*********************************************************************/					  
		transfer:begin	
  $display("Transfer Operation!\n");		
if(counter<5)		
begin
			if(enter)begin
					if(destination_exists)//Destination card number exist
							   begin
									destination_server_balance_reg = destination_server_balance;
									destination_server_pass_reg = destination_server_pass;		
										   if((en_ammount_money <= source_server_balance_reg)&&(en_ammount_money!=0))
										   begin
												   $display("Transfer Operation succ!\n");	
													source_server_balance_reg = source_server_balance_reg - en_ammount_money;
													destination_server_balance_reg = destination_server_balance_reg + en_ammount_money;
													$display("Source Balance: %d\n", source_server_balance_reg);
													$display("Destination Balance: %d\n", destination_server_balance_reg);
													account_balance=source_server_balance_reg;
												next_state = anything_else;
											end
											else
											begin
												if(en_ammount_money==0) 
												begin									
														$display("Enter Money Valu!\n");												
														  next_state = transfer;
												end 
												else
												begin											
													$display("Insuffucient balance!\n");
													next_state = option_select;
												end
											end
							   end 
							   else begin
							   $display("In Correct Destination account !\n");
								destination_server_balance_reg = 0;
								destination_server_pass_reg = 0;	
								next_state = transfer; 
							   end
						end
							else begin
							next_state=transfer;
								end
						  end
							else
							next_state = idle;						  
				 end					  
endcase
end

always @(*)
 begin

		
		y0=0;
		y1=0;
		y5=0;
		y11=0;
		y10=0;
		y7=0;
		y3=0;
		y2=0;
		y4=0;
		y6=0;
		y8=0;
		y12=0;

  case(current_state)
  	idle     : begin
				y0=1;
            end
  	balance_check     : begin
				y1=1;
            end

	exit     : begin
                y5=1;
            end	
	anything_else     : begin
				y11=1;
            end	
	option_select     : begin
				y10=1;
            end	
	lang_used     : begin
				y7=1;
            end	
	scan_card :begin
				y8=1;
			end
	
	new_pass :begin
				y12=1;
			  end			
	deposit     : begin
				y3=1;
            end
	withdraw    : begin
				y2=1;				
            end
	transfer    : begin

				y4=1;				
            end
	enter_pass    : begin
				y6=1;
            end

 endcase
end


sequence idle_pass;
((current_state==idle)&&(ic));
endsequence

property card_valid;
@(posedge clk) idle_pass |=> (current_state==scan_card);
endproperty

a_card_valid:assert property(card_valid);
c_card_valid:cover property(card_valid);

property idle_f;
@(posedge clk) ((current_state == idle) && (!(ic)) |=> (current_state==idle)); 
endproperty

a_idle_f:assert property(idle_f);
c_idle_f:cover property(idle_f);

sequence scan_card_op;
(current_state==scan_card) && (source_exists);
endsequence

property scan_card_p;
@(posedge clk) idle_pass |=> scan_card_op |=>(current_state==lang_used);
endproperty

a_scan_card_p:assert property(scan_card_p);
c_scan_card_p:cover property(scan_card_p);

property scan_card_f;
@(posedge clk) (current_state==scan_card) |-> (source_exists==0)[*5] ##1 (current_state==idle);
endproperty

sequence lang_pass;
(current_state == lang_used)[*1:5] ##0 (keyboard != 0);
endsequence

property lang_P;
@(posedge clk) (idle_pass ##1 scan_card_op ##1 lang_pass) |=> (current_state==enter_pass);
endproperty

a_lang_p: assert property(lang_P);

sequence password_pass;
(current_state == enter_pass)[*1:5] ##0 enter ##0 (en_password == source_server_pass_reg);
endsequence

property user_valid;
@(posedge clk) (idle_pass ##1 scan_card_op ##1 lang_pass ##1 password_pass) |=> (current_state==option_select);
endproperty

a_user_valid:assert property(user_valid);
c_user_valid:cover property(user_valid);

sequence withdraw_op;
(current_state==withdraw)[*1:10] ##0 (enter ##0 ((en_ammount_money <= source_server_balance_reg) ##0 (en_ammount_money!=0)));   
endsequence

property withdraw_pass;
@(posedge clk) ((current_state==option_select)[*1:5] ##0 (option=='b10) ##1 withdraw_op) |=> (current_state==anything_else);
endproperty

a_withdraw_pass:assert property(withdraw_pass);
c_withdraw_pass:cover property(withdraw_pass);

sequence balance_op;
(current_state==balance_check) ;
endsequence

property bal_check_p;
@(posedge clk) (current_state==option_select)[*1:5] ##0 (option=='b1) ##1 balance_op[*6]  |=> (current_state==anything_else);
endproperty

a_bal_check_p:assert property(bal_check_p);
c_bal_check_p:cover property(bal_check_p);


sequence deposit_op;
(current_state==deposit)[*1:10] ##0 (enter ##0 ((en_ammount_money <= deposit_max_val) && (en_ammount_money!=0))); 
endsequence

property deposit_pass;
@(posedge clk) (current_state==option_select)[*1:5] ##0 (option=='b11) ##1 deposit_op |=> (current_state==anything_else);
endproperty

a_deposit_pass:assert property(deposit_pass);
c_deposit_pass:cover property(deposit_pass);

sequence transfer_op;
(current_state==transfer)[*1:5] ##0 enter ##0 destination_exists ##0 ((en_ammount_money <= source_server_balance_reg) ##0 (en_ammount_money!=0));
endsequence

property transfer_pass;
@(posedge clk) ((current_state==option_select)[*1:5] ##0 (option=='b100) ##1 transfer_op) |=> (current_state==anything_else);
endproperty

a_transfer_pass:assert property(transfer_pass);
c_transfer_pass:cover property(transfer_pass);


sequence new_pass_op;
(current_state==new_pass)[*1:10] ##0 enter;
endsequence

property new_pass_p;
@(posedge clk) ((current_state==option_select)[*1:5] ##0 (option=='b110) ##1 new_pass_op) |=> (current_state==anything_else);
endproperty

a_new_pass_p:assert property(new_pass_p);
c_new_pass_p:cover property(new_pass_p);


sequence anything_else_op;
(current_state==anything_else)[*1:5] ##0 (mt);
endsequence

property anything_else_p;
@(posedge clk) (withdraw_op or balance_op or deposit_op or transfer_op or new_pass_op) |=> anything_else_op |=> (current_state==option_select);  
//@(posedge clk) (anything_else_op) |=> (current_state==option_select);
endproperty

a_anything_else_p:assert property(anything_else_p);
c_anything_else_p:cover property(anything_else_p);

property anything_else_f;
@(posedge clk) ((current_state==anything_else) && (!mt)[*5]) |=> (current_state==exit) ;
endproperty

property exit_pass;
@(posedge clk) (current_state==option_select) ##[0:4] (option=='b101) ##1 (current_state == exit) |=> (current_state == idle);
endproperty
		
a_exit:assert property (exit_pass);
c_exit:cover property (exit_pass);

endmodule

