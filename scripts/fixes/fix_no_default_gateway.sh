#!/usr/bin/env sh

# Sometimes nixos on UTM boots without a default gateway

sudo ip route add default via 192.168.64.1

