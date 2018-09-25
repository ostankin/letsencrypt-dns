#!/bin/bash

# In your environment, you should have these defined:

#AWS_ACCESS_KEY_ID="AAAAAAAAAAAAAAAAAAAA"
#AWS_SECRET_ACCESS_KEY="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"

# STAGING=False
STAGING=True

docker run -e PROVIDER=route53 \
       -e LEXICON_ROUTE53_ACCESS_KEY="$AWS_ACCESS_KEY_ID" \
       -e LEXICON_ROUTE53_ACCESS_SECRET="$AWS_SECRET_ACCESS_KEY" \
       -e CERTBOT_DOMAIN="*.z.example.com" \
       -e CERTBOT_STAGING="$STAGING" \
       -e CERTBOT_DELEGATED="z.example.com" \
       -e CERTBOT_ALIAS="staging_star_z.example.com" \
       -v /var/lib/letsencrypt-dns-staging:/certs \
       salemove/letsencrypt-dns
