# DoH Servers Blocker Script for Mikrotik (using pre-processed .rsc files)

# Create the DoH script
/system script
add name="Update-DoH-Lists" source={
    :log info "Starting DoH blocklist update script"
    
    # Define URLs to your pre-processed GitHub .rsc files
    :local ipv4Url "https://raw.githubusercontent.com/yvespires658/DoH-IP-blocklists/master/mikrotik-doh-ipv4.rsc"
    :local ipv6Url "https://raw.githubusercontent.com/yvespires658/DoH-IP-blocklists/master/mikrotik-doh-ipv6.rsc"
    :local ipv4File "doh-ipv4.rsc"
    :local ipv6File "doh-ipv6.rsc"
    :local ipv4ListName "DoHServersIPv4"
    :local ipv6ListName "DoHServersIPv6"
    
    # Download the MikroTik-formatted IPv4 DoH server list
    :log info "Downloading IPv4 DoH server list"
    /tool fetch url=$ipv4Url dst-path=$ipv4File mode=https
    :delay 5s
    
    # Download the MikroTik-formatted IPv6 DoH server list
    :log info "Downloading IPv6 DoH server list"
    /tool fetch url=$ipv6Url dst-path=$ipv6File mode=https
    :delay 5s
    
    # Check if files were downloaded successfully
    :if ([:len [/file find name=$ipv4File]] = 0) do={
        :log error "Failed to download IPv4 DoH list"
        return 0
    }
    :if ([:len [/file find name=$ipv6File]] = 0) do={
        :log error "Failed to download IPv6 DoH list"
        return 0
    }
    
    # Remove existing address list entries with previous and new names
    :log info "Clearing existing IPv4 DoH address lists"
    /ip firewall address-list remove [/ip firewall address-list find list="DoHServers"]
    /ip firewall address-list remove [/ip firewall address-list find list=$ipv4ListName]
    
    :log info "Clearing existing IPv6 DoH address lists"
    /ipv6 firewall address-list remove [/ipv6 firewall address-list find list="DoHServers"]
    /ipv6 firewall address-list remove [/ipv6 firewall address-list find list=$ipv6ListName]
    
    # Modify the downloaded scripts to use our list names
    :local ipv4Content [/file get [/file find name=$ipv4File] contents]
    :local ipv6Content [/file get [/file find name=$ipv6File] contents]
    
    :local modifiedIpv4Content [:put [/terminal(:local s $ipv4Content; :return [:substitute $s "list=DoHServers" "list=$ipv4ListName" -1])]]
    :local modifiedIpv6Content [:put [/terminal(:local s $ipv6Content; :return [:substitute $s "list=DoHServers" "list=$ipv6ListName" -1])]]
    
    /file set [/file find name=$ipv4File] contents=$modifiedIpv4Content
    /file set [/file find name=$ipv6File] contents=$modifiedIpv6Content
    
    # Import the scripts directly
    :log info "Importing IPv4 DoH addresses"
    /import file-name=$ipv4File
    
    :log info "Importing IPv6 DoH addresses"
    /import file-name=$ipv6File
    
    # Clean up downloaded files
    :log info "Cleaning up temporary files"
    /file remove $ipv4File
    /file remove $ipv6File
    
    # Verify lists have entries
    :local ipv4Count [/ip firewall address-list print count where list=$ipv4ListName]
    :local ipv6Count [/ipv6 firewall address-list print count where list=$ipv6ListName]
    
    :log info "DoH blocklist update completed. IPv4 addresses: $ipv4Count, IPv6 addresses: $ipv6Count"
}

# Create firewall rules to block DoH traffic (only on first run)
:if ([:len [/ip firewall filter find comment="drop DoH IPv4"]] = 0) do={
    /ip firewall filter add action=drop chain=forward comment="drop DoH IPv4" dst-address-list="DoHServersIPv4"
}

:if ([:len [/ipv6 firewall filter find comment="drop DoH IPv6"]] = 0) do={
    /ipv6 firewall filter add action=drop chain=forward comment="drop DoH IPv6" dst-address-list="DoHServersIPv6"
}

# Remove old rules if they exist
:if ([:len [/ip firewall filter find comment="drop DoH"]] > 0) do={
    /ip firewall filter remove [find comment="drop DoH"]
}

:if ([:len [/ipv6 firewall filter find comment="drop IPv6 DoH"]] > 0) do={
    /ipv6 firewall filter remove [find comment="drop IPv6 DoH"]
}

# Create a scheduler to run the script monthly (30 days)
/system scheduler
add interval=4w2d name="Update DoH Blocklists" on-event="/system script run Update-DoH-Lists" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=may/17/2025 start-time=03:00:00

# Run the script immediately for initial setup
/system script run Update-DoH-Lists

:log info "DoH blocking setup completed successfully"