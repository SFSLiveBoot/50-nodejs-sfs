#!/bin/sh

: "${lbu:=/opt/LiveBootUtils}"
. "$lbu/scripts/common.func"

: "${nodejs_dist:=https://nodejs.org/dist}"
: "${nodejs_dist_json:=$nodejs_dist/index.json}"
: "${nodejs_arch:=linux-x64}"

latest_nodejs_ver() {
  curl -s "$nodejs_dist_json" | jq -r 'map(select(.lts!=false and contains({files:["'$nodejs_arch'"]})))[0].version'
}

installed_nodejs_ver() {
  "$DESTDIR/opt/bin/node" --version
}

latest_nodejs_url() {
  : ${nodejs_ver:=$(latest_nodejs_ver)}
  echo "$nodejs_dist/$nodejs_ver/node-${nodejs_ver}-$nodejs_arch.tar.xz"
}

confirm_latest() {
  local name="$1" installed="$2" latest="$3"
  test "x$installed" = "x$latest" || {
    echo "Update for $name available: '$installed' -> '$latest'" >&2
    return 1
  }
}
