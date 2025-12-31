FROM debian:stable-slim

RUN apt-get update && apt-get upgrade -y

RUN apt-get install gnucobol -y
RUN apt-get install git -y
RUN apt-get install -y libxml2 libxml2-dev

WORKDIR /workspace

ARG GIT_USER_NAME="Ryan Murphy"
ARG GIT_USER_EMAIL="ryan.murphy@rychannel.com"

RUN git config --global user.name "$GIT_USER_NAME" \
 && git config --global user.email "$GIT_USER_EMAIL"

CMD ["/bin/bash"]