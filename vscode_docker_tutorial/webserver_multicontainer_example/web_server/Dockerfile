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
        curl \
        redis \
    # It is best practice with linux images
    # to clear the package list to reduce image size
    && rm -rf /var/lib/apt/lists/*

# Install python dependencies, no caching and tell pip that its okay to break the system installation (Without venv)
# RUN pip3 install --no-cache-dir --break-system-packages -r requirements.txt

# Alternatively, this is could be less error-prone in practice, without any cost in performance or size.
# Therefore, it is preferable to create a venv inside the container:

# Create and activate virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python dependencies in virtual environment
RUN pip install --no-cache-dir -r requirements.txt


# Copy the python script from current folder in host to container
COPY web_server.py .

# Copy Redis configuration
COPY src/redis.conf /etc/redis/redis.conf

# Copy startup script
COPY src/start.sh .
RUN chmod +x start.sh

# Command to run startup script on container run
CMD ["./start.sh"]