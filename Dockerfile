FROM ubuntu:18.04

RUN apt-get update && \
    apt-get -y install \
    nginx \
    unzip \
    wget \
    ca-certificates \
    php7.2 php7.2-fpm php7.2-cli php7.2-json php7.2-mysql php7.2-curl

ENV PAGEKIT_VERSION 1.0.18
RUN mkdir /pagekit
WORKDIR /pagekit
VOLUME ["/pagekit/storage", "/pagekit/app/cache"]

RUN wget https://github.com/pagekit/pagekit/releases/download/$PAGEKIT_VERSION/pagekit-$PAGEKIT_VERSION.zip -O /pagekit/pagekit.zip && \
    unzip /pagekit/pagekit.zip && rm /pagekit/pagekit.zip

ADD nginx.conf /etc/nginx/nginx.conf

RUN chown -R www-data: /pagekit && \
    apt-get autoremove wget unzip -y && \
    apt-get autoclean -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["sh", "-c", "service php7.2-fpm start && nginx"]
