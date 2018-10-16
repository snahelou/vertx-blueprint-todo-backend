FROM gradle AS builder
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle build -x test --no-daemon


FROM java:8-jre
ENV VERTICLE_FILE /home/gradle/src/build/libs/vertx-blueprint-todo-backend-fat.jar
# Set the location of the verticles
ENV VERTICLE_HOME /usr/verticles
EXPOSE 8082
COPY --from=builder $VERTICLE_FILE $VERTICLE_HOME/
COPY config/config_docker.json $VERTICLE_HOME/
WORKDIR $VERTICLE_HOME
ENTRYPOINT ["sh", "-c"]
CMD ["java -jar vertx-blueprint-todo-backend-fat.jar -conf config_docker.json"]
