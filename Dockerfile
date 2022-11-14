FROM ubuntu:20.04

# Install basic packages
RUN apt update
RUN apt install gnupg git curl make g++ pip -y

# Add apt repo for: nodejs, yarn, and postgresql
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -E -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN curl -sS https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update

# Install nodejs, yarn, and postgresql
RUN apt install nodejs -y
RUN apt install yarn -y
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install postgresql-14 postgresql-contrib libpq-dev

EXPOSE 3000 4000 5432