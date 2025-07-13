#!/bin/bash

# Exit on error
set -e

# Check usage
if [ -z "$1" ]; then
    echo "Usage: $0 <domains_file>"
    exit 1
fi

# Input file with domains
domains_file="$1"

# Timestamp for output directory
timestamp=$(date +%Y%m%d_%H%M%S)
base_scan_dir=~/scan/domains_$timestamp

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

    echo "  - Running assetfinder..."
    assetfinder --subs-only "$domain" | tee "$recon_dir/assetfinder.txt" > /dev/null

    echo "  - Running findomain..."
    # echo "$domain" > "$recon_dir/tmp_domain.txt"
    findomain -t $domain --output "$recon_dir/findomain.txt"

    # Combine results
    cat "$recon_dir"/*.txt | sort -u > "$recon_dir/all_domains.txt"
    echo "  [+] Total unique subdomains found: $(wc -l < "$recon_dir/all.txt")"

done < "$domains_file"

echo "[*] Subdomain enumeration complete for all domains."
