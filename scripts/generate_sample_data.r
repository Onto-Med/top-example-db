library(purrr)

n <- 10000
min_date <- as.Date("1950-01-01")
max_date <- Sys.Date()

subject <- data.frame(
  subject_id = 1:n,
  birth_date = sample(seq(min_date, max_date, by = "day"), n, TRUE),
  sex        = sample(c("m", "f"), n, replace = TRUE)
)

assessment1 <- pmap_dfr(subjects, function(subject_id, birth_date, sex) {
  result <- data.frame()
  for (i in 1:sample(1:10, 1)) {
    result <- rbind(
      result,
      data.frame(
        subject_id = subject_id,
        created_at = sample(seq(birth_date, max_date, by = "day"), 1),
        height     = rnorm(1, ifelse(sex == "m", 180, 170), 10),
        weight     = rnorm(1, 70, 20)
      )
    )
  }
  return(result)
})

write.csv(subject, "database/subject.csv", row.names = FALSE)
write.csv(assessment1, "database/assessment1.csv", row.names = FALSE)
