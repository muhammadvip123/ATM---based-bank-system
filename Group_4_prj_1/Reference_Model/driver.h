//driver
SC_MODULE(driver){
	sc_out<bool> ic, mt ,enter; // clock - insert card - More transactions
    sc_out<sc_uint<2>> option;
    sc_out<sc_uint<64>> credit_number,destination_number;
    sc_out<sc_uint<4>> keyboard;
    sc_out<sc_uint<16>> en_password, new_password;
    sc_out<sc_uint<16>> en_ammount_money;
    

    void drive(void){
        wait(5,SC_NS);
        credit_number = 5992448333886628;
        ic = 1;
        wait(20,SC_NS);
        ic = 0;
        keyboard = 3;
        wait(10,SC_NS);
        keyboard = 0;
        en_password = 3423;
        enter = 1;
        wait(10,SC_NS);
        option = 1;
        enter =0;


    }
	
	SC_CTOR(driver){
		SC_THREAD(drive);
	}
};
