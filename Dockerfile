FROM jekyll/jekyll:3.3.1

ARG DATE

WORKDIR /

RUN apk update
RUN apk add git --no-cache
RUN apk add nginx --no-cache
RUN apk add openrc --no-cache
RUN git clone https://github.com/juanlu-sanz/juanlu-sanz.github.io.git repo && \
    cd repo && \
    git pull origin master && \
    echo ${DATE}

WORKDIR /repo

RUN bundle
RUN mkdir /www /nginxconfigs && \
    adduser -D -g 'www' www && \
    chown -R www:www /var/lib/nginx && \
    chown -R www:www /www

ARG BUILDVAR=sad 
RUN if [ "$BUILDVAR" == "SO"]; \
    then export SOMEVAR=hello; \
    else export SOMEVAR=world; \
    fi 

RUN bundle exec jekyll build --destination /www

EXPOSE 80:8008

WORKDIR /nginxconfigs
RUN mkdir logs && touch access.log
COPY ./configs/nginx.conf /nginxconfigs
COPY ./configs/mime.types /nginxconfigs
RUN touch /repo/.jekyll-metadata
RUN chown -R jekyll /repo
#CMD nginx -p . -c /nginxconfigs/nginx.conf

# $a = Get-Date; docker build --build-arg DATE=$a -t juanlu.is:0.1 .

# docker run juanlu.is:0.1