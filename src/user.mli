type logged_in_user = Data.user_data option ref
(** The type [logged_in_user] is a mutable reference to an option holding the
    data of the user currently logged in. *)

val current_user : logged_in_user
(** [current_user] is the current user logged into the application. *)

val is_logged_in : unit -> bool
(** [is_logged_in ()] is [true] if a user is currently logged in, and [false]
    otherwise. *)

val print_profile_menu : unit -> unit
(** [print_profile_menu ()] prints the profile menu to the console. *)

val signup : string -> string -> string -> unit
(** [signup id name password] creates a new user with user id [id], name [name],
    and password [password]. The new user is added to the data. *)

val login_and_set_user : string -> string -> unit
(** [login_and_set_user id password] logs in the user with the provided [id] and
    [password]. If successful, [current_user] is set to this user. Raises an
    exception if the user id or password is invalid. *)

val logout : unit -> unit
(** [logout ()] logs out the current user. Raises an exception if no user is
    logged in. *)

val update_current_username : string -> unit
(** [update_current_username new_name] updates the current user's username to
    [new_name]. Raises an exception if no user is logged in. *)

val update_current_user_password : string -> unit
(** [update_current_user_password new_password] updates the current user's
    password to [new_password]. Raises an exception if no user is logged in. *)

val update_current_user_bills : Data.bill -> unit
(** [update_current_user_bills bill] adds [bill] to the current user's list of
    bills. Raises an exception if no user is logged in. *)

val update_current_user_todolist : Data.todo -> unit
(** [update_current_user_todolist todo] adds [todo] to the current user's to-do
    list. Raises an exception if no user is logged in. *)

val update_current_user_specific_todo : Data.todo -> Data.todo -> unit
(** [update_current_user_specific_todo old_todo new_todo] replaces [old_todo] in
    the current user's to-do list with [new_todo]. Raises an exception if no
    user is logged in. *)

val update_current_user_specific_bill : Data.bill -> Data.bill -> unit
(** [update_current_user_specific_bill old_bill new_bill] replaces [old_bill] in
    the current user's bill list with [new_todo]. Raises an exception if no user
    is logged in. *)

val get_current_user_bal : unit -> float
(** [get_current_user_bal ()] returns the current user's balance. Raises an
    exception if no user is logged in. *)

val get_current_username : unit -> string
(** [get_current_username ()] returns the current user's username. Raises an
    exception if no user is logged in. *)

val get_current_user_pass : unit -> string
(** [get_current_user_pass ()] returns the current user's password. Raises an
    exception if no user is logged in. *)

val get_current_user_info : unit -> Data.user_data
(** [get_current_user_info ()] returns the current user's data. Raises an
    exception if no user is logged in. *)

val get_current_user_bills : unit -> Data.bill list
(** [get_current_user_bills ()] returns the current user's list of bills. Raises
    an exception if no user is logged in. *)

val get_current_user_todolist : unit -> Data.todo list
(** [get_current_user_todolist ()] returns the current user's to-do list. Raises
    an exception if no user is logged in. *)

val delete_current_user : unit -> unit
(** [delete_current_user ()] removes the current user from the system and logs
    out. Raises an exception if no user is logged in. *)

val save_current_user : unit -> unit
(** [save_current_user ()] saves the current user's data back to the data
    system. Raises an exception if no user is logged in. *)

val update_current_user_balance : float -> unit
(** [update_current_user_balance amount] updates the current user's balance to
    [amount]. Raises an exception if no user is logged in. *)
