# Dockerfile for BrickEvent

FROM ruby:1.9.3 as brick-event

LABEL maintainer="Thomas Herrmann <mail@thoherr.de>"

ARG APPUSER=brick-event
ARG APPBASEDIR=/brick-event

RUN useradd -U -m $APPUSER

# Prepare Application directory
RUN mkdir $APPBASEDIR
RUN mkdir -p $APPBASEDIR/tmp

RUN mkdir -p /log && chown -R $APPUSER:$APPUSER /log && ln -sf /log $APPBASEDIR
VOLUME /log

WORKDIR $APPBASEDIR

# Install Gemset
# This is done separately here, before the entire app is copied below
# so that normal changes to the app do not trigger re-installations
# of the entire Gemset
COPY .ruby-gemset .ruby-version Gemfile Gemfile.lock $APPBASEDIR/
RUN bundle install --system

# Copy Application
COPY . $APPBASEDIR/
RUN chown -R $APPUSER:$APPUSER $APPBASEDIR

# Switch to application user
USER $APPUSER

EXPOSE 3000
# ENTRYPOINT /bin/bash -l -c "RAILS_ENV=production rake db:migrate && rails server -b 0.0.0.0 Puma"
ENTRYPOINT /bin/bash -l -c "rake db:migrate && script/rails server -b 0.0.0.0"
