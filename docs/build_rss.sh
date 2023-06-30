#!/bin/bash
# Build the RSS feed
rsync -av --delete _onair/ _benchtop/ _posts/

# Display the status in git
git status
