# letsencrypt-dns
Autonomous docker container responsible for issuing and renewing Letsencrypt certificates using DNS-challenge. This is a logical extension of Kyle Ondy's [dns-certbot](https://hub.docker.com/r/kyleondy/dns-certbot/), with added support for delegated domains (default Dehydrated hook does not support such configuration, see [discussion on GitHub](https://github.com/AnalogJ/lexicon/issues/80)).

# Usage

## Environment variables

* `PROVIDER=route53` - optional (defaults to `cloudflare`).
* `CERTBOT_DOMAIN` - the domain to get the certificate for.
* `CERTBOT_STAGING` - if set to anything but `False`, requests a fake certificate,
not subject to rate limits.
* `CERTBOT_DELEGATED` - if specified, indicates the part of the domain delegated to another DNS authority. `False` is equivalent to not set.
* `CERTBOT_ALIAS` - if specified, sets the name of the directory under `/certs` to be used.

`CERTBOT_ALIAS` is required to request wildcard certificates.

## Credentials

Credentials for the provider need to be passed via environment variables.
Variable names format is as follows:

```
LEXICON_<PROVIDER>_<PARAMETER>
```

For example, for `PROVIDER=cloudflare` the following variables are expected (see
[Lexicon Usage examples][1]):
* `LEXICON_CLOUDFLARE_USERNAME`
* `LEXICON_CLOUDFLARE_TOKEN`

For `PROVIDER=route53` the following variables are expected, but they are optional
(you can also use AWS Profile or IAM role instead of explicit credentials):
* `LEXICON_ROUTE53_ACCESS_KEY`
* `LEXICON_ROUTE53_ACCESS_SECRET`

## Volumes

* `<your Letsencrypt certificates directory>:/certs`

[1]: https://github.com/AnalogJ/lexicon/tree/d30759754272c8fa2e7426b0fe0980022318083e#usage
