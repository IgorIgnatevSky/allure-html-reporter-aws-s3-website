FROM python:3.11-rc-alpine


LABEL "com.github.actions.name"="Playwright HTML Reporter AWS S3 Upload"
LABEL "com.github.actions.description"="Upload Playwright HTML Test Results to an AWS S3 repository"
LABEL "com.github.actions.icon"="refresh-cw"
LABEL "com.github.actions.color"="green"

LABEL version="0.1"
LABEL repository="https://github.com/PavanMudigonda/playwright-html-reporter-s3-website"
LABEL homepage="https://abcd.guru/"
LABEL maintainer="Pavan Mudigonda <mnpawan@gmail.com>"

# https://github.com/aws/aws-cli/blob/master/CHANGELOG.rst
ENV AWSCLI_VERSION='1.18.14'

RUN pip install --quiet --no-cache-dir awscli==${AWSCLI_VERSION}

RUN apk update && \
    apk add --no-cache bash wget unzip && \
    rm -rf /var/cache/apk/* \
    && apk upgrade \
    && apk add ca-certificates \
    && update-ca-certificates \
    && apk add --update coreutils && rm -rf /var/cache/apk/*   \ 
    && apk add --update openjdk11 tzdata curl unzip bash \
    && apk add --no-cache nss \
    && rm -rf /var/cache/apk/*

ARG RELEASE=2.24.1
ARG ALLURE_REPO=https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline

RUN echo $RELEASE && \
    apk update && \
    apk add --no-cache bash wget unzip && \
    rm -rf /var/cache/apk/*

RUN wget --no-verbose -O ./allure-$RELEASE.tgz $ALLURE_REPO/$RELEASE/allure-commandline-$RELEASE.tgz && \
    tar -xf ./allure-$RELEASE.tgz && \
    chmod -R +x ./allure-$RELEASE/bin

ENV ROOT=/app \
    PATH=$PATH:/allure-$RELEASE/bin

RUN mkdir -p $ROOT


WORKDIR $ROOT

COPY ./entrypoint.sh /entrypoint.sh

RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]

