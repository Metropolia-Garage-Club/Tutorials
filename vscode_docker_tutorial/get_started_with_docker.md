## Quick tutorial for docker with VSCode

###### Why use Docker?

A docker container is a minimal virtualized program containing a whole operating system and whatever you choose to install on it. This allows you to develop your project on any system and easily port or share it to others in a single file you can simply run like an executable.

In this guide I will also outline how cross-platform docker images work, that you can use to develop regardless of if you run it on ARM or X86 architecture. This is very useful if you want to build projects for the Nvidia Jetson or Raspberry Pi. 

###### Why in VSCode?

My personal preference is using VSCode for all projects involving coding as it is completely modular with the extension library. You can create and run docker containers and code all within VSCode. If you so wish, you can even SSH into the target computer (Like jetson) and use the container there so you never have to even physically touch the platform you wish to code for. This makes development extremely convenient because you can do all of it from a single interface and remotely.






### Pre-requisites

* [VSCode installation](https://code.visualstudio.com/download) (Just download and install)
* [Docker Desktop](https://docs.docker.com/desktop/)
* Basic knowledge of linux and command line use

Note that Docker Desktop runs its own Virtual Machine environment (Even on a linux installation) and causes
more overhead. If you prefer a minimal, but more involved installation and upkeep you can
install Docker Engine and Docker Compose separately. This option is only available on Linux.
It's not really worth doing this unless you want to do something extremely computation heavy, so I recommend saving yourself the headache.

If you need to develop for a resource-constrained target device like Raspberry Pi, I **DO** Recommend installing only the Docker Engine on that device. 
This gives you the ease-of-use and features of Desktop while developing, but removes the extra overhead on the target device where you only want to run the image.
More on this in chapter 8.

More info about Docker Engine can be found [here.](https://docs.docker.com/engine/)

#### 1. Getting started

Once you have both programs, open up VSCode and head to the extensions marketplace. 

Find:

* Dev Containers
* Docker

Install them. You should see a new tab added to VSCode with the Docker icon. If you open this tab, You can see the "Containers" and "Images" sections. This is essentially the same interface as in Docker Desktop GUI.

Docker engine needs to be running in the background. Make sure to start Docker Desktop. VSCode will now automatically hook up into the service.

##### Note for Windows/Mac:
*You may want to check that you are using Linux containers by default in Docker Desktop. Find the icon in your toolbar, right click and switch to Linux containers.*

#### 2. Short introduction Docker

##### Docker Terminology Guide
###### Core Concepts
##### Container
A lightweight, standalone, and executable software package that includes everything needed to run a piece of software: code, runtime, system tools, libraries, and settings. Think of it as a running instance of an image - like a running program created from its executable.
##### Image
A read-only template containing a set of instructions for creating a Docker container. It's like a snapshot or blueprint that contains all the necessary files, dependencies, and configurations needed to create a container. Similar to how a class is used to create objects in programming.
##### Dockerfile
A text file containing instructions for building a Docker image. It specifies the base image, adds additional components, and configures various settings. Think of it as a recipe that tells Docker how to create an image.
##### Docker Compose
A tool for defining and running multi-container Docker applications. The docker-compose.yml file is where you define your application's services, networks, and volumes in a declarative way. Think of it as a project configuration file that orchestrates multiple containers. 
Defining arguments in the compose file is the same as defining arguments in the CMD line upon running the container.

In short, a **Dockerfile** *builds* an **Image** to then *run* as a **Container**.

#### 3. Basic introduction to using Docker in VSCode

Follow Part 1 of this tutorial to see how docker works in practice in VSCode. Part 1 is short and shows you the general gist of how to build and run Docker containers in VSCode and introduces the very basics of navigating the UI.

[Docker tutorial for VSCode](https://learn.microsoft.com/en-us/visualstudio/docker/tutorials/docker-tutorial)

Afterword: 

In general, you work first in the regular editor in your workspace folder and when the container has been build you move to the Docker tab to run it. Then you can work within the container tab.

This is done by right-clicking the running container in VSCode and pressing either **"Attach Visual Studio Code"**

This will open a new VSCode instance which allows you to work within the folder structure of the running container instance in real-time.

Alternatively, you can use **"Attach Shell"** to open a CMD window in the existing VSCode window and use command line commands to do things.

Note that CMD functionality is base image dependent. In general with projects, you often build on Ubuntu base images which allows you to mess around in the running container instance as if you were in a linux CMD line, but this isn't always the case.

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

Note that the file does not have a filetype. Naming a file "Dockerfile" makes VSCode
automatically recognize it as such. You should preferably have this in the root folder of your project.

##### Essential Commands

###### FROM 
>FROM ubuntu:20.04

* Always the first non-comment instruction
* Specifies the base image to build upon
* Examples: python:3.9, node:14, ubuntu:20.04
* Downloaded from a docker image repository unless directory path specified (You should download it locally first for faster use)
* Architecture (ARM/x86) dependent (Check chapter 6 for instructions on multi-architecture containers)
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

# In case of ubuntu, many APT packages have suggested or 
# recommended dependencies.
# These usually get installed by default, but aren't required.
# It is worth disabling their installation
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

# Set working directory inside the image
WORKDIR /app

# Copy a python dependencies requirements.txt from host (better caching)
# Note the dot means 
# "to current working directory" (/app) in this context
COPY requirements.txt .

# Build image with needed project packages
# Since building is non-interactive, we have to disable pop-up dialogs
# As well as answer "yes" (-y) to all prompts during installation
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y \
        python3 \
        python3-pip \
        python3-venv \
    # It is best practice with linux images
    # to clear the package list to reduce image size
    && rm -rf /var/lib/apt/lists/*

# Create and activate virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python dependencies in virtual environment
RUN pip install --no-cache-dir -r requirements.txt

# Copy the python script from host to container
COPY app.py .

# Command to run the application on startup
CMD ["python", "app.py"]
```

In general, the building is non interactive so software you want to install within the container should always have the argument -y to skip yes/no prompts.

######  Best Practices

**General recommendation**
* Keep it simple and lightweight as possible. Consider breaking projects with lots of dependencies into multiple smaller containers, if possible. Docker Compose and multi-stage builds let you control this easily. More on those below.
* Consider pruning the final container to be used on target device of any tools and files you have needed for development (Development container vs Production container)

**Use Specific Base Image Tags**

* Use specific versions instead of 'latest'
* Ensures reproducible builds
* Prefer using purpose-specific images, eg. python base image if you only need to run python instead of running an entire ubuntu instance


**Layer Optimization**

* Combine related RUN commands with &&
* Place rarely changing instructions first (Speeds up building because of docker caching)
* Use [.dockerignore](https://www.geeksforgeeks.org/how-to-use-a-dockerignore-file/) for unnecessary files


**Cache Usage**

* Copy requirements files before other files
* Install dependencies before copying application code
* Order your Dockerfile commands from least to most frequently changing. This speeds up building during development.


[Multi-stage Builds](https://docs.docker.com/build/building/multi-stage/)

* Use for compiling applications
* Reduces final image size
* Separates build dependencies from runtime


**Security**

* Don't run as root when possible
* Use trusted base images

#### 5. Docker Compose

A docker compose yaml -file is used to specify multiple "services" that are run
after the container is spun up. This also makes it easy to orchestrate multiple containers
which can interact with each other. 

Specifying things like network access, ports etc. in CMD line window everytime you run a container is clunky. 
Hardware and network access as well as services and other things can be customized in the  docker-compose.yaml and this is the preferred way of doing things in VSCode.

The yaml -file should be in the same directory as your Dockerfile, and its name needs to be either
*compose.yaml* or *docker-compose.yaml*.


##### Example snippet of the structure of a Docker Compose yaml :
```yml
# The version of the Docker Compose file format
# '3.8' is used for modern Docker installations and supports the latest features
version: '3.8'

# 'services' defines the containers/applications that make up your project
# Each service will run in its own container
services:
  # 'web_server' is the name of our first service
  # This name is also used as:
  # - The DNS hostname in the Docker network
  # - The container name prefix (e.g., project_web_server_1)
  # - Reference for dependencies between services
  web_server:
    # 'build' specifies that this image should be built from source
    build: 
      # 'context' specifies where to find the build files (Dockerfile)
      # './' means the current directory
      # './web_server' means look in the web_server directory
      context: ./web_server
    
    # 'ports' maps container ports to host ports
    # Format is: "HOST_PORT:CONTAINER_PORT"
    # Here, port 5000 inside container is accessible on host's port 5000
    ports:
      - "5000:5000"

```
Tip: While making a docker-compose.yaml in VSCode you can press ctrl+space for intellisense to give you suggestion on available variables. Intellisense also gives you explanatory tooltips if you hover over the variable names. 

[About Docker Compose](https://docs.docker.com/compose/gettingstarted/)

[About Docker Compose in VSCode](https://code.visualstudio.com/docs/containers/docker-compose)

For more detailed look into docker compose, I have included a fully functional testing setup
in chapter 7.

Note that "context" also tells the script how to handle directory structure. You **can't** specify a parallel or upwards directory structure. You should not "share" dependencies between two folders.
Whatever a container needs, should be found below the Dockerfile in the directory.

However, you can set the build context to the top directory but then you have to specify the more accurate path to any files Dockerfile in any sub-folder wants to access. 



When you use a docker compose file, the building process changes a little. 
You must run the script, which will build the dockerfile.

To easily run the script, simply right-click on the file, scroll down and find
>Compose up

You can use "Select services" version to specify which parts of the compose file you want to run.
This can be useful for debugging.

When you want to close the containers, simply do the same as before, but choose
>Compose down

It is useful to occasionally run
```
docker system prune -f
```
In the CMD line to clear the docker cache. 

You can also find the small prune icon by hovering over the "Docker" and "Images" tab lines in VSCode. This way you can easily prune (remove) existing images from memory as well as cached containers.

More info on keeping [Docker clean](https://docs.docker.com/engine/manage-resources/pruning/).

#### 6. Qemu and Docker

QEMU (Quick Emulator) is a free and open-source machine emulator and virtualizer
that allows one CPU architecture to run code compiled for another architecture.
When compiling or testing code, for example, the Raspberry Pi, QEMU can be used to simulate an AArch64 (ARM) system on an x86 machine. This means that developers don’t need a real Raspberry Pi to compile and test code for it. This also works for other edge computing devices like Jetson.

In the context of Docker, this allows you to develop and compile docker containers based on images for ARM devices, significantly speeding up and easing development of code in projects.

Qemu is available for [Windows, Linux and MacOS.](https://www.qemu.org/download/) 

##### Qemu support is provided with docker desktop installation 
##### You should not need to do anything. However, if you want to test it:
```
docker run --platform=linux/arm64/v8 --rm -t arm64v8/ubuntu uname -m
```

You should see "aarch64" as result.

For non-desktop installation on linux machine, follow these instructions
[Docker multi-platform](https://docs.docker.com/build/building/multi-platform/)
[Building ARM Docker Containers on x86](https://www.stereolabs.com/docs/docker/building-arm-container-on-x86)
[More commands for testing](https://github.com/multiarch/qemu-user-static)

###### Note on Jetsons:

As stated in chapter 4, Jetson devices run their own ARM tegra -based ubuntu operating systems.
They have their own compatible [Docker images](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-base).
These function like regular ubuntu images, but have support for Jetson specific features like GPIO control, Jetpack etc. You should always prefer these when developing for the Jetson.
Qemu in Docker handles emulation, but for specific project related things like using GPIO pins you may have to write your own "emulation" scripts for testing.

#### 7. Putting it all together

During the making of this document, I have created and included a multi-container setup with commented scripts, if you need more indepth look into how a docker project should work or how to actually
use docker compose. 
The files are found in the example folder on [Metropolia Garage Club Github](https://github.com/Metropolia-Garage-Club/Tutorials).

The code examples for Dockerfile and Docker Compose shown before are used in it and there are added functionalities with comments. I recommend checking it out!
Simply run the compose file in VSCode. 


That concludes it for using Docker in VSCode. In the next chapter, i will briefly go over on how to set up SSH in VSCode and also how to use it to copy and run docker containers on the target machine easily.


#### 8. SSH, VSCode and Docker

###### Pre-requisites
* Make sure you have an [OpenSSH compatible client installed](https://code.visualstudio.com/docs/remote/troubleshooting#_installing-a-supported-ssh-client)
* Head to the VSCode extensions marketplace and find and install "Remote-SSH Extension"

You should see a new tab called "Remote Explorer". This is where you connect from to your target device. You need to make sure that the device you want to connect to has SSH enabled. 

The assumption in this chapter is that your target device (Where you want to SSH to) is running an ARM -based microprocessor and an Ubuntu based OS. This will in all likelihood be by far the majority of your use cases.

Check online for guide how to set up SSH Server on target device running another OS. Here is a link for instructions for [Windows](https://gist.github.com/teocci/5a96568ab9bf93a592d7a1a237ebb6ea).

###### You need to set up the following things on the target device locally:

The device needs to be on the same network as your PC. It should preferably have a static IP address set. VSCode will remember the connection and you can simply login again later by clicking on the device in the Remote Explorer.

Later on you may look into setting up a VPN like Netbird to allow you to SSH even across the internet using custom DNS names!

On a target device running Ubuntu, you must enable:

Settings -> System -> Secure Shell

###### Setup Docker for running containers:

Install [Docker Engine](https://docs.docker.com/engine/install/) on the device. No need for Desktop or Compose. As said before, you simply want to run containers without VM overhead. You don't need to build them on the target.

Finally, you are ready to develop remotely!

In Remote Explorer, you can see the "Remotes" Tab on the top-left.

If you right click on it, you can choose "New Remote". Alternatively, open the CMD line in VSCode with Ctrl+J.

The command you use to log in remotely to a computer via SSH is of the format:

```
ssh username@ip_address
```

TODO:

docker image copying
SSH use in VSCODE.



# TODO
* Clean grammar
* Comment and clean redis/flask code
* Add SSH instructions VSCode
* Add instructions to copy docker image over SSH to target
https://stackoverflow.com/questions/23935141/how-to-copy-docker-images-from-one-host-to-another-without-using-a-repository


