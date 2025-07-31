cat("Current working dir:", getwd(), "\n")
print(list.files("../../"))
source("../../run_script1.R")
print(ls())

test_that("uTest1 returns correct message", {
  expect_equal(uTest1(), "Hello Campylobacter_analysis pipeline with R script 1d")
})