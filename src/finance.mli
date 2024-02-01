val deposit_amt : string -> bool
(** [deposit_amt amt] deposits a given amount [amt] into the current user's
    balance. If the amount is less than or equal to 0, returns [false].
    Otherwise, updates the balance and returns [true]. *)

val withdraw_amt : string -> bool
(** [withdraw_amt amt] withdraws a given amount [amt] from the current user's
    balance. If the balance is less than the amount, returns [false]. Otherwise,
    updates the balance and returns [true]. *)

val update_bill_todo : Data.bill -> unit
(** [update_bill_todo bill todo] takes a bill and adds it to current user's bill
    list as well as a personalized todo task. *)

val view_balance : unit -> unit
(** [view_balance ()] prints the current user's balance to standard output. *)

val deposit : unit -> unit
(** [deposit ()] prompts the user to enter an amount to deposit into the current
    user's balance. If the deposit is successful, prints a confirmation message.
    If the deposit is not successful, prints an error message. *)

val withdraw : unit -> unit
(** [withdraw ()] prompts the user to enter an amount to withdraw from the
    current user's balance. If the withdrawal is successful, prints a
    confirmation message. If the withdrawal is not successful, prints an error
    message. *)

val add_bill : unit -> unit
(** [add_bill ()] prompts the user to enter the details of a new bill, including
    the description, amount, and due date. If the due date is not in the format
    "YYYY-MM-DD", prints an error message. Otherwise, adds the new bill to the
    current user's list of bills and adds a corresponding task to the user's
    todo list. *)

val view_bills : unit -> unit
(** [view_bills ()] prints a list of the current user's bills to standard
    output. If the user has no bills, prints a message indicating that there are
    no bills to display. *)

val pay_bill : Data.bill -> bool
(** [pay_bill bill] marks the bill and bill todo as complete and withdraws the
    bill amount from account *)

val mark_bill_complete : unit -> unit
(** [mark_bill_complete ()] prompts the user to enter the number of a bill to
    mark as complete. If the bill number is valid, it marks the bill and bill
    todo as complete, and withdraws the bill amount from account. If the task
    number is not valid, it prints an error message. *)

val print_finance_menu : unit -> unit
(** [print_finance_menu ()] prints the finance menu options to standard output. *)
