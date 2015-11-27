#!/usr/bin/env sh
#
# This content is released under the (https://github.com/horttanainen/goto/blob/master/LICENSE) MIT License. 
# this script should not be run directly,
# instead you need to source it from your .bashrc (or similar to your shell choice),
# by adding this line:
#   . /path/to/your/goto/goto.sh

gotopath=""

export lines="$gotopath/lines"
export linenum="$gotopath/linenum"
export paths="$gotopath/paths"
export tmpfile="$gotopath/tmpfile"

script="$gotopath/subgoto.sh"

goto() {
    goto=1
    export workdir="$(pwd)"
    while getopts ":cr:a:" opt; do
        case $opt in
            r)
                goto=0
                if [ $(echo "${#workdir}") = 1 ]; then
                    file="${workdir}$OPTARG"
                else
                    file="$workdir/$OPTARG"
                fi
                if [ -e $file ]; then
                    echo "$file" | cat - "$lines" > $tmpfile && mv $tmpfile "$lines"
                    break
                else
                    echo "File or folder does not exist!"
                    break
                fi
                ;;
            a)
                goto=0
                char=$(echo $OPTARG | cut -c 1)
                if [ $char = "/" ]; then
                    :
                else
                    echo "Absolute paths must begin with /"
                    break
                fi
                if [ -e $OPTARG ]; then
                    echo "$OPTARG" | cat - "$lines" > $tmpfile && mv $tmpfile "$lines"
                    break
                else
                    echo "File or folder does not exist!"
                    break
                fi
                ;;
            c)
                goto=0
                echo "$workdir" | cat - "$lines" > $tmpfile && mv $tmpfile "$lines"
                break
                ;;
            \?)
                goto=0
                echo "Invalid option: -$OPTARG" >&2
                ;;
        esac
    done
    shift $((OPTIND-1))
    if [ $goto = 0 ]; then
        :
    else
        . $script
        subgoto $@
    fi
}
