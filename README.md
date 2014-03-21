## mhubig/partkeepr docker image repository

This is the repository for the trusted builds of the `mhubig/partkeepr` docker
image. Releases are made with the help of [git-flow (AVH Edition)][1] and keept
in sync with the [partkeepr][2] releases.

To use it, you need to have a working [docker][3] installation. Than run the
following command:

    $ docker run -d -p 8080:80 --name partkeepr mhubig/partkeepr:0.1.9-1

[1]: https://github.com/petervanderdoes/gitflow
[2]: http://www.partkeepr.org
[3]: https://www.docker.io
