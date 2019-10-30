FROM ubuntu:16.04

RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial"-pgdg main | tee  /etc/apt/sources.list.d/pgdg.list

RUN apt-get update \
    && apt-get install -y python-software-properties software-properties-common postgresql-11 postgresql-client-11 postgresql-contrib-11

RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*

# # Add the PostgreSQL PGP key to verify their Debian packages.
# # It should be the same key as https://www.postgresql.org/media/keys/ACCC4CF8.asc
# RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

# # Add PostgreSQL's repository. It contains the most recent stable release
# #     of PostgreSQL, ``9.3``.
# RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# # Note: The official Debian and Ubuntu images automatically ``apt-get clean``
# # after each ``apt-get``

USER root
ADD /sudoers.txt /etc/sudoers
RUN chmod 440 /etc/sudoers

COPY docker-entrypoint.sh /usr/local/bin/

# RUN chmod 777 usr/local/bin/docker-entrypoint.sh
RUN sudo ln -s usr/local/bin/docker-entrypoint.sh /
# backwards compat

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-9.3`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN /etc/init.d/postgresql start

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/11/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/11/main/postgresql.conf

ENTRYPOINT ["docker-entrypoint.sh"]

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/11/bin/postgres", "-D", "/var/lib/postgresql/11/main", "-c", "config_file=/etc/postgresql/11/main/postgresql.conf"]