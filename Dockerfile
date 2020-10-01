FROM organizr/organizr:latest AS build

RUN apk add --quiet nodejs yarn util-linux

COPY package.json yarn.lock /build/www/Dashboard/
RUN cd /build/www/Dashboard \
  && yarn --no-progress

COPY . /build/www/Dashboard
RUN cd /build/www \
  && ln -s Dashboard/plugins . \
  && cd Dashboard \
  && yarn run gulp \
  && yarn run build

FROM organizr/organizr:latest

COPY docker/30-install /etc/cont-init.d/
COPY docker/v2-master-hash.txt /minified/git_hash
COPY --from=build /build/www/Dashboard/assets /minified/assets
COPY --from=build /build/www/Dashboard/index.php /minified/

