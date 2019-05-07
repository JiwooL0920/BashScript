#! /bin/bash
cd ..
echo "Please read README.md for description of the features"
printf "\n"
printf "Please select a feature:\n1:TODO Log\n2:Merge Log\n3:Another Feature\n4:Compile Error Log\n5:Delete Temporary Files\n6:(Custom 1) chmod Converter\n7:(Custom 2) chmod Friendly Reminder \nFeature:"

read input
printf "\n"

#1) TODO Log--------------------------------------------------------------------------------------------------------------------------------------DONE
if [ $input = "1" ]; then
    #Create necessary file; if exist already delete and create again
    if [ -f ~/CS1XA3/Project01/logs/todo.log ]; then
        touch ~/CS1XA3/Project01/logs/todo.log
    else
        touch ~/CS1XA3/Project01/logs/todo.log
   fi
   #grep lines with #TODO and copy it to todo.log
   grep -rh "#TODO" > ~/CS1XA3/Project01/logs/todo.log 2> /dev/null

#2) Merge Log-------------------------------------------------------------------------------------------------------------------------------------DONE
elif [ $input = "2" ]; then
    #Create necessary file; if exist already delete and create again
    if [ -f ~/CS1XA3/Project01/logs/merge.log ]; then
        rm ~/CS1XA3/Project01/logs/merge.log
        touch ~/CS1XA3/Project01/logs/merge.log
    else
        touch ~/CS1XA3/Project01/logs/merge.log
    fi

    tmpFile1=$(mktemp) #make temporary files to aid grep
    tmpFile2=$(mktemp)
    git log --oneline >> $tmpFile1
    grep -i "merge" $tmpFile1 > $tmpFile2
    cut -d " " -f 1 $tmpFile2 >> ~/CS1XA3/Project01/logs/merge.log  #You only want commit hashes; cut commit comment

#3) File Type Count-------------------------------------------------------------------------------------------------------------------------------DONE
elif [ $input = "3" ]; then
    result=()   #An empty array where the number of files for each type will be appended to
    #HTML----------------------------------------------------------------------------------------
    html=$(mktemp)
    find ~/CS1XA3 -iname "*.html" -type f -print0 | while IFS= read -d $'\0' files; do
        echo $files >> $html
        done
    if [ -s $html ]; then
        result1=$(wc -l $html | cut -d " " -f 1)   #Only want the number; cut file name
        result+=($result1)   #append to the array
    else
        result+=(0)
    fi
    #Javascript------------------------------------------------------------------------------------
    javascript=$(mktemp)
    find ~/CS1XA3 -iname "*.js" -type f -print0 | while IFS= read -d $'\0' files; do
        echo $files >> $javascript
        done
    if [ -s $javascript ]; then
        result2=$(wc -l $javascript | cut -d " " -f 1)
        result+=($result2)
    else
        result+=(0)
    fi
    #css------------------------------------------------------------------------------------
    css=$(mktemp)
    find ~/CS1XA3 -iname "*.css" -type f -print0 | while IFS= read -d $'\0' files; do
        echo $files >> $css
        done
    if [ -s $css ]; then
        result3=$(wc -l $css | cut -d " " -f 1)
        result+=($result3)
    else
        result+=(0)
    fi
    #python------------------------------------------------------------------------------------
    python=$(mktemp)
    find ~/CS1XA3 -iname "*.py" -type f -print0 | while IFS= read -d $'\0' files; do
        echo $files >> $python
        done
    if [ -s $python ]; then
        result4=$(wc -l $python | cut -d " " -f 1)
        result+=($result4)
    else
        result+=(0)
    fi
    #haskell------------------------------------------------------------------------------------
    haskell=$(mktemp)
    find ~/CS1XA3 -iname "*.hs" -type f -print0 | while IFS= read -d $'\0' files; do
        echo $files >> $haskell
        done
    if [ -s $haskell ]; then
        result5=$(wc -l $haskell | cut -d " " -f 1)
        result+=($result5)
    else
        result+=(0)
    fi
    #bash------------------------------------------------------------------------------------
    bash=$(mktemp)
    find ~/CS1XA3 -iname "*.sh" -type f -print0 | while IFS= read -d $'\0' files; do
        echo $files >> $bash
        done
    if [ -s $bash ]; then
        result6=$(wc -l $bash | cut -d " " -f 1)
        result+=($result6)
    else
        result+=(0)
    fi
    #result------------------------------------------------------------------------------------
    echo "HTML: ${result[0]}, Javascript: ${result[1]}, CSS: ${result[2]}, Python: ${result[3]}, Haskell: ${result[4]}, Bash Script: ${result[5]}"




#4) Compile Error Log--------------------------------------------------------------------------------------------------------------------------------
elif [ $input = "4" ]; then
    #Create compile_fail.log; if exists already delete and create again
    if [ -f ~/CS1XA3/Project01/logs/compile_fail.log ]; then
        rm ~/CS1XA3/Project01/logs/compile_fail.log
        touch ~/CS1XA3/Project01/logs/compile_fail.log
    else
        touch ~/CS1XA3/Project01/logs/compile_fail.log
    fi

    #Find python files that failed to compile
    find ~/CS1XA3 -iname "*.py" -type f -print0 | while IFS= read -d $'\0' files; do
        python -m py_compile $files 2> /dev/null   #Ignore compile/error message
        if [ $? -ne 0 ]; then   #If there's no output from compile
            echo $files >> ~/CS1XA3/Project01/logs/compile_fail.log
        else
            rm $files"c"   #Else if compile succeeds, delete all .pyc files
        fi
        done


    #Find Haskell files that failed to compile
    find ~/CS1XA3 -iname "*.hs" -type f -print0 | while IFS= read -d $'\0' files; do
        ghc $files >/dev/null 2>/dev/null   #Ignore compile/error message
        if [ $? -ne 0 ]; then
            echo $files >> ~/CS1XA3/Project01/logs/compile_fail.log
        else
            name=$(echo $files | cut -f1 -d".")  #If compile succeeds, detele all compiled files
	    rm $name
            rm $name".hi"
            rm $name".o"
        fi
        done

#5) Delete Temporary Files----------------------------------------------------------------------------------------------------------------------
elif [ $input = "5" ]; then
    find $(git ls-files . --exclude-standard --others) -iname "*.tmp" -type f -print0 | while IFS= read -d $'\0' files; do
        rm $files
        done



#6) (Custom 1) chmod converter----------------------------------------------------------------------------------------------------------------------DONE
elif [ $input = "6" ]; then
    #Get user input
    printf "Path of the directory:"
    read dirPath
    printf "Extension:"
    read extension
    printf "Chmod:"
    read chmodNum
    for item in $extension; do
        find $dirPath -iname "*${item}" -type f -print0 | while IFS= read -d $'\0' files ; do
            chmod $chmodNum $files
            done
        done


#7) (Custom 2) chmod Friendly Reminder-------------------------------------------------------------------------------------------------------------
elif [ $input = "7" ]; then
    #Get user input
    printf "User:"
    read user
    printf "Group:"
    read group
    printf "Everyone else:"
    read everyoneElse
    #Create a dictionary for the possible chmod inputs
    declare -A chmods=( [rwx]=7 [rw_]=6 [r_x]=5 [r__]=4 [_wx]=3 [_w_]=2 [__x]=1 [___]=0 )
    echo "chmod = " ${chmods[$user]}${chmods[$group]}${chmods[$everyoneElse]}

fi
