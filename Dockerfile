FROM debian:latest 
#ruby:2.2.3-slim

RUN apt-get update -qq \
    && apt-get upgrade \
    && apt-get dist-upgrade \
    && apt-get install -y sqlite3 \
      build-essential \
      libsqlite3-dev \
      libpq-dev \
      postgresql-client \
      tmux \
      lynx \
      iftop \
      nodejs  \
      figlet \
      vim \
      emacs-nox \
      git \
      tar \
      screenfetch \
      ruby-full \
    && apt-get clean 
#screenfetch
RUN gem update && \
    gem install bundler rails --no-user-install

COPY config/config_file.tgz /root/config_file.tgz

RUN cd /root \
    &&tar -xzvf config_file.tgz  \
    && chown root:root -Rvf .vimrc .vim .emacs .emacs.d \
    && rm ~/config_file.tgz

ENV RAILS_ROOT /var/www/rails

RUN mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT

EXPOSE 3000

#COPY ./src/Gemfile Gemfile

#COPY ./src/Gemfile.lock Gemfile.lock

#VOLUME $RAILS_ROOT 

RUN  echo '[ -f Gemfile ] && bundle install || echo "no Gemfile"' >> ~/.bashrc

#RUN  echo 'clear' >> ~/.bashrc
#RUN  echo 'echo "Rails - env :" | figlet ' >> ~/.profile
#RUN  echo 'echo "Rails - env :" | figlet ' >> /etc/motd 
#RUN  echo 'screenfetch' >>   ~/.profile

#CMD ["/bin/bash"]
#CMD ["/usr/bin/tmux"]


CMD ["bundle","exec","rails","server","-b","0.0.0.0"]]
