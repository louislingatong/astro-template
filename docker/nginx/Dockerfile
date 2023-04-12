FROM nginx

ARG ENVIRONMENT
ARG APPS

# Copy the configure bash file
ADD ./docker/nginx/scripts/configure-$ENVIRONMENT.sh /configure.sh

# Copy the default.conf to contain the global directives
ADD ./docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy the unconfigured *.conf file
# This will be configured in the configure.sh file
ADD ./docker/nginx/$ENVIRONMENT.conf /etc/nginx/conf.d/configuration-file.conf.unconfigured

RUN ["chmod", "+x", "/configure.sh"]
RUN /configure.sh
