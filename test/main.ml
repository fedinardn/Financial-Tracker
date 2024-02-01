open OUnit2
open Budget
open Todo
open Finance
open Data
open User

(*cloc --by-file --include-lang=OCaml .*)
(*Testing Plan: Much of our system relied on the interface and thus a lot of our
  testing was done directly using make plan, the command that made the planner
  and allowed users to log in and record their spending, bills, and tasks.
  Howver, many of out interface functions used helper functions in other modules
  that could be tested using OUnit. We tested these functions and realized we
  were running into problems using the same logged in user for all of them, so
  for each test we created a new user and tested a function in each to see if we
  obtained the expected change to our json file. Among them, we tested
  withdrawing, depositing, and getting current_user balance. We also tested
  adding todo's and bills. A big thing we tested was date authentification,
  testing edge cases such as leap years, and making sure each month had the
  proper number of days. For the most part, we used glassbox testing to write
  these tests. We ensured in each test helper function, we performed current
  user functions and got the expected result, even if that required depositing,
  adding bills, and adding todo's each time. For multi user testing, we directly
  used the interface which we worked on developing early. We have tested
  extensively on the interface and the OUnit tests test the helper functions
  that are used in the interface. This shows that the tests show the correctness
  of our program because the tests are written to perform together, similar to
  how our interface works, as well as separately*)
let data_dir_prefix = "data" ^ Filename.dir_sep
let test = data_dir_prefix ^ "test_main.json"
let string_pp s = s

let signup_save id nm pw =
  User.signup id nm pw;
  User.login_and_set_user id pw;
  User.save_current_user ();
  Data.save_data_to_json test

let test_loggedin (name : string) (id : string) (nm : string) (pw : string)
    (expected_output : bool) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  assert_equal expected_output (User.is_logged_in ()) ~printer:string_of_bool

let test_loggedout (name : string) (id : string) (nm : string) (pw : string)
    (expected_output : bool) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  User.logout ();
  assert_equal expected_output (User.is_logged_in ()) ~printer:string_of_bool

let test_current_t (name : string) (id : string) (nm : string) (pw : string)
    (expected_output : string) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  assert_equal expected_output (User.get_current_username ()) ~printer:string_pp

let test_encr_pass (name : string) (pw : string) (expected_output : string) :
    test =
  name >:: fun _ ->
  assert_equal expected_output (Data.encrypt_pass pw) ~printer:string_pp

let get_balance_t (name : string) (id : string) (nm : string) (pw : string)
    (expected_output : float) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  assert_equal expected_output
    (User.get_current_user_bal ())
    ~printer:string_of_float

let get_name_t (name : string) (id : string) (nm : string) (pw : string)
    (expected_output : string) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  assert_equal expected_output (User.get_current_username ()) ~printer:string_pp

let get_password_t (name : string) (id : string) (nm : string) (pw : string)
    (expected_output : string) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  assert_equal expected_output
    (User.get_current_user_pass ())
    ~printer:string_pp

let get_bills_t (name : string) (id : string) (nm : string) (pw : string)
    (expected_output : Data.bill list) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  assert_equal expected_output (User.get_current_user_bills ())

let get_todos_t (name : string) (id : string) (nm : string) (pw : string)
    (expected_output : Data.todo list) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  assert_equal expected_output (User.get_current_user_todolist ())

let dep_once_t (name : string) (id : string) (nm : string) (pw : string)
    (amt : string) (expected_output : float) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  ignore (deposit_amt amt);
  User.save_current_user ();
  Data.save_data_to_json test;
  assert_equal expected_output
    (User.get_current_user_bal ())
    ~printer:string_of_float

let dep_twice_t (name : string) (id : string) (nm : string) (pw : string)
    (amt1 : string) (amt2 : string) (expected_output : float) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  ignore (deposit_amt amt1);
  User.save_current_user ();
  ignore (deposit_amt amt2);
  User.save_current_user ();
  Data.save_data_to_json test;
  assert_equal expected_output
    (User.get_current_user_bal ())
    ~printer:string_of_float

let dep_with_once_t (name : string) (id : string) (nm : string) (pw : string)
    (amt_d : string) (amt_w : string) (expected_output : float) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  ignore (deposit_amt amt_d);
  User.save_current_user ();
  ignore (withdraw_amt amt_w);
  User.save_current_user ();
  Data.save_data_to_json test;
  assert_equal expected_output
    (User.get_current_user_bal ())
    ~printer:string_of_float

let dep_with_dep_t (name : string) (id : string) (nm : string) (pw : string)
    (amt_d : string) (amt_w : string) (amt_d2 : string)
    (expected_output : float) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  ignore (deposit_amt amt_d);
  User.save_current_user ();
  ignore (withdraw_amt amt_w);
  User.save_current_user ();
  ignore (deposit_amt amt_d2);
  User.save_current_user ();
  Data.save_data_to_json test;
  assert_equal expected_output
    (User.get_current_user_bal ())
    ~printer:string_of_float

let update_user_t (name : string) (id : string) (nm : string) (pw : string)
    (newn : string) (expected_output : string) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  User.update_current_username newn;
  User.save_current_user ();
  Data.save_data_to_json test;
  assert_equal expected_output (User.get_current_username ()) ~printer:string_pp

let update_userpass_t (name : string) (id : string) (nm : string) (pw : string)
    (newp : string) (expected_output : string) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  User.update_current_user_password newp;
  User.save_current_user ();
  Data.save_data_to_json test;
  assert_equal expected_output
    (User.get_current_user_pass ())
    ~printer:string_pp

let bill_add_help des amt due =
  let bill =
    {
      bill_description = des;
      bill_complete = false;
      bill_amount = float_of_string amt;
      bill_due = due;
    }
  in
  User.update_current_user_bills bill;
  User.save_current_user ()

let add_bill_t (name : string) (id : string) (nm : string) (pw : string)
    (des : string) (amt : string) (due_by : string)
    (expected_output : Data.bill) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  bill_add_help des amt due_by;
  Data.save_data_to_json test;
  assert_equal expected_output (List.hd (User.get_current_user_bills ()))

let add_twobill_t (name : string) (id : string) (nm : string) (pw : string)
    (des1 : string) (amt1 : string) (due_by1 : string) (des2 : string)
    (amt2 : string) (due_by2 : string) (expected_output : Data.bill list) : test
    =
  name >:: fun _ ->
  signup_save id nm pw;
  bill_add_help des1 amt1 due_by1;
  bill_add_help des2 amt2 due_by2;
  Data.save_data_to_json test;
  assert_equal expected_output (User.get_current_user_bills ())

let todo_add_help (des : string) (due_by : string) =
  let todo =
    { todo_description = des; todo_complete = false; todo_due_by = due_by }
  in
  User.update_current_user_todolist todo;
  User.save_current_user ()

let add_todo_t (name : string) (id : string) (nm : string) (pw : string)
    (des : string) (due_by : string) (expected_output : Data.todo) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  todo_add_help des due_by;
  Data.save_data_to_json test;
  assert_equal expected_output (List.hd (User.get_current_user_todolist ()))

let complete_recent_todo_t (name : string) (id : string) (nm : string)
    (pw : string) (des : string) (due_by : string) (des2 : string)
    (due_by2 : string) (expected_output : Data.todo list) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  todo_add_help des due_by;
  todo_add_help des2 due_by2;
  Data.save_data_to_json test;
  let old_todo =
    { todo_description = des2; todo_complete = false; todo_due_by = due_by2 }
  in
  let comp_todo =
    { todo_description = des2; todo_complete = true; todo_due_by = due_by2 }
  in
  User.update_current_user_specific_todo old_todo comp_todo;
  Data.save_data_to_json test;
  assert_equal expected_output (User.get_current_user_todolist ())

let complete_old_todo_t (name : string) (id : string) (nm : string)
    (pw : string) (des : string) (due_by : string) (des2 : string)
    (due_by2 : string) (expected_output : Data.todo list) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  todo_add_help des due_by;
  todo_add_help des2 due_by2;
  Data.save_data_to_json test;
  let old_todo =
    { todo_description = des; todo_complete = false; todo_due_by = due_by }
  in
  let comp_todo =
    { todo_description = des; todo_complete = true; todo_due_by = due_by }
  in
  User.update_current_user_specific_todo old_todo comp_todo;
  Data.save_data_to_json test;
  assert_equal expected_output (User.get_current_user_todolist ())

let add_bill_todo_t (name : string) (id : string) (nm : string) (pw : string)
    (des : string) (amt : string) (due_by : string)
    (expected_output : Data.todo) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  let bill =
    {
      bill_description = des;
      bill_complete = false;
      bill_amount = float_of_string amt;
      bill_due = due_by;
    }
  in
  Finance.update_bill_todo bill;
  User.save_current_user ();
  Data.save_data_to_json test;
  assert_equal expected_output (List.hd (User.get_current_user_todolist ()))

let pay_bill_todo_t (name : string) (id : string) (nm : string) (pw : string)
    (des : string) (amt : string) (due_by : string) (des2 : string)
    (amt2 : string) (due2 : string) (expected_output : Data.todo list) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  Data.save_data_to_json test;
  let bill =
    {
      bill_description = des;
      bill_complete = false;
      bill_amount = float_of_string amt;
      bill_due = due_by;
    }
  in
  let bill2 =
    {
      bill_description = des2;
      bill_complete = false;
      bill_amount = float_of_string amt2;
      bill_due = due2;
    }
  in
  Finance.update_bill_todo bill;
  User.save_current_user ();
  Finance.update_bill_todo bill2;
  User.save_current_user ();
  Data.save_data_to_json test;
  ignore (Finance.pay_bill bill2);
  Data.save_data_to_json test;
  assert_equal expected_output (User.get_current_user_todolist ())

let pay_bill_bal_t (name : string) (id : string) (nm : string) (pw : string)
    (dep : string) (des : string) (amt : string) (due_by : string)
    (des2 : string) (amt2 : string) (due2 : string) (expected_output : float) :
    test =
  name >:: fun _ ->
  signup_save id nm pw;
  ignore (Finance.deposit_amt dep);
  User.save_current_user ();
  Data.save_data_to_json test;
  let bill =
    {
      bill_description = des;
      bill_complete = false;
      bill_amount = float_of_string amt;
      bill_due = due_by;
    }
  in
  let bill2 =
    {
      bill_description = des2;
      bill_complete = false;
      bill_amount = float_of_string amt2;
      bill_due = due2;
    }
  in
  Finance.update_bill_todo bill;
  User.save_current_user ();
  Finance.update_bill_todo bill2;
  User.save_current_user ();
  Data.save_data_to_json test;
  ignore (Finance.pay_bill bill2);
  Data.save_data_to_json test;
  assert_equal expected_output
    (User.get_current_user_bal ())
    ~printer:string_of_float

let is_valid_date_test (name : string) (date : string) (expected_output : bool)
    : test =
  name >:: fun _ ->
  assert_equal expected_output (Todo.is_valid_date date) ~printer:string_of_bool

let deadline_test (name : string) (id : string) (nm : string) (pw : string)
    (des : string) (due_by : string) (des2 : string) (due_by2 : string)
    (description : string) (expected_output : string) : test =
  name >:: fun _ ->
  signup_save id nm pw;
  todo_add_help des due_by;
  todo_add_help des2 due_by2;
  Data.save_data_to_json test;
  assert_equal expected_output
    (Todo.get_deadline description)
    ~printer:string_pp

let sor_bill =
  {
    bill_description = "sorority dues";
    bill_complete = false;
    bill_amount = 500.;
    bill_due = "2023-08-16";
  }

let light_bill =
  {
    bill_description = "light";
    bill_complete = false;
    bill_amount = 100.;
    bill_due = "2023-07-05";
  }

let light_todo =
  {
    todo_description = "Pay light Bill";
    todo_complete = false;
    todo_due_by = "2023-07-05";
  }

let light_todo_payed =
  {
    todo_description = "Pay light Bill";
    todo_complete = true;
    todo_due_by = "2023-07-05";
  }

let sor_todo =
  {
    todo_description = "Pay sorority dues Bill";
    todo_complete = false;
    todo_due_by = "2023-08-16";
  }

let sor_todo_payed =
  {
    todo_description = "Pay sorority dues Bill";
    todo_complete = true;
    todo_due_by = "2023-08-16";
  }

let hw =
  {
    todo_description = "do homework";
    todo_complete = false;
    todo_due_by = "2023-05-16";
  }

let hw_done =
  {
    todo_description = "do homework";
    todo_complete = true;
    todo_due_by = "2023-05-16";
  }

let dishes =
  {
    todo_description = "wash dishes";
    todo_complete = false;
    todo_due_by = "2023-05-15";
  }

let dishes_done =
  {
    todo_description = "wash dishes";
    todo_complete = true;
    todo_due_by = "2023-05-15";
  }

let budget_tests =
  [
    test_loggedin "is logged in" "user0" "name0" "passw" true;
    test_loggedout "is logged_out" "user" "name" "pass" false;
    test_current_t "make Justin Hsu User" "jh3110" "Justin Hsu" "cs3110"
      "Justin Hsu";
    get_balance_t "get balance test" "jh3110" "Justin Hsu" "cs3110" 0.;
    get_name_t "get name test" "jh3110" "Justin Hsu" "cs3110" "Justin Hsu";
    get_password_t "get password empty test" "pd" "Penny Wise" "" "";
    get_password_t "get password nonempty test" "pd" "Penny Wise" "balloon"
      "balloon";
    get_bills_t "get empty bills test" "taytay13" "Taylor" "13" [];
    get_todos_t "get empty todos test" "taytay13" "Taylor" "13" [];
    test_encr_pass "empty" "" "";
    test_encr_pass "one character" "a" "*";
    test_encr_pass "several characters" "goobcs3110" "**********";
    test_encr_pass "several characters with spaces" "goob cs3110" "***********";
    dep_once_t "deposit $5" "dr497" " dani" "goob" "5" 5.;
    dep_once_t "deposit $40000" "username" "name" "pass" "40000" 40000.;
    dep_once_t "deposit $195" "cdc223" "cannon" "beach" "195" 195.;
    dep_twice_t "deposit $195 and $40" "ddc79" "drew" "noandsabtit" "195" "40"
      235.;
    dep_twice_t "deposit $0 and $40" "ddc79" "dre" "noandsabit" "0" "40" 40.;
    dep_with_once_t "deposit 200 withdraw $50" "pdt35" "peter" "cs3110" "200"
      "50" 150.;
    dep_with_once_t "withdraw into negatives" "user" "nombre" "contra" "200"
      "300" ~-.100.;
    dep_with_dep_t "deposit $500 withdraw $200 deposite $57" "marfau" "mariana"
      "gig" "500" "200" "57" 357.;
    update_user_t "change Dr.Lee's name" "cs110" "Lilian Lee" "python"
      "Prof Lee" "Prof Lee";
    update_userpass_t "change goob to xalteno" "DR497" " Dani" "goob" "xalteno"
      "xalteno";
    add_bill_t "add sor bill" "ata35" "angela" "axo" "sorority dues" "500"
      "2023-08-16" sor_bill;
    add_twobill_t "add light bill" "katy123" "sanne" "ut" "sorority dues" "500"
      "2023-08-16" "light" "100" "2023-07-05" [ light_bill; sor_bill ];
    add_todo_t "add hw todo" "ednaox" "edna ojeda" "xochi" "do homework"
      "2023-05-16" hw;
    is_valid_date_test "jan 23, 2024 is valid" "2024-01-23" true;
    is_valid_date_test "jan (not valid day), 2024 is not valid" "2024-01-57"
      false;
    is_valid_date_test "(not a month) 14, 2024 is not valid" "2024-13-14" false;
    is_valid_date_test "(0 month) 14, 2024 is not valid" "2024-00-14" false;
    is_valid_date_test "January (0 day), 2024 is not valid" "2024-01-00" false;
    is_valid_date_test "January 15, 0000 is valid" "0000-01-15" true;
    is_valid_date_test "feb 31, 2024 is not valid" "2024-02-31" false;
    is_valid_date_test "June 31, 2024 is not valid" "2024-06-31" false;
    is_valid_date_test "April 31, 2024 is not valid" "2024-04-31" false;
    is_valid_date_test "November 31, 2024 is not valid" "2024-11-31" false;
    is_valid_date_test "Febuary 29 non leap year" "2023-02-29" false;
    is_valid_date_test "Febuary 29 leap year" "2024-02-29" true;
    complete_recent_todo_t "wash dishes complete" "dr6768" "dani r" "236c"
      "do homework" "2023-05-16" "wash dishes" "2023-05-15" [ dishes_done; hw ];
    complete_old_todo_t "hw complete" "dr67" "danir" "236c" "do homework"
      "2023-05-16" "wash dishes" "2023-05-15" [ dishes; hw_done ];
    add_bill_todo_t "sorority dues as todo" "Ata35" "Angela A" "axo2022"
      "sorority dues" "500" "2023-08-16" sor_todo;
    pay_bill_todo_t "pay light bill" "katy123" "sanne" "ut" "sorority dues"
      "500" "2023-08-16" "light" "100" "2023-07-05"
      [ light_todo_payed; sor_todo ];
    pay_bill_todo_t "pay sor bill" "katy123" "sanne" "ut" "light" "100"
      "2023-07-05" "sorority dues" "500" "2023-08-16"
      [ sor_todo_payed; light_todo ];
    pay_bill_bal_t "pay light bill pos bal" "katy123" "sanne" "ut" "1000"
      "sorority dues" "500" "2023-08-16" "light" "100" "2023-07-05" 900.;
    pay_bill_bal_t "pay light bill no money" "katy123" "sanne" "ut" "0"
      "sorority dues" "500" "2023-08-16" "light" "100" "2023-07-05" ~-.100.;
    pay_bill_bal_t "pay light bill neg bal" "katy123" "sanne" "ut" "10"
      "sorority dues" "500" "2023-08-16" "light" "100" "2023-07-05" ~-.90.;
    pay_bill_bal_t "pay sor bill neg bal" "katy123" "sanne" "ut" "10" "light"
      "100" "2023-07-05" "sorority dues" "500" "2023-08-16" ~-.490.;
    deadline_test "overdue by day" "mac" "dan" "comp" "prom" "2023-05-14" "hw"
      "2057-03-19" "prom" "Task prom is overdue!\n";
    deadline_test "overdue by month" "mac" "dan" "comp" "prom" "2023-03-14" "hw"
      "2057-03-19" "prom" "Task prom is overdue!\n";
    deadline_test "overdue by year" "mac" "dan" "comp" "prom" "2022-03-14" "hw"
      "2057-03-19" "prom" "Task prom is overdue!\n";
    deadline_test "due in future" "max" "danx" "compx" "prom" "2022-05-14" "hw"
      "2057-03-19" "hw" "Task hw is still some time away! Get started on it!\n";
  ]

let suite = "test suite for Orion" >::: List.flatten [ budget_tests ]
let _ = run_test_tt_main suite
