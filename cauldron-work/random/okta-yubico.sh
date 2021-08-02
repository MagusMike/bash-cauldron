#!/bin/bash/

curl -v -X GET \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS 00KxQ3o5t0dIBunfWr-968IkoPyAN6WRKhIDkUI0gw" \
"https://wellframe.okta.com/api/v1/org/factors/yubikey_token/tokens"

###/api/v1/users/${userId}/factors/${factorId}

