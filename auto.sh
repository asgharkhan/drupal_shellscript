#!/bin/bash
# Configure Virtual and Remove Virtual.


# Check who is running this scription. Runner should be root.
if [ "$(whoami)" != 'root' ]; then
	echo $"You have no permission to run $0 as non-root user. Use sudo"
		exit 1;
fi

# Get the Drupal Directory path.
echo "Enter your sites location(/Library/WebServer/Documents)"
read sites_dir

# If user press Enter we will use default path.
if [[ -z "$sites_dir" ]]; then
  sites_dir="/Library/WebServer/Documents"
fi;

# Make sure directory is exist.
if [ ! -d "$sites_dir" ]; then
  echo "Directory Does not exist"
  exit 1;
fi 

# Get the Drupal Directory.
echo "Enter Drupal Root Directory name under sites Directory"
read drupal_dir

# Check directory Name does not contain the space.
 if [[ "$drupal_dir" != "${drupal_dir/ /}" ]]
    then
        echo "Drupal Directory contains the space. Replace space with dash, dot or under score" >&2
        exit 1
    fi

drupal_path=$sites_dir/$drupal_dir

if [ ! -d "$drupal_path" ]; then
  echo "Site does not exist on $drupal_path"
  exit 1;
fi 

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



nitro_apache="/etc/apache2/nitro-drupal"
if [ ! -d "$nitro_apache" ]; then
  mkdir $nitro_apache
  if [ ! -d "$nitro_apache" ]; then 
    echo "Script has tried to create the /etc/apache2/nitro-drupal. Please create manually"
    exit 1;
  fi
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