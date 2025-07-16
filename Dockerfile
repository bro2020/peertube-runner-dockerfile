FROM node:24-slim AS runner

SHELL ["/bin/bash", "-c"]

# Install FFMPEG

ARG FFMPEG_VERSION=7.1

RUN apt update && \
    apt install xz-utils curl ca-certificates -y --no-install-recommends --no-install-suggests && \
    curl -sL "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-n${FFMPEG_VERSION}-latest-linux64-gpl-${FFMPEG_VERSION}.tar.xz" \
    -o /tmp/ffmpeg.tar.xz && \
    tar -xf /tmp/ffmpeg.tar.xz --transform "s/ffmpeg-n${FFMPEG_VERSION}-latest-linux64-gpl-${FFMPEG_VERSION}\/bin/usr\/local\/bin/" \
    ffmpeg-n${FFMPEG_VERSION}-latest-linux64-gpl-${FFMPEG_VERSION}/bin/ffmpeg && \
    tar -xf /tmp/ffmpeg.tar.xz --transform "s/ffmpeg-n${FFMPEG_VERSION}-latest-linux64-gpl-${FFMPEG_VERSION}\/bin/usr\/local\/bin/" \
    ffmpeg-n${FFMPEG_VERSION}-latest-linux64-gpl-${FFMPEG_VERSION}/bin/ffprobe && \
    apt purge xz-utils curl ca-certificates -y --autoremove && \
    rm -rf /tmp/ffmpeg.tar.xz && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/* && \
    rm -vrf /usr/share/doc/* && \
    rm -vrf /usr/share/man/* && \
    rm -vrf /usr/local/share/doc/* && \
    rm -vrf /usr/local/share/man/*

COPY files/usr/local/bin/entrypoint /usr/local/bin/entrypoint

# Install peertube-runner
ARG PEERTUBE_RUNNER_VERSION=0.1.3

RUN npm install -g @peertube/peertube-runner@${PEERTUBE_RUNNER_VERSION}

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

ARG WHISPER_CTRANSLATE2_VERSION=0.5.3

RUN pip3 install whisper-ctranslate2==${WHISPER_CTRANSLATE2_VERSION} --break-system-packages && \
    rm -rf /root/.cache/pip/*

# Un-privileged user running the application
ARG DOCKER_USER
USER ${DOCKER_USER}

ARG PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE=whisper-ctranslate2 
ENV PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE=${PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE}

ARG PEERTUBE_RUNNER_TRANSCRIPTION_MODEL=tiny  
ENV PEERTUBE_RUNNER_TRANSCRIPTION_MODEL=${PEERTUBE_RUNNER_TRANSCRIPTION_MODEL}

ARG PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE_PATH=/usr/local/bin/whisper-ctranslate2 
ENV PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE_PATH=${PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE_PATH}
