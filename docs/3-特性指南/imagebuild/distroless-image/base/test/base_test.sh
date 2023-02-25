#!/bin/bash

BASEIMAGE="$1"

cat > dockerfile << EOF
FROM golang:1.18 as build

WORKDIR /go/src/app
COPY . .

RUN CGO_ENABLED=1 go build -o /go/bin/app test.go

FROM ${BASEIMAGE}

COPY --from=build /go/bin/app /
ENTRYPOINT ["./app"]
EOF

docker build -f dockerfile . -t valid:base

docker run valid:base

if [ $? != 0 ]; then
    echo "failed"
	exit 1
else
	echo "success"
fi

rm -f dockerfile