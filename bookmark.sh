#!/bin/bash
# author: zcx
username=`whoami`
platform=`uname -a`
read_timeout=5
retry_times=3
script_path=scripts/bookmark


function __exit(){
    kill -SIGINT $$
}


function __help {
	if [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ] ; then
		echo ''
		echo 'b  - Bookmark list'
		echo 'a  - Add the current directory to bookmark'
		echo 't <bookmark_index>  - Goes (cd) to the directory associated with "bookmark_index"'
		echo 'r <bookmark_index> ...  - Deletes the bookmark with index'
		echo 'c  - Deletes all bookmark'
		echo -e "\n"
		__exit
	fi
}


function __get_user_dir(){
    result=$(echo ${platform} | grep "Darwin")
    if [[ "$result" != "" ]];then
         user_dir=/Users/${username}
    else
         if [[ "${username}" == "root" ]];then
             user_dir=/root
         else
             user_dir=/home/${username}
         fi
    fi
}


function __get_db(){
    __get_user_dir
    if [[ ! -d "${user_dir}/${script_path}" ]];then
        mkdir -p ${user_dir}/${script_path}
    fi
    db=${user_dir}/${script_path}/.bk.db
    if [ ! -f "${db}" ];then
        echo ${user_dir} >>  ${db}
    fi
}


function __get_bookmarks(){
   __get_db
   targets=(`cat ${db}`)
}


function data_init(){
    __help $1
    __get_bookmarks
}


function b(){
    data_init $1
    echo -e "Welcome to your bookmark:"
    echo -e  "----------------------------------------------------------------\n"
    bookmark_num=${#targets[@]}
    if [ ${bookmark_num} -eq 0 ];then
        echo -e "\t\t\033[31mNo bookmark, please add a bookmark.\033[0m\n"
    else
        ix=1
        for target in ${targets[@]};
        do
          echo -e  "\033[46;30m   $ix   \033[0m: $target\n"
          ((ix++))
        done
    fi
    echo -e "-----------------------------------------------------------------\n"
}


function t(){
     data_init $1
     if [[ "${result}" != "" ]];then
        target=${targets[$1]}
     else
        target=${targets[$1-1]}
     fi
     if [ -n "${target}" ];then
         echo "target: ${target}"
         cd ${target}
     else
         echo "This bookmark not exists, please retry."
     fi
}


function a(){
    data_init $1
    for target in ${targets[@]}
    do
        if [[ "${target}" == "${PWD}" ]];then
           echo "This bookmark is exists."
           __exit
        fi
    done
    echo ${PWD} >> ${db} && echo -e "add a new bookmark: ${PWD}"
}


function r(){
     data_init $1
     targets_len=${#targets[@]}
     last_ix=0
     del_num=0
     for ix in "$@"
     do
        _ix=${ix}
        if [ "${ix}" -gt 0 ] 2>/dev/null;then
            if [ ${ix} -gt ${last_ix} ];then
                ((ix=${ix}-${del_num}))
                if [ ${ix} -gt ${targets_len} ];then
                    echo -e "This bookmark index ${_ix} is out of range."
                    continue
                fi
            fi
            del_bookmark=`sed -n ''${ix}'p' ${db}`
            echo -e "delete a bookmark: ${del_bookmark}"
            sed -i '' "${ix}d" ${db}
            last_ix=${ix}
            ((del_num++))
            ((targets_len--))
        else
            echo -e "Each index must be a number, but ${ix} is not."
        fi
     done
}


function c(){
    data_init $1
    ix=1
    while true
    do
        if [[ ${ix} -gt ${retry_times} ]];then
            echo -e "More than ${retry_times} retries, bye bye."
            __exit
        fi
        ((ix++))
        echo -e "Delete all bookmark, are you sure？(y/n):"
        read -t ${read_timeout} confirm
        if [ $? -eq 1 ];then
            __exit
        fi
        if [[ "${confirm}" == "y" ]];then
           : > ${db} && echo -e "Delete all bookmark successfully." && break
        elif [[ "${confirm}" == "n" ]];then
            break
        else
            continue
        fi
    done
}
