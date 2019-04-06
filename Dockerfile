FROM ubuntu:16.04

# Set the locale
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get install -y \
    software-properties-common \
    python-software-properties
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update -y
RUN apt-get install -y \
	vim \
	git \
	curl \
	wget \
	php7.1 \
	php7.1-common \
	php7.1-curl \
	php7.1-xml \
	php7.1-zip \
	php7.1-gd \
	php7.1-mysql \
	php7.1-mbstring

RUN a2dissite 000-default
COPY app_vhost.conf /etc/apache2/sites-available/
RUN a2ensite app_vhost

EXPOSE 80 443

RUN mkdir /unison
RUN mkdir -p /home/webapp

RUN ln -s /unison /home/webapp/htdocs

RUN mkdir /unison/public
COPY index.php /unison/public/

VOLUME /unison
WORKDIR /unison

COPY app_start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/app_start.sh


CMD ["/usr/local/bin/app_start.sh"]