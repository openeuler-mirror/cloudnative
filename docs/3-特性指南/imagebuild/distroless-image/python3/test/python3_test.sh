#!/bin/bash

BASEIMAGE="$1"

cat > dockerfile << EOF
FROM ${BASEIMAGE}
copy . /app
workdir /app
CMD ["/usr/bin/python3","test.py"]
EOF

docker build -f dockerfile . -t valid:python

docker run valid:python

if [ $? != 0 ]; then
    echo "failed"
	exit 1
else
	echo "success"
fi

rm -f dockerfile