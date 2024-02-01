open Yojson.Basic.Util

type bill = {
  bill_description : string;
  bill_complete : bool;
  bill_amount : float;
  bill_due : string;
}

type todo = {
  todo_description : string;
  todo_complete : bool;
  todo_due_by : string;
}

type user_data = {
  userID : string;
  password : string;
  name : string;
  balance : float;
  bills : bill list;
  todolist : todo list;
}

let data : user_data list ref = ref []

let read_input () =
  let input = read_line () in
  String.trim input

let json_to_bill json =
  {
    bill_description = json |> member "bill_description" |> to_string;
    bill_complete = json |> member "bill_complete" |> to_bool;
    bill_amount = json |> member "bill_amount" |> to_float;
    bill_due = json |> member "bill_due" |> to_string;
  }

let json_to_todo json =
  {
    todo_description = json |> member "todo_description" |> to_string;
    todo_complete = json |> member "todo_complete" |> to_bool;
    todo_due_by = json |> member "todo_due_by" |> to_string;
  }

let json_to_user json =
  {
    userID = json |> member "userID" |> to_string;
    password = json |> member "password" |> to_string;
    name = json |> member "userInfo" |> member "name" |> to_string;
    balance = json |> member "userInfo" |> member "balance" |> to_float;
    bills =
      json |> member "userInfo" |> member "bills" |> to_list
      |> List.map json_to_bill;
    todolist =
      json |> member "userInfo" |> member "todolist" |> to_list
      |> List.map json_to_todo;
  }

let read_json_file file_name =
  let json = Yojson.Basic.from_file file_name in
  json |> member "users" |> to_list |> List.map json_to_user

let init_data file_name = data := read_json_file file_name

let bill_to_json bill =
  `Assoc
    [
      ("bill_description", `String bill.bill_description);
      ("bill_complete", `Bool bill.bill_complete);
      ("bill_amount", `Float bill.bill_amount);
      ("bill_due", `String bill.bill_due);
    ]

let todo_to_json todo =
  `Assoc
    [
      ("todo_description", `String todo.todo_description);
      ("todo_complete", `Bool todo.todo_complete);
      ("todo_due_by", `String todo.todo_due_by);
    ]

let user_to_json user =
  `Assoc
    [
      ("userID", `String user.userID);
      ("password", `String user.password);
      ( "userInfo",
        `Assoc
          [
            ("name", `String user.name);
            ("balance", `Float user.balance);
            ("bills", `List (List.map bill_to_json user.bills));
            ("todolist", `List (List.map todo_to_json user.todolist));
          ] );
    ]

let save_data_to_json file_name =
  let json_data = `Assoc [ ("users", `List (List.map user_to_json !data)) ] in
  let json_string = Yojson.Basic.pretty_to_string json_data in
  let oc = open_out file_name in
  output_string oc json_string;
  close_out oc

let string_of_bill bill =
  "Description: " ^ bill.bill_description ^ "\n" ^ "Complete: "
  ^ string_of_bool bill.bill_complete
  ^ "\n" ^ "Amount: "
  ^ string_of_float bill.bill_amount
  ^ "\n" ^ "Due: " ^ bill.bill_due ^ "\n"

let string_of_todo todo =
  "Description: " ^ todo.todo_description ^ "\n" ^ "Complete: "
  ^ string_of_bool todo.todo_complete
  ^ "\n" ^ "Due by: " ^ todo.todo_due_by ^ "\n"

let rec string_of_bills bills =
  match bills with
  | [] -> ""
  | bill :: rest -> string_of_bill bill ^ string_of_bills rest

let rec string_of_todos todos =
  match todos with
  | [] -> ""
  | todo :: rest -> string_of_todo todo ^ string_of_todos rest

let rec encrypt_pass pass =
  let str = ref "" in
  let n = String.length pass in
  for x = 1 to n do
    str := !str ^ "*"
  done;
  !str

let string_of_user_info user =
  "Username: " ^ user.userID ^ "\n" ^ "Password: " ^ encrypt_pass user.password
  ^ "\n" ^ "Name: " ^ user.name ^ "\n" ^ "Balance: "
  ^ string_of_float user.balance
  ^ "\n" ^ "Bills:\n" ^ string_of_bills user.bills ^ "\n" ^ "Todo List:\n"
  ^ string_of_todos user.todolist

let display_data () =
  let display_bill bill =
    Printf.printf "  Bill: %s, Completed: %b, Amount: %f, Due: %s\n"
      bill.bill_description bill.bill_complete bill.bill_amount bill.bill_due
  in

  let display_todo todo =
    Printf.printf "  Todo: %s, Completed: %b, Due by: %s\n"
      todo.todo_description todo.todo_complete todo.todo_due_by
  in

  let display_user user =
    Printf.printf "UserID: %s, Name: %s, Password: %s\n" user.userID user.name
      user.password;
    Printf.printf "Balance: %f\n" user.balance;
    Printf.printf "Bills:\n";
    List.iter display_bill user.bills;
    Printf.printf "Todos:\n";
    List.iter display_todo user.todolist
  in

  Printf.printf "User List:\n";
  List.iter display_user !data;
  Printf.printf "End of User List\n"
