# Orion

## About

Finance Tracker/Planner - Terminal Application

A finance tracker that helps users keep track of their expenses, income, and budget. It provides tools for creating budgets, tracking spending, and identifying areas where money can be saved. The software may also generate reports and graphs to give users a clear overview of their financial situation. With this tracker, users can easily manage their finances and make informed decisions to improve their financial health.

A planner is designed to help users organize their tasks, schedule appointments, and keep track of important deadlines. It will include features such as a calendar, to-do lists, reminders, and goal tracking to ensure that all tasks are completed on time. The planner will help users to stay on top of their schedule and stay productive, ultimately leading to a more efficient and successful day-to-day life.

## What’s the Problem?

- Poor Financial organization: Keeping track of bills, receipts etc can be overwhelming especially for people with busy schedules.
- Budgeting: overspending is a common problem that can lead to financial problems
- Reminders: keeping track of daily activities

## What’s the goal?

By incorporating a financial tracker into a daily planner, people can handle their finances and schedules all in one place.
Creating a personalized budget for users based on their income and expenses
Keeping track of spending, savings and investment goals

## Technology Stack

- OCaml

## Key Features

- User interface that welcomes user to their planner
- User can input tasks and financial actions
- User can ask for list of that day’s to-dos
- User can get reminders on the terminal for important tasks for the day
- User can keep track of spending for the month
- Ask for their monthly income and to input their expected monthly expenses.

## Running the application

Read through the `install.md` file for steps

## Project Files Description

```bash
Orion/
├── bin/                             # Directory for Application Main file
│   ├── dune                         # Dune build system executable
│   └── main.ml                      # Main executable
├── data/                            # Directory for data files
│   ├── schema.json                  # JSON schema for data
│   ├── test.json                    # Main database in JSON format
│   ├── test_empty.json              # JSON file for testing empty state
│   └── test_main.json               # JSON file for testing
├── node_modules/                    # Directory for Node.js dependencies
├── src/                             # Directory for source code
│   ├── data.ml                      # Data handling implementation file
│   ├── data.mli                     # Data handling interface file
│   ├── dune                         # Dune build system file for src library
│   ├── finance.ml                   # Finance handling implementation file
│   ├── finance.mli                  # Finance handling interface file
│   ├── todo.ml                      # Task handling implementation file
│   ├── todo.mli                     # Task handling interface file
│   ├── user.ml                      # User implementation file
│   └── user.mli                     # User interface file
├── test/                            # Directory for test code
│  ├── dune                          # Dune build system file for test directory
│  └── main.ml                       # Test files
├── .gitignore                       # Files to ignore when running git commands
├── .ocamlformat                     # Ocaml formatting file
├── Budget.opam                      # OPAM package descriptions
├── Makefile                         # Makefile to automate build tasks
├── README.md                        # The file containing information about the project
├── dune                             # Dune build system file
├── dune-project                     # Dune project description file
├── dune-workspace                   # Workspace file for Dune build system
├── exclude.lst                      # List of files to exclude from certain operations
├── install.md                       # Markdown file with installation instructions
├── opendoc.sh                       # Shell script to open project documentation
├── package-lock.json                # Lock file for exact Node.js dependency tree
└── package.json                     # File describing Node.js dependencies

```

## Authors

Fedinard Nyanyo
