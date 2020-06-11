FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y git wget

RUN mkdir /output
VOLUME ["/output"]

RUN git clone https://github.com/FortyNorthSecurity/EyeWitness.git
WORKDIR /EyeWitness/Python/setup
RUN ./setup.sh
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /output
ENTRYPOINT ["/EyeWitness/Python/EyeWitness.py"]