# partkeepr docker image

This is the source repository for the trusted builds of the [`mhubig/partkeepr`][0]
docker image releases. For more information on PartKeepr check out the [website][1].

> The most resent version is: 1.4.0-18

To use it, you need to have a working [docker][2] installation. Start by cloning the
repo and running the following commands:

```shell
export PARTKEEPR_OKTOPART_APIKEY=0123456 # optional, get one here https://octopart.com
docker-compose up # add -d to run in deamon mode
```

This will start PartKeepr and a preconfigured MariaDB database container.

> To get a list of all supported PARTKEEPR_ environment variables go to the file
> [`mkparameters`][3], starting at line 15.

Now open the partkeepr setup page (e.g.: http://localhost:8080/setup) and follow the
instructions. To get the generated authentikation key execute the following command:

```shell
docker-compose exec partkeepr cat app/authkey.php
```

The default database parameters are:

<img src="https://raw.githubusercontent.com/mhubig/docker-partkeepr/master/setupdb.png" width="500">

## Howto manually build & run the docker image

```shell
docker build -t mhubig/partkeepr:latest --rm .
docker run -d -p 8080:80 --name partkeepr mhubig/partkeepr
```

## Howto create a new release

Since I have switched to [GitHub Flow][4], releasing is now quite simple.
Ensure you are on master, bump the version number and push:

```shell
./bump-version.sh 1.4.0-18
git push && git push --tags
```

## Docker Image CI/CD Pipeline

This git repo is connected to a build Pipeline at https://hub.docker.com. A new
Image is build for every Tag pushed to this repo. The images are taged with a
version number (e.g. `1.4.0-18`) and `latest`.

[0]: https://hub.docker.com/r/mhubig/partkeepr/
[1]: http://www.partkeepr.org
[2]: https://www.docker.com
[3]: https://github.com/mhubig/docker-partkeepr/blob/master/mkparameters#L15
[4]: https://guides.github.com/introduction/flow/
