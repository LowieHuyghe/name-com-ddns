#!/usr/bin/env sh

nameDotComRequest () {
  local username="$1"
  if [ -z "$username" ]; then >&2 echo "username is not set"; return 1; fi
  local token="$2"
  if [ -z "$token" ]; then >&2 echo "token is not set"; return 1; fi
  local url="$3"
  if [ -z "$url" ]; then >&2 echo "url is not set"; return 1; fi
  local method="$4"
  if [ -z "$method" ]; then >&2 echo "method is not set"; return 1; fi
  local data="$5"
  if [ -z "$data" ]; then >&2 echo "data is not set"; return 1; fi

  local result="$( curl -sSf -u "$username:$token" "$url" -X "$method" -H 'Content-Type: application/json' --data "$data" )"
  if [[ $? != 0 ]] || [ -z "$result" ]; then
    >&2 echo "request to '$url' failed"
    >&2 echo "  data: $data"
    >&2 echo "  result: $result"
    return 1
  fi

  echo "$result"
  return 0
}

listRecords () {
  local username="$1"
  if [ -z "$username" ]; then >&2 echo "username is not set"; return 1; fi
  local token="$2"
  if [ -z "$token" ]; then >&2 echo "token is not set"; return 1; fi
  local domainName="$3"
  if [ -z "$domainName" ]; then >&2 echo "domainName is not set"; return 1; fi
  local page="$4"
  if [ -z "$page" ]; then
    local page=1
  fi
  local perPage="$3"
  if [ -z "$perPage" ]; then
    local perPage=1000
  fi

  local records="$( nameDotComRequest "$username" "$token" "https://api.name.com/v4/domains/$domainName/records" "GET" "{\"page\":$page, \"perPage\":$perPage}" )"
  if [[ $? != 0 ]] || [ -z "$records" ]; then
    >&2 echo "listRecords for '$domainName' failed"
    return 1
  fi

  echo "$records"
  return 0
}

getRecordId () {
  local username="$1"
  if [ -z "$username" ]; then >&2 echo "username is not set"; return 1; fi
  local token="$2"
  if [ -z "$token" ]; then >&2 echo "token is not set"; return 1; fi
  local domainName="$3"
  if [ -z "$domainName" ]; then >&2 echo "domainName is not set"; return 1; fi
  local host="$4"
  if [ -z "$host" ]; then >&2 echo "host is not set"; return 1; fi

  local records="$( listRecords "$username" "$token" "$domainName" )"
  if [ -z "$records" ]; then
    >&2 echo "getRecordId for '$domainName' failed"
    return 1
  fi

  if ! which jq > /dev/null; then
    >&2 echo "getRecordId for '$domainName' failed"
    >&2 echo " jq needs to be installed"
    return 1
  fi

  local id=$( echo "$records" | jq -M ".records | .[] | select(.host==\"$host\") | .id" )
  if [ -z "$id" ]; then
    >&2 echo "getRecordId for '$domainName' failed"
    >&2 echo "  no id found for '$host'"
    return 1
  fi

  printf "$id"
  return 0
}

updateRecord () {
  local username="$1"
  if [ -z "$username" ]; then >&2 echo "username is not set"; return 1; fi
  local token="$2"
  if [ -z "$token" ]; then >&2 echo "token is not set"; return 1; fi
  local domainName="$3"
  if [ -z "$domainName" ]; then >&2 echo "domainName is not set"; return 1; fi
  local id="$4"
  if [ -z "$id" ]; then >&2 echo "id is not set"; return 1; fi
  local host="$5"
  if [ -z "$host" ]; then >&2 echo "host is not set"; return 1; fi
  local type="$6"
  if [ -z "$type" ]; then >&2 echo "type is not set"; return 1; fi
  local answer="$7"
  if [ -z "$answer" ]; then >&2 echo "answer is not set"; return 1; fi

  if ! nameDotComRequest "$username" "$token" "https://api.name.com/v4/domains/$domainName/records/$id" "PUT" "{\"host\":\"$host\",\"type\":\"$type\",\"answer\":\"$answer\"}"; then
    >&2 echo "updateRecord failed"
    return 1
  fi

  return 0
}

updateRecordByHost () {
  local username="$1"
  if [ -z "$username" ]; then >&2 echo "username is not set"; return 1; fi
  local token="$2"
  if [ -z "$token" ]; then >&2 echo "token is not set"; return 1; fi
  local domainName="$3"
  if [ -z "$domainName" ]; then >&2 echo "domainName is not set"; return 1; fi
  local host="$4"
  if [ -z "$host" ]; then >&2 echo "host is not set"; return 1; fi
  local type="$5"
  if [ -z "$type" ]; then >&2 echo "type is not set"; return 1; fi
  local answer="$6"
  if [ -z "$answer" ]; then >&2 echo "answer is not set"; return 1; fi

  local id=$( getRecordId "$username" "$token" "$domainName" "$host" )
  if [ -z "$id" ]; then
    >&2 echo "updateRecordByHost failed"
    return 1
  fi

  if ! updateRecord "$username" "$token" "$domainName" "$id" "$host" "$type" "$answer" > /dev/null; then
    >&2 echo "updateRecordByHost failed"
    return 1
  fi

  return 0
}
