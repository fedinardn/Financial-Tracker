type logged_in_user = Data.user_data option ref

let current_user : logged_in_user = ref None

let is_logged_in () =
  match !current_user with
  | None -> false
  | Some _ -> true

let print_profile_menu () =
  print_endline "";
  ANSITerminal.printf [ ANSITerminal.magenta ] "Profile Menu \n";
  print_endline "1. Change User's Name";
  print_endline "2. Change Password";
  print_endline "3. Delete Account";
  print_endline "4. Back";
  print_string "> "

let signup user_id name password =
  let new_user =
    {
      Data.userID = user_id;
      Data.password;
      Data.name;
      Data.balance = 0.0;
      Data.bills = [];
      Data.todolist = [];
    }
  in
  Data.data := new_user :: !Data.data

let login user_id password =
  let rec find_user = function
    | [] -> None
    | user :: users ->
        if user.Data.userID = user_id && user.Data.password = password then
          Some user
        else find_user users
  in
  find_user !Data.data

let login_and_set_user user_id password =
  match login user_id password with
  | Some user -> current_user := Some user
  | None -> failwith "Invalid user id or password"

let logout () =
  match !current_user with
  | None -> failwith "No user logged in"
  | Some _ -> current_user := None

let update_current_username new_name =
  match !current_user with
  | Some current_user_data ->
      let updated_user = { current_user_data with Data.name = new_name } in
      current_user := Some updated_user
  | None -> failwith "No user logged in"

let update_current_user_balance amount =
  match !current_user with
  | Some current_user_data ->
      let updated_user = { current_user_data with Data.balance = amount } in
      current_user := Some updated_user
  | None -> failwith "No user logged in"

let update_current_user_password new_password =
  match !current_user with
  | None -> failwith "No user logged in"
  | Some current_user_data ->
      let updated_user =
        { current_user_data with Data.password = new_password }
      in
      current_user := Some updated_user

let get_current_username () =
  match !current_user with
  | Some current_user_data -> current_user_data.Data.name
  | None -> failwith "No user logged in"

let get_current_user_pass () =
  match !current_user with
  | Some current_user_data -> current_user_data.Data.password
  | None -> failwith "No user logged in"

let get_current_user_info () =
  match !current_user with
  | None -> failwith "No user logged in"
  | Some current_user_data -> current_user_data

let get_current_user_bal () =
  match !current_user with
  | None -> failwith "No user logged in"
  | Some current_user_data -> current_user_data.balance

let get_current_user_bills () =
  match !current_user with
  | None -> failwith "No user logged in"
  | Some current_user_data -> current_user_data.bills

let get_current_user_todolist () =
  match !current_user with
  | Some current_user_data -> current_user_data.todolist
  | None -> failwith "No user logged in"

let update_current_user_bills bill =
  match !current_user with
  | Some current_user_data ->
      let updated_user =
        {
          current_user_data with
          Data.bills = bill :: get_current_user_bills ();
        }
      in
      current_user := Some updated_user
  | None -> failwith "No user logged in"

let update_current_user_todolist todo =
  match !current_user with
  | Some current_user_data ->
      let updated_user =
        {
          current_user_data with
          Data.todolist = todo :: get_current_user_todolist ();
        }
      in
      current_user := Some updated_user
  | None -> failwith "No user logged in"

let update_current_user_specific_todo old_todo new_todo =
  match !current_user with
  | None -> failwith "No user logged in"
  | Some current_user_data ->
      let updated_todos =
        List.map
          (fun todo -> if todo = old_todo then new_todo else todo)
          current_user_data.Data.todolist
      in
      let updated_user =
        { current_user_data with Data.todolist = updated_todos }
      in
      current_user := Some updated_user

let update_current_user_specific_bill old_bill new_bill =
  match !current_user with
  | None -> failwith "No user logged in"
  | Some current_user_data ->
      let updated_bills =
        List.map
          (fun bill -> if bill = old_bill then new_bill else bill)
          current_user_data.Data.bills
      in
      let updated_user =
        { current_user_data with Data.bills = updated_bills }
      in
      current_user := Some updated_user

let delete_current_user () =
  match !current_user with
  | None -> failwith "No user logged in"
  | Some user ->
      Data.data :=
        List.filter (fun u -> u.Data.userID <> user.userID) !Data.data
(*current_user := None*)

let save_current_user () =
  match !current_user with
  | None -> failwith "No user logged in"
  | Some current_user_data ->
      let rec update_user_list = function
        | [] -> []
        | user :: users ->
            if user.Data.userID = current_user_data.Data.userID then
              current_user_data :: users
            else user :: update_user_list users
      in
      Data.data := update_user_list !Data.data
