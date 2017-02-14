# letsencrypt-dns
Autonomous docker container responsible for issuing and renewing Letsencrypt certificates using DNS-challenge. This is a logical extension of Kyle Ondy's [dns-certbot](https://hub.docker.com/r/kyleondy/dns-certbot/), with added support for delegated domains (default Dehydrated hook does not support such configuration, see [discussion on GitHub](https://github.com/AnalogJ/lexicon/issues/80)).

# Usage

## Environment variables

* `PROVIDER=route53` - optional (defaults to `cloudflare`).
* `LEXICON_ROUTE53_ACCESS_KEY=<AWS IAM user Access Key ID>` - required
if PROVIDER is set to `route53`
* `LEXICON_ROUTE53_ACCESS_SECRET=<AWS IAM user Secret Key>` - required
if PROVIDER is set to `route53`
* `CERTBOT_DOMAIN` - the domain to get the certificate for.
* `CERTBOT_STAGING` - if set to anything but `False`, requests a fake certificate,
not subject to rate limits.
* `DELEGATION_MASTER_DOMAIN` - if specified, indicates the master domain that
delegates `CERTBOT_DOMAIN` to another authority. `False` is equivalent to not set.

## Volumes

* `<your Letsencrypt certificates directory>:/certs`
