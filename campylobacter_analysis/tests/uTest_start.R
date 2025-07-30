library(testthat)

results <- test_dir("tests/testthat", reporter = "summary")

has_failures <- any(vapply(results, function(x) {
  isTRUE(x$failed > 0) || isTRUE(x$error)
}, logical(1)))

if (has_failures) {
  quit(status = 1)
}

cat("\n✅ All unit tests have passed!\n")