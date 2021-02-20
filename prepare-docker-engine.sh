#!/bin/bash
echo '{ "experimental": true }' | sudo tee /etc/docker/daemon.json'
sudo systemctl restart docker
