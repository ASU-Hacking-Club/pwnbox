# pwnbox
pwnbox is a dockerized environment for quick reversing and pwning. Essentially, a command line VM for pwning. 

## Installation
Install [Docker](https://docs.docker.com/v17.12/install/).
Since Docker is compatible with Windows, Linux, and OS X--with some caveats.
Once installed, run:
```bash
docker pull pwndevils/pwnbox
```

## Usage
pwnbox follows all the same rules as a normal docker container.
To run pwnbox:
```bash
docker run -it --rm pwndevils/pwnbox
```
which will start the container, and delete it after usage.

### Mounting Volumes
Often, we want to save data generated in pwnbox or simply use data stored on our host machine.
To mount a volume from your host computer into pwnbox do:
```bash
docker run -it --rm -v /path/in/host/:/path/in/pwnbox/ pwndevils/pwnbox
``` 


