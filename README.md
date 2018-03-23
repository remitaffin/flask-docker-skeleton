# flask-docker-skeleton
Skeleton project to run a Flask in docker in just seconds
on Linux or MacOS.

## Get started

On MacOs:
1. Install docker as indicated here:
https://docs.docker.com/docker-for-mac/install/

2. Install python with [homebrew](https://brew.sh) to have pip:
`brew install pip`

3. Install docker-compose:
`sudo pip install -U docker-compose==1.17.1`


On Ubuntu/Debian:
1. Install docker:
`wget -qO- https://get.docker.com/ | sh`

2. Install python and pip
`sudo apt-get update && sudo apt-get install -y python-dev python-pip`

3. Install docker-compose
`sudo pip install -U docker-compose==1.17.1`

## Start your new project

1. Copy this project's code in another directory:
   `cp -R ./flask-docker-skeleton ./new_github_project`
2. Run `./create_app.sh yourapplication` (Pick the name wisely)
3. Run `docker-compose up` to start your containers
4. Go to http://localhost:8000
5. You're all set! Your app is running Python 3.6 on Alpine Linux and all
your pip packages are installed inside your virtual environment.

## New project's structure

```
run.py
/virtualenv
/yourapplication
    __init__.py
    /controllers
        __init__.py
        /site
            __init__.py
            hello.py
    /templates
        layout.html
        index.html
        login.html
```

## To SSH inside the container and run any commands

1. `docker-compose run app bash`
2. Run any commands in the docker shell

## Add new linux packages

1. Update the Dockerfile
2. Run `docker-compose up --build`

## Add new pip packages

1. Add packages to the requirements.txt file
2. Run `./reset_virtualenv.sh`

## Use postgresql

1. Uncomment every line that is commented out in docker-compose.yml
2. Run `docker-compose up` to restart your containers
