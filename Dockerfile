FROM ubuntu:trusty

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update; apt-get clean
RUN useradd apps
RUN mkdir -p /home/apps && chown apps:apps /home/apps

RUN apt-get install -y x11vnc
RUN apt-get install -y xvfb
RUN apt-get install -y fluxbox
RUN apt-get install -y wget
RUN apt-get install -y wmctrl
RUN apt-get install -y curl

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update && apt-get install -f
RUN apt-get -y install google-chrome-stable
RUN google-chrome --version

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 16.2.0

RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN node -v
RUN npm -v

COPY . .
EXPOSE 8080
RUN npm install

ENTRYPOINT ["npm", "run", "tests"]