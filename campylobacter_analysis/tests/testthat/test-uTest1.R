source("../../run_script1.R")

test_that("uTest1 returns correct message", {
  expect_equal(uTest1(), "Hello Campylobacter_analysis pipeline with R script 1d")
})