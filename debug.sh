#!/bin/bash 

C=0
for A in "$@"
do
	C=$(( $C + 1 ))
	echo "ARG${C}[${A}]"
done

echo "ARGS-END"
echo ""
echo ""
echo "SDTIN["
cat
echo "] END"
