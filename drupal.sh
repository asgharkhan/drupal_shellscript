#!/bin/bash
# Create drush alliases and sync database and source code.
#

# Check who is running this scription. Runner should be root.
if [ "$(whoami)" != 'root' ]; then
	echo $"You have no permission to run $0 as non-root user. Use sudo"
		exit 1;
fi

#
# Do you want to create site for BI or Nitro or others.
#

PS3='Do you want to configure which server site: '
options=("BI Int" "Nitro Dev" "Others" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "BI Int")
           bi
            ;;
        "Nitro Dev")
           nitro
            ;;
        "Others")
           other
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done

bi() {
 echo "User Chose the bi option"
}

nitro() {
echo "User chose the nitro"
}

other() {
 echo "User chose the other";
}

# Check directory exist ~/.drush

drush_dir="~/.drush"
if [ ! -d "drush_dir" ]; then
  mkdir $drush_dir
  if [ ! -d "$drush_dir" ]; then 
    echo "Script has tried to create the $drush_dir. Please create manually"
    exit 1;
  fi
fi

