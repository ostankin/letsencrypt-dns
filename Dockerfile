FROM alpine:latest
MAINTAINER techmovers@glia.com

RUN apk add --update \
        bash \
        curl \
        git \
        openssl \
        py-pip \
        python

RUN cd / \
 && apk add --no-cache --virtual .build-deps \
    gcc \
    python-dev \
    musl-dev \
    libffi-dev \
    openssl-dev \
 && git clone https://github.com/lukas2511/dehydrated.git \
 && (cd dehydrated && git checkout tags/v0.6.5) \
 # need to install boto3 explicitly. For some reason dns-lexicon[route53] doesn't seem to do it
 && pip install dns-lexicon==3.2.9 dns-lexicon[route53]==3.2.9 boto3 \
 && apk del .build-deps

ADD https://raw.githubusercontent.com/AnalogJ/lexicon/d30759754272c8fa2e7426b0fe0980022318083e/examples/dehydrated.default.sh /dehydrated/
RUN chmod +x /dehydrated/dehydrated.default.sh
ADD dns-certbot.sh /dns-certbot.sh
RUN chmod +x /dns-certbot.sh

CMD  [ "/dns-certbot.sh" ]
