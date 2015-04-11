FROM debian:jessie
MAINTAINER Aditya Mukerjee "dev@chimeracoder.net"

# Download and Install Nginx
ENV DEBIAN_FRONTEND noninteractive 
RUN apt-get update -y 
RUN apt-get upgrade -y 
RUN apt-get install -y nginx-full openssl systemd

# Helpful for emergency debugging
RUN apt-get install -y vim curl

# Remove the default Nginx configuration file
RUN rm -v /etc/nginx/nginx.conf

# Copy a configuration file from the current directory
ADD nginx.conf /etc/nginx/

# Copy SSL cert and key
ADD nginx.crt /etc/nginx/nginx.crt
ADD nginx.key /etc/nginx/nginx.key

# Copy Diffie-Helman params
# Generate these using 
# $ openssl dhparam -out dhparam.pem 2048
# Generating them inside Docker requires mounting /dev/random from the host
ADD dhparam.pem /etc/nginx/ssl/dhparam.pem


# Expose ports 80 and 443 for nginx
EXPOSE 80
EXPOSE 443

RUN systemctl enable nginx.service
RUN systemctl enable systemd-networkd.service
RUN systemctl enable systemd-resolved.service

# Run systemd as init
CMD ["/sbin/init"]
