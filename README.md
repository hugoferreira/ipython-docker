There are two redirected ports:

* **80**: running iPython in notebook mode
* **22**: running SSH

Place your public ssh key as `id_dsa.pub` in the same directory as the Dockerfile (or change it accordingly) before building with:

`docker build .`

To run the container:

`docker run -d -p 80 -p 22 ipython /sbin/my_init`

Use `docker ps` or `docker port <container> 80` to find out to which port it was mapped, and then open it in the browser. The same rationale applies for ssh'ing into the container.
