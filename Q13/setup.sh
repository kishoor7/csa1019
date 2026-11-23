#!/usr/bin/env bash
# Configure a Jenkins multibranch pipeline with this Jenkinsfile.
# Install Git, SSH Agent and Credentials Binding plugins; configure cloud-ssh-key and cloud-host.
# Install Docker on agent and VM, grant agent Docker access, add VM to known_hosts.
docker build -t se-flask:ci .
docker run --rm se-flask:ci python -m unittest -v
