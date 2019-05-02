#!/bin/bash
docker run --network host -ti --rm --name mongoshell ${PROJECT}_mongo mongo 127.0.0.1:27017
