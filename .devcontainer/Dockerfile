FROM node:22-bookworm-slim

ARG OMP_REF=""
RUN apt-get update \
    && apt-get install -y --no-install-recommends bash ca-certificates curl fd-find git jq make python3 python3-pip python3-yaml ripgrep unzip \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/bin/fdfind /usr/local/bin/fd \
    && useradd --create-home --shell /bin/bash agent \
    && mkdir -p /workspace /home/agent/.local/bin /home/agent/.omp/agent \
    && chown -R agent:agent /workspace /home/agent/.local /home/agent/.omp \
    && chmod 700 /home/agent/.omp /home/agent/.omp/agent

USER agent
ENV PATH="/home/agent/.local/bin:${PATH}"
WORKDIR /workspace
RUN curl --fail --show-error --silent --location https://raw.githubusercontent.com/can1357/oh-my-pi/main/scripts/install.sh --output /tmp/install-omp.sh \
    && if [ -n "${OMP_REF}" ]; then sh /tmp/install-omp.sh --binary --ref "${OMP_REF}"; else sh /tmp/install-omp.sh --binary; fi \
    && rm /tmp/install-omp.sh \
    && omp --version
