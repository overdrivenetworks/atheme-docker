local build(contrib=false) = {
  "kind": "pipeline",
  "name": "build" + (if contrib then "-contrib" else ""),
  "steps": [
    {
      "name": "set image tags",
      "image": "alpine",
      "environment": {
        "VERSION": "7.2.10-r2"
      },
      "commands": [
        "./write-tags.sh $VERSION contrib > .tags",
        "# Will build the following tags:",
        "cat .tags"
      ]
    },
    {
      "name": "build docker image",
      "image": "ovdnet/drone-docker",
      "settings": {
        "repo": "ovdnet/atheme",
        "username": {
          "from_secret": "docker_user"
        },
        "password": {
          "from_secret": "docker_password"
        },
        "build_args": std.prune([
          "ATHEME_VERSION=7.2.10-r2",
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
  ]
};

[
  build(),
  build(contrib=true)
]

