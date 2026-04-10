# R To-Do List Manager

A command-line to-do list application written in R that demonstrates data frames, functions, control flow, and CSV file I/O.

## Overview

This project is a functional task manager that allows users to:
- Add tasks with priority levels (1-5)
- View all tasks in a formatted table
- Mark tasks as complete
- Delete tasks
- Filter tasks by priority
- Automatically save/load tasks to and from CSV

The software demonstrates R data handling using data frames, input parsing, and persistence with base R functions.

## Development Environment

* R (version 4.0+)
* RStudio (optional but recommended)
* Text editor or IDE of choice

R is a language and environment for statistical computing and graphics. This project showcases R's data manipulation capabilities through data frames and built-in functions.

## How to Run

Ensure you have R installed. If not, visit [cran.r-project.org](https://cran.r-project.org/).

### Run the application:

```bash
Rscript todo_manager.R
```

Or from within RStudio:

```r
source("todo_manager.R")
main()
```

### Example Usage:

```
R To-Do List Manager
Type 'help' for available commands.

> add
Task title: Buy groceries for the week
Priority (1-5): 3
Task added (ID: 1).

> list

All tasks
============================================================================================
ID   Title                                Priority Status     Created
--------------------------------------------------------------------------------------------
1    Buy groceries for the week           3        Pending    2026-04-10 13:42:42
--------------------------------------------------------------------------------------------

> complete
Task ID to complete: 1
Task 1 marked complete.

> quit
Saved 1 task(s) to tasks.csv
Goodbye!
```

## Code Structure

- `initialize_tasks()`: Creates an empty data frame with the correct structure.
- `normalize_tasks()`: Validates and normalizes loaded CSV data.
- `load_tasks()`: Loads tasks from CSV and handles missing/corrupt data.
- `save_tasks()`: Persists tasks to CSV.
- `add_task()`: Appends a validated task with a generated ID and timestamp.
- `print_task_table()`: Renders task tables for list and filter views.
- `mark_complete()`: Updates a task's completion status.
- `delete_task()`: Removes a task using data frame subsetting.
- `filter_by_priority()`: Displays only tasks with the requested priority.
- `parse_int()`: Safely parses numeric command input.
- `make_input_reader()`: Handles terminal and piped input consistently.
- `main()`: Command loop that orchestrates user actions.

## Key Learning Objectives

- **Data Frames**: Core data structure in R for storing tabular data.
- **Vectorized Operations**: Use subsetting expressions for filtering and updates.
- **Functions**: Write modular, reusable functions with clear purpose.
- **File I/O**: Read and write CSV files using base R functions.
- **Error Handling**: Use `tryCatch()` for robust file operations.
- **String Formatting**: Use `sprintf()` for table-like terminal output.
- **Control Flow**: Use a loop and conditional command dispatch.

## Future Enhancements

- Add due dates and reminder notifications
- Export tasks to Excel format using `writexl` package
- Implement a Shiny web interface for interactive use
- Add task statistics and reporting
- Integrate with cloud storage (Google Drive, Dropbox)

## Running Notes

To verify the code runs:

```bash
printf "help\nquit\n" | Rscript todo_manager.R
```

The application creates `tasks.csv` in the same directory to persist tasks across sessions.

## Author

Christopher Edeson
CSE 310: Applied Programming  
BYU-Pathway Worldwide

## Learning Log

Time spent: 21.5 hours  
See `time-log.md` in week05 for daily breakdown.

Learning strategies and reflections are documented in `learning-strategies.md`.

## Additional Resources

* [R for Data Science](https://r4ds.had.co.nz/) - Comprehensive guide
* [The R Project](https://www.r-project.org/) - Official R website
* [RStudio Cheat Sheets](https://rstudio.com/resources/cheatsheets/) - Quick references
* [Base R Functions](https://stat.ethz.ch/R-manual/R-devel/library/base/html/00Index.html) - Official documentation
