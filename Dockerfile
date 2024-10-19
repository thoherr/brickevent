# Dockerfile for BrickEvent

FROM ruby:3.2 as brickevent

ARG APPUSER=brickevent
ARG APPBASEDIR=/$APPUSER

LABEL maintainer="Thomas Herrmann <mail@thoherr.de>"

# Install netcat for our startup script
RUN apt-get update && apt-get -y install netcat-traditional && apt-get clean

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update \
 && apt-get install -y libsqlite3-dev nodejs yarn --no-install-recommends \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -u 300 -U -d $APPBASEDIR -m $APPUSER

WORKDIR $APPBASEDIR

# Install Gemset
# This is done separately here, before the entire app is copied below
# so that normal changes to the app do not trigger re-installations
# of the entire Gemset
COPY Gemfile Gemfile.lock $APPBASEDIR/
RUN bundle config set path '/usr/local/bundle'
RUN bundle install

# Copy Application
COPY . $APPBASEDIR/

# do some cleanup
RUN rm -rf $APPBASEDIR/.git* $APPBASEDIR/.idea $APPBASEDIR/tmp $APPBASEDIR/log

# recreate tmp and log dirs
RUN mkdir -p $APPBASEDIR/tmp && mkdir -p $APPBASEDIR/log

RUN chown -R $APPUSER:$APPUSER $APPBASEDIR

# groups for using chrome (not really sure if this is neccessary, but it doesn't hurt)
RUN usermod -G audio,video $APPUSER

# Switch to application user
USER $APPUSER

# Set bundle path for app user (otherwise the gems would not be found)
RUN bundle config set path '/usr/local/bundle'

# Install yarn packages for app user
RUN yarn install --check-files

EXPOSE 3000
CMD /bin/bash -l -c startup/startup.sh
