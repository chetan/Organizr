FROM organizrtools/organizr-v2:latest AS build

RUN apk add --quiet nodejs yarn util-linux

COPY package.json yarn.lock /build/www/Dashboard/
RUN cd /build/www/Dashboard \
  && yarn --no-progress

COPY . /build/www/Dashboard
RUN cd /build/www \
  && ln -s Dashboard/plugins . \
  && cd Dashboard \
# not entirely sure why i have to run yarn again here
  && yarn --no-progress \
  && yarn run gulp \
  && yarn run build

FROM organizrtools/organizr-v2:latest

COPY docker/30-install /etc/cont-init.d/
COPY docker/v2-master-hash.txt /minified/git_hash
COPY --from=build /build/www/Dashboard/assets /minified/assets
COPY --from=build /build/www/Dashboard/index.php /minified/

