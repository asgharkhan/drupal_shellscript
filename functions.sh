#!/bin/bash
# This file contains the all useful functions.
#

. "$DIR/constants.sh"


check_drush_dir() {
# Check directory exist ~/.drush
drush_dir=~/.drush
if [ ! -d "$drush_dir" ]; then
  mkdir $drush_dir
  if [ ! -d "$drush_dir" ]; then 
    echo "Script has tried to create the $drush_dir. Please create manually"
    exit 1;
  fi
fi
}

generate_aliases() {
 # Make sure Directory exist.
check_drush_dir

  cp $DIR/aliases/bi.aliases.drushrc.php ~/.drush/$site_url.aliases.drushrc.php
  # Change Document root value for local. 
  echo "Document local value is $drupal_path"
  sed -i -- "s|@local_doc|${drupal_path}|g" ~/.drush/$site_url.aliases.drushrc.php


  # Change the Site URL for local
  sed -i -- "s|@local_url|$site_url|g" ~/.drush/$site_url.aliases.drushrc.php
  # Add the Entries for BI
  sed -i -- "s|@dev_url|$bi_site_url|g" ~/.drush/$site_url.aliases.drushrc.php
  sed -i -- "s|@dev_doc|$int_doc_root|g" ~/.drush/$site_url.aliases.drushrc.php
echo "Document Int value is $int_doc_root"
  sed -i -- "s|@dev_ssh|$bi_ssh_user|g" ~/.drush/$site_url.aliases.drushrc.php
  sed -i -- "s|@dev_host|$BI_HOST|g" ~/.drush/$site_url.aliases.drushrc.php
 # NOTE: sed create a backup file we don't need that.
 rm -f ~/.drush/$site_url.aliases.drushrc.php--
}

configure_drupal() {

 echo "drush rsync @$site_url.int @$site_url.local executed. Please wait a while"
 # drush rsync -r -v --progress @$site_url.int @$site_url.local
drush rsync @$site_url.int @$site_url.local
 echo "Site downded" 
 # Get the Mac current user.
  _user="$(id -u -n)"

 #Set the Drupal directories and file permissions.

 #sudo bash "$DIR/fix-permissions.sh" --drupal_path=$drupal_path --drupal_user=$_user
 sudo chown -R $SUDO_USER $drupal_path
 echo "chown -R $SUDO_USER $drupal_path"
 echo "Set the directory permissions" 
 
db_name="${site_url//[ \.\-]/_}"

# Change your directory
cd $drupal_path

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

# Create database.
#mysql -u"$mysql_user" -p "$mysql_password" -e "create database $db_name"
echo "create database $db_name" | mysql -u "$mysql_user" -p"$mysql_password"

sudo drush eval '
include DRUPAL_ROOT."/includes/install.inc";
include DRUPAL_ROOT."/includes/update.inc";
global $db_prefix;
$settings["drupal_hash_salt"] = array(
  "value"   => drupal_random_key(),
  "required" => TRUE,

);
$settings["databases"]["value"] = update_parse_db_url("mysql://'"$mysql_user"':'"$mysql_password"'@localhost/'"$db_name"'", $db_prefix);
drupal_rewrite_settings($settings, $db_prefix);
'

 drush sql-sync @$site_url.int @$site_url.local
}

bi() {
 BI_HOST="77.246.39.193"

 echo "Enter a ssh host"
 read bi_ssh_host
 # Check user entered a ssh user.
 if [[ ! -z "$bi_ssh_host" ]]; then
  BI_HOST="$bi_ssh_host"
 fi
 echo "Enter a ssh user name"
 read bi_ssh_user
 # Check user entered a ssh user.
 if [[ -z "$bi_ssh_user" ]]; then
  echo "You did not enter the ssh user"
  exit 1;
 fi


  bi_sname=$(echo "${bi_ssh_user%?}")
  echo "Enter BI Int site URL(https://int-$bi_sname.bi-customerhub.com)"
  read bi_site_url

 if [[ -z "$bi_site_url" ]]; then
  bi_site_url="https://int-$bi_sname.bi-customerhub.com"
 fi

 echo "Enter Int site root directory path(/home/$bi_ssh_user/public_html)"
 read int_doc_root
 if [[ -z "$int_doc_root" ]]; then
   int_doc_root="/home/$bi_ssh_user/public_html"
 fi

 generate_aliases
 echo "Aliases file created for $site_url"

 configure_drupal
}


nitro() {
  echo "User chose the nitro"
}

other() {
 echo "User chose the other";
}

