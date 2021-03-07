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

### Persistent certificate storage

`<your Letsencrypt certificates directory>:/certs`

Mounting a host volume to `/certs` makes sure the certificates issued by Letsencrypt are not gone when the docker container dies.

### Custom event hooks

`<your custom hooks for Letsencrypt events>:/hooks:ro`

Every time Dehydrated launches certbot, it attaches a hook to each event that certbot can issue. The events are as follows:

* `deploy_challenge` - called when certbot requests a domain validation
* `clean_challenge` - called when the domain validation challenge is no longer needed
* `invalid_challenge` - called when a domain validation has failed
* `deploy_cert` - called when a new certificate has been issued
* `unchanged_cert` - called when certbot has run 
* `startup_hook` - called at the start of Dehydrated
* `exit_hook` - called when Dehydrated exits

If Dehydrated finds an executable script in `/hooks` directory with the same name as the event that triggered, it calls this script.
For example, `/hooks/deploy_cert` can be a script that reloads `nginx` in order to pick up the new certificate.

[1]: https://github.com/AnalogJ/lexicon/tree/d30759754272c8fa2e7426b0fe0980022318083e#usage
