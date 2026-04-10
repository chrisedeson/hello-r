# R To-Do List Manager - Batch input mode for Rscript
# Usage: echo -e "list\nquit" | Rscript todo_manager.R

initialize_tasks <- function() {
  data.frame(
    id = integer(),
    title = character(),
    priority = integer(),
    completed = logical(),
    stringsAsFactors = FALSE
  )
}

add_task <- function(tasks_df, title, priority) {
  new_id <- if (nrow(tasks_df) == 0) 1 else max(tasks_df$id) + 1
  new_task <- data.frame(
    id = new_id, title = title, priority = priority, completed = FALSE,
    stringsAsFactors = FALSE
  )
  result_df <- rbind(tasks_df, new_task)
  cat(sprintf("Task added (ID: %d)\n", new_id))
  return(result_df)
}

display_tasks <- function(tasks_df) {
  if (nrow(tasks_df) == 0) {
    cat("No tasks.\n\n")
    return(invisible(NULL))
  }
  cat("\nTasks:\n")
  cat(sprintf("%3s %30s %s %s\n", "ID", "Title", "Pri", "Status"))
  cat(strrep("-", 50), "\n")
  for (i in 1:nrow(tasks_df)) {
    t <- tasks_df[i, ]
    st <- if (t$completed) "Done" else "Todo"
    tl <- if (nchar(t$title) > 28) substr(t$title, 1, 25) %+% "..." else t$title
    cat(sprintf("%3d %30s %3d %s\n", t$id, tl, t$priority, st))
  }
  cat(strrep("-", 50), "\n\n")
  invisible(NULL)
}

mark_complete <- function(tasks_df, id) {
  if (!(id %in% tasks_df$id)) {
    cat(sprintf("Task %d not found\n", id))
    return(tasks_df)
  }
  idx <- which(tasks_df$id == id)
  tasks_df[idx, "completed"] <- TRUE
  cat(sprintf("Task %d done\n", id))
  return(tasks_df)
}

delete_task <- function(tasks_df, id) {
  if (!(id %in% tasks_df$id)) {
    cat(sprintf("Task %d not found\n", id))
    return(tasks_df)
  }
  tasks_df <- tasks_df[-which(tasks_df$id == id), ]
  cat(sprintf("Task %d deleted\n", id))
  return(tasks_df)
}

filter_by_priority <- function(tasks_df, priority) {
  if (!(priority %in% 1:5)) {
    cat("Priority 1-5\n")
    return(invisible(NULL))
  }
  filtered_df <- tasks_df[tasks_df$priority == priority, ]
  if (nrow(filtered_df) == 0) {
    cat(sprintf("No tasks priority %d\n\n", priority))
    return(invisible(NULL))
  }
  cat(sprintf("\nPriority %d:\n", priority))
  cat(sprintf("%3s %30s %s\n", "ID", "Title", "Status"))
  cat(strrep("-", 40), "\n")
  for (i in 1:nrow(filtered_df)) {
    t <- filtered_df[i, ]
    st <- if (t$completed) "Done" else "Todo"
    cat(sprintf("%3d %30s %s\n", t$id, t$title, st))
  }
  cat(strrep("-", 40), "\n\n")
  invisible(NULL)
}

save_tasks <- function(tasks_df, filename = "tasks.csv") {
  tryCatch({
    write.csv(tasks_df, file = filename, row.names = FALSE)
    cat(sprintf("Saved %d tasks\n", nrow(tasks_df)))
  }, error = function(e) {
    cat(sprintf("Save error: %s\n", e$message))
  })
}

load_tasks <- function(filename = "tasks.csv") {
  if (!file.exists(filename)) {
    return(initialize_tasks())
  }
  tryCatch({
    df <- read.csv(filename, stringsAsFactors = FALSE)
    if (nrow(df) == 0) return(initialize_tasks())
    df$id <- as.integer(df$id)
    df$priority <- as.integer(df$priority)
    df$completed <- as.logical(df$completed)
    cat(sprintf("Loaded %d tasks\n", nrow(df)))
    return(df)
  }, error = function(e) {
    cat(sprintf("Load error: %s\n", e$message))
    return(initialize_tasks())
  })
}

print_help <- function() {
  cat("\nCommands:\n")
  cat("  list              Display tasks\n")
  cat("  add <title> <pri> Add task (pri: 1-5)\n")
  cat("  complete <id>     Mark done\n")
  cat("  delete <id>       Remove\n")
  cat("  filter <pri>      Show by priority\n")
  cat("  help              This menu\n")
  cat("  quit              Exit\n\n")
}

main <- function() {
  cat("\n=== R To-Do Manager ===\n\n")
  tasks <- load_tasks("tasks.csv")
  
  lines <- readLines(con = "stdin", warn = FALSE)
  i <- 1
  
  while (i <= length(lines)) {
    line <- trimws(tolower(lines[i]))
    i <- i + 1
    if (line == "" || substr(line, 1, 1) == "#") next
    
    parts <- strsplit(line, "[[:space:]]+")[[1]]
    cmd <- parts[1]
    
    if (cmd == "list") {
      display_tasks(tasks)
    }
    else if (cmd == "add") {
      if (length(parts) >= 3) {
        title <- parts[2]
        pri_str <- parts[3]
        priority <- as.integer(pri_str)
        if (!is.na(priority) && priority >= 1 && priority <= 5) {
          tasks <- add_task(tasks, title, priority)
        } else {
          cat("Invalid priority\n")
        }
      }
    }
    else if (cmd == "complete") {
      if (length(parts) >= 2) {
        id <- as.integer(parts[2])
        if (!is.na(id)) {
          tasks <- mark_complete(tasks, id)
        }
      }
    }
    else if (cmd == "delete") {
      if (length(parts) >= 2) {
        id <- as.integer(parts[2])
        if (!is.na(id)) {
          tasks <- delete_task(tasks, id)
        }
      }
    }
    else if (cmd == "filter") {
      if (length(parts) >= 2) {
        pri <- as.integer(parts[2])
        if (!is.na(pri)) {
          filter_by_priority(tasks, pri)
        }
      }
    }
    else if (cmd == "help") {
      print_help()
    }
    else if (cmd == "quit" || cmd == "exit") {
      save_tasks(tasks)
      cat("Goodbye!\n")
      break
    }
    else if (cmd != "") {
      cat(sprintf("Unknown: %s\n", cmd))
    }
  }
  
  invisible(NULL)
}

if (!interactive()) {
  main()
}
