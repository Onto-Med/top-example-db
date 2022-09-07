library(purrr)
library(childsds)
library(lubridate)

n        <- 1000
min_date <- as.Date("1950-01-01")
max_date <- Sys.time()
ref      <- combineReferences(
  GrowthSDS::kromeyerHauschild,
  GrowthSDS::microcensus.germany,
  x.cut = 18
)

subject <- data.frame(
  subject_id = 1:n,
  birth_date = sample(seq(min_date, as.Date(max_date), by = "day"), n, TRUE),
  sex        = sample(c("male", "female"), n, replace = TRUE)
)

assessment1 <- pmap_dfr(subject, function(subject_id, birth_date, sex) {
  result     <- data.frame()
  birth_time <- as.POSIXct(birth_date)
  for (i in 1:sample(1:10, 1)) {
    created_at <- sample(seq(birth_time, max_date, by = "10 mins"), 1)
    age        <- time_length(interval(birth_time, created_at), "years")
    result     <- rbind(result, data.frame(subject_id, created_at, age, sex))
  }
  return(result)
})

assessment1$height <- mock_values(assessment1, sex = "sex", age = "age", childsds::kro.ref, "height")$height
assessment1$weight <- mock_values(assessment1, sex = "sex", age = "age", childsds::kro.ref, "weight")$weight

write.csv(subject, "database/subject.csv", row.names = FALSE)
write.csv(assessment1[, c(1, 2, 5, 6)], "database/assessment1.csv", row.names = FALSE)
