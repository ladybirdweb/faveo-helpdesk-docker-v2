#!/bin/bash
docker-compose down
docker-compose up -d
docker exec ${domainname}-apache bash -c "update-ca-certificates"