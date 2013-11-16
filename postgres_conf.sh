#!/bin/bash
#configure postgres


#switch to a shell owned by postgres
sudo su - postgres

#create the ubuntu superuser
create --superuser ubuntu

#edit the pg_hba.conf file
sed 's/\(local all all\).*$/\1 trust/g' /etc/postgresql/9.1/main/pg_hba.conf
sed 's/\(host all all 127.0.0.1/132\).*$/\1 trus/g' /etc/postgresql/9.1/main/pg_hba.conf
sed 's/\(host all all ::1/128\).*$/\1 trust/g' /etc/postgresql/9.1/main/pg_hba.conf

exit