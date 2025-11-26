FROM maven:3.9.5-eclipse-temurin-17-alpine AS builder

#Directorio de trabajo
WORKDIR /app

#Copiar pom.xml para cache de dependencias
COPY pom.xml .

#Instalar dependencias (evitar go-offline porque falla en Render)
RUN mvn -q -e -DskipTests package || true

#Copiar el código fuente
COPY src ./src

#Construir el JAR
RUN mvn -q -e -DskipTests package


FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

#Copiar el JAR generado
COPY --from=builder /app/target/*.jar app.jar

#Exponer puerto
EXPOSE 8080

#Comando de inicio
ENTRYPOINT ["java", "-jar", "app.jar"]