#!/bin/bash

echo ""
echo "Stop  lmadmin"
echo ""
sudo systemctl --no-pager status lmadmin
sudo systemctl --no-pager stop   lmadmin

echo ""
echo "Start lmadmin"
echo ""
sudo systemctl --no-pager status lmadmin
sudo systemctl --no-pager start  lmadmin
sudo systemctl --no-pager status lmadmin
