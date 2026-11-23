#!/usr/bin/env bash
set -e
docker build -t se-static:q11 .
docker run --rm -d --name se-static-q11 -p 8080:80 se-static:q11
curl -fsS http://localhost:8080
