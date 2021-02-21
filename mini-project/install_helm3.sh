#!/bin/bash
sudo wget https://get.helm.sh/helm-v3.5.2-linux-arm64.tar.gz        #download the helm installer
sudo tar -zxvf helm-v3.5.2-linux-arm64.tar.gz                       # extract it
sudo mv linux-arm64/helm /usr/local/bin                             # move the command to bin
helm version                                                        # check helm version