#!/usr/bin/env sh

subgoto() {
    keyword="$*"

    gotofolder() {
        if [ -d "$*" ]; then
            cd "$*"
        else
            src="$*"
            base=${src##*/}
            dir=${src%"$base"}
            dirtest=$(echo "$dir" | tr -d '[:space:]') #fix for issue #2
            if [ -z $dirtest ]; then
                cd $(dirname $src)
            else
                cd $dir
            fi
        fi
    }

    scrollsearchresults() {
        printf "Press (space) to goto, (n) next result, (p) previous.\n\n"
        line=1
        maxlines=$(echo "$result" | wc -l)
        while true; do
            folder="$(echo "$result" | tail -n+$line | head -n1)"
            echo $folder
            old_stty_cfg=$(stty -g)
            stty raw -echo ; key=$(head -c 1) ; stty $old_stty_cfg 
            if [ "$key" = "n" ]; then
                if [ "$line" -eq "$maxlines" ]; then
                    line=1
                else
                    line=`expr $line + 1`
                fi
            elif [ "$key" = "p" ]; then
                if [ "$line" -eq 1 ]; then
                    line=$maxlines
                else
                    line=`expr $line - 1`
                fi
            elif [ "$key" = " " ]; then
                echo "$folder" | cat - "$lines" > $tmpfile && mv $tmpfile "$lines"
                gotofolder $folder
                break
            else
                break
            fi
        done
    }

    findfromroot() {
        printf "No match with ${keyword}. Look from root? (space)\n"
        old_stty_cfg=$(stty -g)
        stty raw -echo ; key=$(head -c 1) ; stty $old_stty_cfg 

        if [ "$key" = " " ]; then
            result=$(find / -name "${keyword}*" -printf "%T@ %p\n" 2> /dev/null | sort -r -k 1 -n | sed 's/^[^ ]* //')
            if [ -z "$result" ]; then
                printf "No match with $keyword \n"
            else
                scrollsearchresults
            fi
        else
            return
        fi
    }

    findfromcurrent() {
        result=$(find "$workdir" -name "${keyword}*" -printf "%T@ %p\n" 2> /dev/null | sort -r -k 1 -n | sed 's/^[^ ]* //')
        if [ -z "$result" ]; then
            findfromroot
        else
            scrollsearchresults
        fi
    }

    scrollgotos() {
        printf "Press (space) to goto, (n) next result, (p) previous.\n"
        printf "Press (s) to do a search from this directory.\n\n"
        line=1
        maxlines=$(echo "$result" | wc -l)
        while true; do
            folders=$(echo "$result" | tail -n+$line | head -n1)
            folder="$(echo "$folders" | cut -d':' -f2)"
            deleteline="$(echo "$folders" | cut -d':' -f1)"
            echo "$folder"
            old_stty_cfg=$(stty -g)
            stty raw -echo ; key=$(head -c 1) ; stty $old_stty_cfg 
            if [ "$key" = "n" ]; then
                if [ "$line" -eq "$maxlines" ]; then
                    line=1
                else
                    line=`expr $line + 1`
                fi
            elif [ "$key" = "p" ]; then
                if [ "$line" -eq 1 ]; then
                    line=$maxlines
                else
                    line=`expr $line - 1`
                fi
            elif [ "$key" = " " ]; then
                sed "${deleteline}d" "$lines" > $tmpfile; mv $tmpfile "$lines"
                echo "$folder" | cat - "$lines" > $tmpfile && mv $tmpfile "$lines"
                gotofolder $folder
                break
            elif [ "$key" = "s" ]; then
                findfromcurrent
                break
            else
                break
            fi
        done

    }

    lookfromgotos() {
        matches=$(grep -n -o "/[^/]*$" $lines )
        if echo "$matches" | grep -q ".*${keyword}.*" ; then
            echo "$matches" | grep ".*${keyword}.*" | cut -f1 -d":" > $linenum
            cat $linenum | xargs -I{} -d"\n" sed -n "{}p" $lines > $paths 
            result=$(paste $linenum $paths -d ":")
            scrollgotos
        else
            findfromcurrent
        fi
    }

    checkforroot() {
        if [ $(echo "${#keyword}") = 1 ]; then
            if [ $keyword = "/" ]; then
                gotofolder $keyword
            else
                removeslash
            fi
        else
            removeslash
        fi
    }

    removeslash() {
        lastchar=${keyword#"${keyword%?}"}
        if [ $lastchar = "/" ]; then
            keyword=${keyword%?}
            lookfromgotos 
        else
            lookfromgotos
        fi
    }

    checkforroot
}
