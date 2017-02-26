#!/bin/bash
# This file contains the all useful functions.
#
generate_aliases() {
  cp ./aliases/bi.aliases.drushrc.php ~/.drush/$site_url.drushrc.php
  # Change Document root value. 
  sed -i -- "s|@local_doc|$local_doc|g" ~/.drush/$site_url.drushrc.php
  # Change the Site URL
  sed -i -- "s|@local_url|$site_url|g" ~/.drush/$site_url.drushrc.php
}

bi() {
 BI_HOST="77.246.39.193"

 echo "Enter a BI ssh user name"
 read bi_ssh
 # Check user entered a ssh user.
 if [[ -z "$bi_ssh" ]]; then
  echo "You did not enter the ssh user"
  exit 1;
 fi

  bi_sname=$(echo "${bi_ssh%?}")
  echo "Enter BI Int site URL(https://int-$bi_sname.bi-customerhub.com)"
  read bi_site_url

 if [[ -z "$bi_site_url" ]]; then
  bi_site_url="https://int-$bi_sname.bi-customerhub.com"
 fi

 echo "Enter Int site root directory path(/home/$bi_ssh/public_html)"
 read int_doc_root
 if [[ -z "$bi_site_url" ]]; then
   int_doc_root="/home/$bi_ssh/public_html"
 fi
 site_url="local.test"
 local_doc='/Library/WebServer/Documents/test.local'
 generate_aliases
}


nitro() {
  echo "User chose the nitro"
}

other() {
 echo "User chose the other";
}