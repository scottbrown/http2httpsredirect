# http2httpsredirect Docker image

This docker image provides a basic redirect server for HTTP requests to be
301 redirected to HTTPS.  This service assumes that the HTTPS service will
always be on port 443.

## Getting Started

Run `make` (without any arguments) see receive a list of targets available
to you.  The rest should be self-explanatory if you are experienced in
creating Docker images.

## Building the Image

1. Run `make image` to build the docker image.

## Testing

1. Run `make start-server` to start the server.
1. Run `curl -I http://localhost:8000`
1. You should notice that you are [HTTP301](https://en.wikipedia.org/wiki/HTTP_301) redirected to https://localhost.
1. Run `make stop-server` to stop the server.

