#To show only running containers use the given command:

docker ps

#To show all containers use the given command:

docker ps -a

#To show the latest created container (includes all states) use the given command:

docker ps -l

#To show n last created containers (includes all states) use the given command:

docker ps -n=-1

#To display total file sizes use the given command:

docker ps -s

#The content presented above is from docker.com.

#In the new version of Docker, commands are updated, and some management commands are added:

docker container ls

#Is used to list all the running containers.

docker container ls -a

#And then, if you want to clean them all,

docker rm $(docker ps -aq)

#Is used to list all the containers created irrespective of its state.
#Here container is the management command.

#list all images
docker images

#remove images
docker rmi imageID

## Build Image
docker build -t test_postgresql .

## RUN Ubuntu container
docker run -it ubuntu:16.04

## Create Container postgresql
docker container run --rm -it --name test_postgresql test_postgresql

## RUN Postgresql container
docker exec -it test_postgresql  psql -U rohit

#make a new copy actual Db all times when the docker is up
#perl to create db and dummy loader to load data

