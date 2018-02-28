#!/bin/bash

while ! curl --noproxy '*' -sSfL --max-time 3 http://graylog:9000/api/system/lbstatus >/dev/null 2>&1 ; do 
    echo 'Graylog not ready; waiting...'
    sleep 5
done

echo "Creating Input plain text TCP..."
curl --noproxy '*' -sSf -X POST -u admin:admin -H "Content-Type: application/json" http://graylog:9000/api/system/inputs -d '{
      "global": "true",
      "title": "Plain text TCP",
      "configuration": {
        "port": 5555,
        "bind_address": "0.0.0.0"
      },
      "type": "org.graylog2.inputs.raw.tcp.RawTCPInput"
}' > /dev/null
echo "Waiting for availability..."
while ! nc -z -w 1 graylog 5555 ; do 
    echo 'Input not ready; waiting...'
    sleep 5
done

echo "Input beats TCP..."
curl --noproxy '*' -sSf -X POST -u admin:admin -H "Content-Type: application/json" http://graylog:9000/api/system/inputs -d '{
      "global": "true",
      "title": "Beats TCP",
      "configuration": {
        "port": 5044,
        "bind_address": "0.0.0.0"
      },
      "type": "org.graylog.plugins.beats.BeatsInput"
}' > /dev/null
echo "Waiting for availability..."
while ! nc -z -w 1 graylog 5044 ; do 
    echo 'Input not ready; waiting...'
    sleep 5
done

echo "Input GELF TCP..."
curl --noproxy '*' -sSf -X POST -u admin:admin -H "Content-Type: application/json" http://graylog:9000/api/system/inputs -d '{
      "global": "true",
      "title": "Gelf TCP",
      "configuration": {
        "port": 12201,
        "bind_address": "0.0.0.0"
      },
      "type": "org.graylog2.inputs.gelf.tcp.GELFTCPInput"
}' > /dev/null
echo "Waiting for availability..."
while ! nc -z -w 1 graylog 12201 ; do 
    echo 'Input not ready; waiting...'
    sleep 5
done

echo "Input GELF UDP..."
curl --noproxy '*' -sSf -X POST -u admin:admin -H "Content-Type: application/json" http://graylog:9000/api/system/inputs -d '{
      "global": "true",
      "title": "Gelf UDP",
      "configuration": {
        "port": 12201,
        "bind_address": "0.0.0.0"
      },
      "type": "org.graylog2.inputs.gelf.udp.GELFUDPInput"
}' > /dev/null
echo "Waiting for availability..."
while ! nc -z -w 1 -u graylog 12201 ; do 
    echo 'Input not ready; waiting...'
    sleep 5
done

echo "Input Syslog TCP..."
curl --noproxy '*' -sSf -X POST -u admin:admin -H "Content-Type: application/json" http://graylog:9000/api/system/inputs -d '{
      "global": "true",
      "title": "Syslog TCP",
      "configuration": {
        "port": 8514,
        "bind_address": "0.0.0.0"
      },
      "type": "org.graylog2.inputs.syslog.tcp.SyslogTCPInput"
}' > /dev/null
echo "Waiting for availability..."
while ! nc -z -w 1 graylog 8514 ; do 
    echo 'Input not ready; waiting...'
    sleep 5
done

echo "Input Syslog UDP..."
curl --noproxy '*' -sSf -X POST -u admin:admin -H "Content-Type: application/json" http://graylog:9000/api/system/inputs -d '{
      "global": "true",
      "title": "Syslog UDP",
      "configuration": {
        "port": 8514,
        "bind_address": "0.0.0.0"
      },
      "type": "org.graylog2.inputs.syslog.udp.SyslogUDPInput"
}'  > /dev/null
echo "Waiting for availability..."
while ! nc -z -w 1 -u graylog 8514 ; do 
    echo 'Input not ready; waiting...'
    sleep 5
done


echo "Sending message to plain text TCP..."
echo 'First log message plain text TCP' | nc -w 1 graylog 5555

echo "Sending message to GELF TCP..."
echo -e '{"version": "1.1","host":"'$(hostname)'","message":"Short message GELF TCP","level": 5, "_user_id": 9001, "_some_info": "foo", "_some_env_var": "bar"}\0' | nc -w 1 graylog 12201

echo "Sending message to GELF UDP..."
echo -e '{"version": "1.1","host":"'$(hostname)'","message":"Short message GELF UDP","level": 5, "_user_id": 9001, "_some_info": "foo", "_some_env_var": "bar"}\0' | nc -w 1 -u graylog 12201

echo "Dismissing quickstart guide..."
curl --noproxy '*' -sSf -X POST -u admin:admin -H "Content-Type: application/json" http://graylog:9000/api/system/gettingstarted/dismiss -d '{}'  > /dev/null
