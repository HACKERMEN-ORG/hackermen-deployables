docker run -it --rm \
    -v $(pwd)/data/matrix/synapse:/data \
    -e SYNAPSE_SERVER_NAME=matrix.system.exposed \
    -e SYNAPSE_REPORT_STATS=yes \
    -e UID=1000 \
    -e GID=1000 \
    matrixdotorg/synapse:latest generate