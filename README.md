# atheme-docker

[![Build Status](https://drone.overdrivenetworks.com/api/badges/overdrivenetworks/atheme-docker/status.svg)](https://drone.overdrivenetworks.com/overdrivenetworks/atheme-docker)

This is an unofficial Docker image for [Atheme IRC Services](https://github.com/atheme/atheme), based off of Alpine and built weekly.

## Maintenance notice

**2022-09 update: This repository is not actively maintained and will NOT be updated past Atheme 7.2.x. If you'd like to take over maintenance with a fork and have it mentioned here, please get in touch with @jlu5.**

## Usage

First, write your desired `atheme.conf` and copy `services.db` (if you have one) into an empty directory. Make sure it is writable by **UID 10000** (or rebuild the image with your desired UID - see Build Arguments below)

```
$ docker run -v /path/to/services/data:/atheme/etc ovdnet/atheme
```

### Supported tags

- You can use the `latest` tag (which points to the [latest release built from this repository](/.drone.jsonnet)), or pin to a specific version (e.g. `7.2.10-r2`, `7.2`, `7`)
- Builds with contrib modules are also available: `contrib` (latest release), as well as pins to specific versions (e.g. `7.2.10-r2-contrib`, `7.2-contrib`, `7-contrib`)

### Sending mail from services

This container bundles `msmtp` to easily route mail through an external provider. You can use it in Atheme by setting `mta = /usr/bin/msmtp` and mounting a configuration file into `/etc/msmtprc`.

The Arch Linux Wiki has a useful page on msmtp configuration: https://wiki.archlinux.org/index.php/Msmtp#Basic_setup

## Build arguments

For those who want to create customized builds, here are options exposed by the Dockerfile:

- `ATHEME_UID`: sets the UID for the Atheme user to run as. Defaults to 10000.
- `ATHEME_VERSION`: Atheme version to pull from Git
- `BUILD_CONTRIB_MODULES`: if set to a non-empty value, enables building contrib modules.
- `MAKE_NUM_JOBS`: sets the `-j` flag for make. Defaults to `$(nproc)` if left empty.
