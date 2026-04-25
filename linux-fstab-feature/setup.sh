#!/bin/bash
cd "$(dirname "$0")"

sudo mkdir -p /feature /desktop
sudo chown $USER:$USER /feature /desktop

feature_url_path="https://manhavn.github.io/linux-fstab-feature"
feature_folder="/feature"

setup_new_user="setup_new_user.sh"
etc_docker_daemon_json="etc.docker.daemon.json"
start_bind_mounts="start-bind-mounts.sh"
etc_fstab="etc.fstab"
install_bash_autosuggestions="install-bash-autosuggestions.sh"

file1=("$feature_url_path/$setup_new_user" "$feature_folder/$setup_new_user")
file2=("$feature_url_path/$etc_docker_daemon_json" "$feature_folder/$etc_docker_daemon_json")
file3=("$feature_url_path/$start_bind_mounts" "$feature_folder/$start_bind_mounts")
file4=("$feature_url_path/$etc_fstab" "$feature_folder/$etc_fstab")
file5=("$feature_url_path/$install_bash_autosuggestions" "$feature_folder/$install_bash_autosuggestions")

for item in "file1" "file2" "file3" "file4" "file5"; do
    declare -n current=$item
    echo ${current[0]} ${current[1]}
    
    # Define the URL and target file
    URL=${current[0]}
    OUTPUT_FILE=${current[1]}
    
    # 1. Create a temporary file for the response body
    TEMP_FILE=$(mktemp)
    
    # 2. Execute curl: capture HTTP status code to variable, body to temp file
    HTTP_STATUS=$(curl -s -o "$TEMP_FILE" -w "%{http_code}" "$URL")
    
    echo $HTTP_STATUS $TEMP_FILE
    cat $TEMP_FILE
    
    # 3. Check if status is 200
    if [ "$HTTP_STATUS" -eq 200 ]; then
        # Use tee to show data and write to final file
        cat "$TEMP_FILE" | sudo tee "$OUTPUT_FILE"
    else
        echo "error: Received HTTP $HTTP_STATUS"
    fi
    
    # Clean up
    rm "$TEMP_FILE"
done

sudo chmod +x $feature_folder/*.sh
bash "$feature_folder/$setup_new_user"
