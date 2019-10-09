FROM organizrtools/organizr-v2:latest AS build

RUN apk add --quiet nodejs yarn util-linux

COPY package.json yarn.lock /config/www/Dashboard/
RUN cd /config/www/Dashboard \
  && yarn --no-progress

COPY . /config/www/Dashboard
RUN cd /config/www \
  && ln -s Dashboard/plugins . \
  && cd Dashboard \
# not entirely sure why i have to run yarn again here
  && yarn --no-progress \
  && yarn run gulp \
  && yarn run build

FROM organizrtools/organizr-v2:latest

ARG GIT_HASH

COPY docker/30-install /etc/cont-init.d/
COPY --from=build /config/www/Dashboard/assets /minified/assets
COPY --from=build /config/www/Dashboard/index.php /minified/
RUN echo "$GIT_HASH" > /minified/git_hash
