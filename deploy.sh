######
# Some custom commands for Control docker containers
# 
#    startctr <container_name>          // start container only
#    startctr <container_name> -sh      // start container and also start bash shell
#    stopctr <container_name>           // stop container 
#
######

startctr() {

    if [ -z "$1" ]
    then
        echo -e "\n\tUsage : startctr <container_name> [OPTION]\n"
        echo -e "OPTION: '-sh' start bash shell\n"
        echo "[*] To start docker only use : "
        echo -e "   $ startctr <container_name>\n"
        echo "[*] To start docker with bash shell/OR shell on running container : "
        echo -e "   $ startctr <container_name> -sh\n"
        return
    fi

    # Check container exists or not
    flag=true
    rdkr=(`docker ps -a --format '{{.Names}}'`)
    for var in "${rdkr[@]}"
    do
        if [ $1 == $var ]
        then
            flag=false
            break
        fi
    done
    if $flag
    then
        echo -e "\e[31m[!] ERROR: Container named \"$1\" does not Exists.\e[0m"
        echo -e "\e[31m[!] Please Check the Name Again.\e[0m"
        echo "Available Containers are : "
        echo "========================"
        for var in "${rdkr[@]}"
        do
            echo $var
        done
        echo "========================"
        return
    fi

    # check if container is currently running or not
    flag=false
    rdkr=(`docker ps --format '{{.Names}}'`)
    for var in "${rdkr[@]}"
    do
        if [ $1 == $var ]
        then
            flag=true
            break
        fi
    done

    if $flag
    then
        echo "Container \"$1\" is already running."
    else
        docker container start $1
        echo -e "\e[32m[+] SUCCESS: Container started Successfully.\e[0m"
    fi

    if [ -z $2 ]
    then
        return
    elif [ "$2" == "-sh" ]
    then
        docker container exec -it $1 bash
    fi
}

# code for stopctr
stopctr() {
    if [ -z "$1" ]
    then
        echo -e "\n\tUsage : stopctr <container_name> [OPTION]\n"
		echo -e "OPTION:- \n"
		echo -e "[*] '-l' list currently running containers"
		echo -e "[*] '-all' stop all running containers"
		return
    fi

	# Check container is currently running or not
	flag=false
	rdkr=(`docker ps --format '{{.Names}}'`)

	if [ "$1" == "-l" ]
	then
		# code for list all running containers
		if [ ${#rdkr} -gt 0 ]
		then
			echo "Currently runnig Containers are : "
			echo "========================"
			for x in "${rdkr[@]}"
			do
				echo "$x"
			done
			echo "========================"
		else
			echo -e "\e[31m[!] Theres no running container at the moment.\e[0m"
		fi
		return
	elif [ "$1" == "-all" ]
	then
		# code to stop all running containers
		if [ ${#rdkr} -gt 0 ]
		then
			for x in "${rdkr[@]}"
			do
        		docker container stop $x 1> /dev/null
        		echo -e "\e[32m[+] ${x} \t: stopped Successfully.\e[0m"
			done
		else
			echo -e "\e[31m[!] Theres no running container at the moment.\e[0m"
		fi
		return
	fi

    for var in "${rdkr[@]}"
    do
        if [ $1 == $var ]
        then
            flag=true
            break
        fi
    done

    if $flag
    then
        docker container stop $1
        echo -e "\e[32m[+] SUCCESS: Container stopped Successfully.\e[0m"
    else
        echo -e "\e[31m[!] ERROR: Theres no running container named \"$1\".\e[0m"

	fi
}
