
docker build --build-arg GIT_HASH=$(git log --format="%h" -1) --tag organizrtools/organizr-v2:minified .
