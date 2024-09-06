### TLSAudit parser code
###
### Reads the Nginx configuration file and extracts TLS configuration options

# Declare a global array to store TLS-relevant configuration options
tls_options=()

parseNginxConfig() {
    # Check if a file name was provided
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 <path/to/nginx_config_file>"
        exit 1
    fi

    # Input Nginx config file
    config_file="$1"

    # Check if the file exists
    if [ ! -f "$config_file" ]; then
        echo "Error: File $config_file not found!"
        exit 1
    fi

    # Declare an array to hold the TLS-relevant configuration options
    tls_options=()


    # Use grep to get the lines and read them into the array
    while IFS= read -r line; do
        # Step 1: Remove leading/trailing spaces and semicolon
        cleaned_string=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//;s/;$//')

        # Step 2: Replace multiple spaces with a single colon
        formatted_string=$(echo "$cleaned_string" | sed 's/[[:space:]]\+/:/g')

        # Step 3: Store the resulting string in the array
        tls_options+=("$formatted_string")
    done < <(grep -E "^\s*(ssl_certificate|ssl_certificate_key|ssl_protocols|ssl_ciphers|ssl_prefer_server_ciphers|ssl_session_cache|ssl_session_timeout|ssl_trusted_certificate|ssl_stapling|ssl_stapling_verify|ssl_dhparam)\s+" "$config_file")
}
