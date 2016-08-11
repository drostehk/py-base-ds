# Droste's Base Repo for Data Science with Python, Jupyter, and Docker!

## Intro
The purpose of this repo is to provide a base Dockerfile for data science projects using Docker, Python3, Anaconda3, and Jupyter notebooks. You will find included in this project:
- A base Dockerfile that generates the drostehk/py-base-ds image.
- An example Dockerfile.dev that can be used as the base for other repos that will extend from drostehk/py-base-ds.
- The environment.yml that contains many of the fundamental dependencies and packages for projects.
- The jupyter_notebook_config.py that specifies some reasonable defaults for the Jupyter notebook configuration.
- A docker-compose.template.yml that can be customized by other repos.
- A docker-compose.yml specifically for this repo to show how things work.

## Why?
You may be wondering why we would leverage Docker for data science using Jupyter notebooks. There are a few reasons:
- By scripting the setup and having everything run in a standard image, we eliminate issues caused by configuration differences between different environments.
- It makes it very fast to get up and running. By just installing Docker and running a single command (```docker-compose up```) you have a working environment.
- We want to create easily reproducible environments when we are ready to go to production.

One concern regarding this workflow for development is the slowness of having to rebuild the Docker image whenever we want to make configuration changes like modifying the environment.yml. We have attempted to address this in two ways:
1. Leveraging the Dockerfile cache by ordering statements such that the most expensive steps are executed first. This means that if you rebuild the container for a small change, like a jupyter_notebook_config.py change, it won't rebuild the environment, it will just recopy that file into the image.

1. Leveraging Docker inheritance and only performing updates in the child image. If you look at Dockerfile.dev, it inherits from our base image which did all the hard work of setting up the environment. This means if you change the environment.yml in a development setting you can simply rebuild the dev image and this will result in copying the environment.yml into your dev image and simply running update instead of rebuilding the entire environment.

## Setup
Setup should be relatively straightforward:
- [Install Docker native](http://www.docker.com/products/overview) for your environment.
- Run: ```docker-compose up```

Running ```docker-compose up``` will pull the latest version of the drostehk/py-base-ds from our Docker Hub repo, build the py-base-ds-dev image locally, and run the image mounting the example notebooks folder included here as a volume inside the image. This will allow you to access Jupyter via [http://localhost:8888](http://localhost:8888).

## Workflow
You are welcome to use this repo standalone. If you do, you may find that you would like to add to or modify the packages contained in the environment.yml from time to time. If you do this, you will need to do the following in order to refresh the packages in the Docker image:
- ```docker-compose down``` (only if it is already running)
- ```docker-compose build```
- ```docker-compose up```

Note: This will only run the anaconda update command on the environment and will not recreate the environment from scratch.

If you decide that you want to either rebuild the environment from scratch OR make changes to the jupyter_notebook_config.py, then a little extra work is required:
- ```docker-compose down``` (only if it is already running)
- ```docker build -t drostehk/py-base-ds .```
- ```docker-compose build```
- ```docker-compose up```

## Rolling your own
If you would like to leverage drostehk/py-base-ds as the base for your Docker image, then you can do the following:
- Copy the Dockerfile.dev into your repo with the filename Dockerfile and make any additions necessary. You should probably also change the FROM drostehk/py-base-ds:latest to be a specific version of py-base-ds rather than 'latest' in order to get consistent results.
- Copy the docker-compose.template.yml into your repo with the filename docker-compose.yml. You should modify the following properties according to match your requirements:
 - your-org
 - your-image-name
 - your-notebooks-path (this can be a relative path, see docker-compose.yml for an example)
- Optionally, if you would like to override the dependencies and packages, you can create your own environment.yml file.
- Optionally, if you would like to override the jupyter_notebook_config.py, you can do so, but you will also need to add a line to your Dockerfile which will COPY the file overtop of the existing one. See the Dockerfile in this repo for an example.

Once you have followed these steps, you can run the same commands as specified in the Workflow section.
