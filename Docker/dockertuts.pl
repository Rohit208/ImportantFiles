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

#pull latest postgresql Image
docker pull postgres:latest

#build yout own image upon it
docker build -t postgresql:12 .

#Create Volumne decide ports and create a Container
sudo docker run -v /exceleron/psql/12:/var/lib/postgresql/data/ -p 5432:5432 --name postgresql -e POSTGRES_PASSWORD=12345 -d imageID

#docker exec interactivily using docker internal options
docker exec -it COMTAINERID psql -p 5432 -U rohit -d test

#docker bash machine
docker exec -it COMTAINERID /bin/bash 

#start or stop conatinner docker service
sudo docker stop postgresql
sudo docker start postgresql

# Docker logs for COnatainer
docker logs COMTAINERID

#Docker postgresql
psql -h 0.0.0.0 -U rohit -p 5432 -d test


#https://tecadmin.net/install-postgresql-server-on-ubuntu/
#https://hub.docker.com/_/postgres
#https://docs.docker.com/engine/examples/postgresql_service/
#https://www.linode.com/docs/applications/containers/how-to-use-dockerfiles/
#https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
#https://github.com/docker/compose