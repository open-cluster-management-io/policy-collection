#!/bin/sh

QUAYHOST=$(oc get route -n local-quay registry-quay -o jsonpath='{.spec.host}')
if [ $? -ne 0 ]; then
	echo "Quay route does not exist yet, please wait and try again."
	exit 1
fi
RESULT=$(curl -X POST -k -s https://$QUAYHOST/api/v1/user/initialize --header 'Content-Type: application/json' --data '{ "username": "quayadmin", "password":"quaypass123", "email": "quayadmin@example.com", "access_token": true}')
if [ $? -eq 0 ]; then
	TOKEN=$(echo "$RESULT" | jq .access_token | sed s'/"//g')
	# Uncomment the next line if you want the access token
	# echo "Access token for quay: $TOKEN"
	echo "Quay password successfully set for user quayadmin."
else
	echo "Quay user configuration failed"
	exit 1
fi
