#!/bin/bash
#@AIM : import database
#@AUTHORS : Benjamin PLIMMER
#@PARAMS : <nom_base> <date_export>


configFile=dbBackup.conf
db=$1
date=$2
backupPath=$db
backupFile=$backupPath/$date.sql

#To specify backup path uncomment 
#backupPath="/home/$db/"
#backupFile=$backupPath$date.sql


#AIM : Echo config file syntax
#PARAMS : NONE
function confFileSyntax
{
echo -e "\n#$configFile configuration file syntax\nIp=<ip>\nPort=<Port>\nUser=<User>\nPassword=<Password>\n"
}

##Start script
#Check if argument is not null
if [[ -z $db ]] || [[ -z $date ]]
then
  echo "missing arguments"
  echo "USAGE : $0 <Database name> <date_export>"
  exit 1
fi

#check if file exist and if correct syntax
if [ -f $configFile ]
then
	#get variables from the configuration file
	source dbBackup.conf
	
	#check if variables were find
	if [[ -z $Ip ]] || [[ -z $Port ]] || [[ -z $User ]]|| [[ -z $Password ]]
	then
		echo "incorrect syntax $configFile"
		confFileSyntax
		exit 1
	fi
else
   echo "$configFile : file does not exist"
   echo "Please create $configFile file"
   confFileSyntax
   exit 1
fi

#check date syntax
if ! [[ $date =~ ^[0-3][0-9]-[0-1][0-9]-[0-9][0-9][0-9][0-9]$ ]]
then
	echo $Regex
	echo "Incorrect date ($date) syntax : <dd-mm-yyyy>"
	echo "example : 20-07-1969"
	exit 1
fi

#test connection to server
Result=`mysql -h $Ip -u $User -p$Password -P $Port --skip-column-names -e ""`
if [ "$Result" == "" ]
then
    echo "connection server"
else
    echo "Could not connect to server"
	exit 1
fi

#Check if backup file exists
if [ ! -f $backupFile.tar.gz ]
then
  echo "Backup does not exist"
  exit 1
fi

#decrypt file
#openssl enc -in $backupFile.tar.gz.enc -d -aes-256-cbc  -pass stdin > $backupFile.tar.gz

tar -xvzf $backupFile.tar.gz
mysql -h $Ip -u $User -p$Password -P $Port $db < $backupFile
rm $backupFile



