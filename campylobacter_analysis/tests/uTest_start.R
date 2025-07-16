library(testthat)
results <- test_dir("tests/testthat", reporter = "summary")

if (any(vapply(results, function(x) x$failed > 0 || x$error, logical(1)))) {
  quit(status = 1)
}
cat("\n All unit tests passed!\n")