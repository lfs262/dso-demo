FROM maven:3.8.3-openjdk-17 AS BUILD

WORKDIR /app

COPY .  .

RUN mvn package -DskipTests && \
    mv target/demo-0.0.1-SNAPSHOT.jar /run/demo.jar

 FROM openjdk:18-alpine AS RUN
 WORKDIR /run
 COPY --from=BUILD /app/target/demo*.jar demo.jar

EXPOSE 8080

CMD java  -jar /run/demo.jar
