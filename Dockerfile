# -------- Stage 1: Build WAR using Maven --------
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Set working directory inside builder container
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code and build WAR
COPY src ./src
RUN mvn clean package

# -------- Stage 2: Run on Tomcat --------
FROM tomcat:10.1-jdk17

# Clean default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy built WAR from previous stage
#COPY --from=build /app/target/hello-servlet.war /usr/local/tomcat/webapps/hello-servlet.war
COPY --from=build /app/target/hello-servlet.war /usr/local/tomcat/webapps/ROOT.war
# Expose Tomcat port
EXPOSE 8080

# Default CMD runs Tomcat
