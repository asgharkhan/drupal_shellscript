#!/bin/bash


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
# Apache file.
apache_file="/etc/apache2/nitro-drupal/$site_url.conf"

# Get the site directory path.
doc_root=$(grep  -e "DocumentRoot" $apache_file | awk '{print $2}')

echo "Docment root is $doc_root"

exit 1;

if [ -f "$apache_file" ]
then
	rm -f $apache_file && perl -pi -e "s,^127.0.0.1 $site_url\n$,," /etc/hosts
else
	echo "$apache_file not found."
fi



