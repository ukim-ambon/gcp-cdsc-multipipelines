library(testthat)

# Get the script location
this_file <- normalizePath(sys.frame(1)$ofile %||% "tests/uTest_start.R")
this_dir <- dirname(this_file)

# Construct the absolute path to testthat/
test_path <- file.path(this_dir, "testthat")

cat("🔍 Looking for test files in: ", test_path, "\n")

results <- test_dir(test_path, reporter = "summary")

if (any(vapply(results, function(x) x$failed > 0 || x$error, logical(1)))) {
	quit(status = 1)
}

cat("\n✅ All unit tests have passed!\n")