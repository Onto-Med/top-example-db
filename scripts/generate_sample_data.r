library(purrr)
library(childsds)
library(lubridate)

args <- commandArgs(trailingOnly = TRUE)

n        <- ifelse(length(args) == 0, 1000, args[1])
min_date <- as.Date(ifelse(length(args) > 2, args[2], "1950-01-01"))
max_date <- Sys.time()

build_skeleton <- function(df, n = 10, master_data = FALSE) {
  pmap_dfr(df, function(subject_id, birth_date, sex) {
    result     <- data.frame()
    birth_time <- as.POSIXct(birth_date)
    for (i in 1:sample(1:n, 1)) {
      created_at <- sample(seq(birth_time, max_date, by = "10 mins"), 1)
      if (master_data) {
        age    <- time_length(interval(birth_time, created_at), "years")
        result <- rbind(result, data.frame(subject_id, created_at, age, sex))
      } else {
        result <- rbind(result, data.frame(subject_id, created_at))
      }
    }
    return(result)
  })
}

## subjects
subject <- data.frame(
  subject_id = 1:n,
  birth_date = sample(seq(min_date, as.Date(max_date), by = "day"), n, replace = TRUE),
  sex        = sample(c("male", "female"), n, replace = TRUE)
)
write.csv(subject, "subject.csv", row.names = FALSE)

## assessments
assessment1 <- build_skeleton(subject, master_data = TRUE)
assessment1$height <- mock_values(assessment1, sex = "sex", age = "age", childsds::kro.ref, "height")$height
assessment1$weight <- mock_values(assessment1, sex = "sex", age = "age", childsds::kro.ref, "weight")$weight
assessment1$sodium_level <- rnorm(nrow(assessment1), mean = 140, sd = 5)
write.csv(assessment1[, c(1, 2, 5, 6, 7)], "assessment1.csv", row.names = FALSE)
rm(assessment1)

## conditions
condition <- build_skeleton(subject, n = 5)
condition$code_system <- "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
condition$code <- sprintf(
  "%s%02d.%d",
  sample(toupper(letters), nrow(condition), replace = TRUE),
  sample(1:99, nrow(condition), replace = TRUE),
  sample(1:99, nrow(condition), replace = TRUE)
)
write.csv(condition, "condition.csv", row.names = FALSE)
rm(condition)

## medications
medication <- build_skeleton(subject, n = 5)
medication$code_system <- "http://fhir.de/CodeSystem/bfarm/atc"
medication$code <- sprintf(
  "%s%02d%s%s%02d",
  sample(toupper(letters), nrow(medication), replace = TRUE),
  sample(1:99, nrow(medication), replace = TRUE),
  sample(toupper(letters), nrow(medication), replace = TRUE),
  sample(toupper(letters), nrow(medication), replace = TRUE),
  sample(1:99, nrow(medication), replace = TRUE)
)
medication$amount <- sample(seq(0, 10, 0.1), nrow(medication), replace = TRUE)
write.csv(medication, "medication.csv", row.names = FALSE)
rm(medication)

## procedures
procedure <- build_skeleton(subject, n = 5)
procedure$code_system <- "http://fhir.de/CodeSystem/bfarm/ops"
procedure$code <- sprintf(
  "%d-%02d",
  sample(c(1, 3, 5, 6, 8, 9), nrow(procedure), replace = TRUE),
  sample(1:99, nrow(procedure), replace = TRUE)
)
write.csv(procedure, "procedure.csv", row.names = FALSE)
rm(procedure)
