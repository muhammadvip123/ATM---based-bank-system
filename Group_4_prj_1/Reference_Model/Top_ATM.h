
#include <systemc.h>
#include <cmath>
#include <string>
#include <vector>
using namespace std;

enum States {
  idle,
  scan_card,
  lang_used,
  enter_pass,
  option_select,
  blance_check,
  withdraw,
  deposit,
  transfer,
  new_pass,
  Exit,
  anything_else
};


typedef unsigned char uint8_t;
typedef unsigned int uint32_t;
//search for card
bool does_cart_exist(const string& filename, const uint64_t& numToSearch)  {
    ifstream file(filename); // Open the file for reading

    if (file.is_open()) // Check if file is opened successfully
    {
        string line;
        while (getline(file, line)) // Read lines from the file
        {
            istringstream iss(line);
            string numString;
            string pinString;
            getline(iss, numString, ','); // Split the line by commas

            uint64_t num = stoll(numString); // Convert the first number to uint64_t
            if (num == numToSearch) // Compare with the number to search
            {
                cout<<"card is found\n";
                return true; // Return true
            }
        }
        file.close(); // Close the file
    }
    cout<<"card is not found\n";
    return false; // Return false if not found or file not opened
}
/*****************************/
bool is_pass_correct(const string& filename,const uint16_t& card_password ,const uint64_t& numToSearch)
{
    ifstream file(filename); // Open the file for reading

    if (file.is_open()) // Check if file is opened successfully
    {
        string line;
        while (getline(file, line)) // Read lines from the file
        {
            istringstream iss(line);
            string numString;
            string pinString;
            getline(iss, numString, ','); // Split the line by commas
            getline(iss, pinString, ','); //get the pass

            uint64_t num = stoll(numString); // Convert the first number to uint64_t
            uint16_t pin = stoll(pinString);
            if (num == numToSearch) // Compare with the number to search
            {
                if(pin == card_password){
                    cout<<"card passowrd is true\n";
                    return true; // Return true if found
                }
                else{
                    cout<<"card password is incorrect\n";
                    return false; //return false if incorrect
                }
                file.close(); // Close the file
            }
        }
        file.close(); // Close the file
    }
    cout<<"card is not found\n";
    return false; // Return false if not found or file not opened
}
//-------------------------------------------------------------------------
//check balance function
uint16_t check_balance(const string& filename, const uint64_t& numToSearch)
{
    ifstream file(filename); // Open the file for reading

    if (file.is_open()) // Check if file is opened successfully
    {
        string line;
        while (getline(file, line)) // Read lines from the file
        {
            istringstream iss(line);
            string numString;
            string balanceString;
            getline(iss, numString, ',');
            getline(iss, balanceString, ','); 
            getline(iss, balanceString, ',');

            uint64_t num = stoll(numString); // Convert the first number to uint64_t
            uint16_t balance = stoll(balanceString);
            if (num == numToSearch) // Compare with the number to search
            {
                file.close(); // Close the file
                return balance;
            }
        }
        file.close(); // Close the file
    }
    return 0;
}

//----------------------------------------------------------------------------------
//withdraw balance
void change_money(const string& filename, const uint64_t& numToSearch, uint16_t money_left)
{
    ifstream file(filename); // Open input file in read mode
    vector<string> lines; // Store lines in memory

    if (file.is_open()) // Check if file is opened successfully
    {
        string line;
        while (getline(file, line)) // Read lines from the file
        {
            istringstream iss(line);
            string numString;
            string balanceString;
            getline(iss, numString, ',');

            uint64_t num = stoll(numString); // Convert the first number to uint64_t
            if (num == numToSearch) // Compare with the number to search
            {
                vector<string> fields; // Store fields in a vector

                // Split line into fields using commas as delimiter
                size_t pos = 0;
                string field;
                while ((pos = line.find(',')) != string::npos) {
                    field = line.substr(0, pos);
                    fields.push_back(field);
                    line.erase(0, pos + 1);
                }
                fields.push_back(line); // Last field after the last comma

                if (fields.size() >= 3) { // Modify the third field (data3)
                    fields[2] = to_string(money_left); // Replace with new value
                }

                // Join the fields back into a line
                line = fields[0];
                for (size_t i = 1; i < fields.size(); ++i) {
                    line += ',' + fields[i];
                }
            }
            lines.push_back(line); // Store the line in memory
        }
        file.close(); // Close the file

        // Write entire contents of the file back to disk
        ofstream outfile(filename, ios::out | ios::trunc);
        if (outfile.is_open()) {
            for (const auto& l : lines) {
                outfile << l << endl;
            }
            outfile.close(); // Close the output file
        } else {
            cout << "Failed to open file for writing." << endl;
        }
    } else {
        cout << "Failed to open file for reading." << endl;
    }
}

//change pass function
void change_pass(const string& filename, const uint64_t& numToSearch, uint16_t new_pass)
{
    ifstream file(filename); // Open input file in read mode
    vector<string> lines; // Store lines in memory

    if (file.is_open()) // Check if file is opened successfully
    {
        string line;
        while (getline(file, line)) // Read lines from the file
        {
            istringstream iss(line);
            string numString;
            string balanceString;
            getline(iss, numString, ',');

            uint64_t num = stoll(numString); // Convert the first number to uint64_t
            if (num == numToSearch) // Compare with the number to search
            {
                vector<string> fields; // Store fields in a vector

                // Split line into fields using commas as delimiter
                size_t pos = 0;
                string field;
                while ((pos = line.find(',')) != string::npos) {
                    field = line.substr(0, pos);
                    fields.push_back(field);
                    line.erase(0, pos + 1);
                }
                fields.push_back(line); // Last field after the last comma

                if (fields.size() >= 3) { // Modify the third field (data3)
                    fields[1] = to_string(new_pass); // Replace with new value
                }

                // Join the fields back into a line
                line = fields[0];
                for (size_t i = 1; i < fields.size(); ++i) {
                    line += ',' + fields[i];
                }
            }
            lines.push_back(line); // Store the line in memory
        }
        file.close(); // Close the file

        // Write entire contents of the file back to disk
        ofstream outfile(filename, ios::out | ios::trunc);
        if (outfile.is_open()) {
            for (const auto& l : lines) {
                outfile << l << endl;
            }
            outfile.close(); // Close the output file
        } else {
            cout << "Failed to open file for writing." << endl;
        }
    } else {
        cout << "Failed to open file for reading." << endl;
    }
}



SC_MODULE(TOP_ATM){
    sc_in<bool> clk, ic, mt ,enter; // clock - insert card - More transactions
    sc_in<sc_uint<2>> option;
    sc_in<sc_uint<64>> credit_number,destination_number;
    sc_in<sc_uint<4>> keyboard;
    sc_in<sc_uint<16>> en_password, new_password;
    sc_in<sc_uint<16>> en_ammount_money;
    sc_out<bool> account_balance;
    sc_out<bool> Insuffucient_flag;
    sc_out<bool> card_accepted;
    sc_out<bool> y0,y1,y2,y3,y4,y5,y6,y7,y11,y10,y8,y12;

    // Created the signals
  	sc_signal<States> state;
    sc_signal<sc_uint<16>> pass;
    int count1, wrongtrials;
    uint64_t card_num_temp;
    uint16_t pass_temp;
    uint16_t balance;
    uint16_t money_wanted;
    int     sum;
    bool    pass_correct;
    bool    card_exist;

    void ATM_Process(void){
        y0.write(0);
        y1.write(0);
        y2.write(0);
        y3.write(0);
        y4.write(0);
        y5.write(0);
        y6.write(0);
        y7.write(0);
        y11.write(0);
        y10.write(0);
        y8.write(0);
        y12.write(0);
        switch(state){
            case idle:
                cout<<"at "<<sc_time_stamp()<<" please insert a card "<<endl;
                y0.write(1);
                if(ic == 1){
                    cout<<"user entered a card"<<endl;
                    state = scan_card;
                    card_num_temp = credit_number.read();
                    count1 = 0;
                    return;
                }
                else{
                    state = idle;
                    return;
                }
            case scan_card:
                cout<<"at "<<sc_time_stamp()<<" scan card state "<<endl;
                card_exist = does_cart_exist("numbers.txt",card_num_temp);
                if(card_exist){
                    cout<<"card exist"<<endl;
                    state = lang_used;
                    return;
                }
                else{
                    state = idle;
                    return;
                }
            case lang_used:
                cout<<"at "<<sc_time_stamp()<<" choose language"<<endl;
                y7.write(1);
                if(count1 < 5){
                    if(keyboard.read() != 0){
                        state = enter_pass;
                        count1=0;
                        wrongtrials = 0;
                        return;
                    }
                    count1 = count1 + 1;
                    return;
                }
                else{
                    state = idle;
                    count1=0;
                    wrongtrials = 0;
                    return;
                }
            case enter_pass:
                y6.write(1);
                cout<<"enter password"<<endl;
                if(count1 < 5){
                    if(enter.read() == 1){
                        count1 = 0;
                        pass_correct = is_pass_correct("numbers.txt",en_password.read(),card_num_temp);
                        if(pass_correct){
                            cout<<"at "<<sc_time_stamp()<<" user entered the correct password"<<endl;
                            state = option_select;
                        }
                        else if(wrongtrials != 5){
                            cout<<"at "<<sc_time_stamp()<<" user entered the wrong password"<<endl;
                            wrongtrials +=1;
                            state = enter_pass;
                            count1 = count1+1;
                        }
                        else{
                            wrongtrials = 0;
                            state = idle;
                            count1 = 0;
                        }
                        return;
                    }
                }
                else{
                    count1 = 0;
                    state = idle;
                    cout<<"at "<<sc_time_stamp()<<" Timeout for password collecting\n";
                    return;
                }
            case option_select:
                y10.write(0);
                if(count1 <5){
                    if(option.read() != 0){
                        if(option.read() == 1){
                            state = blance_check;
                            cout<<"at "<<sc_time_stamp()<<" check Balance operation selected\n";
                            count1 = 0 ; 
                        }
                        else if(option.read() == 2){
                            state = withdraw;
                            cout<<"at "<<sc_time_stamp()<<" withdraw operation selected\n";
                            count1 = 0 ; 
                        }
                        else if(option.read() == 3){
                            state = deposit;
                            cout<<"at "<<sc_time_stamp()<<" deposit operation selected\n";
                            count1 = 0 ; 
                        }
                        else if(option.read() == 4){
                            state = transfer;
                            cout<<"at "<<sc_time_stamp()<<" transfer operation selected\n";
                            count1 = 0 ; 
                        }
                        else if(option.read() == 5){
                            state = new_pass;
                            cout<<"at "<<sc_time_stamp()<<" new password operation selected\n";
                            count1 = 0 ; 
                        }
                        else if(option.read() == 6){
                            state = Exit;
                            count1 = 0 ; 
                        }
                        else {
                            count1 +=1;
                        }
                        return;
                    }
                    count1 = count1+1;
                    return;
                }
                else{
                    state = idle;
                    count1 = 0;
                    return;
                }


            case blance_check:
                y1.write(1);
                balance = check_balance("numbers.txt",card_num_temp);
                if(count1 <5){
                    cout<<"at "<<sc_time_stamp()<<" balance is checked and it is equivalent to the following "<<balance<<" Egyptian pounds\n";
                    state = blance_check;
                    count1 +=1;
                    return;
                }
                else{
                    state = anything_else;
                    count1 = 0;
                    return;
                }


            case withdraw:
                y2.write(1);
                balance = check_balance("numbers.txt",card_num_temp);
                if(count1 < 10){
                    if(enter.read()== 1){
                        if(en_ammount_money.read() <= balance) {
                            balance = balance - en_ammount_money.read();
                            cout<<"at "<<sc_time_stamp()<<" an amount of money "<<en_ammount_money.read()<<" have been withdrawed"<<endl;
                            change_money("numbers.txt", card_num_temp,balance);
                            count1 = 0;
                            state = anything_else;
                            return;
                        }
                        else{
                            cout<<"at "<<sc_time_stamp()<<" insuffcient ammount in Balance!!"<<endl;
                            state = withdraw;
                            return;
                        }
                    }
                    else{
                        count1 = count1+1;
                        return;
                    }
                }
                else{
                    count1 = 0;
                    state = idle;
                    cout<<"at "<<sc_time_stamp()<<" Timeout for withdrawing money\n";
                    return;
                }
            case deposit:
                y3.write(1);
                balance = check_balance("numbers.txt",card_num_temp);
                if(count1 < 10){
                    if(enter.read()== 1)
                        if(en_ammount_money.read() !=0 ){
                            balance = balance + en_ammount_money.read();
                            change_money("numbers.txt", card_num_temp,balance);
                            state = anything_else;
                            cout<<"at "<<sc_time_stamp()<<" user depsited "<<en_ammount_money.read()<<" now balance is equal to "<<balance<<endl;
                            count1 = 0;
                            return;
                        }
                    else{
                        count1 = count1+1;
                        return;
                    }
                }
                else{
                    count1 = 0;
                    money_wanted = 0;
                    state = idle;
                    cout<<"at "<<sc_time_stamp()<<" Timeout for inserting money\n";
                    return;
                }
            case transfer:
                y4.write(1);
                balance = check_balance("numbers.txt",card_num_temp);
                if(count1 < 10){
                    if(enter.read() == 1){
                        if(en_ammount_money.read() !=0 && en_ammount_money.read() <= balance && does_cart_exist("numbers.txt",destination_number.read())){
                            balance = balance + en_ammount_money.read();
                            change_money("numbers.txt", destination_number.read(),balance);
                            state = anything_else;
                            cout<<"at "<<sc_time_stamp()<<" user depsited "<<en_ammount_money.read()<<" now balance is equal to "<<balance<<endl;
                            count1 = 0;
                            return;
                        }
                    }
                    else{
                        count1 = count1+1;
                        return;
                    }
                }
                else{
                    count1 = 0;
                    money_wanted = 0;
                    state = idle;
                    cout<<"at "<<sc_time_stamp()<<" Timeout for inserting money\n";
                    return;
                }
            case new_pass:
                y12.write(1);
                cout<<"change password operation"<<endl;
                if(count1 < 10){
                    if(enter.read()== 1){
                        change_pass("numbers.txt",card_num_temp,new_password.read());
                        cout<<"at "<<sc_time_stamp()<<" user changed password"<<endl;;
                        state = anything_else;
                        return;
                    }
                    else{
                        count1 += 1;
                        return;
                    }
                }
                else{
                    count1 = 0;
                    state = idle;
                    return;
                }
            case anything_else:
                y11.write(1);
                if(mt.read() == 1){
                    cout<<"at "<<sc_time_stamp()<<" user checked for another operation \n";
                    state = option_select;
                    return;
                }
                else{
                    cout<<"at "<<sc_time_stamp()<<" user ended the operations \n";
                    state = idle;
                    return; 
                }
                
        }

    }
    SC_CTOR(TOP_ATM)        
  {
    SC_METHOD(ATM_Process); 
    sensitive << clk.pos();
  }      
};
