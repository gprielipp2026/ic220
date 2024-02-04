#!/bin/bash

echo
echo "Gathering config info that is unique to your machine...."

echo "Here is some config info"    > bread_crumbs.txt
ifconfig                          >> bread_crumbs.txt
echo "Done!"                      >> bread_crumbs.txt

echo
echo "File bread_crumbs.txt created; now follow directions to submit."
echo
