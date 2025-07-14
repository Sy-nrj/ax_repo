#!/bin/bash

domain_dir="$1"
live_subs="$domain_dir/subdomains/live_subs.txt"
ports_dir="$domain_dir/open_ports"
output_file="$port_dir/open_ports.txt"

mkdir -p "$ports_dir"

echo "[+] Scanning open ports for live Hosts ..."

naabu -list "$live_subs" -top-65535 -silent -o "$outputfile" || true

echo "[+] Open ports saved to $output_file"
