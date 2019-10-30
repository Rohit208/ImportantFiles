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

# # Install ``python-software-properties``, ``software-properties-common`` and PostgreSQL 9.3
# #  There are some warnings (in red) that show up during the build. You can hide
# #  them by prefixing each apt-get statement with DEBIAN_FRONTEND=noninteractive
# RUN apt-get update && apt-get install -y python-software-properties software-properties-common postgresql-11 postgresql-client-11 postgresql-contrib-11

# # Note: The official Debian and Ubuntu images automatically ``apt-get clean``
# # after each ``apt-get``

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

COPY docker-entrypoint.sh /usr/local/bin/

# RUN chmod 777 usr/local/bin/docker-entrypoint.sh
RUN sudo ln -s usr/local/bin/docker-entrypoint.sh /
# backwards compat

ENTRYPOINT ["docker-entrypoint.sh"]

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/11/bin/postgres", "-D", "/var/lib/postgresql/11/main", "-c", "config_file=/etc/postgresql/11/main/postgresql.conf"]















# I: /boot/vmlinuz.old is now a symlink to vmlinuz-5.0.0-32-generic
# I: /boot/initrd.img.old is now a symlink to initrd.img-5.0.0-32-generic
# I: /boot/vmlinuz is now a symlink to vmlinuz-5.3.0-18-generic
# I: /boot/initrd.img is now a symlink to initrd.img-5.3.0-18-generic
# Found memtest86+ image: /boot/memtest86+.elf
# Found memtest86+ image: /boot/memtest86+.bin
# done
# Setting up xserver-xorg-video-intel (2:2.99.917+git20190815-1) ...
# Setting up liblinux-epoll-perl (0.016-1) ...
# Setting up libqt4-sql-mysql:amd64 (4:4.8.7+dfsg-7ubuntu3) ...
# Setting up cups-daemon (2.2.12-2ubuntu1) ...
# Setting up openjdk-8-jre-headless:amd64 (8u232-b09-0ubuntu1) ...

# pam-auth-update: Local modifications to /etc/pam.d/common-*, not updating.


# Removing libxml-simple-perl (2.25-1) ...
# Removing libxml-libxml-perl (2.0134+dfsg-1) ...
# update-perl-sax-parsers: Unregistering Perl SAX parser XML::LibXML::SAX::Parser with priority 50...
# update-perl-sax-parsers: Unregistering Perl SAX parser XML::LibXML::SAX with priority 50...
# update-perl-sax-parsers: Updating overall Perl SAX parser modules info file...
# Replacing config file /etc/perl/XML/SAX/ParserDetails.ini with new version
# Removing libxml-sax-expat-perl (0.51-1) ...
# update-perl-sax-parsers: Unregistering Perl SAX parser XML::SAX::Expat with priority 50...
# update-perl-sax-parsers: Updating overall Perl SAX parser modules info file...
# Replacing config file /etc/perl/XML/SAX/ParserDetails.ini with new version
# Removing libxml-sax-perl (1.02+dfsg-1) ...
# update-perl-sax-parsers: Unregistering Perl SAX parser XML::SAX::PurePerl with priority 50...
# update-perl-sax-parsers: Updating overall Perl SAX parser modules info file...
# Removing libxml-namespacesupport-perl (1.12-1) ...
# Removing libxml-sax-base-perl (1.09-1) ...

# Removing libsereal-perl (4.007-1) ...
# Removing libsereal-decoder-perl (4.007+ds-1) ...
# Removing libsereal-encoder-perl (4.007+ds-1) ...
