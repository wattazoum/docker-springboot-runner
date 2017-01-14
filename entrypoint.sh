#!/bin/sh
set -e

# In case the user wants only to use java with options
if [ $# -gt 0 ]
then
    exec java $@
    exit 0
fi

# Behavior when using the /app folder
#
# In the setenv.sh file you may define the following environment
# variables
#
# JAVA_OPTS : a string containing the list of java options to 
#             pass to the java command.
#             eg. JAVA_OPTS="-Xmx1g -Dfile.encoding=utf8"
# APP_ARGS

SETENV_FILE=/app/setenv.sh

if [ -r $SETENV_FILE ]
then
    source $SETENV_FILE
fi


TMP_JARS_LIST=/tmp/jars_list 

find /app -maxdepth 1 -name '*.jar' > $TMP_JARS_LIST
nb_jars=$(cat $TMP_JARS_LIST | wc -l)
if [ $nb_jars -gt 1 ]
then
    echo 'ERROR: You may only have one jar in the /app folder'
    echo '==================================================='
    cat $TMP_JARS_LIST
    exit 1
elif [ $nb_jars -eq 0 ]
then
    echo 'ERROR: There should be one and only one jar in the /app folder'
    echo '=============================================================='
    exit 1
else 
    CMD="java $JAVA_OPTS -jar $(cat $TMP_JARS_LIST) $APP_ARGS"
    echo "Launching the following command:"
    echo "  |"
    echo '  `->  '"$CMD"
    echo 
    exec $CMD
fi

exit 0

