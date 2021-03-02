# Dockerfile for BrickEvent

FROM ruby:2.7 as brickevent

LABEL maintainer="Thomas Herrmann <mail@thoherr.de>"

# Install google chrome for system tests and netcat for our startup script
RUN curl -sS https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update \
 && apt-get install -y google-chrome-stable --no-install-recommends \
 && apt-get install -y netcat \
 && apt-get install -yqq unzip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install chromedriver
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

ARG APPUSER=brickevent
ARG APPBASEDIR=/brickevent

RUN useradd -u 300 -U -m $APPUSER

# groups for using chrome (not really sure if this is neccessary, but it doesn't hurt)
RUN usermod -G audio,video $APPUSER

# Prepare Application directory
RUN mkdir $APPBASEDIR

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
RUN rm -rf $APPBASEDIR/.git $APPBASEDIR/tmp $APPBASEDIR/log $APPBASEDIR/docker

# recreate tmp and log dirs
RUN mkdir -p $APPBASEDIR/tmp && mkdir -p $APPBASEDIR/log

# adjust permissions
RUN chown -R $APPUSER:$APPUSER $APPBASEDIR

# Set options for chrome via wrapper script to make Rails system test setup easier
RUN rm /usr/bin/google-chrome \
 && echo "/usr/bin/google-chrome-stable --headless --disable-gpu --no-sandbox \$@" > /usr/bin/google-chrome \
 && chmod +x /usr/bin/google-chrome

# Switch to application user
USER $APPUSER

# Set bundle path for app user (otherwise the gems would not be found)
RUN bundle config set path '/usr/local/bundle'

# set display port to avoid crash
ENV DISPLAY=:99

EXPOSE 3000
ENTRYPOINT /bin/bash -l -c startup/startup.sh
