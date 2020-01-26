#!/bin/bash

read -p 'Enter Virtual Host : ' virtualHost

vhostFileEnabledSites=/etc/apache2/sites-enabled/$virtualHost.conf

if [ -f "$vhostFileEnabledSites" ]; then
    echo "$vhostFileEnabledSites Host Already Exists"
    exit 1
fi

read -p 'Enter Virtual Directory : ' virtualHostDirectory

if [ ! -d "$virtualHostDirectory" ]; then
    echo "$virtualHostDirectory Directory Not Exists"
    exit 1
fi

echo "127.0.0.1     $virtualHost" | sudo tee -a /etc/hosts


echo "<VirtualHost *:80>
    DocumentRoot \"$virtualHostDirectory\"
    ServerName www.$virtualHost
    ServerAlias $virtualHost
   <Directory \"$virtualHostDirectory\">
    Options FollowSymLinks
    AllowOverride All
   Options -Indexes
    </Directory>
    </VirtualHost>
" | sudo tee -a /etc/apache2/sites-available/$virtualHost.conf


sudo a2ensite $virtualHost.conf

sudo service apache2 restart


echo " | ----------------------------- | "
echo " | --- Virtual Host Is Ready --- | "
echo " | ----------------------------- | "