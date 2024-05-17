#!/bin/bash

# Generate hashings
RANDOM_DATA=$(openssl rand -hex 16)
PROOF=$(echo -n "$RANDOM_DATA" | sha256sum | awk '{print $1}')
#PUBLIC_PROOF=$(echo -n "$PROOF" | sha256sum | awk '{print $1}')
HEX_DIGITS=$(echo "$PROOF" | tr -cd '[:xdigit:]')
HEX_SUM=1
# Loop through each hexadecimal digit and sum them up
for ((i = 0; i < ${#HEX_DIGITS}; i += 2)); do
    # Extract two characters at a time
    HEX_PAIR=${HEX_DIGITS:$i:2}
    # Convert the hexadecimal pair to decimal and add it to the sum
    DECIMAL=$((16#$HEX_PAIR))
    HEX_SUM=$((HEX_SUM * (DECIMAL + 1)))
done

# Define the port to listen on
PORT=8080

# Create a temporary file for the handle_request script
HANDLE_REQUESTS=$(mktemp /tmp/handle_request.XXXXXX)

echo "$HEX_SUM" > /tmp/hexSum

# Write the handle_request function to the temporary file
cat << 'EOF' > "$HANDLE_REQUESTS"
#!/bin/bash

# Read the request from stdin
read -r REQUEST

# Parse the request (we only care about GET requests)
if [[ $REQUEST =~ ^GET ]]; then
    # Generate a simple HTTP response with a 200 OK status and some HTML content
    RESPONSE="HTTP/1.1 200 OK\r\n"
    RESPONSE+="Content-Type: text/plain\r\n"
    RESPONSE+="Connection: close\r\n"
    RESPONSE+="\r\n"
    RESPONSE+="$(cat /tmp/hexSum)"

    # Send the response
    echo -en "$RESPONSE"
else
    # Respond with a 400 Bad Request for any non-GET requests
    RESPONSE="HTTP/1.1 400 Bad Request\r\n"
    RESPONSE+="Content-Type: text/plain\r\n"
    RESPONSE+="Connection: close\r\n"
    RESPONSE+="\r\n"
    RESPONSE+="bad"

    # Send the response
    echo -en "$RESPONSE"
fi
EOF

# Make the temporary script executable
chmod +x "$HANDLE_REQUESTS"

echo "https://airtable.com/apppJsMZ2MAT6iLkN/shr8pabyEDG9vBryN?prefill_Proof=$PROOF" > /tmp/claim

# Generate form
EXTERNAL_IP=$(curl -s ifconfig.me/ip)
echo "https://airtable.com/apppJsMZ2MAT6iLkN/shrMGGBajfUIdGjJe?prefill_URL=$EXTERNAL_IP:$PORT&prefill_HexSum=$HEX_SUM&prefill_Proof=$PROOF"

# Use socat to listen on the specified port and handle requests
socat TCP-LISTEN:"$PORT",reuseaddr,fork EXEC:"$HANDLE_REQUESTS"

# Clean up the temporary script on exit
trap "rm -f $HANDLE_REQUESTS" EXIT
