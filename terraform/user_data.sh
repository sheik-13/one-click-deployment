#!/bin/bash

# Wait for OS readiness & apt locks
sleep 30
export DEBIAN_FRONTEND=noninteractive

# Retry apt update
for i in {1..10}; do
    sudo apt update -y && break
    echo "APT update failed — retrying..."
    sleep 5
done

# Retry apt install
for i in {1..10}; do
    sudo apt install -y python3 python3-flask unzip && break
    echo "APT install failed — retrying..."
    sleep 5
done

# Install CloudWatch Agent from official .deb
sudo wget -O /tmp/amazon-cloudwatch-agent.deb https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i /tmp/amazon-cloudwatch-agent.deb

# Create app directory
sudo mkdir -p /home/ubuntu/app
sudo chown -R ubuntu:ubuntu /home/ubuntu/app

# Write app.py
sudo bash -c 'cat << "EOF" > /home/ubuntu/app/app.py
${app_py}
EOF'
sudo chown ubuntu:ubuntu /home/ubuntu/app/app.py

# Write requirements.txt
sudo bash -c 'cat << "EOF" > /home/ubuntu/app/requirements.txt
${requirements}
EOF'
sudo chown ubuntu:ubuntu /home/ubuntu/app/requirements.txt

# Install Python dependencies with retry
for i in {1..5}; do
    sudo pip3 install -r /home/ubuntu/app/requirements.txt && break
    echo "pip install failed — retrying..."
    sleep 5
done

# CloudWatch Agent config
sudo bash -c 'cat << "EOF" > /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/home/ubuntu/app/app.log",
            "log_group_name": "/apt-devops-assignment/app",
            "log_stream_name": "{instance_id}-app-log"
          },
          {
            "file_path": "/var/log/syslog",
            "log_group_name": "/apt-devops-assignment/syslog",
            "log_stream_name": "{instance_id}-syslog"
          }
        ]
      }
    }
  }
}
EOF'

# Start CloudWatch Agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a start \
    -m ec2 \
    -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json

# Create systemd service
sudo bash -c 'cat << "EOF" > /etc/systemd/system/app.service
[Unit]
Description=Flask API Service
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/app
ExecStart=/usr/bin/python3 /home/ubuntu/app/app.py >> /home/ubuntu/app/app.log 2>&1
Restart=always

[Install]
WantedBy=multi-user.target
EOF'

sudo systemctl daemon-reload
sudo systemctl enable app
sleep 5
sudo systemctl start app
