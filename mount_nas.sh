#!/bin/bash

# Function to create a mount point directory if it doesn't already exist
create_mount_point() {
  local mount_point=$1
  echo "Creating mount point at $mount_point..."
  sudo mkdir -p "$mount_point"
}

# Function to mount the NAS share temporarily
mount_share_temp() {
  local nas_ip=$1
  local sharename=$2
  local mount_point=$3
  local username=$4
  local password=$5
  echo "Mounting share $sharename from NAS at $nas_ip to $mount_point..."
  sudo mount -t cifs -o username="$username",password="$password" "//${nas_ip}/${sharename}" "$mount_point"
}

# Function to create a credentials file for storing NAS login details
create_credentials_file() {
  local username=$1
  local password=$2
  local cred_file="/etc/cifs-creds"
  echo "Creating credentials file at $cred_file..."
  sudo bash -c "echo 'username=$username' > $cred_file"
  sudo bash -c "echo 'password=$password' >> $cred_file"
  sudo chmod 600 $cred_file  # Set file permissions to read/write for root only
}

# Function to update the /etc/fstab file for permanent mount
update_fstab() {
  local nas_ip=$1
  local sharename=$2
  local mount_point=$3
  local uid=$4
  local gid=$5
  local cred_file="/etc/cifs-creds"
  echo "Updating /etc/fstab for permanent mount..."
  sudo bash -c "echo '//${nas_ip}/${sharename} ${mount_point} cifs credentials=${cred_file},uid=${uid},gid=${gid},iocharset=utf8 0 0' >> /etc/fstab"
}

# Function to reload the systemd daemon to apply changes
reload_systemd_daemon() {
  echo "Reloading systemd daemon to apply changes..."
  sudo systemctl daemon-reload
}

# Function to test the fstab entry by mounting all filesystems mentioned in fstab
test_mount() {
  echo "Testing the fstab entry..."
  sudo mount -a
}

# Main function to coordinate all steps for mounting the NAS share
main() {
  local nas_ip="192.168.1.100"  # Replace with your NAS IP address
  local sharename="shared_folder"  # Replace with your NAS shared folder name
  local mount_point="/media/nas_share"  # Replace with your desired mount point
  local username="xxxx"  # Replace with your NAS username
  local password="xxx"  # Replace with your NAS password
  local uid=1002  # Replace with the desired user ID for file ownership
  local gid=1002  # Replace with the desired group ID for file ownership

  create_mount_point "$mount_point"  # Create the mount point directory
  mount_share_temp "$nas_ip" "$sharename" "$mount_point" "$username" "$password"  # Mount the NAS share temporarily
  create_credentials_file "$username" "$password"  # Create a credentials file for storing NAS login details
  update_fstab "$nas_ip" "$sharename" "$mount_point" "$uid" "$gid"  # Update /etc/fstab for permanent mount
  reload_systemd_daemon  # Reload systemd daemon to apply changes
  test_mount  # Test the fstab entry by mounting all filesystems
}

# Run the main function
main

