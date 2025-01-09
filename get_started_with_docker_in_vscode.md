## Quick tutorial for docker with VSCode

###### Why use Docker?

A docker container is a minimal virtualized program containing a whole operating system and whatever you choose to install on it. This allows you to develop your project on any system and easily port or share it to others in a single file you can simply run like an executable.

In this guide I will also outline how to create cross-platform docker images that you can use to develop regardless of if you run it on ARM or X86 architecture. This is very useful if you want to build projects for the Nvidia Jetson or Raspberry Pi. 

###### Why in VSCode?

My personal preference is using VSCode for all projects involving coding as it is completely modular with the extension library. You can create and run docker containers and code all within VSCode. If you so wish, you can even SSH into the target computer (Like jetson) and use the container there so you never have to even physically touch the platform you wish to code for. This makes development extremely convenient because you can do all of it from a single interface and remotely.






### Pre-requisites

* [VSCode installation](https://code.visualstudio.com/download) (Just download and install)
* [Docker](https://docs.docker.com/desktop/) (I recommmend installing whole Desktop suite for ease of use, but you can get by with just *Engine* and *Compose*) 
* Basic knowledge of linux and command line use


#### 1. Getting started

Once you have both programs, open up VSCode and head to the extensions marketplace. 

Find:

* Dev Containers
* Docker

Install them. You should see a new tab added to VSCode with the Docker icon. If you open this tab, You can see the "Containers" and "Images" sections. This is essentially the same interface as in Docker Desktop GUI.

Docker engine needs to be running in the background. Make sure to start Docker Desktop. VSCode will now automatically hook up into the service.

##### Note for Windows/Mac:
*You may want to check that you are using Linux containers by default in Docker Desktop. Find the icon in your toolbar, right click and switch to Linux containers.**

#### 2. Short introduction Docker

##### Docker Terminology Guide
###### Core Concepts
##### Container
A lightweight, standalone, and executable software package that includes everything needed to run a piece of software: code, runtime, system tools, libraries, and settings. Think of it as a running instance of an image - like a running program created from its executable.
##### Image
A read-only template containing a set of instructions for creating a Docker container. It's like a snapshot or blueprint that contains all the necessary files, dependencies, and configurations needed to create a container. Similar to how a class is used to create objects in programming.
##### Dockerfile
A text file containing instructions for building a Docker image. It specifies the base image, adds additional components, and configures various settings. Think of it as a recipe that tells Docker how to create an image.
##### Docker Compose (docker-compose.yml)
A tool for defining and running multi-container Docker applications. The docker-compose.yml file is where you define your application's services, networks, and volumes in a declarative way. Think of it as a project configuration file that orchestrates multiple containers. 
Defining arguments in the compose file is the same as defining arguments in the CMD line upon building or running the container.

In short, a **Dockerfile** *builds* an **Image** to then *run* as a **Container**.

#### 3. Basic introduction to using Docker in VSCode

Follow this tutorial to see how docker works in practice in VSCode. Part 1 is short and shows you the general gist of how to build and run Docker containers in VSCode and introduces the very basics of navigating the UI.

[Docker tutorial for VSCode](https://learn.microsoft.com/en-us/visualstudio/docker/tutorials/docker-tutorial)

Afterword: 

In general, you work first in the regular editor in your workspace folder and when the container has been build you move to the Docker tab to run it. Then you can work within the container tab.

This is done by right-clicking the running container in VSCode and pressing either **"Attach Visual Studio Code"**

This will open a new VSCode instance which allows you to work within the folder structure of the running container instance in real-time.

Alternatively, you can use **"Attach Shell"** to open a CMD window in the existing VSCode window and use command line commands to do things.

Note that functionality is base image dependent. In general, you will probably build on Ubuntu base images which allows you to mess around in the running container instance as if you were in a linux CMD line.
#### 4. Dockerfile
##### Dockerfile Commands and Structure Guide
###### Basic Structure
A Dockerfile is read from top to bottom, with each instruction creating a new layer in the image. Here's the typical structure:

1. Base image selection
2. Working directory setup
3. Dependencies installation
4. Source code copying
5. Build commands execution
6. Container startup command

##### Essential Commands

###### FROM 
>FROM ubuntu:20.04

* Always the first non-comment instruction
* Specifies the base image to build upon
* Examples: python:3.9, node:14, ubuntu:20.04
* Downloaded from a docker image repository unless directory path specified (You should download it locally first for faster use)
* Architecture (ARM/x86) dependent (Check further down for instructions on multi-architecture containers)
* Use [Nvidia images for Jetson development](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-base) (Above applies, Jetsons are ARM-based)

###### WORKDIR
>WORKDIR /app

* Sets the working directory for subsequent instructions
* Creates the directory if it doesn't exist
* Similar to running 'cd' in a terminal


###### COPY
>COPY ..
COPY src/ /app/src/

* Copies files from host machine to container
* First path: source on host
* Second path: destination in container

###### ADD

>ADD archive.tar.gz /app/

* Similar to COPY but with extra features
* Can extract compressed files
* Can download files from URLs

###### RUN

>RUN apt-get update && apt-get install -y python3
RUN pip install -r requirements.txt


* Executes commands during image build
* Creates a new layer in the image
* Used for installing packages, running builds, etc.
* Especially useful with linux-based containers

###### ENV

>ENV PORT=3000
ENV NODE_ENV=production

* Sets environment variables
* Available during build and in running container

###### EXPOSE

>EXPOSE 80

* Documents which ports the container listens on
* Doesn't actually publish the port (done during run in CMD line or in docker-compose.yml)

###### CMD

>CMD ["python", "app.py"]

* Specifies the command to run when container starts
* Only one CMD instruction per Dockerfile (Use Docker-compose.yml for more control)
* Can be overridden at runtime

###### ENTRYPOINT

>ENTRYPOINT ["python"]
>CMD ["app.py"]

* Sets the main executable of the container
* Combined with CMD for default arguments
* Harder to override than CMD

#### Example Dockerfile structure

```docker
# Use Ubuntu as base image
FROM ubuntu:24.04

# Set working directory
WORKDIR /app

# Copy a python requirements.txt file first from host (better caching)
COPY requirements.txt .

# Update apt repository and install python
RUN apt-get update && \
    apt-get install -y && \
    python3 && \
    python3-pip

# Install python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Expose port 5000
EXPOSE 5000

# Set environment variables
ENV FLASK_APP=app.py
ENV FLASK_ENV=production

# Command to run the application
CMD ["python", "app.py"]
```
######  Best Practices

**Use Specific Base Image Tags**

* Use specific versions instead of 'latest'
* Ensures reproducible builds


**Layer Optimization**

* Combine related RUN commands with &&
* Place rarely changing instructions first (Speeds up building because of docker caching)
* Use .dockerignore for unnecessary files


**Cache Usage**

* Copy requirements files before other files
* Install dependencies before copying application code


[Multi-stage Builds](https://docs.docker.com/build/building/multi-stage/)

* Use for compiling applications
* Reduces final image size
* Separates build dependencies from runtime


**Security**

* Don't run as root when possible
* Use trusted base images

#### 5. Docker Compose

Specifying things like network access, ports etc. in CMD line window everytime you run a container is clunky. 
Hardware and network access as well as services and other things can be customized in the Docker-compose.yml and this is the preferred way of doing things in VSCode.

The .yml file should be in the same directory as your Dockerfile.

Example snippet of the structure of a docker-compose.yml :
```yml
services:
  web:
    build:
        context:  .  #The dot builds using a local dockerfile
        dockerfile: ./Dockerfile
    ports:
      - "8000:5000" # Map host:container ports
```
Tip: While making a docker-compose.yml in VSCode you can press ctrl+space for intellisense to give you suggestion on available variables. Intellisense also gives you explanatory tooltips if you hover over the variable names. 

[Getting started with Docker Compose in VSCode](https://code.visualstudio.com/docs/containers/docker-compose) 
(Independent from previous tutorial, but you can mess around in the same instance to get a feel for it)

[About Docker Compose](https://docs.docker.com/compose/gettingstarted/)


# TODO
* Add Qemu instructions
https://www.stereolabs.com/docs/docker/building-arm-container-on-x86
* Finish Docker Compose section with a functional script
* Make example files functional & work with each other at the end
* Add SSH instructions VSCode
* Add instructions to copy docker image over SSH to target
https://stackoverflow.com/questions/23935141/how-to-copy-docker-images-from-one-host-to-another-without-using-a-repository


