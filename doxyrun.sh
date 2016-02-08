#!/bin/bash
DOXYGEN=doxygen
CONFIG_FILE=single
FILE=$1
echo "INPUT=$FILE" > $CONFIG_FILE
echo "GENERATE_XML=YES" >> $CONFIG_FILE
echo "GENERATE_HTML=NO" >> $CONFIG_FILE
echo "GENERATE_LATEX=NO" >> $CONFIG_FILE
echo "GENERATE_MAN=NO" >> $CONFIG_FILE
echo "GENERATE_RTF=NO" >> $CONFIG_FILE
echo "RECURSIVE=YES" >> $CONFIG_FILE
echo "EXCLUDE= $FILE/tests \\" >> $CONFIG_FILE
echo "         $FILE/slre.c \\" >> $CONFIG_FILE
echo "         $FILE/include \\" >> $CONFIG_FILE
echo "         $FILE/build \\" >> $CONFIG_FILE
echo "         $FILE/slre.h" >> $CONFIG_FILE
$DOXYGEN $CONFIG_FILE