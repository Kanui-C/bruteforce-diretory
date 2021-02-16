#!/bin/bash
# DESENVOLVEDOR: Daniel Kanui
# FUNÇAO: ENCONTRAR DIRETORIOS
# DATA: DOMINGO 2 DE AGOSTO 19:41
# Uso: ./PROG www.teste.com /usr/share/dirb/wordlists/common.txt
wordlist="$2"
#VARIAVEIS RESPONSAVEIS POR CORES
limpar="\r\033[K"
ROSA='\033[01;35m'
RED='\033[01;31m'
AMARELO='\033[01;33m'
BRANCO='\033[01;37m'
VERDE='\033[01;32m'
NEGRITO='\033[1m'
CIANO='\033[01;36m'
PRETO='\033[01;30m'
function norton(){


echo -e "${ROSA}
         █████╗ ██╗   ██╗██╗   ██╗███╗   ███╗██╗
        ██╔══██╗╚██╗ ██╔╝██║   ██║████╗ ████║██║
        ███████║ ╚████╔╝ ██║   ██║██╔████╔██║██║
        ██╔══██║  ╚██╔╝  ██║   ██║██║╚██╔╝██║██║
        ██║  ██║   ██║   ╚██████╔╝██║ ╚═╝ ██║██║
        ╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝╚═╝
${CIANO}"
}




function warning(){
	echo -e "${NEGRITO}Utilize:"
	echo -e "	${VERDE}$0 <domínio> <wordlist>${NEGRITO}"
	echo -e ""
	echo -e "	exemplos de domínio:	${BRANCO}google.com, globo.com, bing.com${NEGRITO}"
	echo -e "	wordlist sugerida:	${VERDE}lista.txt /usr/share/dirb/wordlists/common.txt${BRANCO}"
	echo -e ""
		exit 1
}

if [[ "$USER" != "root" ]]; then
    echo -e "${RED}É NECESSARIO EXECUTAR COMO ROOT!${RED}"
    exit
fi
if [[ "$#" != "2" ]]; then
	echo ""
	echo -e "${RED}Numero de argumentos incorreto.${BRANCO}"
		warning
elif [[ "$(host $1 | grep 'has address')" == "" ]]; then
	echo ""
	echo -e "${RED}Domínio '$alvo' não encontrado.${BRANCO}"
		warning
elif [[ ! -f "$2" ]]; then
	echo ""
	echo -e "${RED}Arquvio de wordlist '$wl' não encontrado.${BRANCO}"
		warning
fi
norton
#len=$(wc -l $2 | cut -d' ' -f1)
#echo -e "$size"
server=$(curl -s --head $1 | grep ""Server"")
date=$(date | sed 's/.\{16\}//' | sed 's/ .*//g')
host=$(host $1 | grep 'has address' |sed 's/[a-z]\+//g' | sed 's/.\{3\}//');
echo -e "${NEGRITO}Aguarde...${BRANCO}"
sudo nmap -sC -sV -O -A -Pn $host > Resultados.txt
echo -e "${NEGRITO}Resultados Do Nmap Enviado Para Resultados.txt${RED}"
echo -e "${NEGRITO}Inicio: $date${BRANCO}"
echo -e "${AMARELO}HOST:$1${BRANCO}"
echo -e "${ROSA}The ip is:$host${BRANCO}"
echo -e "\033[01;36mThe WebServer is: $server""\033[01;37m"
echo -e "\033[01;31m--------------------------------------\033[01;37m"
echo -e "\033[01;32mBuscando Por Diretorios e Arquivos\033[01;32m"
echo -e "\033[01;31m--------------------------------------\033[01;37m"
for palavra in $(cat $wordlist); do
		echo "Testando: $1/$palavra                               " | tr '\n' '\r'
		resposta=$(curl -s -o /dev/null -w "%{http_code}" $1/$palavra)
		if [ $resposta -ne "404" ] #&& [ $resposta -ne "301" ]
		then
		#if [ $resposta == "200" ]
		#	then
		#	echo -e "${RED}[!]${BRANCO}[Ayumi encontrou]:${AMERELO}$1/$palavra${BRANCO} ${RED}[code:$resposta]{BRANCO}"
		#	continue
		#fi
		echo -e "${RED}[!]${BRANCO}[Ayumi encontrou]:${AMARELO}$1/$palavra${BRANCO} ${VERDE}[code:$resposta]${BRANCO}"
		
		fi
done
echo -e "${NEGRITO}Final: $date${BRANCO}"
