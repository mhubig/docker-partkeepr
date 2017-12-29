# partkeepr docker image

This is the source repository for the trusted builds of the [`mhubig/partkeepr`][0] docker image releases. For more information on PartKeepr check out the [website][1].

> The most resent version is: 1.3.0

To use it, you need to have a working [docker][2] installation. Start by running
the following command:

    $ docker run -d -p 80:80 --name partkeepr mhubig/partkeepr

Or to run it together with a MariaDB database container.

    $ docker-compose up

Now go to the partkeepr setup page (e.g.: http://localhost/setup) and follow the directions. To get the authentikation key you can use something like:

    $ docker exec -it partkeepr cat app/authkey.php

or

    $ docker-compose exec -it partkeepr cat app/authkey.php

The default database parameters are:

![Database Parameters](https://raw.githubusercontent.com/mhubig/docker-partkeepr/master/setupdb.png "Database Parameters")

## HOWTO manually build the docker image

    $ make tag
    $ docker-compose up

[0]: https://hub.docker.com/r/mhubig/partkeepr/
[1]: http://www.partkeepr.org
[2]: https://www.docker.com
