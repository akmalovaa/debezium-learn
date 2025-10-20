#!/bin/bash
CONNECTOR_URL="http://YOUR_IP:8083"  # Replace YOUR_IP with the actual IP address

### Start Debezium connector
echo "Waiting for Debezium Connect to be ready..."
MAX_ATTEMPTS=30
ATTEMPT=0
while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  if curl -s $CONNECTOR_URL > /dev/null 2>&1; then
    echo "Debezium Connect is ready!"
    break
  fi
  ATTEMPT=$((ATTEMPT+1))
  echo "Attempt $ATTEMPT/$MAX_ATTEMPTS - waiting..."
  sleep 1
done
if [ $ATTEMPT -eq $MAX_ATTEMPTS ]; then
  echo "Debezium Connect did not become ready in time"
  exit 1
fi
echo "Registering Debezium connector..."
curl -i -X POST -H "Content-Type: application/json" --data @debezium-connector.json $CONNECTOR_URL/connectors
echo ""
echo "Connector registered!"
