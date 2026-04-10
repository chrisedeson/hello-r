# R To-Do List Manager

A command-line to-do list application written in R that demonstrates core language concepts including data frames, functions, vectorized operations, and file I/O.

## Overview

This project is a functional task manager that allows users to:
- Add tasks with priority levels (1-5)
- View all tasks in a formatted table
- Mark tasks as complete
- Delete tasks
- Filter tasks by priority
- Automatically save/load tasks to/from CSV

The software demonstrates R's unique approach to data manipulation including data frames, vectorized operations, and functional programming patterns.

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
Welcome to R To-Do Manager!
Type 'help' for available commands.

> add
Task title: Buy groceries
Priority (1-5): 3
✓ Task added successfully!

> list

ID   Task                            Priority Status
-----------------------------------------------------------------
1    Buy groceries                   3        Pending

> complete
Enter task ID to mark complete: 1
✓ Task marked as complete!

> quit
✓ Tasks saved to tasks.csv
Goodbye!
```

## Code Structure

- `initialize_tasks()`: Creates an empty data frame with the correct structure.
- `create_task()`: Generates a single task as a data frame row.
- `add_task()`: Appends a new task to the tasks data frame.
- `display_tasks()`: Formats and prints all tasks using R's string formatting.
- `mark_complete()`: Updates a task's completion status.
- `delete_task()`: Removes a task using data frame subsetting.
- `filter_by_priority()`: Filters and displays tasks by priority using vectorized subsetting.
- `save_tasks()`: Serializes the data frame to CSV using `write.csv()`.
- `load_tasks()`: Deserializes CSV data back into a data frame with error handling.
- `main()`: Interactive loop that uses `readline()` and `switch()` for command handling.

## Key Learning Objectives

- **Data Frames**: Core data structure in R for storing tabular data.
- **Vectorized Operations**: Use subsetting and vectorized functions instead of loops.
- **Functions**: Write modular, reusable functions with clear purpose.
- **File I/O**: Read and write CSV files using base R functions.
- **Error Handling**: Use `tryCatch()` for robust error management.
- **String Formatting**: Use `sprintf()` and `paste()` for formatted output.
- **Control Flow**: Use `switch()` statements and conditional logic.

## Future Enhancements

- Add due dates and reminder notifications
- Export tasks to Excel format using `writexl` package
- Implement a Shiny web interface for interactive use
- Add task statistics and reporting
- Integrate with cloud storage (Google Drive, Dropbox)

## Running Notes

To verify the code runs:

```bash
Rscript todo_manager.R << EOF
help
quit
EOF
```

The application creates `tasks.csv` in the same directory to persist tasks across sessions.

## Video Demo

See `video.md` in the week05 folder for a detailed walkthrough of the project, or access the recorded demo at: [Video Link](add-your-link-here)

## Author

Christopher Edeson Effiong  
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
