library(testthat)

this_file <- tryCatch(normalizePath(sys.frame(1)$ofile), error = function(e) "tests/uTest_start.R")
this_dir <- dirname(this_file)

test_path <- file.path(this_dir, "testthat")

cat("🔍 Looking for test files in: ", test_path, "\n")

results <- test_dir(test_path, reporter = "summary")

# Exit with error if any test failed
if (any(vapply(results, function(x) x$failed > 0 || x$error, logical(1)))) {
  quit(status = 1)
}

cat("\n✅ All unit tests have passed!\n")