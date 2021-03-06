#!/bin/sh
pid=0

# SIGTERM-handler
term_handler() {
  if [ $pid -ne 0 ]; then
    echo ""
    echo ">>> Shutting down zookeeper $ID ..."
    bin/zkServer.sh stop $ZOOCFG
    wait "$pid"
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

echo ">>> Configurando $ZOOCFG..."
qtde_found=$(cat $ZOOCFG | grep -c "server.$ID")

if [ $qtde_found -eq 0 ]; then
   #string not contained in file
   #echo "server.$ID=$(ip route | awk '/link/ { print $7 }'):2888:3888" >> $ZOOCFG
   echo "$ID" > $ZOOKEEPER_DATA/myid
else
   #string is in file at least once
   #sed -i "s/server.$ID=zookeeper$ID/server.$ID=$(ip route | awk '/link/ { print $7 }')/g" $ZOOCFG
   echo "$ID" > $ZOOKEEPER_DATA/myid   
fi

sleep 5
#echo ">>> Starting zookeeper $ID ..."
#bin/zkServer.sh start $ZOOCFG & 
#pid="$!"

#trap 'term_handler' SIGHUP SIGINT SIGTERM

#sleep 5
#tail -f $ZOO_LOG_DIR/zookeeper*.out & wait

while true; do 

  echo ">>> Trying to start zookeeper $ID ..."
  bin/zkServer.sh start $ZOOCFG & 
  pid="$!"

  if [ -z "$pid" ]
  then
        echo ">>> Waiting for another zookeeper instances!"
        sleep 15
        #trap 'term_handler' SIGHUP SIGINT SIGTERM
  else
        echo ">>> Zookeeper $ID started!"
        break
  fi

done

sleep 5
tail -f $ZOO_LOG_DIR/zookeeper*.out & wait






