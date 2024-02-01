type bill = {
  bill_description : string;
  bill_complete : bool;
  bill_amount : float;
  bill_due : string;
}
(** The type [bill] represents a single bill, with a description, a completion
    status, an amount, and a due date. *)

type todo = {
  todo_description : string;
  todo_complete : bool;
  todo_due_by : string;
}
(** The type [todo] represents a single todo item, with a description, a
    completion status, and a due date. *)

type user_data = {
  userID : string;
  password : string;
  name : string;
  balance : float;
  bills : bill list;
  todolist : todo list;
}
(** The type [user_data] represents a user's data, including their ID, password,
    name, balance, a list of bills, and a todo list. *)

val data : user_data list ref
(** [data] is a mutable reference to a list of all user data. *)

val read_input : unit -> string
(** [read_input ()] reads a line from standard input, removes leading and
    trailing white space, and returns the result. *)

val init_data : string -> unit
(** [init_data file_name] initializes the [data] with the user data from a JSON
    file specified by [file_name]. If the file does not exist or its contents
    are not in the expected format, this function raises an exception. *)

val display_data : unit -> unit
(** [display_data ()] prints a list of all user data to standard output. Each
    user's data is printed in a specific format that includes the user's ID,
    name, balance, and their list of bills and todos. *)

val encrypt_pass : string -> string
(** [encrypt_pass pass] returns a string of stars the same length as the
    password *)

val string_of_user_info : user_data -> string
(** [string_of_user_info user] returns a string representation of [user]'s data,
    including the user's ID, name, balance, and their list of bills and todos.
    The password is not included in the string representation for security
    reasons. *)

val save_data_to_json : string -> unit
(** [save_data_to_json file_name] saves the current [data] to a JSON file
    specified by [file_name]. If the file does not exist, it is created. If it
    does exist, its contents are overwritten. *)
