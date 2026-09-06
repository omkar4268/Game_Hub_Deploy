FROM tomcat:11.0-jdk21

# Clean out default Tomcat demo apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your games into ROOT so the hub loads at the main website URL
COPY ./ROOT /usr/local/tomcat/webapps/ROOT

EXPOSE 8080
CMD ["catalina.sh", "run"]