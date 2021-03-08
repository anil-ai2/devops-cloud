FROM centos
RUN yum install httpd -y
COPY index.html /var/www/html/

EXPOSE 80
# Start the service
CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]