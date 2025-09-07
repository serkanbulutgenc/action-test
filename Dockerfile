#FROM python:3.12-slim AS builder
FROM ghcr.io/astral-sh/uv:debian-slim AS builder

LABEL mainainer="serkan" version="0.0.1"

# The installer requires curl (and certificates) to download the release archive
RUN apt-get update &&\
    apt-get install -y --no-install-recommends curl ca-certificates &&\
    useradd -Mr apiUser

# Download the latest installer
# ADD https://astral.sh/uv/install.sh /uv-installer.sh

# Run the installer then remove it
#RUN sh /uv-installer.sh && rm /uv-installer.sh

# Ensure the installed binary is on the `PATH`
#ENV PATH="/root/.local/bin/:$PATH"

COPY  ./uv.lock  .
COPY ./pyproject.toml .
COPY ./.python-version .

RUN uv sync --locked --no-dev

WORKDIR /fastApp

COPY app .

#RUN chown -R apiUser:www-data /fastApp

#USER apiUser

EXPOSE 8088

CMD ["uv", "run", "fastapi", "run", "--host", "0.0.0.0", "--port" ,"8088"]
