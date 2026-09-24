FROM ghcr.io/astral-sh/uv:python3.14-bookworm-slim

LABEL org.opencontainers.image.title="Photo Tagger"
LABEL org.opencontainers.image.description="Photo Tagger CLI with ExifTool and LibRaw"
LABEL org.opencontainers.image.source="https://github.com/holrak/photo-tagger-docker"

ENV DEBIAN_FRONTEND=noninteractive
ENV UV_NO_PROGRESS=1
ENV PATH="/root/.local/bin:${PATH}"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        exiftool \
        libraw-dev \
        libgomp1 \
        ca-certificates \
        curl \
        git \
    && rm -rf /var/lib/apt/lists/*

RUN uv tool install \
    "photo-tagger @ git+https://github.com/holrak/photo-tagger.git@native-output"

RUN photo-tagger --help >/dev/null \
    && exiftool -ver

WORKDIR /photos

ENTRYPOINT ["photo-tagger"]
CMD ["--help"]
