#!/bin/bash

sudo systemctl status lmadmin
sudo systemctl stop   lmadmin
sudo systemctl status lmadmin
sudo systemctl start  lmadmin
sudo systemctl status lmadmin
