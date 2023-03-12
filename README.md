# Self-Hosted GitHub-Actions-Runner inside a docker-container
This is a Repository provides a docker-image to host GitHub-Action-Runners inside the docker-runtime.
Docker-Container requires the docker-socket to be passed into it in order to be able to build docker images using GitHub Actions.

Upon startup, the container generates itself a Token for a Actions-Runner and registers itself within the provided repository.
From now on it is able to run the Workflow-Actions from the repository.

## Installation

### Prerequisites

- Generate a GitHub-Acces-Token with the scopes repo (full) and admin:org (read:org)
- Have docker installed

### Docker-Compose

```yaml
version: "3"

services:
  github-actions-runner:
    container_name: 'github-actions-runner'
    image: ghcr.io/meepmr/gh-action-runner:<version of the official GitHub-Runner>
    privileged: true
    environment:
      GH_TOKEN: '<the previously generated Token>'
      GH_REPOSITORY: '<the name of the GitHub Repository which the runner should be accessible in>'
      GH_OWNER: '<the GitHub username of the owener of the Repository>'
      RUNNER_NAME: '<the name of the runner (has to be unique per repository)>'
    volumes:
      - '/var/run/docker.sock:/var/run/docker.sock' # Mapping the docker-socket into the container
```

### Starting more than one Runner

To start more than one Runner using the compose-file there is currently one (not very nice) solution:

<details>
<summary>Duplicating the service inside the compose-file</summary>

``` yaml
version: "3"

services:
  github-actions-runner-1:
    container_name: 'github-actions-runner'
    image: ghcr.io/meepmr/gh-action-runner:<version of the official GitHub-Runner>
    privileged: true
    environment:
      GH_TOKEN: '<the previously generated Token>'
      GH_REPOSITORY: '<the name of the GitHub Repository which the runner should be accessible in>'
      GH_OWNER: '<the GitHub username of the owener of the Repository>'
      RUNNER_NAME: '<the name of the runner (has to be unique per repository)>'
    volumes:
      - '/var/run/docker.sock:/var/run/docker.sock' # Mapping the docker-socket into the container
      
  github-actions-runner-2:
    container_name: 'github-actions-runner'
    image: ghcr.io/meepmr/gh-action-runner:<version of the official GitHub-Runner>
    privileged: true
    environment:
      GH_TOKEN: '<the previously generated Token>'
      GH_REPOSITORY: '<the name of the GitHub Repository which the runner should be accessible in>'
      GH_OWNER: '<the GitHub username of the owener of the Repository>'
      RUNNER_NAME: '<the name of the runner (has to be unique per repository)>'
    volumes:
      - '/var/run/docker.sock:/var/run/docker.sock' # Mapping the docker-socket into the container
```
</details>

## GitHub Actions

For the GitHub-Runner to run any actions, the workflow-job has to specify this behavior:

```yaml
jobs:
  <job>:
    runs-on: [self-hosted]
```
