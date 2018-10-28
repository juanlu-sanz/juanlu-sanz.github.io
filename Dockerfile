FROM jekyll/jekyll:3.8.2

ARG DATE
ARG BRANCH=synced

WORKDIR /

RUN apk update
RUN apk add git --no-cache
RUN apk add nginx --no-cache
RUN apk add openrc --no-cache
RUN git clone https://github.com/juanlu-sanz/juanlu-sanz.github.io.git repo && \
    cd repo && \
    git checkout ${BRANCH} && \
    git pull origin ${BRANCH} && \
    echo ${DATE}

WORKDIR /repo

RUN chown -R jekyll /repo

RUN bundle
RUN mkdir /www /nginxconfigs && \
    adduser -D -g 'www' www && \
    chown -R www:www /var/lib/nginx && \
    chown -R www:www /www

#RUN cat _config.yml

RUN bundle exec jekyll build --destination /www

EXPOSE 80:8008

WORKDIR /nginxconfigs
RUN mkdir logs && touch access.log
COPY ./configs/nginx.conf /nginxconfigs
COPY ./configs/mime.types /nginxconfigs
RUN touch /repo/.jekyll-metadata
RUN chown -R jekyll /repo