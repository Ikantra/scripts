#!/bin/bash
#By JMH
###Note this was initially done for CentOS
###Assuming no compiler
yum groupinstall "Development tools"
###Userspace for Apache
mkdir /var/www
groupadd www-group
useradd -d /var/www -g www-group -s /bin/false www-user
chown www-user_www-group /var/www
###Assuming src doesn't already exists
#mkdir /usr/local/src
###removes the content of SRC if needed
#cd /usr/local/src
#rm -rf *
###Installing PCRE dependency, removing current one if applicable
yum remove pcre
wget https://ftp.pcre.org/pub/pcre/pcre-8.00.tar.gz
tar -xzf pcre-8.00.tar.gz
cd pcre-8.00
./configure --prefix=/usr/local/pcre
make && make install #
###Apache \o/
cd /usr/local/src
wget apache.uib.no//httpd/httpd-2.4.25.tar.gz -O /usr/local/src/httpd-2.4.25.tar.gz
gzip -d httpd-2.4.25.tar.gz
tar -xvf httpd-2.4.25.tar
cd /usr/local/src/httpd-2.4.25/srclib
rm -f /usr/local/src/httpd-2.4.25/srclib/apr
rm -f /usr/local/src/httpd-2.4.25/srclib/apr-util
wget apache.uib.no//apr/apr-1.5.2.tar.gz
wget apache.uib.no//apr/apr-util-1.5.4.tar.gz
mkdir apr && tar -zxvf apr-1.5.2.tar.gz -C apr --strip-components 1
mkdir apr-util && tar -zxvf apr-util-1.5.4.tar.gz -C apr-util --strip-components 1
cd /usr/local/src/httpd-2.4.25
./configure --with-included-apr --with-pcre
make (clean) && make install #
vim /usr/local/apache2/conf/httpd.conf
###initialisation
#/usr/local/apache2/bin/apachect1 -k start
