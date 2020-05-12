#!/bin/bash

clear

ROWGAP=5
COLGAP=15
ROWLINE1=1
ROWLINE2=6
ROWLINE3=11
ROWLINE4=16
ROWLINE5=21
COLLINE1=21
COLLINE2=36
COLLINE3=51
COLLINE4=66
COLLINE5=81

cursorRow=1
cursorCol=21
scroll=0
curLine=1
copyList=''
moveList=''

frame()
{
	tput cup 0 0
	echo ================================================================================================
	for(( i=1 ; i<=35 ; i++ ))
	do
		echo '|'
	
	done
	for(( i=1 ; i <=26 ; i++ ))
	do
		tput cup $i 20
		echo '|'
	done
	for(( i=1 ; i<=35 ; i++ ))
	do
		tput cup $i 95
		echo '|'
	done
	tput cup 27 1
	echo *****************************************information******************************************
	tput cup 34 1
	echo *****************************************information******************************************
	tput cup 36 0
	echo ================================================================================================
}

parentDir()
{	
	curPos=$PWD
	PDfileNum=2
	cd ..

	tput cup 1 1
	tput setaf 4
	echo ..

	for PDfileName in `ls -l | grep '^d' | awk '{print $9}' ; ls -l | grep '^-' | awk '{print $9}' ; ls -l | grep -v '^d' | grep -v '^-' | awk '{print $9}'`
	do
		if [ "$PDfileNum" -le 20 ]
		then
			tput cup $PDfileNum 1

			if [ "`stat -c "%A" $PDfileName | cut -b1`" = "d" ]
			then
				tput setaf 4
			elif [ "`stat -c "%A" $PDfileName | cut -b4`" = "x" ]
			then
				tput setaf 1
			elif [ "`stat -c "%A" $PDfileName | cut -b1`" = "-" ]
			then
				tput setaf 7
			else
				tput setaf 2
			fi
			echo $PDfileName | cut -c 1-10
			PDfileNum=`expr $PDfileNum + 1`
		fi	
	done

	cd $curPos
	tput setaf 7
}

dirInfo()
{
	tput cup 35 20
	echo "`ls | wc -l` total   `ls -l | grep '^d' | wc -l` dir   `ls -l | grep '^-' | wc -l` file   `ls -l | grep -v '^d' | grep -v '^-' | awk '{print $9}' | wc -w` sfile   `du -sb | cut -f1` byte"
}

fileInfo()
{
	selected=$1

	tput cup 28 20
	echo "file name : `stat -c %n $1`"
	tput cup 29 20
	if [ "`stat -c "%A" $1 | cut -b1`" = "d" ]
	then
		echo [34m"file type : `stat -c %F $1`"[0m
	elif [ "`stat -c "%A" $1 | cut -b4`" = "x" ]
	then
		echo [31m"file type : `stat -c %F $1`"[0m
	elif [ "`stat -c "%A" $1 | cut -b1`" = "-" ]
	then
		echo [0m"file type : `stat -c %F $1`"[0m
	else
		echo [32m"file type : `stat -c %F $1`"[0m
	fi
	tput cup 30 20
	echo "file size : `stat -c %s $1`"
	tput cup 31 20
	echo "modification time : `stat -c %y $1`"
	tput cup 32 20
	echo "permission : `stat -c %a $1`"
	tput cup 33 20
	echo "absolute path : `realpath $1`"
}

internUI()
{
	row=$1
	col=$2
	fileNum=1

	for fileName in `ls -l | grep '^d' | awk '{print $9}' ; ls -l | grep '^-' | awk '{print $9}' ; ls -l | grep -v '^d' | grep -v '^-' | awk '{print $9}'`
	do
		if [ $fileNum -ge `expr 0 + $scroll` ] && [ $fileNum -le `expr 24 + $scroll` ]
		then
			if [ "`stat -c "%A" $fileName | cut -b1`" = "d" ]
			then
				if [ $cursorRow -eq $row ] && [ $cursorCol -eq $col ]
				then
					fileInfo $fileName
					tput setaf 0
					tput setab 4
				else
					tput setaf 4
				fi
				tput cup $row $col
				echo '     __'
				tput cup `expr $row + 1` $col
				echo '/---/ |'
				tput cup `expr $row + 2` $col
				echo '|  d  |'
				tput cup `expr $row + 3` $col
				echo '-------'
				tput cup `expr $row + 4` $col
				echo $fileName | cut -c 1-10
			elif [ "`stat -c "%A" $fileName | cut -b4`" = "x" ]
			then
				if [ $cursorRow -eq $row ] && [ $cursorCol -eq $col ]
				then
					fileInfo $fileName
					tput setaf 0
					tput setab 1
				else
					tput setaf 1
				fi
				tput cup $row $col
				echo '_______'
				tput cup `expr $row + 1` $col
				echo '|     |'
				tput cup `expr $row + 2` $col
				echo '|  x  |'
				tput cup `expr $row + 3` $col
				echo '-------'
				tput cup `expr $row + 4` $col
				echo $fileName | cut -c 1-10
			elif [ "`stat -c "%A" $fileName | cut -b1`" = "-" ]
			then
				if [ $cursorRow -eq $row ] && [ $cursorCol -eq $col ]
				then
					fileInfo $fileName
					tput setaf 0
					tput setab 7
				else
					tput setaf 7
				fi
				tput cup $row $col
				echo '_______'
				tput cup `expr $row + 1` $col
				echo '|     |'
				tput cup `expr $row + 2` $col
				echo '|  o  |'
				tput cup `expr $row + 3` $col
				echo '-------'
				tput cup `expr $row + 4` $col
				echo $fileName | cut -c 1-10
			else
				if [ $cursorRow -eq $row ] && [ $cursorCol -eq $col ]
				then
					fileInfo $fileName
					tput setaf 0
					tput setab 2
				else
					tput setaf 2
				fi
				tput cup $row $col
				echo '_______'
				tput cup `expr $row + 1` $col
				echo '|     |'
				tput cup `expr $row + 2` $col
				echo '|  s  |'
				tput cup `expr $row + 3` $col
				echo '-------'
				tput cup `expr $row + 4` $col
				echo $fileName | cut -c 1-10

			fi
			col=`expr $col + $COLGAP`		
			if [ "$col" -gt $COLLINE5 ]
			then
					row=`expr $row + $ROWGAP`
					col=$COLLINE1
			fi
		fi
		fileNum=`expr $fileNum + 1`
		tput sgr0	
	done

	fileNum=`expr $fileNum - 1`
}

getLim()
{
	lastLine=`expr $fileNum / 5 + 1`
	lastFile=`expr $fileNum % 5 + 1`
	case "$lastFile"
	in
		1)rightLim=$COLLINE1;;
		2)rightLim=$COLLINE2;;
		3)rightLim=$COLLINE3;;
		4)rightLim=$COLLINE4;;
		5)rightLim=$COLLINE5;;
	esac
}

mainUI()
{
	if [ $cursorRow -eq $ROWLINE1 ] && [ $cursorCol -eq $COLLINE1 ]
	then
		fileInfo ..
		tput setaf 0
		tput setab 4
	else
		tput setaf 4
	fi
	tput cup 1 21
	echo '     __'
	tput cup 2 21
	echo '/---/ |'
	tput cup 3 21
	echo '|  d  |'
	tput cup 4 21
	echo '-------'
	tput cup 5 21
	echo '..'
	tput sgr0
	internUI $ROWLINE1 $COLLINE2
}

inputKey()
{
	while [ 1 ]
	do
		read -n 1 key
		if [ "$key" = '' ]
		then
			read -n 2 key
			if [ $key = '[A' ] && [ $curLine -gt 1 ]
			then
				clear
				curLine=`expr $curLine - 1`
				frame
				parentDir
				dirInfo
				if [ $cursorRow -eq $ROWLINE1 ]
				then
					scroll=`expr $scroll - 5`
					if [ $scroll -gt 0 ]
					then
						internUI $ROWLINE1 $COLLINE1
					else
						mainUI
					fi
				else
					cursorRow=`expr $cursorRow - $ROWGAP`
					if [ $scroll -gt 0 ]
					then
						internUI $ROWLINE1 $COLLINE1
					else
						mainUI
					fi
				fi
			elif [ $key = '[B' ] && [ $curLine -lt $lastLine ]
			then
				if [ $curLine -eq `expr $lastLine - 1` ]
				then
					if [ $cursorCol -le $rightLim ]
					then
						clear
						curLine=`expr $curLine + 1`
						frame
						parentDir
						dirInfo
						if [ $cursorRow -eq $ROWLINE5 ]
						then
							scroll=`expr $scroll + 5`
							internUI $ROWLINE1 $COLLINE1
						else
							cursorRow=`expr $cursorRow + $ROWGAP`
							if [ $scroll -gt 0 ]
							then
								internUI $ROWLINE1 $COLLINE1
							else
								mainUI
							fi
						fi
					fi
				else
					clear
					curLine=`expr $curLine + 1`
					frame
					parentDir
					dirInfo
					if [ $cursorRow -eq $ROWLINE5 ]
					then
						scroll=`expr $scroll + 5`
						internUI $ROWLINE1 $COLLINE1
					else
						cursorRow=`expr $cursorRow + $ROWGAP`
						if [ $scroll -gt 0 ]
						then
							internUI $ROWLINE1 $COLLINE1
						else
							mainUI
						fi
					fi
				fi
			elif [ $key = '[C' ] && [ $cursorCol -lt $COLLINE5 ]
			then
				if [ $curLine -eq $lastLine ]
				then
					if [ $cursorCol -lt $rightLim ]
					then
						clear
						cursorCol=`expr $cursorCol + $COLGAP`
						frame
						parentDir
						dirInfo
						if [ $scroll -gt 0 ]
						then
							internUI $ROWLINE1 $COLLINE1
						else
							mainUI
						fi
					fi
				else
					clear
					cursorCol=`expr $cursorCol + $COLGAP`
					frame
					parentDir
					dirInfo
					if [ $scroll -gt 0 ]
					then
						internUI $ROWLINE1 $COLLINE1
					else
						mainUI
					fi
				fi
			elif [ $key = '[D' ] && [ $cursorCol -gt $COLLINE1 ]
			then
				clear
				cursorCol=`expr $cursorCol - $COLGAP`
				frame
				parentDir
				dirInfo
				if [ $scroll -gt 0 ]
				then
					internUI $ROWLINE1 $COLLINE1
				else
					mainUI
				fi
			fi
		elif [ "$key" = '' ]
		then
			if [ "`stat -c "%A" $selected | cut -b1`" = "d" ]
			then
				clear
				cd $selected
				cursorRow=$ROWLINE1
				cursorCol=$COLLINE1
				curLine=1
				scroll=0
				frame
				parentDir
				dirInfo
				mainUI
				getLim
			elif [ "`stat -c "%A" $selected | cut -b4`" = "x" ]
			then
				echo -e "\n"
				./$selected
				clear
				frame
				parentDir
				dirInfo
				if [ $scroll -gt 0 ]
				then
					internUI $ROWLINE1 $COLLINE1
				else
					mainUI
				fi
				getLim
			fi
		elif [ "$key" = 'c' ]
		then
			copyList="$copyList `realpath $selected`"
		elif [ "$key" = 'p' ] && [ "$copyList" != '' ]
		then
			clear
			cp -R $copyList .
			frame
			parentDir
			dirInfo
			if [ $scroll -gt 0 ]
			then
				internUI $ROWLINE1 $COLLINE1
			else
				mainUI
			fi
			getLim
			copyList=''
		elif [ "$key" = 'm' ]
		then
			moveList="$moveList `realpath $selected`"
		elif [ "$key" = 'v' ] && [ "$moveList" != '' ]
		then
			clear
			mv $moveList .
			frame
			parentDir
			dirInfo
			if [ $scroll -gt 0 ]
			then
				internUI $ROWLINE1 $COLLINE1
			else
				mainUI
			fi
			getLim
			moveList=''
		else
			key=NULL
		fi
		tput cup 37 0
	done
}

frame
parentDir
dirInfo
mainUI
getLim
tput cup 37 0
inputKey
