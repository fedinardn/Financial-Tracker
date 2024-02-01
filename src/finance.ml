open Todo
open Data

type deposit = { amt : string }

let deposit_amt amt =
  let bal = User.get_current_user_bal () in
  if float_of_string amt <= 0.0 then false
  else
    let amount = bal +. float_of_string amt in
    User.update_current_user_balance amount;
    (*balance := !balance + int_of_string amt;*)
    true

let withdraw_amt amt =
  let bal = User.get_current_user_bal () in
  (*if bal < int_of_string amt then false else*)
  let amount = bal -. float_of_string amt in
  User.update_current_user_balance amount;
  (*balance := !balance - int_of_string amt;*)
  true

let print_finance_menu () =
  ANSITerminal.print_string [ ANSITerminal.green ] "Finances \n";

  print_endline "1. View Balance";
  print_endline "2. Deposit";
  print_endline "3. Withdraw";
  print_endline "4. Record Bills and Subscriptions";
  print_endline "5. View Bills";
  print_endline "6. Pay a Bill";
  print_endline "7. Back";
  print_string "> "

let view_balance () =
  ANSITerminal.print_string [ ANSITerminal.magenta ] "Current balance:\n";
  print_float (User.get_current_user_bal ())

let deposit () =
  print_string "Amount: ";
  flush stdout;
  let amount = read_input () in
  let dep = { amt = amount } in
  if deposit_amt dep.amt then
    ANSITerminal.print_string [ ANSITerminal.cyan ] "Deposited!"
  else
    ANSITerminal.print_string [ ANSITerminal.cyan ] "Cannot deposit below $06"

let withdraw () =
  print_string "Amount: ";
  flush stdout;
  let amount = read_input () in
  let withd = { amt = amount } in
  if withdraw_amt withd.amt then
    ANSITerminal.print_string [ ANSITerminal.yellow ] "Withdrawn!"
  else ANSITerminal.print_string [ ANSITerminal.red ] "Not Enough Funds"

let update_bill_todo bill =
  let task =
    {
      todo_description = "Pay " ^ bill.bill_description ^ " Bill";
      todo_complete = false;
      todo_due_by = bill.bill_due;
    }
  in
  User.update_current_user_bills bill;
  User.update_current_user_todolist task

let pay_bill bill_1 =
  let updated_bill = { bill_1 with bill_complete = true } in
  User.update_current_user_specific_bill bill_1 updated_bill;
  let old_todo =
    {
      todo_description = "Pay " ^ bill_1.bill_description ^ " Bill";
      todo_complete = false;
      todo_due_by = bill_1.bill_due;
    }
  in
  let new_todo = { old_todo with todo_complete = true } in
  User.update_current_user_specific_todo old_todo new_todo;
  withdraw_amt (string_of_float bill_1.bill_amount)

let mark_bill_complete () =
  let bills = User.get_current_user_bills () in
  print_string "Bill number to mark complete: ";
  flush stdout;
  let bill_num = read_int () in
  if bill_num <= 0 || bill_num > List.length bills then
    print_endline "Invalid task number!"
  else
    let bill_1 = List.nth bills (bill_num - 1) in
    ignore (pay_bill bill_1);
    print_endline "Task marked as complete!"

let add_bill () =
  print_string "Bill: ";
  flush stdout;
  let desc = read_input () in
  print_string "Amount: $";
  flush stdout;
  let amt = read_input () in
  print_string "Pay By (YYYY-MM-DD): ";
  flush stdout;
  let due_by_str = read_input () in
  if not (Todo.is_valid_date due_by_str) then
    ANSITerminal.print_string [ ANSITerminal.red ]
      "Invalid date format. Please use YYYY-MM-DD format.\n"
  else
    let due_by = due_by_str in
    let bill =
      {
        bill_description = desc;
        bill_complete = false;
        bill_amount = float_of_string amt;
        bill_due = due_by;
      }
    in

    update_bill_todo bill;
    ANSITerminal.print_string [ ANSITerminal.cyan ] "Bill added!"

let view_bills () =
  let bills = User.get_current_user_bills () in
  if List.length bills = 0 then
    ANSITerminal.print_string [ ANSITerminal.yellow ] "No bills to display!\n"
  else ANSITerminal.print_string [ ANSITerminal.blue ] "Current bills: \n";
  List.iteri
    (fun i bill ->
      ANSITerminal.printf [ ANSITerminal.white ] "%d. %s ($%s) due by (%s) \n"
        (i + 1) bill.bill_description
        (string_of_float bill.bill_amount)
        bill.bill_due)
    bills
