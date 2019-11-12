#!/usr/bin/env bash
echo 'export PS1="\[$(tput setaf 3)\]\[$(tput bold)\][\t \u>\[$(tput sgr0)\]\[$(tput setaf 1)\]\h\[$(tput sgr0)\]\[$(tput setaf 4)\] \W] \\$ \[$(tput sgr0)\]"' >> ~/.bashrc ;
echo 'alias ll="ls -lrthF";' >> ~/.bashrc
echo 'alias grep="grep --color=auto";' >> ~/.bashrc
mkdir /logs;
touch /logs/postgresql.log;
chmod -R 777 /logs;
tail -f /logs/* &
/docker-entrypoint.sh "$@"

# Allow local connections from anywhere:
sed -i 's/^host    all             all             127\.0\.0\.1\/32            trust/host    all             all             0\.0\.0\.0\/32              trust/' /var/lib/postgresql/data/pg_hba.conf

# comment this to add at the bottom:
sed -i "s/^log_timezone/#log_timezone/" /var/lib/postgresql/data/postgresql.conf;
sed -i "s/^timezone =/#timezone =/" /var/lib/postgresql/data/postgresql.conf;
sed -i "s/^log_line_prefix/#log_line_prefix/" /var/lib/postgresql/data/postgresql.conf;

##################################################################################################################################

echo "###################### CUSTOM MODIFICATION START ######################" >> /var/lib/postgresql/data/postgresql.conf;
echo "log_timezone = 'Asia/Kolkata'" >> /var/lib/postgresql/data/postgresql.conf;
echo "timezone = 'Asia/Kolkata'" >> /var/lib/postgresql/data/postgresql.conf;
echo "log_file_mode = 0777" >> /var/lib/postgresql/data/postgresql.conf;
echo "log_line_prefix = '%m [%p] [%r] [%a] %q%u@%d '" >> /var/lib/postgresql/data/postgresql.conf;
# echo "log_statement = 'all' # to debug all statement" >> /var/lib/postgresql/data/postgresql.conf;
# echo "log_directory = '/var/lib/postgres/psql_logs'" >> /var/lib/postgresql/data/postgresql.conf;
# echo "log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'"" >> /var/lib/postgresql/data/postgresql.conf;
echo "######################  CUSTOM MODIFICATION END  ######################" >> /var/lib/postgresql/data/postgresql.conf;

##################################################################################################################################