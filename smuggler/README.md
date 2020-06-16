# smuggler Dockerfile #

This is a Dockerfile for @defparam's smuggler tool (https://github.com/defparam/smuggler).
Build with:
```
git clone https://github.com/defparam/smuggler
cp Dockerfile smuggler/
cd smuggler
docker build . -t <your-name>/smuggler
```

Run with:
```
docker run --rm -it -v $PWD:/smuggler/payloads <your-name>/smuggler -u <URL>
```
* your current directory will be mounted as /smuggler/payloads in the container (work dir)
* default container entrypoint is to run smuggler, just provide flags when running

If you'd rather drop into shell and run smuggler from there:
```
docker run --rm -it -v $PWD:/smuggler/payloads --entrypoint /bin/bash <your-name>/smuggler
```