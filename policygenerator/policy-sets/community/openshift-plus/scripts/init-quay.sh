#!/bin/sh

QUAYHOST=$(oc get route -n local-quay registry-quay -o jsonpath='{.spec.host}')
if [ $? -ne 0 ]; then
	echo "Quay route does not exist yet, please wait and try again."
	exit 1
fi

RESULT=$(oc get secret -n local-quay quayadmin)
if [ $? -eq 0 ]; then
	echo "Quay user configuration secret already exists: quayadmin in namespace local-quay"
	exit 1
fi

ADMINPASS=`head -c 8 /dev/urandom | base64 | sed 's/=//'`

RESULT=$(curl -X POST -k -s https://$QUAYHOST/api/v1/user/initialize --header 'Content-Type: application/json' --data "{ \"username\": \"quayadmin\", \"password\":\"${ADMINPASS}\", \"email\": \"quayadmin@example.com\", \"access_token\": true}")
echo "$RESULT" | grep -q "non-empty database"
if [ $? -eq 0 ]; then
	echo "Quay user configuration failed, the database has been initialized."
	exit 1
else
	cat <<EOF | kubectl create -f -
apiVersion: v1
kind: Secret
metadata:
  name: quayadmin
  namespace: local-quay
type: Opaque
data:
  password: $(echo ${ADMINPASS} | base64)
EOF
	TOKEN=$(echo "$RESULT" | jq .access_token | sed s'/"//g')
	# Uncomment the next line if you want the access token
	# echo "Access token for quay: $TOKEN"
	echo "Quay password successfully set for user quayadmin and stored in secret local-quay/quayadmin."
fi
