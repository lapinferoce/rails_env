#!/usr/bin/env bash

DB_PASSWORD="mysecretpassword"
PROJECT_NAME=`basename $(pwd)`

echo "== checking root image exists"
image=$(docker images | grep "rails_env" | awk  '{}{print $1}')
[ "x$image" != "xrails_env" ] && echo "== rail image not found , building new one.."&& docker build -t rails_env . 

#echo "== checking $USER's image exists "
#user_image="rails_env-$USER"
#[ "x$image" != "xrails_env" ] && echo "== $USER's images not found , building new one.."&& docker build -t rails_env-$USER .
#



user_db_container_exited=$(docker ps -a | grep "rails_env_db" | grep "Exited" | awk '{}{ print $1}')
user_db_container_up=$(docker ps -a | grep "rails_env_db" | grep "Up" | awk '{}{ print $1}')

if [ "x$user_db_container_up" == "x" ]
then
  if [ "x$user_db_container_exited" == "x" ] 
  then
    docker run --name rails_env_db -e POSTGRES_PASSWORD=$DB_PASSWORD -d postgres
  else
    docker start rails_env_db 
  fi
fi

rails_user_env="rails_env-$USER-$PROJECT_NAME"
chcon -Rt svirt_sandbox_file_t $(pwd)/src
echo "== starting env"
# if user container not exist

user_container_up=$(docker ps -a | grep "$rails_user_env" | grep "Up" | awk '{}{ print $1}')
user_container=$(docker ps -a | grep "$rails_user_env" | grep "Exited" | awk '{}{ print $1}')

## we should handle attach !!!
if [ "x$user_container_up" == "x" ]
then
  if [ "x$user_container" == "x" ]
   then 
     echo "== no user container " && docker run  -e PROJECT=$PROJECT_NAME -p 127.0.0.1:3000:3000  --name $rails_user_env -v $(pwd)/src:/var/www/rails -it --link rails_env_db:db rails_env:latest /usr/bin/tmux
   else
    echo "== reusing existing container "&& docker start -a -i $rails_user_env  
  fi
else
  echo "== already running container atteching" && docker attach  $rails_user_env
fi


#echo "== starting shell"
##docker attach rails_env-$USER
#
#echo "committing to image"
##docker commit rails_env_latest rails_env:latest
#
#echo "== cleanning up"
##docker rm rails_env_latest
#
#
##docker export <CONTAINER ID> | docker import - some-image-name:latest
