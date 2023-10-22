//testbench for golden
#include <systemc.h>
#include "Top_ATM.h"
#include "driver.h"

int sc_main(int argc, char* argv[]){
	//ports and signals
    sc_signal<bool> ic, mt, enter; // clock - insert card - More transactions
    sc_signal<sc_uint<2>> option;
    sc_signal<sc_uint<64>> credit_number, destination_number;
    sc_signal<sc_uint<4>> keyboard;
    sc_signal<sc_uint<16>> en_password, new_password;
    sc_signal<sc_uint<16>> en_ammount_money;
    sc_signal<bool> account_balance;
    sc_signal<bool> Insuffucient_flag;
    sc_signal<bool> card_accepted;
    sc_signal<bool> y0, y1, y2, y3, y4, y5, y6, y7, y11, y10, y8, y12;
	sc_clock clock("clk",10,SC_NS);
    
	
	//module instances
	TOP_ATM ATM("ATM-Golden");
	driver dr("driver");
	// monitor mon("monitor");

	//clock
	ATM.clk(clock);
	
    ATM.ic(ic); // Connect insert_card input
    ATM.mt(mt); // Connect More transactions input
    ATM.enter(enter); // Connect enter input
    ATM.option(option); // Connect option input
    ATM.credit_number(credit_number); // Connect credit_number input
    ATM.destination_number(destination_number); // Connect destination_number input
    ATM.keyboard(keyboard); // Connect keyboard input
    ATM.en_password(en_password); // Connect en_password input
    ATM.new_password(new_password); // Connect new_password input
    ATM.en_ammount_money(en_ammount_money); // Connect en_ammount_money input

    dr.ic(ic); // Connect insert_card input
    dr.mt(mt); // Connect More transactions input
    dr.enter(enter); // Connect enter input
    dr.option(option); // Connect option input
    dr.credit_number(credit_number); // Connect credit_number input
    dr.destination_number(destination_number); // Connect destination_number input
    dr.keyboard(keyboard); // Connect keyboard input
    dr.en_password(en_password); // Connect en_password input
    dr.new_password(new_password); // Connect new_password input
    dr.en_ammount_money(en_ammount_money); // Connect en_ammount_money input

    //outputs
    ATM.account_balance(account_balance); // Connect account_balance output
    ATM.Insuffucient_flag(Insuffucient_flag); // Connect insufficient_flag output
    ATM.card_accepted(card_accepted); // Connect card_accepted output
    ATM.y0(y0); // Connect y0 output
    ATM.y1(y1); // Connect y1 output
    ATM.y2(y2); // Connect y2 output
    ATM.y3(y3); // Connect y3 output
    ATM.y4(y4); // Connect y4 output
    ATM.y5(y5); // Connect y5 output
    ATM.y6(y6); // Connect y6 output
    ATM.y7(y7); // Connect y7 output
    ATM.y11(y11); // Connect y11 output
    ATM.y10(y10); // Connect y10 output
    ATM.y8(y8); // Connect y8 output
    ATM.y12(y12); // Connect y12 output
	
	//tracing
	// sc_trace_file *fp;
	// fp=sc_create_vcd_trace_file("vcd_trace");
	// fp->set_time_unit(100, SC_PS);
	
	// sc_trace(fp, s_din, "INPUT");
	// sc_trace(fp, clock, "CLK");
	// sc_trace(fp, clear, "CLR");
	// sc_trace(fp, s_dout, "OUTPUT");
	
	//simulation start
	sc_start(-1);
	// sc_close_vcd_trace_file(fp);
	return 0; //end
}
