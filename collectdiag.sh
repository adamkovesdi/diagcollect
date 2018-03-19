#!/bin/bash
# Log collector by Adam Kovesdi 2018
# Edit commands and variables here

LOGFILE="/tmp/logs_`hostname -s`.log"
TARBALL="/tmp/logs_`hostname -s`.tar.gz"

##################################################

COMMANDS="hostname
ifconfig -a
w
last -10
uname -a
tail -50 /var/log/syslog"

##################################################
# do not edit beyond this line 
##################################################

cleanup() {
  rm -f $LOGFILE 2> /dev/null
  rm -f $TARBALL 2> /dev/null
}

banner() {
  echo "###########################################################################"
  echo "####                    Collecting Host data diag.                     ####"
  echo "#### (script might take a few minutes depending on your configuration) ####"
  echo "###########################################################################"
}

recorddate() {
  echo "" >> $LOGFILE
  echo "###################" >> $LOGFILE
  echo "#### Timestamp ####" >> $LOGFILE
  echo "###################" >> $LOGFILE
  echo "Hostname: `hostname -s`" >> $LOGFILE
  date >> $LOGFILE
  echo "" >> $LOGFILE
  echo "" >> $LOGFILE
  echo "" >> $LOGFILE
}

log() {
  echo -n "[ $count of $nr_tests] $1 ..."
  echo "#### $count) $1 ####" >> $LOGFILE
  echo "" >> $LOGFILE
  $1 >> $LOGFILE 2>&1
  echo "" >> $LOGFILE
  echo "" >> $LOGFILE
  echo "" >> $LOGFILE
  echo " DONE"
  let "count=count+1"
}

compresstarball() {
  #echo "Collecting additional log files ..."
  #tar -czvf $TARBALL $LOGFILE /var/log/syslog
  echo " DONE"
  echo ""
  #echo "All log files contained in $TARBALL"
  echo "All logs have been saved in this log file: $LOGFILE"
}

docommands() {
  count=1
  nr_tests=0
  while read -r line; do
    let "nr_tests=nr_tests+1"
  done <<< "$COMMANDS"
  echo "$(date)"
  echo "Hostname: $(hostname -s)" 
  echo Number of tests to run: $nr_tests
  while read -r line; do
    log "$line"
  done <<< "$COMMANDS"
}

banner
cleanup
recorddate
docommands
recorddate
