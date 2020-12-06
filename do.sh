#! /bin/bash

function require_root() {
	if [ $(id -u) -eq 0 ]; then
		return 0
	else
		echo "Please run me as root."
		exit 1
	fi
}

function is_running() {
	id=$(docker ps -f name=minidlna -f status=running --format "{{.ID}}")
	if [[ $id ]]; then 
		return 0
	else
		return 1
	fi
}

function container_exists() {
	id=$(docker container ls -a -f name=minidlna --format "{{.ID}}")
	if [[ $id ]]; then
		return 0
	else
		return 1
	fi
}

function image_exists() {
	id=$(docker images minidlna --format "{{.ID}}")
	if [[ $id ]]; then
		return 0
	else
		return 1
	fi
}

function do_run() {
	echo "Use Systemd with Docker Compose instead. See README file."
	exit 0
}

function do_update() {
	require_root
	is_running && systemctl stop docker-compose@minidlna
	container_exists && docker rm minidlna

	if image_exists; then docker rmi minidlna; fi
	if image_exists; then
		echo "Failed to rm existing image, please fix and re-run."
		return 1
	fi

	docker build -t minidlna --no-cache .
	if image_exists; then
		echo "Image updated successfully."
	else 
		echo "Failed to build image."
		return 1
	fi
}

function do_build() {
	require_root
	if image_exists; then
		echo "Image exists already. Run $0 update if you want to update the existing build."
		return 0
	fi
	docker build -t minidlna .
	return $?
}

function usage() {
	echo "$0 [COMMAND]"
	echo
	echo "Commands:"
	echo "		build 	: build the Docker image"
	echo "		run	: run a container named minidlna using the image"
	echo "		update	: clean existing containers and update existing image with latest binaries"
}


if [ "$1" == "run" ]; then do_run; exit $?;
elif [ "$1" == "build" ]; then do_build; exit $?;
elif [ "$1" == "update" ]; then do_update; exit $?;
else usage
fi

exit 0