#!/usr/bin/env sh
#This content is released under the (https://github.com/horttanainen/goto/blob/master/LICENSE) MIT License. 
dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
modify="$dir/goto.sh"
tmpfile="$dir/tmpfile"
newpath="gotopath=\"$dir\""

number=$(grep -n gotopath $modify| cut -d":" -f 1| head -n 1)
sed "${number}d" "$modify" > $tmpfile; mv $tmpfile "$modify"
sed "${number}i $newpath" "$modify" > $tmpfile; mv $tmpfile "$modify"

oldvalue=$(grep \(\) $modify | cut -d"(" -f 1)
printf "give shortcut for goto (current: $oldvalue): "
IFS= read -r name
name=$(echo "$name" | tr -d '[:space:]')
if [ -z $(echo $name | tr -d "[:alpha:]") ]; then
    if [ -z $name ]; then
        :
    else
        newname="${name}\(\) \{"
        number=$(grep -n \(\) $modify| cut -d":" -f 1| head -n 1)
        sed "${number}d" "$modify" > $tmpfile; mv $tmpfile "$modify"
        sed "${number}i $newname" "$modify" > $tmpfile; mv $tmpfile "$modify"
    fi
else
    printf "Only alphabetic characters allowed.\n"
    exit 0
fi
