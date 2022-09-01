FROM postgres
COPY database/* /docker-entrypoint-initdb.d/
RUN chmod a+r /docker-entrypoint-initdb.d/*
