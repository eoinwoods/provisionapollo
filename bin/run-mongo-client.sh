#
#  run-mongo-client.sh - script to record how to start the MongoDB command
#                        line client ("mongo") using Docker in the Apollo
#                        environment
#
# Note: "-it" == interactive and allocate a tty
sudo docker run -it --net=container:datahogdb mongo mongo
