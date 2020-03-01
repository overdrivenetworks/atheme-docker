# atheme-docker

[![Build Status](https://drone.overdrivenetworks.com/api/badges/overdrivenetworks/atheme-docker/status.svg)](https://drone.overdrivenetworks.com/overdrivenetworks/atheme-docker)

This is an unofficial Docker image for [Atheme IRC Services](https://github.com/atheme/atheme), based off of Alpine and rebuilt weekly.

## Usage

First, write your desired `atheme.conf` and copy `services.db` (if you have one) into an empty directory. Make sure it is writable by **UID 10000** (or rebuild the image with your desired UID - see Build Arguments below)

```
$ docker run -v /path/to/services/data:/atheme/etc ovdnet/atheme
```

### Supported tags

- You can use the `latest` tag (which points to the [latest release built from this repository](/.drone.yml)), or pin to a specific version (e.g. `7.2.10-r2`, `7.2`, `7`)
- Builds with contrib modules are also available: `contrib` (latest release), as well as pins to specific versions (e.g. `7.2.10-r2-contrib`, `7.2-contrib`, `7-contrib`)

## Build arguments

For those who want to create customized builds, here are options exposed by the Dockerfile:

- `ATHEME_UID`: sets the UID for the Atheme user to run as. Defaults to 10000.
- `ATHEME_VERSION`: Atheme version to pull from Git
- `BUILD_CONTRIB_MODULES`: if set to a non-empty value, enables building contrib modules.
