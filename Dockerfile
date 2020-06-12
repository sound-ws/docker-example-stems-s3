FROM zenko/cloudserver:latest

COPY wav /bucket-data

# Install Python.
RUN apt-get update && \
    apt-get install -y python python-dev python-pip python-virtualenv && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y netcat

# Install aws cli
RUN pip install awscli --upgrade --user
ENV PATH=/root/.local/bin:$PATH

COPY scripts /scripts

# Or the s3 server not work properly
ENV REMOTE_MANAGEMENT_DISABLE=1

# Make sure data stays in image
RUN mkdir -p /s3data/data && mkdir -p /s3data/meta
ENV S3DATAPATH="/s3data/data"
ENV S3METADATAPATH="/s3data/meta"

# Load data and cleanup
RUN /scripts/load_data && rm -rf /bucket-data
