# nginx-reverse-proxy

This is a simple Docker-ization of Nginx, designed for use as a reverse-proxy in front of app-servers (like Unicorn) that don't like slow clients.

## Usage

This image expects a linked "app" container to be provided. The app container should have an HTTP app-server listening on port `${NGINX_APP_PORT-5000}`.

e.g.

    # start app-server
    docker run --name theapp -d tutum/hello-world

    # wrap it with an Nginx proxy
    docker run --name nginx -p 80:80 --link theapp:app \
      nginx-reverse-proxy
