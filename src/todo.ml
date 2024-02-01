open Data
open User

let print_todo_menu () =
  let tasks = get_current_user_todolist () in
  let incomplete_count =
    List.length (List.filter (fun task -> not task.todo_complete) tasks)
  in

  print_endline "";
  ANSITerminal.printf [ ANSITerminal.magenta ]
    "To-Do List (%d incomplete tasks):\n" incomplete_count;
  print_endline (string_of_int incomplete_count ^ " tasks to complete!");
  print_endline "1. Add task";
  print_endline "2. View tasks";
  print_endline "3. View tasks on specific date";
  print_endline "4. Mark task as complete";
  print_endline "5. Get Task Timeline";
  print_endline "6. Back";
  print_string "> "

let is_valid_date date_str =
  (* check format *)
  let date_regex = Str.regexp "^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$" in
  if not (Str.string_match date_regex date_str 0) then false
  else
    let x = Str.matched_string date_str in
    let year = int_of_string (String.sub x 0 4) in
    let month = int_of_string (String.sub x 5 2) in
    let day = int_of_string (String.sub x 8 2) in
    (* Check the month*)
    if month < 1 || month > 12 then false
    else
      (* Check the day*)
      let days_in_month =
        match month with
        | 4 | 6 | 9 | 11 -> 30
        | 2 ->
            if year mod 4 = 0 && (year mod 100 <> 0 || year mod 400 = 0) then 29
            else 28
        | _ -> 31
      in
      day >= 1 && day <= days_in_month

let get_deadline task_desc =
  let tasks = get_current_user_todolist () in
  match List.find_opt (fun task -> task.todo_description = task_desc) tasks with
  | None -> "Task not found"
  | Some task ->
      let today = Unix.localtime (Unix.time ()) in
      let current_year = today.tm_year + 1900 in
      let current_month = today.tm_mon + 1 in
      let current_day = today.tm_mday in

      let year = int_of_string (String.sub task.todo_due_by 0 4) in
      let month = int_of_string (String.sub task.todo_due_by 5 2) in
      let day = int_of_string (String.sub task.todo_due_by 8 2) in

      let diff_years = year - current_year in
      let diff_months = month - current_month in
      let diff_days = day - current_day in

      if diff_years < 0 then
        "Task " ^ task.todo_description ^ " is " ^ "overdue!\n"
      else if diff_years <= 0 && diff_months < 0 then
        "Task " ^ task.todo_description ^ " is " ^ "overdue!\n"
      else if diff_years <= 0 && diff_months <= 0 && diff_days < 0 then
        "Task " ^ task.todo_description ^ " is " ^ "overdue!\n"
      else if diff_years = 0 && diff_months = 0 && diff_days = 0 then
        "Task " ^ task.todo_description ^ " is due today!\n"
      else if diff_years = 0 && diff_months = 0 && diff_days = 1 then
        "Task " ^ task.todo_description ^ " is due tomorrow!\n"
      else
        "Task " ^ task.todo_description
        ^ " is still some time away! Get started on it!\n"

let rec task_time_table () =
  let tasks = get_current_user_todolist () in
  (*ANSITerminal.print_string [ ANSITerminal.blue ] "Current tasks: \n";*)
  let overdue = ref [] in
  let tom = ref [] in
  let td = ref [] in
  let fut = ref [] in
  List.iteri
    (fun i task ->
      let status = get_deadline task.todo_description in
      if status = "Task " ^ task.todo_description ^ " is " ^ "overdue!\n" then
        overdue := List.cons task !overdue
      else if status = "Task " ^ task.todo_description ^ " is due today!\n" then
        td := List.cons task !td
      else if status = "Task " ^ task.todo_description ^ " is due tomorrow!\n"
      then tom := task :: !tom
      else fut := task :: !fut)
    tasks;
  ANSITerminal.print_string [ ANSITerminal.blue ] "Overdue tasks: \n";
  List.iteri
    (fun i task ->
      let status =
        if task.todo_complete then
          ANSITerminal.sprintf [ ANSITerminal.green ] "completed"
        else ANSITerminal.sprintf [ ANSITerminal.red ] "incomplete"
      in
      ANSITerminal.printf [ ANSITerminal.white ] "%d. %s (%s) %s\n" (i + 1)
        task.todo_description status task.todo_due_by)
    !overdue;
  ANSITerminal.print_string [ ANSITerminal.blue ] "Tasks due Today: \n";
  List.iteri
    (fun i task ->
      let status =
        if task.todo_complete then
          ANSITerminal.sprintf [ ANSITerminal.green ] "completed"
        else ANSITerminal.sprintf [ ANSITerminal.red ] "incomplete"
      in
      ANSITerminal.printf [ ANSITerminal.white ] "%d. %s (%s) %s\n" (i + 1)
        task.todo_description status task.todo_due_by)
    !td;
  ANSITerminal.print_string [ ANSITerminal.blue ] "Tasks due Tomorrow: \n";
  List.iteri
    (fun i task ->
      let status =
        if task.todo_complete then
          ANSITerminal.sprintf [ ANSITerminal.green ] "completed"
        else ANSITerminal.sprintf [ ANSITerminal.red ] "incomplete"
      in
      ANSITerminal.printf [ ANSITerminal.white ] "%d. %s (%s) %s\n" (i + 1)
        task.todo_description status task.todo_due_by)
    !tom;

  ANSITerminal.print_string [ ANSITerminal.blue ] "Tasks due Later: \n";
  List.iteri
    (fun i task ->
      let status =
        if task.todo_complete then
          ANSITerminal.sprintf [ ANSITerminal.green ] "completed"
        else ANSITerminal.sprintf [ ANSITerminal.red ] "incomplete"
      in
      ANSITerminal.printf [ ANSITerminal.white ] "%d. %s (%s) %s\n" (i + 1)
        task.todo_description status task.todo_due_by)
    !fut;
  if List.length tasks = 0 then print_endline "No tasks."

let rec add_task () =
  print_string "Task: ";
  flush stdout;
  let description = read_input () in
  print_string "Due date (YYYY-MM-DD): ";
  flush stdout;
  let due_by_str = read_input () in
  if not (is_valid_date due_by_str) then begin
    ANSITerminal.print_string [ ANSITerminal.red ]
      "Invalid date format. Please use YYYY-MM-DD format.\n";
    add_task ()
  end
  else
    let due_by = due_by_str in
    let task =
      {
        todo_description = description;
        todo_complete = false;
        todo_due_by = due_by;
      }
    in
    update_current_user_todolist task;
    ANSITerminal.print_string [ ANSITerminal.cyan ] "Task added!"

let view_tasks () =
  let tasks = get_current_user_todolist () in
  ANSITerminal.print_string [ ANSITerminal.blue ] "Current tasks: \n";
  List.iteri
    (fun i task ->
      let status =
        if task.todo_complete then
          ANSITerminal.sprintf [ ANSITerminal.green ] "completed"
        else ANSITerminal.sprintf [ ANSITerminal.red ] "incomplete"
      in
      ANSITerminal.printf [ ANSITerminal.white ] "%d. %s (%s) %s\n" (i + 1)
        task.todo_description status task.todo_due_by)
    tasks;
  if List.length tasks = 0 then print_endline "No tasks."

let view_tasks_on_date date =
  let tasks = get_current_user_todolist () in
  if not (is_valid_date date) then
    ANSITerminal.print_string [ ANSITerminal.red ]
      "Invalid date format. Please use YYYY-MM-DD format.\n"
  else
    let tasks_on_date =
      List.filter (fun task -> task.todo_due_by = date) tasks
    in
    if List.length tasks_on_date = 0 then
      print_endline "No tasks due on this date."
    else
      List.iter
        (fun task ->
          Printf.printf "%s (%s)\n" task.todo_description
            (if task.todo_complete then "completed" else "not completed");
          Printf.printf "Due on: %s\n" task.todo_due_by)
        tasks_on_date

let mark_complete () =
  let tasks = get_current_user_todolist () in
  print_string "Task number to mark complete: ";
  flush stdout;
  let task_num = read_int () in
  if task_num <= 0 || task_num > List.length tasks then
    print_endline "Invalid task number!"
  else
    let task = List.nth tasks (task_num - 1) in
    let updated_task = { task with todo_complete = true } in
    update_current_user_specific_todo task updated_task;
    print_endline "Task marked as complete!"
