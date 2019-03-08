#! /bin/bash
if [ ! -f /home/vagrant/already-installed-flag ]
then
  echo "ADD EXTRA ALIAS VIA .bashrc"
  cat /vagrant/bashrc.append.txt >> /home/vagrant/.bashrc
  #echo "GENERAL YUM UPDATE"
  #yum -y update
  #echo "INSTALL GIT"
  yum -y install git
  #echo "INSTALL VIM"
  #yum -y install vim
  #echo "INSTALL TREE"
  yum -y install tree
  #echo "INSTALL unzip curl wget lsof"
  yum  -y install unzip curl wget lsof 
  # install sysstat
  yum -y sysstat
  systemctl start sysstat
  systemctl enable sysstat


  # Regular pg10 install                                                                           
  rpm -Uvh https://yum.postgresql.org/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
  yum -y update
  yum -y install postgresql10-server postgresql10
  yum -y install postgresql10-contrib postgresql10-libs postgresql10-devel
 
  # Extra packages and devtool for install of https://github.com/ossc-db/pg_plan_advsr  
  #yum -y install postgresql-devel
  yum -y install gcc

  # setup pg_hba.conf and start pg10
  cp /vagrant/pg_hba.conf /tmp/pg_hba.conf
  #su -c "cp -p /var/lib/pgsql/10/data/pg_hba.conf /var/lib/pgsql/10/data/pg_hba.conf.`date '+%Y%m%d-%H%M'`.bak" -s /bin/sh postgres
  #su -c "cat /tmp/pg_hba.conf > /var/lib/pgsql/10/data/pg_hba.conf" -s /bin/sh postgres
  /usr/pgsql-10/bin/postgresql-10-setup initdb
  systemctl enable postgresql-10.service
  systemctl start postgresql-10.service 

  # install pgbouncer (setup to be completed)
  yum -y install pgbouncer
  cp /vagrant/pgbouncer.ini /etc/pgbouncer/pgbouncer.ini
  cp /vagrant/userlist.txt /etc/pgbouncer/userlist.txt
  
  # Postgres adapter for Python
  yum -y install python-psycopg2
  
  # setup environment variables and extra alias for postgres user
  cat /vagrant/bashrc.append.txt >> /var/lib/pgsql/.bash_profile
  echo 'export PATH="$PATH:/usr/pgsql-10/bin"' >> /var/lib/pgsql/.bash_profile


  # setup help files

  cp /vagrant/update_alluser_passwords_from_changeme.* /tmp
  su -c "cp -p /tmp/update_alluser_passwords_from_changeme.* ~" -s /bin/sh postgres
  su -c "chmod 700 ~/update_alluser_passwords_from_changeme.sh"  -s /bin/sh postgres
  su -c "~/update_alluser_passwords_from_changeme.sh <new-secure-password>" -s /bin/sh postgres

  sudo cat /vagrant/environment >> /etc/environment
  cp /vagrant/quick-start-setup-pg-ora-demo-scripts.sh /tmp
  cp /vagrant/quick-start-setup-pg-ora-demo-scripts.sql /tmp
  su -c "cp -p /tmp/quick-start-setup-pg-ora-demo-scripts.* ~" -s /bin/sh postgres
  su -c "chmod 700 ~/quick-start-setup-pg-ora-demo-scripts.sh"  -s /bin/sh postgres
  cp /vagrant/update_alluser_passwords_from_changeme.sh /tmp
  cp /vagrant/update_alluser_passwords_from_changeme.sql /tmp
  su -c "cp -p /tmp/update_alluser_passwords_from_changeme.* ~" -s /bin/sh postgres
  su -c "chmod 700 ~/update_alluser_passwords_from_changeme.sh"  -s /bin/sh postgres


else
  echo "already installed flag set : /home/vagrant/already-installed-flag"
fi

