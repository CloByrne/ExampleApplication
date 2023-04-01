#!/usr/bin/bash
# Check if there is an instance running with the image name we are deploying
CURRENT_INSTANCE=$(docker ps -a -q --filter ancestor="$IMAGE_NAME" --format="{{.ID}}")

# If an instance does exist, stop the instance
if [ "CURRENT_INSTANCE" ]
then
    docker rm $(docker stop $CURRENT_INSTANCE)
fi

# Pull down the instance from docker hub
docker pull $IMAGE_NAME

# Check if a docker container exists with the name node_app, if it does remove the container
CONTAINER_EXISTS=$(docker ps -a | grep node_app)
if [ "$CONTAINER_EXISTS" ]
then
    docker rm node_app
fi

# Create a container called node_app that is available on port 8443 from our docker image
docker create -p 8443:8443 --name node_app $IMAGE_NAME
# Write the private key to a file
echo $PRIVATE_KEY > privatekey.pem
# Write the server key to a file
echo $SERVER > server.crt
# Add the private key to the node_app docker container
docker cp ./privatekey.pem node_app:/privatekey.pem
# Add the server key yo the node_app docker container
docker cp ./server.crt node_app:server.crt
# Start the node_app container
docker start node_app

# sudo apt update && sudo apt install nodejs npm

# Install pm2 which is a production process manager for Node.js with a built-in load balancer.
# sudo npm install -g pm2

# stop any instance of our application running currently
# pm2 stop example_app

# change directory into folder where application is downloaded
# sudo chmod 777 ExampleApplication/
# cd ExampleApplication/

# Install application dependancies
# npm install

# echo $PRIVATE_KEY > privatekey.pem
# echo $SERVER > server.crt

# Start the application with the process name example_app using pm2
# pm2 start ./bin/www --name example_app

# echo "deploy code"
