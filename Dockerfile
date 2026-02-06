# image JDK 21 
FROM eclipse-temurin:21-jdk AS builder

WORKDIR /app

# Copie fichiers Gradle
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# Copie du code
COPY src src

# donne les droits d'exécution au wrapper Gradle et lance le build
RUN chmod +x gradlew 
RUN ./gradlew clean test bootWar


# utilise une image JRE plus légere
FROM eclipse-temurin:21-jre

WORKDIR /app

# récupère le fichier WAR généré avant
COPY --from=builder /app/build/libs/*.war app.war

EXPOSE 8080

# Commande de démarrage
ENTRYPOINT ["java", "-jar", "app.war"]