#!/usr/bin/env Rscript

# Command-Line To-Do List Manager in R
# Author: Christopher Edeson Effiong
# Course: CSE 310 - Applied Programming
# Module: R Language

# Create an empty tasks data frame with the proper structure.
initialize_tasks <- function() {
  # Initialize empty data frame with columns: id, title, priority, completed
  tasks_df <- data.frame(
    id = integer(),
    title = character(),
    priority = integer(),
    completed = logical(),
    stringsAsFactors = FALSE
  )
  return(tasks_df)
}

# Create a new task with the given title and priority level.
create_task <- function(id, title, priority) {
  # Ensure priority is between 1 and 5
  priority <- max(1, min(5, priority))
  
  # Create a single-row data frame for the new task
  new_task <- data.frame(
    id = id,
    title = title,
    priority = priority,
    completed = FALSE,
    stringsAsFactors = FALSE
  )
  return(new_task)
}

# Add a new task to the tasks data frame.
add_task <- function(tasks_df, title, priority) {
  # Generate new ID based on current max ID
  if (nrow(tasks_df) == 0) {
    new_id <- 1
  } else {
    new_id <- max(tasks_df$id) + 1
  }
  
  # Create and append the new task
  new_task <- create_task(new_id, title, priority)
  tasks_df <- rbind(tasks_df, new_task)
  
  cat("✓ Task added successfully!\n")
  return(tasks_df)
}

# Display all tasks in a formatted table.
display_tasks <- function(tasks_df) {
  if (nrow(tasks_df) == 0) {
    cat("No tasks yet. Add one to get started!\n")
    return()
  }
  
  cat("\n")
  cat(sprintf("%-4s %-35s %-8s %-12s\n", "ID", "Task", "Priority", "Status"))
  cat(paste(rep("-", 65), collapse = ""), "\n")
  
  # Iterate through each row and display formatted output
  for (i in 1:nrow(tasks_df)) {
    task <- tasks_df[i, ]
    status <- if (task$completed) "✓ Complete" else "Pending"
    cat(sprintf("%-4d %-35s %-8d %-12s\n", 
                task$id, 
                task$title, 
                task$priority, 
                status))
  }
  
  cat("\n")
}

# Mark a task as complete by its ID.
mark_complete <- function(tasks_df, id) {
  # Find the row with matching ID
  idx <- which(tasks_df$id == id)
  
  if (length(idx) == 0) {
    cat(sprintf("Error: Task with ID %d not found.\n", id))
    return(tasks_df)
  }
  
  # Update the completed status
  tasks_df[idx, "completed"] <- TRUE
  cat("✓ Task marked as complete!\n")
  return(tasks_df)
}

# Delete a task by its ID.
delete_task <- function(tasks_df, id) {
  # Find the row with matching ID
  idx <- which(tasks_df$id == id)
  
  if (length(idx) == 0) {
    cat(sprintf("Error: Task with ID %d not found.\n", id))
    return(tasks_df)
  }
  
  # Remove the row by keeping all rows except the one to delete
  tasks_df <- tasks_df[-idx, ]
  cat("✓ Task deleted successfully!\n")
  return(tasks_df)
}

# Filter and display tasks by priority level.
filter_by_priority <- function(tasks_df, priority) {
  # Subset data frame to only rows with matching priority
  filtered_df <- tasks_df[tasks_df$priority == priority, ]
  
  if (nrow(filtered_df) == 0) {
    cat(sprintf("No tasks with priority %d.\n", priority))
    return()
  }
  
  cat(sprintf("\nTasks with Priority %d:\n", priority))
  cat(sprintf("%-4s %-35s %-8s %-12s\n", "ID", "Task", "Priority", "Status"))
  cat(paste(rep("-", 65), collapse = ""), "\n")
  
  for (i in 1:nrow(filtered_df)) {
    task <- filtered_df[i, ]
    status <- if (task$completed) "✓ Complete" else "Pending"
    cat(sprintf("%-4d %-35s %-8d %-12s\n", 
                task$id, 
                task$title, 
                task$priority, 
                status))
  }
  
  cat("\n")
}

# Save tasks to a CSV file.
save_tasks <- function(tasks_df, filename = "tasks.csv") {
  tryCatch({
    write.csv(tasks_df, file = filename, row.names = FALSE)
    cat(sprintf("✓ Tasks saved to %s\n", filename))
  }, error = function(e) {
    cat(sprintf("Error saving tasks: %s\n", e$message))
  })
}

# Load tasks from a CSV file.
load_tasks <- function(filename = "tasks.csv") {
  # Check if file exists
  if (!file.exists(filename)) {
    cat(sprintf("No previous task file found. Starting fresh.\n"))
    return(initialize_tasks())
  }
  
  # Read the CSV file
  tryCatch({
    tasks_df <- read.csv(filename, stringsAsFactors = FALSE)
    
    # Handle empty file
    if (nrow(tasks_df) == 0) {
      return(initialize_tasks())
    }
    
    # Ensure column types are correct
    tasks_df$id <- as.integer(tasks_df$id)
    tasks_df$title <- as.character(tasks_df$title)
    tasks_df$priority <- as.integer(tasks_df$priority)
    tasks_df$completed <- as.logical(tasks_df$completed)
    
    return(tasks_df)
  }, error = function(e) {
    cat(sprintf("Error loading tasks: %s\n", e$message))
    return(initialize_tasks())
  })
}

# Main menu loop.
main <- function() {
  # Load existing tasks from file
  tasks <- load_tasks("tasks.csv")
  
  cat("\n")
  cat("Welcome to R To-Do Manager!\n")
  cat("Type 'help' for available commands.\n\n")
  
  # Main interactive loop
  while (TRUE) {
    cat("> ")
    input <- tolower(trimws(readline()))
    
    # Use switch to handle commands
    switch(input,
      "1" = ,
      "add" = {
        cat("Task title: ")
        title <- readline()
        cat("Priority (1-5): ")
        priority_input <- readline()
        
        tryCatch({
          priority <- as.integer(priority_input)
          if (is.na(priority) || priority < 1 || priority > 5) {
            cat("Invalid priority. Please enter a number between 1 and 5.\n")
          } else {
            tasks <- add_task(tasks, title, priority)
          }
        }, error = function(e) {
          cat("Invalid input.\n")
        })
      },
      
      "2" = ,
      "list" = {
        display_tasks(tasks)
      },
      
      "3" = ,
      "complete" = {
        cat("Enter task ID to mark complete: ")
        id_input <- readline()
        
        tryCatch({
          id <- as.integer(id_input)
          if (is.na(id)) {
            cat("Invalid ID. Please enter a number.\n")
          } else {
            tasks <- mark_complete(tasks, id)
          }
        }, error = function(e) {
          cat("Invalid input.\n")
        })
      },
      
      "4" = ,
      "delete" = {
        cat("Enter task ID to delete: ")
        id_input <- readline()
        
        tryCatch({
          id <- as.integer(id_input)
          if (is.na(id)) {
            cat("Invalid ID. Please enter a number.\n")
          } else {
            tasks <- delete_task(tasks, id)
          }
        }, error = function(e) {
          cat("Invalid input.\n")
        })
      },
      
      "5" = ,
      "filter" = {
        cat("Filter by priority (1-5): ")
        priority_input <- readline()
        
        tryCatch({
          priority <- as.integer(priority_input)
          if (is.na(priority) || priority < 1 || priority > 5) {
            cat("Invalid priority. Please enter a number between 1 and 5.\n")
          } else {
            filter_by_priority(tasks, priority)
          }
        }, error = function(e) {
          cat("Invalid input.\n")
        })
      },
      
      "help" = {
        cat("\nAvailable commands:\n")
        cat("  1 or 'add'      - Add a new task\n")
        cat("  2 or 'list'     - Display all tasks\n")
        cat("  3 or 'complete' - Mark a task as complete\n")
        cat("  4 or 'delete'   - Delete a task\n")
        cat("  5 or 'filter'   - Filter tasks by priority\n")
        cat("  'help'          - Show this help menu\n")
        cat("  'quit'          - Exit the program\n\n")
      },
      
      "quit" = ,
      "exit" = {
        # Save tasks before exiting
        save_tasks(tasks)
        cat("Goodbye!\n")
        break
      },
      
      {
        # Default case for unknown commands
        cat("Unknown command. Type 'help' for available commands.\n")
      }
    )
  }
}

# Run the main program
if (!interactive()) {
  main()
}
