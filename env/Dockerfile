FROM jekyll/jekyll:3.3.1

#Arguments
ARG DATE
ARG BRANCH=synced

WORKDIR /

#Updates and installs
RUN apk update
RUN apk add git --no-cache
RUN apk add nginx --no-cache
RUN apk add openrc --no-cache

#Cache bundle install
COPY ./Gemfile* /tmp/
RUN cat /tmp/Gemfile
WORKDIR /tmp
RUN bundle install

#RUN git clone https://github.com/juanlu-sanz/juanlu-sanz.github.io.git repo && \
#    cd repo && \
#    git checkout ${BRANCH} && \
#    git pull origin ${BRANCH} && \
#    echo ${DATE}
RUN mkdir /repo
COPY ./ /repo/

#Move to jekyll base folder and change owner
WORKDIR /repo
RUN chown -R jekyll /repo

#Nginx configs
RUN mkdir /www /nginxconfigs && \
    adduser -D -g 'www' www && \
    chown -R www:www /var/lib/nginx && \
    chown -R www:www /www

#Install all gems if not on cache (should be)
RUN bundle && \
    bundle install

#Convert jekyll files into static html content
RUN bundle exec jekyll build --destination /www

#EXPOSE 80:8008

WORKDIR /nginxconfigs
RUN mkdir logs && touch access.log
COPY ./configs/nginx.conf /nginxconfigs
COPY ./configs/mime.types /nginxconfigs
RUN touch /repo/.jekyll-metadata
RUN chown -R jekyll /repo