#################################################################################################
FROM gcr.io/deeplearning-platform-release/workbench-container:latest

### for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
       apt-get install -y --no-install-recommends apt-utils && \
       apt-get install -y sudo && \
       apt-get install -y libssl-dev pkg-config && \
       apt-get install -y python3-pip && \
       apt-get install -y procps && \
       apt-get install -y curl && \
       apt-get update

RUN echo "tzdata tzdata/Areas select Europe" > /tmp/preseed.txt; \
    echo "tzdata tzdata/Zones/Europe select Stockholm" >> /tmp/preseed.txt; \
    debconf-set-selections /tmp/preseed.txt && \
    apt-get update && \
    apt-get install -y git golang-go

########################################################################################################
# Install GCLOUD
########################################################################################################
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz

# Installing the package
RUN mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin    

#########################################################################################################
# AVML
# Install MUSL
RUN sudo apt-get install musl-dev musl-tools musl

# Install rustup
RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- --default-toolchain stable -y && \
    /root/.cargo/bin/rustup update beta && \
    /root/.cargo/bin/rustup update nightly

ENV PATH=/root/.cargo/bin:$PATH

RUN git clone https://github.com/microsoft/avml.git
WORKDIR /avml
#To configure your current shell, run:
#source $HOME/.cargo/env

RUN rustup target add x86_64-unknown-linux-musl
RUN cargo build --release --target x86_64-unknown-linux-musl
#########################################################################################################