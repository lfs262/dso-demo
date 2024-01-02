FROM maven:3.8.3-openjdk-17 AS BUILD

WORKDIR /app

COPY .  .

RUN mvn package -DskipTests && \
    mv target/demo-0.0.1-SNAPSHOT.jar /run/demo.jar

FROM openjdk:18-alpine AS RUN
WORKDIR /run
COPY --from=BUILD /run/demo.jar demo.jar

ARG USER=demo
ENV HOME=/home/$USER
RUN adduser -D $USER && chown $USER:0 /run/demo.jar
RUN apk add --no-cache curl

USER $USER

HEALTHCHECK --interval=30s --timeout=10s --retries=2 --start-period=20s \
  CMD curl -f http://localhost:8080/ || exit

EXPOSE 8080
CMD java  -jar /run/demo.jar
