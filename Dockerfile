FROM maven:latest

WORKDIR /app

COPY .  .

RUN mvn package -DskipTests && \
    mv target/demo-0.0.1-SNAPSHOT.jar /run/demo.jar

EXPOSE 8080

CMD java  -jar /run/demo.jar
