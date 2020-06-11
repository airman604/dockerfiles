# EyeWitness Dockerfile #

Build with:
```
docker build . -t <your-name>/eyewitness
```

Run with:
```
docker run --rm -it -v $PWD:/output <your-name>/eyewitness --single www.google.com -d ./google
```
* your current directory will be mounted as /output in the container (work dir)
* output will be saved under ./google/ directory (-d flag)
* default container entrypoint is to run EyeWitness, just provide flags when running

If you'd rather drop into shell and run EyeWitness from there (EyeWitness.py will be in /EyeWitness/Python):
```
docker run --rm -it -v $PWD:/output --entrypoint /bin/bash <your-name>/eyewitness
```