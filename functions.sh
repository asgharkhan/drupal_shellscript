#!/bin/bash
# This file contains the all useful functions.
#

. ./constants.sh


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

  cp ./aliases/bi.aliases.drushrc.php ~/.drush/$site_url.aliases.drushrc.php
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
 drush rsync -r -v --progress @$site_url.int @$site_url.local

 # Get the Mac current user.
  _user="$(id -u -n)"

 #Set the Drupal directories and file permissions.

 sudo bash fix-permissions.sh --drupal_path=$drupal_path --drupal_user=$_user
 echo "Site downded" 
 

}

bi() {
 BI_HOST="77.246.39.193"

 echo "Enter a BI ssh user name"
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

