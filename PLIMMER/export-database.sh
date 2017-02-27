#!/bin/bash
#@AIM : Export database
#@AUTHORS : Benjamin PLIMMER
#@PARAMS : database name

configFile=dbBackup.conf
db=$1
date=$(date +"%d-%m-%Y")
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
if [[ -z $db ]]
then
  echo "No argument"
  echo "USAGE : $0 <Database name>"
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


#test if database exist
Result=`mysql -h $Ip -u $User -p$Password -P $Port --skip-column-names -e "SHOW DATABASES LIKE '$db'"`
if [ "$Result" == "$db" ]
then
    echo "Database exist"
else
    echo "$db does not exist or could not connect to server"
	exit 1
fi

#Create backup
if [ ! -d $backupPath ]
then
  mkdir -p $backupPath
fi

mysqldump -h $Ip -u $User -p$Password -P $Port $db > $backupFile
tar -zcvf $backupFile.tar.gz $backupFile
rm $backupFile

#encrypt file
#openssl enc -in $backupFile.tar.gz -aes-256-cbc  -pass stdin > $backupFile.tar.gz.enc

#rsync folder
#rsync -a $backupPath /target