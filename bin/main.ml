open Budget

let data_dir_prefix = "data" ^ Filename.dir_sep
let test = data_dir_prefix ^ "test.json"
let clear_terminal () = ignore (Sys.command "clear")

open Budget

let data_dir_prefix = "data" ^ Filename.dir_sep
let test = data_dir_prefix ^ "test.json"

let rec save_changes () =
  print_endline "";
  ANSITerminal.print_string [ ANSITerminal.magenta ] "Save Changes. \n";
  print_endline "1. Yes";
  print_endline "2. No";
  print_string "> ";
  let save_input = read_line () in
  match save_input with
  | "1" ->
      User.save_current_user ();
      Data.save_data_to_json test;
      print_endline "";
      ANSITerminal.print_string [ ANSITerminal.green ] "Changes Saved";
      print_endline ""
  | "2" ->
      print_endline "";
      ANSITerminal.print_string [ ANSITerminal.red ] "Changes Not Saved.";
      print_endline ""
  | _ ->
      print_endline "";
      ANSITerminal.print_string [ ANSITerminal.red ] "Invalid Input \nTry Again";
      print_endline "";
      save_changes ()

let rec profile_helper () =
  clear_terminal ();
  User.print_profile_menu ();
  let profile_input = read_line () in
  match profile_input with
  | "1" ->
      print_string "Enter new username: ";
      let new_username = read_line () in
      User.update_current_username new_username;
      save_changes ();
      profile_helper ()
  | "2" ->
      print_string "Enter new password: ";
      let new_password = read_line () in
      User.update_current_user_password new_password;
      save_changes ();
      profile_helper ()
  | "3" ->
      (*When a user is deleted it doesnt log out the user straight away. It
        fails*)
      User.delete_current_user ();
      save_changes ();
      User.logout ()
  | "4" -> ()
  | _ ->
      print_endline "";
      ANSITerminal.print_string [ ANSITerminal.red ] "Invalid Input \nTry Again";
      profile_helper ()

let rec finance_helper () =
  Finance.print_finance_menu ();
  let finance_input = read_line () in
  match finance_input with
  | "1" ->
      Finance.view_balance ();
      print_newline ();
      finance_helper ()
  | "2" ->
      Finance.deposit ();
      save_changes ();
      Finance.view_balance ();
      print_newline ();
      finance_helper ()
  | "3" ->
      Finance.withdraw ();
      save_changes ();
      Finance.view_balance ();
      print_newline ();
      finance_helper ()
  | "4" ->
      Finance.add_bill ();
      save_changes ();
      finance_helper ()
  | "5" ->
      Finance.view_bills ();
      finance_helper ()
  | "6" ->
      Finance.view_bills ();
      Finance.mark_bill_complete ();
      save_changes ();
      finance_helper ()
  | "7" -> ()
  | _ ->
      print_endline "";
      ANSITerminal.print_string [ ANSITerminal.red ] "Invalid Input \nTry Again";
      profile_helper ()

let rec tasks_helper () =
  Todo.print_todo_menu ();
  let todo_input = read_line () in
  match todo_input with
  | "1" ->
      print_string "Enter a new task: ";
      Todo.add_task ();
      save_changes ();
      tasks_helper ()
  | "2" ->
      Todo.view_tasks ();
      tasks_helper ()
  | "3" ->
      print_string "Enter the date of\n   the task to view: ";
      let date = read_line () in
      Todo.view_tasks_on_date date;
      tasks_helper ()
  | "4" ->
      Todo.view_tasks ();
      print_string "Enter the number of\n   the task to mark as complete: ";
      Todo.mark_complete ();
      save_changes ();
      tasks_helper ()
  | "5" ->
      Todo.task_time_table ();
      tasks_helper ()
  | "6" -> ()
  | _ ->
      print_endline "";
      ANSITerminal.print_string [ ANSITerminal.red ] "Invalid Input \nTry Again";
      profile_helper ()

let menu () =
  match User.is_logged_in () with
  | false ->
      print_endline "";
      ANSITerminal.print_string [ ANSITerminal.magenta ]
        "Welcome to Planner App. \nPlease Log in or Sign up\n";
      print_endline "";
      ANSITerminal.print_string [ ANSITerminal.blue ] "1. Sign Up";
      print_endline "";
      ANSITerminal.print_string [ ANSITerminal.blue ] "2. Log in";
      print_endline "";
      ANSITerminal.print_string [ ANSITerminal.red ] "3. Exit";
      print_endline "";
      print_string "> "
  | true ->
      let user_name = User.get_current_username () in
      print_endline "";
      ANSITerminal.print_string [ ANSITerminal.magenta ]
        ("Welcome " ^ user_name ^ "\n");
      print_endline "1. Profile";
      print_endline "2. Tasks";
      print_endline "3. Finance";
      print_endline "4. View All Information";
      print_endline "5. Logout";
      print_string "> "

let rec test_loop () =
  menu ();
  let input = read_line () in
  match input with
  | "1" when not (User.is_logged_in ()) ->
      print_string "Enter user ID: ";
      let user_id = read_line () in
      print_string "Enter name: ";
      let name = read_line () in
      print_string "Enter password: ";
      let password = read_line () in
      User.signup user_id name password;
      Data.save_data_to_json test;
      test_loop ()
  | "2" when not (User.is_logged_in ()) ->
      print_string "Enter user ID: ";
      let user_id = read_line () in
      print_string "Enter password: ";
      let password = read_line () in
      (try User.login_and_set_user user_id password
       with Failure msg ->
         print_endline "";
         ANSITerminal.print_string [ ANSITerminal.red ] (msg ^ "\nTry Again");
         print_endline "");
      test_loop ()
  | "3" when not (User.is_logged_in ()) ->
      ANSITerminal.print_string [ ANSITerminal.magenta ] "Goodbye!";
      print_newline ()
  (*Profile Code *)
  | "1" when User.is_logged_in () ->
      profile_helper ();
      test_loop ()
  (*Tasks Code*)
  | "2" when User.is_logged_in () ->
      tasks_helper ();
      test_loop ()
  (*Finance Code*)
  | "3" when User.is_logged_in () ->
      finance_helper ();
      test_loop ()
  | "4" when User.is_logged_in () ->
      let info = User.get_current_user_info () in
      print_endline ("User Information: \n" ^ Data.string_of_user_info info);
      test_loop ()
  | "5" when User.is_logged_in () ->
      User.logout ();
      test_loop ()
  | _ ->
      print_endline "";
      ANSITerminal.print_string [ ANSITerminal.red ] "Invalid Input \nTry Again";
      test_loop ()

let () =
  Data.init_data test;
  test_loop ()
