
`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"

//---------------------------------------------------------------------------------
//defining parameters
parameter CNS = 64, CIS = 4,DBD=16 ,Pass_width=16,balance_width=14, CLK_Period = 10;
//---------------------------------------------------------------------------------

//----------------------------------------------------------------------------------
// defining the interface
interface ATM_if ();
    // Inputs
    logic                       clk;
    logic                       rst;
    logic                       ic; // Insert card
    logic                       mt; // More transaction
	logic						enter;
   	logic     [CNS-1:0]    		credit_number;
	logic     [Pass_width-1:0]  en_password;
    logic     [Pass_width-1:0]  new_password;
    logic     [15:0]       		en_ammount_money;
    logic     [CNS-1:0]   		destination_number;
    logic     [2:0]        		option;
    logic     [3:0]        		keyboard;

    // Outputs
    logic                           card_accepted;
    logic     [balance_width-1:0]   account_balance;
    logic                           Insuffucient_flag;
    logic                       y0;
    logic                       y1;
    logic                       y2;
    logic                       y3;
    logic                       y4;
    logic                       y5;
    logic                       y6;
    logic                       y7;
    logic                       y11;
    logic                       y10;
    logic                       y8;
	logic                       y12;
endinterface
//----------------------------------------------------------------------------------


//--------------------------------------------------------------------------------------
//defining transactions class
class transactions extends uvm_sequence_item;
	// Inputs
    static bit                       		rst;
    static bit                       		ic; // Insert card
	static bit                              enter;
    static rand bit                       	mt; // More transaction
   	static rand bit     [CNS-1:0]    		credit_number,destination_number;
	static rand bit     [Pass_width-1:0]  	en_password;
    static rand bit     [Pass_width-1:0]    new_password;
    static rand bit     [15:0]       		en_ammount_money;
    //static rand bit     [CNS-1:0]   		destination_number;
    static rand bit     [2:0]        		option;
    static rand bit     [3:0]        		keyboard;

    // Outputs
    static bit                       		card_accepted;
    static bit                       		account_balance;
    static bit                       		Insuffucient_flag;
    static bit                       		y0;
    static bit                       		y1;
    static bit                       		y2;
    static bit                       		y3;
    static bit                       		y4;
    static bit                       		y5;
    static bit                       		y6;
    static bit                       		y7;
    static bit                       		y11;
    static bit                       		y10;
    static bit                       		y8;
	static bit                       		y12;


	//define necessary credit informations
	static bit [15:0] credit_pass[15:0];
	static bit [63:0] credit_number_bank [15:0];
	static rand bit i;


	constraint credit_number_constraint {
    credit_number inside {0,credit_number_bank};
  } 
	constraint des_num_constraint {
		destination_number inside {0,credit_number_bank};
	}
	
	constraint pass_constraint{
		en_password inside {credit_pass};
	}

	constraint i_cons{
		i dist {0:=5, 1:=95};
	}
	constraint option_cons{
		option inside {0,1,2,3,4,5,6,7};
	}

	constraint en_ammount_money_cons{
		en_ammount_money inside {[0:10000]};
		en_ammount_money dist {0:=100, [1:10000]:=2} ;
	}

	//constructor
	function new(input string inst ="TRANS");
		super.new(inst);
		// Initialize the credit_number_bank array with the specified values
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

		// Initialize the credit_pass array with the specified values
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
	endfunction

	///registering the transactions objects to a factory
	`uvm_object_utils_begin(transactions)
	`uvm_field_int(rst, UVM_DEFAULT)
	`uvm_field_int(ic, UVM_DEFAULT)
	`uvm_field_int(mt, UVM_DEFAULT)
	`uvm_field_int(credit_number, UVM_DEFAULT)
	`uvm_field_int(en_password, UVM_DEFAULT)
	`uvm_field_int(new_password, UVM_DEFAULT)
	`uvm_field_int(en_ammount_money, UVM_DEFAULT)
	`uvm_field_int(destination_number, UVM_DEFAULT)
	`uvm_field_int(option, UVM_DEFAULT)
	`uvm_field_int(keyboard, UVM_DEFAULT)
	`uvm_field_int(card_accepted, UVM_DEFAULT)
	`uvm_field_int(account_balance, UVM_DEFAULT)
	`uvm_field_int(Insuffucient_flag, UVM_DEFAULT)
	`uvm_field_int(y0, UVM_DEFAULT)
	`uvm_field_int(y1, UVM_DEFAULT)
	`uvm_field_int(y2, UVM_DEFAULT)
	`uvm_field_int(y3, UVM_DEFAULT)
	`uvm_field_int(y4, UVM_DEFAULT)
	`uvm_field_int(y5, UVM_DEFAULT)
	`uvm_field_int(y6, UVM_DEFAULT)
	`uvm_field_int(y7, UVM_DEFAULT)
	`uvm_field_int(y8, UVM_DEFAULT)
	`uvm_field_int(y10, UVM_DEFAULT)
	`uvm_field_int(y11, UVM_DEFAULT)
	`uvm_object_utils_end
endclass
//-----------------------------------------------------------------------------------


//------------------------------------------------------------------------------------
//sequence class
class generator extends uvm_sequence #(transactions);
	//registering to a factory
	`uvm_object_utils(generator);
	transactions t;
	uvm_event Gen_Mon_event;
	uvm_event Mon_GEN_event;
	rand int unsigned mySignal;
	int index [$];
	bit flag;


	function new(input string inst ="GEN");
		super.new(inst);
		Gen_Mon_event = new();
    	Gen_Mon_event = uvm_event_pool::get_global("Gen_Mon_event");
		Mon_GEN_event = new();
    	Mon_GEN_event = uvm_event_pool::get_global("Mon_GEN_event");

	endfunction


	virtual task body();
  		t =transactions::type_id::create("TRANS");
		flag = 1;
		start_item(t);
		t.rst = 0;
		finish_item(t);
		Gen_Mon_event.trigger();
		Mon_GEN_event.wait_trigger();
		t.rst = 1;
		t.keyboard.rand_mode(0);
		t.en_ammount_money.rand_mode(0);
		t.en_password.rand_mode(0);
		t.new_password.rand_mode(0);
		t.destination_number.rand_mode(0);
		t.option.rand_mode(0);
		t.i.rand_mode(0);
		t.mt.rand_mode(0);
		repeat(30000) begin
			t.credit_number.rand_mode(1);
			start_item(t);
			t.ic = 1;
			assert(t.randomize()) else $fatal("couldn't randomize");
			finish_item(t);
			Gen_Mon_event.trigger();
			Mon_GEN_event.wait_trigger();
			t.credit_number.rand_mode(0);
			t.print(uvm_default_line_printer);
			if(t.y8)begin
				start_item(t);
				t.ic = 0;
				finish_item(t);
				Gen_Mon_event.trigger();
				Mon_GEN_event.wait_trigger();
				if(t.y7)begin
					`uvm_info("GEN","Card inserted and found in design",UVM_NONE);
					t.credit_number.rand_mode(0);
					t.keyboard.rand_mode(1);
					mySignal = $urandom_range(0, 7); // Randomize mySignal from 0 to 7
					repeat(mySignal) begin
						#(CLK_Period);
					end
					start_item(t);
					assert(t.randomize() with{t.keyboard !=0;}) else $fatal("couldn't randomize");
					finish_item(t);
					Gen_Mon_event.trigger();
					Mon_GEN_event.wait_trigger();
					t.keyboard = 0;
					if(t.y6) begin
						t.keyboard.rand_mode(0);
						t.i.rand_mode(1);
						assert(t.randomize()) else $fatal("couldn't randomize");
						t.i.rand_mode(0);
						t.enter = 1;
						if(t.i) begin
							start_item(t);
							index = (t.credit_number_bank.find_index(x) with (x == t.credit_number));
							t.en_password = index[0];
							finish_item(t);
						end
						else begin
							t.en_password.rand_mode(1);
							start_item(t);
							assert(t.randomize()) else $fatal("couldn't randomize");
							finish_item(t);
							t.en_password.rand_mode(0);
						end
						t.enter = 0;
						Gen_Mon_event.trigger();
						Mon_GEN_event.wait_trigger();
						t.en_password = 0;
						while(t.y10) begin
							while(flag) begin
								t.option.rand_mode(1);
								start_item(t);
								assert(t.randomize() with{t.option !=0;}) else $fatal("couldn't randomize");
								finish_item(t);
								Gen_Mon_event.trigger();
								Mon_GEN_event.wait_trigger();
								t.option.rand_mode(0);
								if(t.option != 7) begin
									flag = 0;
								end
								t.option =0;
							end
							flag = 1;
							t.mt.rand_mode(1);
							mySignal = $urandom_range(0, 10); // Randomize mySignal from 0 to 7
							repeat(mySignal) begin
								#(CLK_Period);
							end
							if(t.y2 || t.y3) begin
								t.enter = 1;
								t.en_ammount_money.rand_mode(1);
								start_item(t);
								assert(t.randomize()) else $fatal("couldn't randomize");
								finish_item(t);
								while(t.y2 || t.y3) begin
									Gen_Mon_event.trigger();
									Mon_GEN_event.wait_trigger();
								end
								t.en_ammount_money.rand_mode(0);
								t.enter = 0;
							end
							else if(t.y1) begin
								while(!t.y11) begin
									Gen_Mon_event.trigger();
									Mon_GEN_event.wait_trigger();
								end
							end
							else if(t.y4) begin
								t.enter = 1;
								t.en_ammount_money.rand_mode(1);
								t.destination_number.rand_mode(1);
								start_item(t);
								assert(t.randomize()) else $fatal("couldn't randomize");
								finish_item(t);
								while(t.y4) begin
									Gen_Mon_event.trigger();
									Mon_GEN_event.wait_trigger();
								end
								t.en_ammount_money.rand_mode(0);
								t.destination_number.rand_mode(0);
								t.enter = 0;
							end
							else if(t.y5) begin
								Gen_Mon_event.trigger();
								Mon_GEN_event.wait_trigger();
							end
							else if(t.y12) begin
								start_item(t);
								t.enter = 1;
								t.new_password.rand_mode(1);
								assert(t.randomize()) else $fatal("couldn't randomize");
								finish_item(t);	
								t.new_password.rand_mode(0);
							end
							t.mt.rand_mode(0);
							Gen_Mon_event.trigger();
							Mon_GEN_event.wait_trigger();
						end
					end
				end
			end
		end
	endtask
endclass
//------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------
//driver class
class driver extends uvm_driver #(transactions);
  `uvm_component_utils(driver)
  
  transactions t;
  virtual ATM_if DUTIF;
  
  //constructor
  function new(input string inst ="DRV",uvm_component c);
    super.new(inst,c);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t =transactions::type_id::create("TRANS");
    if(!(uvm_config_db#(virtual ATM_if)::get(this,"","DUTIF",DUTIF)))
      `uvm_fatal("DRV","Driver is unable to access interface")
  endfunction
    
      ///////////run phase////////////////
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(t);
      DUTIF.rst = t.rst;
      DUTIF.ic = t.ic;
      DUTIF.mt = t.mt;
      DUTIF.credit_number   = t.credit_number;
	  DUTIF.destination_number =t.destination_number;
	  DUTIF.en_ammount_money = t.en_ammount_money;
	  DUTIF.en_password = t.en_password;
	  DUTIF.new_password = t.new_password;
	  DUTIF.option = t.option;
	  DUTIF.keyboard = t.keyboard;
	  DUTIF.enter = t.enter;
      `uvm_info("DRV","Data is send to the driver as following",UVM_NONE);
      t.print(uvm_default_line_printer);
      seq_item_port.item_done();
    end
  endtask
endclass
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//monitor
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  //uvm_analysis_port #(transactions) send;
  transactions t;
  virtual ATM_if DUTIF;
  uvm_event Gen_Mon_event;
  uvm_event Mon_GEN_event;
  integer  i;
  
  //constructor
  function new(input string inst ="MON",uvm_component c);
    super.new(inst,c);
    //send =new("WRITE",this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t =transactions::type_id::create("TRANS");
    if(!(uvm_config_db#(virtual ATM_if)::get(this,"","DUTIF",DUTIF)))
      `uvm_fatal("MON","Driver is unable to access interface")
    Gen_Mon_event = uvm_event_pool::get_global("Gen_Mon_event");
	Mon_GEN_event = uvm_event_pool::get_global("Mon_GEN_event");
  endfunction
      ///////////run phase////////////////
  virtual task run_phase(uvm_phase phase);
	forever begin
    	Gen_Mon_event.wait_trigger();
		@(negedge DUTIF.clk);
		t.Insuffucient_flag = DUTIF.Insuffucient_flag;
		t.card_accepted = DUTIF.card_accepted;
		t.account_balance = DUTIF.account_balance;
		t.y0 = DUTIF.y0;
		t.y1 = DUTIF.y1;
		t.y2 = DUTIF.y2;
		t.y3 = DUTIF.y3;
		t.y4 = DUTIF.y4;
		t.y5 = DUTIF.y5;
		t.y6 = DUTIF.y6;
		t.y7 = DUTIF.y7;
		t.y8 = DUTIF.y8;
		t.y11 = DUTIF.y11;
		t.y10 = DUTIF.y10;
		t.y12 = DUTIF.y12;
		Mon_GEN_event.trigger() ;
    end
  endtask
endclass
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//agent
class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  //constructor
  function new(input string inst ="AGENT",uvm_component c);
    super.new(inst,c);
  endfunction
  
  driver d;
  uvm_sequencer #(transactions) seq;
  monitor m;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    d = driver::type_id::create("DRV",this);
	m = monitor::type_id::create("MON",this);
    seq = uvm_sequencer #(transactions)::type_id::create("SEQ",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    d.seq_item_port.connect(seq.seq_item_export);
  endfunction
endclass
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//test
class test extends uvm_test;
  `uvm_component_utils(test)
  
  function new(input string inst ="TEST",uvm_component c);
    super.new(inst,c);
  endfunction
  
  generator gen;
  agent a;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    gen = generator::type_id::create("GEN",this);
    a = agent::type_id::create("AGENT",this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    gen.start(a.seq);
    phase.drop_objection(this);
  endtask
endclass
//--------------------------------------------------------------------------------
//testbench module
//--------------------------------------------------------------------------------
module ATM_tb();
	test t;
	ATM_if DUTIF();
	localparam [3:0]      idle=4'b0000,             //s0
                      blance_check=4'b0001,     //s1
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

	u_atm_fsm   #( .CNS (CNS), .CIS (CIS),.DBD(DBD) ,.Pass_width(Pass_width),.balance_width(balance_width) ) DUT(
	.clk(DUTIF.clk),
	.rst(DUTIF.rst),
	.ic(DUTIF.ic),
	.mt(DUTIF.mt),
	.credit_number(DUTIF.credit_number),
	.destination_number(DUTIF.destination_number),
	.en_password(DUTIF.en_password),
	.new_password(DUTIF.new_password),
	.en_ammount_money(DUTIF.en_ammount_money),
	.option(DUTIF.option),
	.keyboard(DUTIF.keyboard),
	.enter(DUTIF.enter),
	.card_accepted(DUTIF.card_accepted),
	.account_balance(DUTIF.account_balance),
	.Insuffucient_flag(DUTIF.Insuffucient_flag), // new output - Insufficient funds flag
	.y0(DUTIF.y0),               // new output
	.y1(DUTIF.y1),               // new output
	.y2(DUTIF.y2),               // new output
	.y3(DUTIF.y3),               // new output
	.y4(DUTIF.y4),               // new output
	.y5(DUTIF.y5),               // new output
	.y6(DUTIF.y6),               // new output
	.y7(DUTIF.y7),               // new output
	.y11(DUTIF.y11),             // new output
	.y10(DUTIF.y10),              // new output
	.y8(DUTIF.y8),
	.y12(DUTIF.y12)
	);
	initial begin
		DUTIF.clk = 0;
	end

	always #(CLK_Period/2) DUTIF.clk =~DUTIF.clk;

	initial begin
		$dumpvars;
		t =new("TEST",null);
		uvm_config_db #(virtual ATM_if)::set(null,"*","DUTIF",DUTIF);
		run_test();
		User_Data_inst1.sample();
		FSM_inst1.sample();
		$set_coverage_db_name("Coverage_Database.txt");
	end

	/**********************Coverage_Section*************************/
covergroup user_data() @(posedge DUTIF.clk); 

	type_option.comment="Coverage model for all the users data";
	
	user_balance:coverpoint DUT.check_source_account_exist.card_balance{
	
	bins balances[]={'d1500,'d2000,'d2500,'d3000,'d3500,'d4000,'d4500,'d5000,'d5500,'d6000,'d6500,'d7000,'d7500,'d8000,'d8500,'d9000};
	}
	user_pass:coverpoint DUT.check_source_account_exist.card_pass{
	bins passwords[]={'d0,'d1,'d2,'d3,'d4,'d5,'d6,'d7,'d8,'d9,'d10,'d11,'d12,'d13,'d14,'d15};
	}
	user_id:coverpoint DUT.check_source_account_exist.credit_number{
	bins IDs[]={'d100,'d200,'d300,'d400,'d500,'d600,'d700,'d800,'d900,'d1000,'d1003,'d1006,'d1009,'d1012,'d1015,'d1018};
	}
	options:coverpoint DUT.option{
	bins options[] = {[0:7]};
	}
	
	user_options:cross user_id,options;
	
endgroup

user_data User_Data_inst1=new();

covergroup FSM_CG @(posedge DUTIF.clk);

type_option.comment="Coverage Model for the fsm states and transitions";
type_option.goal=100;

current_state:coverpoint DUT.current_state {

bins valid_states[] = {idle,blance_check,scan_card,withdraw,deposit,transfer,exit,new_pass,lang_used,enter_pass,option_select,anything_else};
/*
bins vallid_transitions[] = (idle => scan_card => lang_used => enter_pass => option_select => withdraw => anything_else),
                            (idle => scan_card => lang_used => enter_pass => option_select => deposit => option_select),
							(idle => scan_card => lang_used => enter_pass => option_select => deposit => idle),
							(idle => scan_card => lang_used => enter_pass => option_select => blance_check => anything_else),
                            (idle => scan_card => lang_used => enter_pass => option_select => deposit => anything_else),
							(idle => scan_card => lang_used => enter_pass => option_select => deposit => option_select),
							(idle => scan_card => lang_used => enter_pass => option_select => deposit => idle),
							(idle => scan_card => lang_used => enter_pass => option_select => new_pass => anything_else),
							(idle => scan_card => lang_used => enter_pass => option_select => new_pass => idle),
							(idle => scan_card => lang_used => enter_pass => option_select => transfer => anything_else),
							(idle => scan_card => lang_used => enter_pass => option_select => transfer => option_select),
							(idle => scan_card => lang_used => enter_pass => option_select => transfer => idle),
							(anything_else => option_select),
							(anything_else => exit),
							(idle => scan_card => lang_used => enter_pass => option_select => idle);
	
*/

bins vallid_transitions[] = (idle => scan_card => lang_used => enter_pass => option_select => withdraw => anything_else),
                            (idle => scan_card => lang_used => enter_pass => option_select => deposit => option_select),
                            (idle => scan_card => lang_used => enter_pass => option_select => deposit => anything_else),
							(idle => scan_card => lang_used => enter_pass => option_select => deposit => option_select),
							(idle => scan_card => lang_used => enter_pass => option_select => new_pass => anything_else),
							(idle => scan_card => lang_used => enter_pass => option_select => transfer => anything_else),
							(idle => scan_card => lang_used => enter_pass => option_select => transfer => option_select),
							(anything_else => option_select),
							(anything_else => exit);
							
							//(idle => scan_card => lang_used => enter_pass => option_select => idle);
	                        //(idle => scan_card => lang_used => enter_pass => option_select => deposit => idle),
							//(idle => scan_card => lang_used => enter_pass => option_select => blance_check => anything_else),
							//(idle => scan_card => lang_used => enter_pass => option_select => new_pass => idle),
							//(idle => scan_card => lang_used => enter_pass => option_select => transfer => idle),

bins goto_idle [] = (idle,lang_used,enter_pass,withdraw,deposit,exit,transfer => idle);

}

endgroup

FSM_CG FSM_inst1=new();


endmodule