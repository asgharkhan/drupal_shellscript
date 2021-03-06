#!/bin/bash
# Configure Virtual and Remove Virtual.
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/drupal.sh"

echo "Current user is $SUDO_USER"
# Check who is running this scription. Runner should be root.
if [ "$(whoami)" != 'root' ]; then
	echo $"You have no permission to run $0 as non-root user. Use sudo"
		exit 1;
fi
 printf '%s\n' "${SUDO_USER:-$USER}"


# Get the Drupal Directory path.
echo "Enter your sites location($NITROSH_SITES_DIR)"
read sites_dir

# If user press Enter we will use default path.
if [[ -z "$sites_dir" ]]; then
  sites_dir="$NITROSH_SITES_DIR"
fi;

# Make sure directory is exist.
if [ ! -d "$sites_dir" ]; then
  echo "Directory Does not exist"
  exit 1;
fi 

# Get the Drupal Directory.
echo "Enter Drupal Root Directory name under sites Directory"
read drupal_dir

if [[ -z "$drupal_dir" ]]; then
  echo "Drupal Directory path is required".
  exit 1;
fi;

# Check directory Name does not contain the space.
 if [[ "$drupal_dir" != "${drupal_dir/ /}" ]]
    then
        echo "Drupal Directory contains the space. Replace space with dash, dot or under score" >&2
        exit 1
    fi

drupal_path=$sites_dir/$drupal_dir

echo "Enter your site local url($drupal_dir)"
read site_url

if [[ -z "$site_url" ]]; then
  site_url=$drupal_dir
fi;

 if [[ "$site_url" != "${site_url/ /}" ]]
    then
        echo "Site URL contains the space. Replace space with dash, dot or under score" >&2
        exit 1
 fi

if [ -d "$drupal_path" ]; then
  echo "Site diresctory with same name $drupal_path already exist"
  exit 1;
fi 
# Ask about server info.
get_server_info


nitro_apache=/etc/apache2/$NITROSH_APACHE_DIR
if [ ! -d "$nitro_apache" ]; then
  mkdir $nitro_apache
  if [ ! -d "$nitro_apache" ]; then 
    echo "Script has tried to create the /etc/apache2/nitro-drupal. Please create manually"
    exit 1;
  fi
fi

nitrosh_include="include /private/etc/apache2/$NITROSH_APACHE_DIR/*.conf"
if grep -qF "$nitrosh_include" $NITROSH_SYSTEM_APACHE ; then
   echo "Found it"
else
   echo "$nitrosh_include" >> $NITROSH_SYSTEM_APACHE
   echo "Inserted into $NITROSH_SYSTEM_APACHE"
fi

echo "
<VirtualHost *:80>
  DocumentRoot $drupal_path
  ServerName $site_url
  <Directory $drupal_path>
    Options +Indexes +FollowSymLinks +MultiViews +Includes
    AllowOverride All
    Order allow,deny 
    allow from all 
  </Directory> 
</VirtualHost>" > $nitro_apache/$site_url.conf


# Add the host entry file
 echo 127.0.0.1 $site_url >> /etc/hosts

sudo apachectl restart