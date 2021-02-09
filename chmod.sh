#!/bin/bash
dir=$PWD

chown -R $user:$group "$dir";
find "$dir" -type d -exec chmod 755 '{}' \;
find "$dir" -type f -exec chmod 644 '{}' \;
