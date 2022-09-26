#/bin/bash

languages="flutter dart cpp javascript html css bash"
core_utils="git xargs find fzf mv sed awk"
list=""

for element in $languages $core_utils
do
    if [[ -z $list ]]
    then
        list="$element"
    else
        list="$list\n$element"
    fi
done

selected=`echo $list | fzf`
read -p "query: " query
query=${query// /+}


if [[ $languages =~ $selected ]]
then
    curl cht.sh/$selected/$query | bat --paging=always
elif [[ $core_utils =~ $selected ]]
then
    curl cht.sh/$selected~$query | bat --paging=always
else
    echo "Error: Selected element is unknown!"
fi

