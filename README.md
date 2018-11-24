# partkeepr docker image

This is the source repository for the trusted builds of the [`mhubig/partkeepr`][0] docker image releases. For more information on PartKeepr check out the [website][1].

> The most resent version is: 1.4.0-11

To use it, you need to have a working [docker][2] installation. Start by running
the following command:

```shell
export PARTKEEPR_OKTOPART_APIKEY=0123456
docker run -d -p 80:80 -e PARTKEEPR_OKTOPART_APIKEY --name partkeepr mhubig/partkeepr
```

Or clone the repo and run it together with a MariaDB database container.

```shell
git clone https://github.com/mhubig/docker-partkeepr.git
cd docker-partkeepr
export PARTKEEPR_OKTOPART_APIKEY=0123456
docker-compose up
```

Now go to the partkeepr setup page (e.g.: http://localhost/setup) and follow the directions. To get the authentikation key you can use something like:

```shell
docker exec -it partkeepr cat app/authkey.php
```

or

```shell
docker-compose exec partkeepr cat app/authkey.php
```

The default database parameters are:

![Database Parameters](https://raw.githubusercontent.com/mhubig/docker-partkeepr/master/setupdb.png "Database Parameters")

## Howto manually build and tag the docker image

```shell
make build tag
```

## Howto create a new release

Since I have switched to [GitHub Flow][3], releasing is now quite simple. Ensure you are on master, bump the version number and push:

```shell
./bump-version.sh 1.4.0-10
git push --follow-tags
```

[0]: https://hub.docker.com/r/mhubig/partkeepr/
[1]: http://www.partkeepr.org
[2]: https://www.docker.com
[3]: https://guides.github.com/introduction/flow/
