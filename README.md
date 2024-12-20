# centos-vnc container

This is this source code repository for the headless el8 and el9 xfce container
[quay.io/l3o/centos-xfce-vnc](https://quay.io/l3o/centos-xfce-vnc).

Currently the following el8 and el9 versions are supported:

* CentOS Stream 8 (``stream8``)
* CentOS Stream 9 (``stream9``)
* Rocky Linux 8 (``rockylinux8``)
* Rocky Linux 9 (``rockylinux9``)

## volumes

* ``/config`` - directory containing additional resources, e.g. background
  images - **optional**

## environment variables

* ``USER_ID`` - arbitrary user id used for the xfce session (default: 10000)
* ``USER`` - arbitrary username for the xfce session (default: container)
* ``VNCPASSWD`` - password for vnc connection (default: pod.VNC)
* ``VNCRESOLUTION`` - vnc screen resolution (default: 1280x720)
* ``BACKGROUND`` - path to background image in the container, e.g.
* ``DESKTOP`` - path to directory containing .desktop files in the container
  (default: ``/config/desktop``)

## examples

This image provides a run label to start the container. To display the
corresponding command please use

    $ podman container runlabel --display run quay.io/l3o/centos-xfce-vnc

whereas

    $ podman container runlabel run quay.io/l3o/centos-xfce-vnc

actually executes the runlabel ``run``. The default runlabel will publish
the internal vnc port ``5901`` to a random port on the host.

In order to specify a custom background image a directory may be mounted to
``/config`` into the container and the full qualified path to the image must
be provided using the ``BACKGROUND`` environment.

    $ podman run --rm -p 5901:5901 \
                 --cap-drop=all --cap-add=chown --cap-add=setuid \
                 --cap-add=setgid --cap-add=setpcap --cap-add=audit_control \
                 --cap-add=dac_override --cap-add=fowner \
                 -v /tmp/bg:/config:ro -e BACKGROUND=/config/custom-bg.png \
                 --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro -d \
                 quay.io/l3o/centos-xfce-vnc:latest
## License

GPLv3+

## Author Information

Christian Felder
