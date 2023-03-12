FROM ubuntu:jammy

ENV GH_TOKEN="<Runner-Access-Token>"
ENV GH_OWNER="<Repository-Owner>"
ENV GH_REPOSITORY="<Repository>"
ENV RUNNER_NAME="<Runner-Name>"
ENV DEBIAN_FRONTEND=noninteractive
ARG RUNNER_VERSION="<Runner-Version>"

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends curl nodejs wget unzip vim git jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip

# Install Docker
RUN apt-get install -y ca-certificates curl gnupg lsb-release
RUN mkdir -m 0755 -p /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

RUN useradd -m runner

RUN cd /home/runner && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN chown -R runner ~runner && /home/runner/actions-runner/bin/installdependencies.sh

ADD start.sh start.sh
RUN chmod +x start.sh

USER runner

ENTRYPOINT ["./start.sh"]
