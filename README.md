## mhubig/partkeepr docker image repository

This is the repository for the trusted builds of the [`mhubig/partkeepr`][0]
[partkeepr][2] docker image releases.

> The most resent version is: 1.2.2

To use it, you need to have a working [docker][3] installation. Start by running
the following command:

    $ docker run -d -p 80:80 --name partkeepr mhubig/partkeepr

Or to run it together with a MariaDB database container.

    $ docker-compose up

[0]: https://hub.docker.com/r/mhubig/partkeepr/
[1]: https://github.com/petervanderdoes/gitflow
[2]: http://www.partkeepr.org
[3]: https://www.docker.io
