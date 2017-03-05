#!/bin/bash
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

. "$DIR/constants.sh"

# Check who is running this scription. Runner should be root.
if [ "$(whoami)" != 'root' ]; then
	echo $"You have no permission to run $0 as non-root user. Use sudo"
		exit 1;
fi

# Get the site URL
echo "Enter your site URL"
read site_url

if [[ -z "$site_url" ]]; then
  echo "You did not enter the site URL"
  exit 1;
fi;
# Check aliases  exist.
alias_file=~/.drush/$site_url.aliases.drushrc.php

if [ ! -f "$alias_file" ] ; then 
   echo "Aliases field does not found here $alias_file"
fi


# Apache file.
apache_file=/etc/apache2/$NITROSH_APACHE_DIR/$site_url.conf
if [ ! -f "$apache_file" ]; then 
  echo "Apache file does not extist here $apache_file"
fi



# Get the site directory path.
doc_root=$(grep  -e "DocumentRoot" $apache_file | awk '{print $2}')

echo "Docment root is $doc_root"

echo "Mysql user name($NITROSH_MYSQL_USER)";
read mysql_user

if [[ -z "$mysql_user" ]]; then 
   mysql_user=$NITROSH_MYSQL_USER
fi 

echo "Mysql root password($NITROSH_MYSQL_PASSWORD)";
read mysql_password

if [[ -z "$mysql_password" ]]; then 
   mysql_password=$NITROSH_MYSQL_PASSWORD
fi 

#cd $doc_root
#echo "Current directory is $PWD"
#db_name=$(drush sql-connect | awk '{print $2}' | cut -d '=' -f2)
db_name="${site_url//[ \.\-]/_}"
#echo "Database name is $db_name"
#echo mysql -u $mysql_user -p$mysql_password -D $db_name -e "DROP DATABASE $db_name"
echo mysqladmin -u$mysql_user -p$mysql_password drop $db_name

if [ -f "$apache_file" ]
then
	rm -rf $apache_file $doc_root $alias_file 
  perl -pi -e "s,^127.0.0.1 $site_url\n$,," /etc/hosts

else
	echo "$apache_file not found."
fi
