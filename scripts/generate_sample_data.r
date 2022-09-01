library(purrr)
library(GrowthSDS)
library(lubridate)

n        <- 1000
min_date <- as.Date("1950-01-01")
max_date <- Sys.Date()
ref      <- combineReferences(
  GrowthSDS::kromeyerHauschild,
  GrowthSDS::microcensus.germany,
  x.cut = 18
)

subject <- data.frame(
  subject_id = 1:n,
  birth_date = sample(seq(min_date, max_date, by = "day"), n, TRUE),
  sex        = sample(c("male", "female"), n, replace = TRUE)
)

assessment1 <- pmap_dfr(subject, function(subject_id, birth_date, sex) {
  result <- data.frame()
  for (i in 1:sample(1:10, 1)) {
    created_at <- sample(seq(birth_date, max_date, by = "day"), 1)
    age        <- time_length(interval(birth_date, created_at), "years")
    result     <- rbind(result, data.frame(subject_id, created_at, age, sex))
  }
  return(result)
})

assessment1$height <- round(centile(assessment1$age, rnorm(1, 0, 1), assessment1$sex, "height", ref), 1)
assessment1$weight <- round(centile(assessment1$age, rnorm(1, 0, 1), assessment1$sex, "weight", ref), 3)

write.csv(subject, "database/subject.csv", row.names = FALSE)
write.csv(assessment1[, c(1, 2, 5, 6)], "database/assessment1.csv", row.names = FALSE)
