# postgres 12:
FROM postgres:latest
LABEL maintainer="Rohit rohitrehni.rr@gmail.com" Name=psql_12 Version=12
# install external dependency for extension plperl
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends postgresql-plperl-12 && apt-get clean

COPY update_config.sh /docker-entrypoint-initdb.d/

COPY create_default_data.sql /docker-entrypoint-initdb.d/

RUN chmod +x /docker-entrypoint-initdb.d/update_config.sh

ENTRYPOINT ["/docker-entrypoint-initdb.d/update_config.sh"]

CMD ["postgres", "-c", "logging_collector=on", "-c", "log_directory=/logs", "-c", "log_filename=postgresql.log", "-c", "log_statement=all"]
