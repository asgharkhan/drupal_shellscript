#!/bin/bash
. ./constants.sh

site_url="local.advert"
drupal_path="/Library/WebServer/Documents/local.advert"
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
echo "end"

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