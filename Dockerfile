FROM r-base AS generate-sample-data
RUN R -e "install.packages(c('purrr', 'childsds', 'lubridate'))"
RUN mkdir /sample-data
COPY scripts/generate_sample_data.r /sample-data
WORKDIR /sample-data
ARG N=1000
ARG MIN_DATE=1950-01-01
RUN Rscript /sample-data/generate_sample_data.r $N $MIN_DATE

FROM postgres AS build-db
COPY database/* /docker-entrypoint-initdb.d/
COPY --from=generate-sample-data /sample-data/*.csv /docker-entrypoint-initdb.d/
RUN chmod a+r /docker-entrypoint-initdb.d/*
