# Generated by precisionFDA exporter (v1.0.3) on 2018-06-14 04:24:50 +0000
# The asset download links in this file are valid only for 24h.

# Exported app: ga4gh-streaming-freebayes, revision: 2, authored by: mike.lin
# https://precision.fda.gov/apps/app-F00VFxj0Xjy947bqvxjyZfFF

# For more information please consult the app export section in the precisionFDA docs

# Start with Ubuntu 14.04 base image
FROM ubuntu:14.04

# Install default precisionFDA Ubuntu packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
	aria2 \
	byobu \
	cmake \
	cpanminus \
	curl \
	dstat \
	g++ \
	git \
	htop \
	libboost-all-dev \
	libcurl4-openssl-dev \
	libncurses5-dev \
	make \
	perl \
	pypy \
	python-dev \
	python-pip \
	r-base \
	ruby1.9.3 \
	wget \
	xz-utils

# Install default precisionFDA python packages
RUN pip install \
	requests==2.5.0 \
	futures==2.2.0 \
	setuptools==10.2

# Add DNAnexus repo to apt-get
RUN /bin/bash -c "echo 'deb http://dnanexus-apt-prod.s3.amazonaws.com/ubuntu trusty/amd64/' > /etc/apt/sources.list.d/dnanexus.list"
RUN /bin/bash -c "echo 'deb http://dnanexus-apt-prod.s3.amazonaws.com/ubuntu trusty/all/' >> /etc/apt/sources.list.d/dnanexus.list"
RUN curl https://wiki.dnanexus.com/images/files/ubuntu-signing-key.gpg | apt-key add -

# Update apt-get
RUN DEBIAN_FRONTEND=noninteractive apt-get update

# Download app assets
RUN curl https://dl.dnanex.us/F/D/534qXXP9B1XbXJ1kxbfP00BjP6Vzj4V0FbPGBv06/htslib-1.3.tar.gz | tar xzf - -C / --no-same-owner --no-same-permissions
RUN curl https://dl.dnanex.us/F/D/XXPg94fxb6yyZ28qXJFK6xb11j5GBJvV6b2zZk3F/pfda-docker-20161014.tar.gz | tar xzf - -C / --no-same-owner --no-same-permissions

# Download helper executables
RUN curl https://dl.dnanex.us/F/D/0K8P4zZvjq9vQ6qV0b6QqY1z2zvfZ0QKQP4gjBXp/emit-1.0.tar.gz | tar xzf - -C /usr/bin/ --no-same-owner --no-same-permissions
RUN curl https://dl.dnanex.us/F/D/bByKQvv1F7BFP3xXPgYXZPZjkXj9V684VPz8gb7p/run-1.2.tar.gz | tar xzf - -C /usr/bin/ --no-same-owner --no-same-permissions

# Write app spec and code to root folder
RUN ["/bin/bash","-c","echo -E \\{\\\"spec\\\":\\{\\\"input_spec\\\":\\[\\{\\\"name\\\":\\\"samples\\\",\\\"class\\\":\\\"string\\\",\\\"optional\\\":false,\\\"label\\\":\\\"samples\\\",\\\"help\\\":\\\"space-separated\\ list\\ of\\ samples\\ to\\ call\\\",\\\"default\\\":\\\"NA12878\\ NA12891\\ NA12892\\\"\\},\\{\\\"name\\\":\\\"endpoint\\\",\\\"class\\\":\\\"string\\\",\\\"optional\\\":false,\\\"label\\\":\\\"endpoint\\\",\\\"help\\\":\\\"GA4GH\\ Streaming\\ API\\ endpoint\\\",\\\"default\\\":\\\"http://htsnexus.rnd.dnanex.us/v1/reads\\\"\\},\\{\\\"name\\\":\\\"namespace\\\",\\\"class\\\":\\\"string\\\",\\\"optional\\\":false,\\\"label\\\":\\\"namespace\\\",\\\"help\\\":\\\"GA4GH\\ Streaming\\ API\\ path\\\",\\\"default\\\":\\\"BroadHiSeqX_b37\\\"\\},\\{\\\"name\\\":\\\"chromosome\\\",\\\"class\\\":\\\"string\\\",\\\"optional\\\":true,\\\"label\\\":\\\"chromosome\\\",\\\"help\\\":\\\"Run\\ on\\ this\\ chromosome\\ only\\ \\(1-22/X/Y\\)\\\"\\},\\{\\\"name\\\":\\\"output_name\\\",\\\"class\\\":\\\"string\\\",\\\"optional\\\":false,\\\"label\\\":\\\"output_name\\\",\\\"help\\\":\\\"How\\ to\\ name\\ the\\ output\\ VCF\\ file\\\",\\\"default\\\":\\\"trio\\\"\\}\\],\\\"output_spec\\\":\\[\\{\\\"name\\\":\\\"vcf\\\",\\\"class\\\":\\\"file\\\",\\\"optional\\\":false,\\\"label\\\":\\\"vcf\\\",\\\"help\\\":\\\"bgzipped\\ VCF\\ file\\\"\\}\\],\\\"internet_access\\\":true,\\\"instance_type\\\":\\\"baseline-16\\\"\\},\\\"assets\\\":\\[\\\"file-BpBq6GQ0qVb40z0FGk4ZYjkY\\\",\\\"file-F00Q2K809YXqp626jjKB5P7Y\\\"\\],\\\"packages\\\":\\[\\]\\} \u003e /spec.json"]
RUN ["/bin/bash","-c","echo -E \\{\\\"code\\\":\\\"if\\ \\[\\ -n\\ \\\\\\\"\\$chromosome\\\\\\\"\\ \\]\\;\\ then\\\\n\\ \\ chromosome\\=\\\\\\\"-c\\ \\$chromosome\\\\\\\"\\\\nfi\\\\noutput_filename\\=\\\\\\\"\\$\\{output_name\\}.vcf.gz\\\\\\\"\\\\n\\\\npfda-docker\\ run\\ --entrypoint\\ /app/main.sh\\ dnamlin/ga4gh-streaming-freebayes\\ \\$chromosome\\ \\\\\\\"\\$endpoint\\\\\\\"\\ \\\\\\\"\\$namespace\\\\\\\"\\ \\$samples\\ \\\\\\\\\\\\n\\ \\ \\|\\ bgzip\\ -c\\ \\\\u003e\\ \\\\\\\"\\$output_filename\\\\\\\"\\\\n\\ \\ \\\\nemit\\ vcf\\ \\\\\\\"\\$output_filename\\\\\\\"\\\\n\\\"\\} | python -c 'import sys,json; print json.load(sys.stdin)[\"code\"]' \u003e /script.sh"]

# Create directory /work and set it to $HOME and CWD
RUN mkdir -p /work
ENV HOME="/work"
WORKDIR /work

# Set entry point to container
ENTRYPOINT ["/usr/bin/run"]

VOLUME /data
VOLUME /work