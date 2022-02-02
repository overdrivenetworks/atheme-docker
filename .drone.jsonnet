local VERSION = "7.2.12";

local build(contrib=false) = {
  "kind": "pipeline",
  "name": "build" + (if contrib then "-contrib" else ""),
  "steps": [
    {
      "name": "set image tags",
      "image": "alpine",
      "environment": {
        "VERSION": VERSION
      },
      "commands": [
        "./write-tags.sh $VERSION" + (if contrib then " contrib" else " ") + "> .tags",
        "# Will build the following tags:",
        "cat .tags"
      ]
    },
    {
      "name": "build docker image",
      "image": "plugins/docker",
      "settings": {
        "repo": "ovdnet/atheme",
        "username": {
          "from_secret": "docker_user"
        },
        "password": {
          "from_secret": "docker_password"
        },
        "build_args": std.prune([
          "ATHEME_VERSION=" + VERSION,
          (if contrib then "BUILD_CONTRIB_MODULES=true")
        ])
      },
      "trigger": {
        "branch": [
          "master"
        ]
      },
      "volumes": [
        {
          "name": "docker-socket",
          "path": "/var/run/docker.sock"
        }
      ]
    }
  ],
  "volumes": [
    {
      "name": "docker-socket",
      "host": {
        "path": "/var/run/docker.sock"
      }
    }
  ],
  "depends_on": std.prune([if contrib then "build"]),
};

[
  build(),
  build(contrib=true)
]

