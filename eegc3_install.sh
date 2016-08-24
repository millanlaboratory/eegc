#!/bin/bash

function help {
	printf "NAME:\n"
	printf "eegc3_install - Installation script for eegc3 (cnbitk)\n" 
	printf "\n"
	printf "SYNOPSIS:\n"
	printf " ./eegc3_install [-t TARGETDIR]\n"
	printf "\n"
	printf "OPTIONS:\n"
	printf " -t TARGETDIR	Target directory where eegc3 is going to be installed.\n"
	printf " 		Default value: /opt/eegc3/\n"	
	printf " -h 		Display help and exit\n"
	printf "\n"
	printf "EXIT VALUES:\n"
	printf " 0 	Success\n"
	printf " 1	Input argument error\n"
	printf " 2 	Installation error (rsync)\n"
	printf "\n"
	
}

SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DSTDIR=/opt/eegc3/

## Get optional argument
while getopts ":t:" opt; do
  case $opt in
    t)
      DSTDIR=$OPTARG
      ;;
    \?)
      help
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      help
      exit 1
      ;;
  esac
done

echo "[eegc3_install] - Source directory:" $SRCDIR
echo "[eegc3_install] - Destination directory:" $DSTDIR

printf "[eegc3_install] - Installing eegc3..."
rsync -a --delete $SRCDIR/ $DSTDIR --exclude ".git" --exclude "debian" --exclude "eegc3_install.sh" --exclude "Makefile" --exclude "AUTHORS" --exclude "README" 2>/dev/null
if [[ $? -gt 0 ]]
then
	printf "Failure. Run the script with sudo privilegies if the destination folder is protected\n"
	exit 1
else
	printf "Done!\n"
fi

printf "[eegc3_install] - Remember to export the environment variable EEGC3_ROOT:\n"
printf "                  $ export EEGC3_ROOT=%s\n" $DSTDIR

exit 0
