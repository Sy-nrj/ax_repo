#!/bin/bash

# Exit on error
set -euo pipefail

# Check usage
if [ -z "$1" ]; then
    echo "Usage: $0 <domains_file>"
    exit 1
fi

# Input file with domains
domains_file="$1"
scan_id="$2"

# Timestamp for output directory
#timestamp=$(date +%Y%m%d_%H%M%S)

base_scan_dir=~/scan/list_$scan_id



echo "[*] Results will be saved in: $base_scan_dir"

# Loop through each domain in the file
while IFS= read -r domain || [[ -n "$domain" ]]; do
    # Skip empty lines
    if [ -z "$domain" ]; then
        continue
    fi

    echo "[+] Processing domain: $domain"

    # Create directory structure
    recon_dir="$base_scan_dir/$domain/subdomains"
    mkdir -p "$recon_dir"

    # Subdomain Enumeration
    echo "  - Running subfinder..."
    subfinder -d "$domain" -silent -o "$recon_dir/subfinder.txt"
    echo "[+] subfinder found $(wc -l < "$recon_dir/subfinder.txt domains")"

    echo "  - Running assetfinder..."
    assetfinder --subs-only "$domain" | tee "$recon_dir/assetfinder.txt" > /dev/null
    echo "[+] assetfinder found $(wc -l | "$recon_dir/assetfinder.txt domains")"

    echo "  - Running findomain..."
    # echo "$domain" > "$recon_dir/tmp_domain.txt"
    findomain -t $domain --output "$recon_dir/findomain.txt"
    echo "[+] Findomain found $(wc -l < "$recon_dir/findomain.txt domains") "

    # Combine results
    cat "$recon_dir"/*.txt | sort -u > "$recon_dir/all_domains.txt"
    echo "  [+] Total unique subdomains found: $(wc -l < "$recon_dir/all_subs.txt")"

done < "$domains_file"

echo "[*] Subdomain enumeration complete for all domains."
