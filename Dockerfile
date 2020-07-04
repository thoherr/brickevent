# Dockerfile for BrickEvent

FROM ruby:2.2 as brickevent

LABEL maintainer="Thomas Herrmann <mail@thoherr.de>"

# Install netcat for our startup script
RUN apt-get update && apt-get -y install netcat && apt-get clean

ARG APPUSER=brickevent
ARG APPBASEDIR=/brickevent

RUN useradd -U -m $APPUSER

# Prepare Application directory
RUN mkdir $APPBASEDIR

WORKDIR $APPBASEDIR

# Install Gemset
# This is done separately here, before the entire app is copied below
# so that normal changes to the app do not trigger re-installations
# of the entire Gemset
COPY .ruby-gemset .ruby-version Gemfile Gemfile.lock $APPBASEDIR/
RUN bundle install

# Copy Application
COPY . $APPBASEDIR/

# create tmp and log dirs if neccessary
RUN mkdir -p $APPBASEDIR/tmp && mkdir -p $APPBASEDIR/log

# adjust permissions
RUN chown -R $APPUSER:$APPUSER $APPBASEDIR

# Switch to application user
USER $APPUSER

EXPOSE 3000
ENTRYPOINT /bin/bash -l -c startup/startup.sh
