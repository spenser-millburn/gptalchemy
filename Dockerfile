FROM python:3.10

# Install dependencies
RUN apt-get update && \
    apt-get install -y fish jq  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip3 install uvicorn pytest 

# Set fish as the default shell
RUN chsh -s /usr/bin/fish
RUN pip3 install shell-gpt==1.4.4


# Set the working directory
WORKDIR /root/.config/fish/functions
COPY *.fish .
COPY ./utils/*.fish .

WORKDIR /root/workspace

# Set environment variable for OpenAI API Key
ENV OPENAI_API_KEY=${OPENAI_API_KEY}

# Start fish shell
CMD ["fish"]

