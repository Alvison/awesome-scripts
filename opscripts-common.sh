#!/bin/bash

print_column (){
    echo -e $1 |awk -F'\t' '{printf "%-15s%s\n",$1,$2}'
}

print_title (){
    length=`echo "$1" |wc -c`
    prefix_count=$(((30-length)/2))
    for i in `seq 0 $prefix_count` ;do
	   echo -n '='
    done
    echo -n " $1 "
    postfix_count=$((length % 2 != 0 ? prefix_count+1: prefix_count))
    for i in `seq 0 $postfix_count` ;do
	   echo -n '='
    done
    printf '\r\n'
}

find_command(){
	commands=`ls -l $1/bin |grep -v '^d' |awk '{print $9}'`
	if [ "$commands" = "" ]; then
		continue;
	fi

	for file in $commands ;do
    	desp=`grep '^## ' $1/bin/$file | cut -c 3-`
    	if [ "$desp" != ""  ]; then
			print_column "$file\t:$desp"
			echo "$file" >> $HOME/.opscripts/cmds.cache
    	fi
	done
	echo ''
}

list_command() {
    rm -f $HOME/.opscripts/cmds.cache 2>/dev/null
    mkdir $HOME/.opscripts 2>/dev/null
    echo 'Available commands:'
    print_title bin
    find_command $OPSCRIPTS_DIR
    
    print_title java/bin
    find_command $OPSCRIPTS_DIR/java
    exit 0;
}

uninstall() {
    echo -n "Uninstall opscripts,(y)es or (n)o?"
    read choice < /dev/tty
    if [ "$choice" = "y" ] && [ "$OPSCRIPTS_DIR" != "/" ];then
        cd $OPSCRIPTS_DIR && make uninstall && rm -rf $OPSCRIPTS_DIR && echo "opscripts uninstall finished. Bye~"
    fi
    exit 0
}
