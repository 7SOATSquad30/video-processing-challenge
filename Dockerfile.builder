FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
&& apt-get install -y \
    curl \
    unzip \
    wget \
    python3.9 python3.9-venv python3.9-distutils \
    gnupg \
    less \
    make \
    zip \
    tar \
    software-properties-common

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python
RUN python --version && pip --version

RUN pip3 install awscli

RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list

RUN apt-get update && apt-get install terraform -y

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs

RUN pip3 install terraform-local

RUN rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash"]