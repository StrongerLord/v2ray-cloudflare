FROM v2fly/v2fly-core:latest

ARG V2RAY_UUID=CHANGE-THIS-UUID

RUN echo "{ \
  \"log\": {\"loglevel\": \"info\"}, \
  \"inbounds\": [{ \
    \"port\": 8080, \
    \"protocol\": \"vmess\", \
    \"settings\": { \
      \"clients\": [{ \
        \"id\": \"${V2RAY_UUID}\", \
        \"alterId\": 0 \
      }] \
    }, \
    \"streamSettings\": { \
      \"network\": \"ws\", \
      \"wsSettings\": { \
        \"path\": \"/wywb\" \
      } \
    } \
  }], \
  \"outbounds\": [{ \
    \"protocol\": \"freedom\", \
    \"settings\": {} \
  }] \
}" > /etc/v2ray/config.json

EXPOSE 8080
