#!/bin/bash
# CSE534

echo "--- Ping information ---"
ping -c 3 $1;
echo "--- Traceroute information ---"
traceroute $1;
exit 0;
