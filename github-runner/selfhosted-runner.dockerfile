FROM docker:dind

ENV GH_TOKEN="<Runner-Access-Token>"
ENV GH_OWNER="<Repository-Owner>"
ENV GH_REPOSITORY="<Repository>"
ENV RUNNER_NAME="<Runner-Name>"
ENV DEBIAN_FRONTEND=noninteractive
ARG RUNNER_VERSION="<Runner-Version>"

RUN apt-get update -y && apt-get upgrade -y && useradd -m docker

RUN apt-get install -y --no-install-recommends \
    curl nodejs wget unzip vim git jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip

RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

ADD start.sh start.sh
RUN chmod +x start.sh

USER docker

ENTRYPOINT ["./start.sh"]
