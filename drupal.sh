#!/bin/bash
# Create drush alliases and sync database and source code.
#
. "$DIR/functions.sh"
# Check who is running this scription. Runner should be root.
#if [ "$(whoami)" != 'root' ]; then
#	echo $"You have no permission to run $0 as non-root user. Use sudo"
#		exit 1;
#fi





#
# Do you want to create site for BI or Nitro or others.
#
get_server_info() {
PS3='Do you want to configure which server site: '
options=("BI Int" "Nitro Dev" "Others" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "BI Int")
           bi
           break 
            ;;
        "Nitro Dev")
           nitro
           break
            ;;
        "Other")
           other
           break
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done

}


#get_server_info

