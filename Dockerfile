FROM node:24-slim AS runner

SHELL ["/bin/bash", "-c"]

# Install FFMPEG
RUN apt update && \
    apt install ffmpeg -y --no-install-recommends --no-install-suggests && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/* && \
    rm -vrf /usr/share/doc/* && \
    rm -vrf /usr/share/man/* && \
    rm -vrf /usr/local/share/doc/* && \
    rm -vrf /usr/local/share/man/*

COPY files/usr/local/bin/entrypoint /usr/local/bin/entrypoint

# Install peertube-runner
RUN npm install -g @peertube/peertube-runner@${PEERTUBE_RUNNER_VERSION:-"0.1.3"}

# Un-privileged user running the application
ARG DOCKER_USER
USER ${DOCKER_USER:-root}

ENTRYPOINT [ "entrypoint" ]
CMD [ "peertube-runner", "server" ]

FROM runner AS whisper_ctranslate2

USER root:root

RUN apt-get update && \
    apt install python3-pip -y --no-install-recommends --no-install-suggests && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/* && \
    rm -vrf /usr/share/doc/* && \
    rm -vrf /usr/share/man/* && \
    rm -vrf /usr/local/share/doc/* && \
    rm -vrf /usr/local/share/man/*

ARG WHISPER_CTRANSLATE2_VERSION

RUN pip3 install whisper-ctranslate2==${WHISPER_CTRANSLATE2_VERSION:-"0.5.3"} --break-system-packages

# Un-privileged user running the application
ARG DOCKER_USER
USER ${DOCKER_USER}

ENV PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE="whisper-ctranslate2"

ENV PEERTUBE_RUNNER_TRANSCRIPTION_MODEL="tiny"

ENV PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE_PATH="/usr/local/bin/whisper-ctranslate2"
