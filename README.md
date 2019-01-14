# ifobs-docker
IFOBS docker image for OTP bank &amp; Kredobank

# Download image from dockerhub
docker pull sergant/ifobs

# Run image:
docker run --rm -v $HOME/dir-with-keys:/mnt/host -v /tmp/.X11-unix:/tmp/.X11-unix:rw -e DISPLAY=unix$DISPLAY --name ifobs sergant/ifobs
