#!/bin/bash
# test
DATE=`date '+%Y-%m-%d %H:%M:%S'`

function fc_log {
	echo "$DATE -> $1"
	echo "$DATE -> $1" >> ./app/logs/error_script_start.log
}

function check_parameter {
	case $1 in 
		install)
			install
			;;
		start)
			start
			;;
		*)
			fc_log "SCRIPT FAILED : Unknow parameter $1"
			;;
		esac
}

function install {
	fc_log "SCRIPT STATUS : Launch 'composer install'"
	composer install
	fc_log "SCRIPT STATUS : Launch 'docker-compose build'"
	docker-compose build
	start
}

function start {
	fc_log "SCRIPT STATUS : Launch server"
	docker-compose up -d
	fc_log "SCRIPT STATUS : Clearing cache"
	php app/console cache:clear 
	fc_log "SCRIPT STATUS : Clearing cache : env prod"
	php app/console cache:clear --env prod
	fc_log "SCRIPT STATUS : Success"

	echo "Well done ! Now, let's go on the website !"
	echo "NOTICE : Wait few seconds if you are an error at the beginning..."
}

fc_log "SCRIPT START"

if [[ $# -eq 0 ]] ; then
	fc_log "SCRIPT FAILED : Missing parameter"
	echo "start.sh help"
	echo "install - install your environnement and launch the server"
	echo "start - Launch the server"
else
	check_parameter $1
fi
