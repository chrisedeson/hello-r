# R To-Do List Manager
# A fresh rebuild with CSV persistence and command-driven interaction.

DATA_FILE <- "tasks.csv"

initialize_tasks <- function() {
  data.frame(
    id = integer(),
    title = character(),
    priority = integer(),
    completed = logical(),
    created_at = character(),
    stringsAsFactors = FALSE
  )
}

normalize_tasks <- function(tasks_df) {
  expected <- c("id", "title", "priority", "completed", "created_at")

  if (!all(expected %in% names(tasks_df))) {
    return(initialize_tasks())
  }

  tasks_df <- tasks_df[, expected]
  tasks_df$id <- as.integer(tasks_df$id)
  tasks_df$title <- as.character(tasks_df$title)
  tasks_df$priority <- as.integer(tasks_df$priority)
  tasks_df$completed <- as.logical(tasks_df$completed)
  tasks_df$created_at <- as.character(tasks_df$created_at)

  tasks_df
}

load_tasks <- function(filename = DATA_FILE) {
  if (!file.exists(filename)) {
    return(initialize_tasks())
  }

  tryCatch({
    tasks_df <- read.csv(filename, stringsAsFactors = FALSE)
    if (nrow(tasks_df) == 0) {
      return(initialize_tasks())
    }
    normalize_tasks(tasks_df)
  }, error = function(e) {
    cat(sprintf("Load error: %s\n", e$message))
    initialize_tasks()
  })
}

save_tasks <- function(tasks_df, filename = DATA_FILE) {
  tryCatch({
    write.csv(tasks_df, file = filename, row.names = FALSE)
    cat(sprintf("Saved %d task(s) to %s\n", nrow(tasks_df), filename))
  }, error = function(e) {
    cat(sprintf("Save error: %s\n", e$message))
  })
}

next_task_id <- function(tasks_df) {
  if (nrow(tasks_df) == 0) {
    return(1L)
  }
  as.integer(max(tasks_df$id, na.rm = TRUE) + 1)
}

print_task_table <- function(tasks_df, heading = "Tasks") {
  if (nrow(tasks_df) == 0) {
    cat(sprintf("%s: no tasks found.\n\n", heading))
    return(invisible(NULL))
  }

  cat(sprintf("\n%s\n", heading))
  cat(strrep("=", 92), "\n")
  cat(sprintf("%-4s %-36s %-8s %-10s %-20s\n", "ID", "Title", "Priority", "Status", "Created"))
  cat(strrep("-", 92), "\n")

  for (i in seq_len(nrow(tasks_df))) {
    task <- tasks_df[i, ]
    status <- if (isTRUE(task$completed)) "Done" else "Pending"
    title <- task$title
    if (nchar(title) > 35) {
      title <- paste0(substr(title, 1, 32), "...")
    }

    cat(sprintf(
      "%-4d %-36s %-8d %-10s %-20s\n",
      task$id,
      title,
      task$priority,
      status,
      task$created_at
    ))
  }

  cat(strrep("-", 92), "\n\n")
  invisible(NULL)
}

add_task <- function(tasks_df, title, priority) {
  title <- trimws(title)
  if (title == "") {
    cat("Task title cannot be empty.\n")
    return(tasks_df)
  }

  if (is.na(priority) || !(priority %in% 1:5)) {
    cat("Priority must be an integer between 1 and 5.\n")
    return(tasks_df)
  }

  new_row <- data.frame(
    id = next_task_id(tasks_df),
    title = title,
    priority = as.integer(priority),
    completed = FALSE,
    created_at = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
    stringsAsFactors = FALSE
  )

  tasks_df <- rbind(tasks_df, new_row)
  cat(sprintf("Task added (ID: %d).\n", new_row$id))
  tasks_df
}

mark_complete <- function(tasks_df, id) {
  if (is.na(id)) {
    cat("Please provide a valid task ID.\n")
    return(tasks_df)
  }

  idx <- which(tasks_df$id == id)
  if (length(idx) == 0) {
    cat(sprintf("Task ID %d not found.\n", id))
    return(tasks_df)
  }

  tasks_df[idx, "completed"] <- TRUE
  cat(sprintf("Task %d marked complete.\n", id))
  tasks_df
}

delete_task <- function(tasks_df, id) {
  if (is.na(id)) {
    cat("Please provide a valid task ID.\n")
    return(tasks_df)
  }

  idx <- which(tasks_df$id == id)
  if (length(idx) == 0) {
    cat(sprintf("Task ID %d not found.\n", id))
    return(tasks_df)
  }

  tasks_df <- tasks_df[-idx, , drop = FALSE]
  cat(sprintf("Task %d deleted.\n", id))
  tasks_df
}

filter_by_priority <- function(tasks_df, priority) {
  if (is.na(priority) || !(priority %in% 1:5)) {
    cat("Priority must be an integer between 1 and 5.\n")
    return(invisible(NULL))
  }

  filtered <- tasks_df[tasks_df$priority == priority, , drop = FALSE]
  print_task_table(filtered, sprintf("Tasks with priority %d", priority))
}

parse_int <- function(value) {
  value <- trimws(value)
  if (value == "") {
    return(NA_integer_)
  }

  parsed <- suppressWarnings(as.integer(value))
  if (is.na(parsed)) {
    return(NA_integer_)
  }
  parsed
}

make_input_reader <- function() {
  function(prompt) {
    # If in RStudio or an interactive R console
    if (interactive()) {
      return(readline(prompt = prompt))
    } 
    
    # If running via command line (Rscript)
    cat(prompt)
    flush.console()
    
    # Read exactly one line from standard input
    line <- readLines(file("stdin"), n = 1, warn = FALSE)
    
    # If length is 0, we hit EOF (e.g., Ctrl+D or end of piped file)
    if (length(line) == 0) {
      return(NA_character_)
    }
    
    return(line)
  }
}

print_help <- function() {
  cat("\nAvailable commands\n")
  cat("  1 or add       Add a task\n")
  cat("  2 or list      Show all tasks\n")
  cat("  3 or complete  Mark task complete\n")
  cat("  4 or delete    Delete a task\n")
  cat("  5 or filter    Show tasks by priority\n")
  cat("  help           Show help\n")
  cat("  quit or exit   Save and close\n\n")
}

main <- function() {
  read_input <- make_input_reader()
  tasks <- load_tasks(DATA_FILE)

  cat("\nR To-Do List Manager\n")
  cat("Type 'help' for available commands.\n\n")

  repeat {
    cmd_raw <- read_input("> ")

    if (is.na(cmd_raw)) {
      save_tasks(tasks, DATA_FILE)
      cat("\nGoodbye!\n")
      break
    }

    cmd <- tolower(trimws(cmd_raw))
    if (cmd == "") {
      next
    }

    if (cmd %in% c("1", "add")) {
      title <- read_input("Task title: ")
      if (is.na(title)) {
        save_tasks(tasks, DATA_FILE)
        cat("\nGoodbye!\n")
        break
      }

      priority_text <- read_input("Priority (1-5): ")
      if (is.na(priority_text)) {
        save_tasks(tasks, DATA_FILE)
        cat("\nGoodbye!\n")
        break
      }

      tasks <- add_task(tasks, title, parse_int(priority_text))
      next
    }

    if (cmd %in% c("2", "list")) {
      ordered <- tasks[order(tasks$completed, tasks$priority, tasks$id), , drop = FALSE]
      print_task_table(ordered, "All tasks")
      next
    }

    if (cmd %in% c("3", "complete")) {
      id_text <- read_input("Task ID to complete: ")
      if (is.na(id_text)) {
        save_tasks(tasks, DATA_FILE)
        cat("\nGoodbye!\n")
        break
      }
      tasks <- mark_complete(tasks, parse_int(id_text))
      next
    }

    if (cmd %in% c("4", "delete")) {
      id_text <- read_input("Task ID to delete: ")
      if (is.na(id_text)) {
        save_tasks(tasks, DATA_FILE)
        cat("\nGoodbye!\n")
        break
      }
      tasks <- delete_task(tasks, parse_int(id_text))
      next
    }

    if (cmd %in% c("5", "filter")) {
      priority_text <- read_input("Priority to filter (1-5): ")
      if (is.na(priority_text)) {
        save_tasks(tasks, DATA_FILE)
        cat("\nGoodbye!\n")
        break
      }
      filter_by_priority(tasks, parse_int(priority_text))
      next
    }

    if (cmd == "help") {
      print_help()
      next
    }

    if (cmd %in% c("quit", "exit")) {
      save_tasks(tasks, DATA_FILE)
      cat("Goodbye!\n")
      break
    }

    cat("Unknown command. Type 'help' for available commands.\n")
  }
}

# Run the program directly
main()