# partkeepr docker image

This is the source repository for the trusted builds of the [`mhubig/partkeepr`][0] docker image releases. For more information on PartKeepr check out the [website][1].

> The most resent version is: 1.4.0-8

To use it, you need to have a working [docker][2] installation. Start by running
the following command:

```shell
docker run -d -p 80:80 --name partkeepr mhubig/partkeepr
```

Or clone the repo and run it together with a MariaDB database container.

```shell
git clone https://github.com/mhubig/docker-partkeepr.git
cd docker-partkeepr
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

## HOWTO manually build the docker image

```shell
make tag
docker-compose up
```

## HowTo create a new release

Since I have switched to [GitHub Flow][3], releasing is now quite simple. Ensure you are on master, bump the version number and push:

```shell
./bump-version.sh 1.4.0-2
git push --follow-tags
```

[0]: https://hub.docker.com/r/mhubig/partkeepr/
[1]: http://www.partkeepr.org
[2]: https://www.docker.com
[3]: https://guides.github.com/introduction/flow/
