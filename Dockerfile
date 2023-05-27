FROM ruby:2.7.3
ARG ROOT="/myapp"
ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

WORKDIR ${ROOT}

RUN apt-get update; \
    apt-get install -y --no-install-recommends \
		  vim tzdata
RUN apt-get install -y nodejs npm && npm install n -g && n 14.21.3
RUN npm install --global yarn
RUN gem install bundler -v 2.2.16
RUN bundle config set --global force_ruby_platform true