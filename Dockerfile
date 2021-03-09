FROM alpine:latest

LABEL maintainer="techmovers@glia.com"

RUN apk add --update \
        bash \
        curl \
        git \
        patch \
        openssl \
        python3 \
        py3-pip

RUN cd / \
 && apk add --no-cache --virtual .build-deps \
    gcc \
    python3-dev \
    musl-dev \
    libffi-dev \
    openssl-dev \
    libxml2-dev \
    libxslt-dev \
 && git clone https://github.com/dehydrated-io/dehydrated.git \
 && (cd dehydrated && git checkout tags/v0.6.5) \
 && pip3 install pip --upgrade \
 && pip3 install cryptography==2.8 dns-lexicon[full]==3.5.3 \
 && apk del .build-deps

ADD https://raw.githubusercontent.com/AnalogJ/lexicon/eaacd80fa8e88ec516e51dfacb7aa5a61783e6a2/examples/dehydrated.default.sh /dehydrated/
RUN chmod +x /dehydrated/dehydrated.default.sh
ADD hook.diff /dehydrated/
RUN cat /dehydrated/hook.diff | patch /dehydrated/dehydrated.default.sh \
  && chmod +x /dehydrated/dehydrated.default.sh
ADD dns-certbot.sh /dns-certbot.sh
RUN chmod +x /dns-certbot.sh

CMD  [ "/dns-certbot.sh" ]
