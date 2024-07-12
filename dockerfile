# Use the Maven image to build the WAR file
FROM maven:3.8.5-openjdk-11 AS builder
COPY . /usr/src/mymaven
WORKDIR /usr/src/mymaven
RUN mvn clean package -DskipTests

# Use the Tomcat 9 base image
FROM tomcat:9

# Create a directory for the OpenTelemetry agent
RUN mkdir /app

# Download the OpenTelemetry Java agent
RUN wget -q -O /app/opentelemetry-javaagent.jar https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v1.10.0/opentelemetry-javaagent.jar

# Copy the WAR file from the builder stage
COPY --from=builder /usr/src/mymaven/target/addressbook.war /usr/local/tomcat/webapps/addressbook.war

# Run Tomcat
CMD ["catalina.sh", "run"]

