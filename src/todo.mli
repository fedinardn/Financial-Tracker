val print_todo_menu : unit -> unit
(** [print_todo_menu ()] prints the todo list menu options to standard output.
    It also displays the number of incomplete tasks in the current user's todo
    list. *)

val is_valid_date : string -> bool
(** [is_valid_date date_str] checks if the string [date_str] is a valid date in
    the format "YYYY-MM-DD". Returns [true] if the date is valid, and [false]
    otherwise. *)

val get_deadline : string -> string
(** [get_deadline task_desc] takes a task description [task_desc] and checks the
    deadline of the task with the provided description in the current user's
    todo list. If the task exists, it prints a message indicating the due date
    of the task in relation to today's date (specfic for if deadline is today or
    tomorrow, general if it is overdue or due farther in the future). If the
    task does not exist, it prints a message indicating that the task was not
    found. *)

val add_task : unit -> unit
(** [add_task ()] prompts the user to enter the details of a new task, including
    the description and due date. If the due date is not in the format
    "YYYY-MM-DD", prints an error message and prompts the user to enter the task
    details again. Otherwise, adds the new task to the current user's todo list. *)

val task_time_table : unit -> unit
(** [task_time_table ()] Displays tasks in order in which they must be done
    based on if they are overdue, due today, due tomorrow, or due later in the
    future. *)

val view_tasks : unit -> unit
(** [view_tasks ()] prints a list of the current user's tasks to standard
    output. If the user has no tasks, it prints a message indicating that there
    are no tasks to display. *)

val view_tasks_on_date : string -> unit
(** [view_tasks_on_date date] prints a list of the current user's tasks due on a
    specified date to standard output. If the user has no tasks due on the
    specified date, it prints a message indicating that there are no tasks to
    display. *)

val mark_complete : unit -> unit
(** [mark_complete ()] prompts the user to enter the number of a task to mark as
    complete. If the task number is valid, it marks the task as complete. If the
    task number is not valid, it prints an error message. *)
