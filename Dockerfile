FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-add-repository -y ppa:fish-shell/release-3 && \
    apt-get update && \
    apt-get install -y fish jq python3 python3-pip docker.io docker-compose && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip3 install uvicorn pytest shell-gpt==0.9.4

# Set fish as the default shell
RUN chsh -s /usr/bin/fish

# Set the working directory
WORKDIR /root/.config/fish/functions
COPY *.fish .
COPY ./utils/*.fish .
WORKDIR /root/workspace
RUN apt-get install git
RUN git config --global guser.email "docker@gptalchemy.com"
RUN git config --global user.name "gptalchemy"


# Start fish shell
CMD ["fish"]

