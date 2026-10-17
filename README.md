# Autos Colombia - Sistema de Parqueadero

Sistema de información para gestión de parqueadero por mensualidad - Iteración 1

## Descripción del Proyecto

Este es el backend del sistema de parqueadero "Autos Colombia", desarrollado como parte de la Evidencia de Aprendizaje 1 de la asignatura Ingeniería de Software. La Iteración 1 se enfoca exclusivamente en la gestión de ENTRADA y SALIDA de vehículos.

## Stack Tecnológico

- Java 17 (LTS)
- Spring Boot 3.2.5
- Spring Web, Spring Data JPA, Spring Security
- MySQL 8.0 con motor InnoDB y charset utf8mb4
- Maven 3.9+
- JPA / Hibernate
- JWT para autenticación (jjwt 0.12.6)
- Lombok
- Bean Validation (jakarta.validation)
- Flyway para migraciones
- Springdoc OpenAPI para documentación Swagger
- JUnit 5 + Mockito para pruebas
- JaCoCo para cobertura (objetivo ≥ 70%)
- Docker + Docker Compose

## Requerimientos Funcionales Implementados

- RF-01: Autenticación con JWT
- RF-02: Registro entrada vehículo
- RF-03: Validación pico y placa
- RF-04: Asignación automática celda
- RF-05: Comprobante entrada con QR
- RF-06: Registro salida
- RF-07: Liberar celda
- RF-08: Comprobante salida con QR
- RF-09: Consulta vehículos
- RF-10: Registro novedades
- RF-11: Cancelación registro
- RF-12: Dashboard ocupación
- RF-13: Reporte ocupación CSV
- RF-14: Auditoría de operaciones

## Estructura del Proyecto

```
autos-colombia/
├── src/
│   ├── main/
│   │   ├── java/com/autoscolombia/
│   │   │   ├── domain/
│   │   │   │   ├── enums/          # Enums JPA
│   │   │   │   ├── model/          # Entidades JPA
│   │   │   │   └── service/        # Servicios de dominio
│   │   │   ├── infrastructure/
│   │   │   │   ├── repository/     # Repositorios JPA
│   │   │   │   └── exception/      # Excepciones personalizadas
│   │   │   ├── presentation/
│   │   │   │   ├── controllers/    # Controladores REST
│   │   │   │   ├── dto/            # Data Transfer Objects
│   │   │   │   └── config/         # Configuración (Security, etc.)
│   │   │   ├── util/               # Utilidades (JwtUtil)
│   │   │   └── AutosColombiaApplication.java
│   │   └── resources/
│   │       ├── db/migration/        # Migraciones Flyway
│   │       └── application.yml
│   └── test/
│       └── java/com/autoscolombia/
├── docs/
│   └── postman/                    # Colección Postman
├── .github/workflows/              # CI/CD con GitHub Actions
├── Dockerfile
├── docker-compose.yml
└── pom.xml
```

## Requisitos Previos

- JDK 17 o superior
- Maven 3.9+
- MySQL 8.0+ (o usar Docker Compose)
- Docker y Docker Compose (opcional)

## Instalación y Ejecución

### Opción 1: Ejecutar con Docker Compose (Recomendado)

1. Clonar el repositorio:
```bash
git clone <repositorio-url>
cd autos-colombia
```

2. Ejecutar con Docker Compose:
```bash
docker-compose up
```

Esto iniciará:
- MySQL 8.0 en el puerto 3306
- La aplicación Spring Boot en el puerto 8080

3. Acceder a la API:
- API: http://localhost:8080
- Swagger UI: http://localhost:8080/swagger-ui.html

### Opción 2: Ejecutar Localmente

1. Configurar la base de datos MySQL:
```sql
CREATE DATABASE autos_colombia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. Configurar las credenciales en `application-dev.yml` o variables de entorno:
```bash
export DB_HOST=localhost
export DB_PORT=3306
export DB_USER=root
export DB_PASSWORD=tu_password
export JWT_SECRET=tu_secret_key
```

3. Compilar y ejecutar:
```bash
mvn clean spring-boot:run
```

## Credenciales de Prueba

El sistema inicia con dos usuarios de prueba:

- **Administrador:**
  - Correo: admin@autoscolombia.com
  - Clave: clave123

- **Operador:**
  - Correo: operador@autoscolombia.com
  - Clave: clave123

## API Documentation

La documentación de la API está disponible en Swagger UI:
http://localhost:8080/swagger-ui.html

## Endpoints Principales

### Autenticación
- `POST /api/v1/auth/login` - Iniciar sesión
- `GET /api/v1/auth/me` - Obtener usuario actual

### Registros
- `POST /api/v1/registros/entrada` - Registrar entrada de vehículo
- `PUT /api/v1/registros/salida/{placa}` - Registrar salida de vehículo
- `GET /api/v1/registros/activos` - Listar registros activos
- `GET /api/v1/registros/ultimos` - Últimos ingresos

### Vehículos
- `GET /api/v1/vehiculos` - Buscar vehículos
- `POST /api/v1/vehiculos` - Crear vehículo

### Celdas
- `GET /api/v1/celdas` - Listar celdas

### Novedades
- `POST /api/v1/novedades` - Registrar novedad
- `GET /api/v1/novedades/pendientes` - Novedades pendientes

### Reportes
- `GET /api/v1/reportes/dashboard` - KPIs del dashboard
- `GET /api/v1/reportes/ocupacion` - Reporte ocupación CSV

## Pruebas

### Ejecutar todas las pruebas:
```bash
mvn clean verify
```

### Ejecutar solo pruebas unitarias:
```bash
mvn test
```

### Ejecutar pruebas de integración:
```bash
mvn verify -P integration-test
```

### Verificar cobertura de código:
```bash
mvn jacoco:report
```

El reporte de cobertura se genera en `target/site/jacoco/index.html`

## Colección Postman

La colección de Postman está disponible en `docs/postman/autos-colombia.postman_collection.json`

Importar esta colección en Postman para probar todos los endpoints.

## CI/CD

El proyecto usa GitHub Actions para CI/CD. El workflow se ejecuta automáticamente en:
- Push a la rama `main`
- Pull requests a la rama `main`

El pipeline:
1. Ejecuta pruebas unitarias y de integración
2. Verifica cobertura de código (JaCoCo ≥ 70%)
3. Construye imagen Docker
4. Publica en GitHub Container Registry

## Variables de Entorno

- `SPRING_PROFILES_ACTIVE`: Perfil de Spring (dev, test)
- `DB_HOST`: Host de la base de datos
- `DB_PORT`: Puerto de la base de datos
- `DB_USER`: Usuario de la base de datos
- `DB_PASSWORD`: Contraseña de la base de datos
- `JWT_SECRET`: Clave secreta para firmar tokens JWT

## Arquitectura

El sistema sigue una arquitectura en capas:

1. **Capa de Presentación:** Controladores REST con Spring MVC
2. **Capa de Servicios:** Lógica de negocio con @Service
3. **Capa de Acceso a Datos:** Repositorios JPA con Spring Data
4. **Capa de Datos:** MySQL 8.0 con InnoDB

## Pico y Placa

El sistema implementa validación de Pico y Placa para Bogotá D.C.:
- Lunes: placas terminadas en 6 y 9
- Martes: placas terminadas en 0 y 1
- Miércoles: placas terminadas en 2 y 3
- Jueves: placas terminadas en 4 y 5
- Viernes: placas terminadas en 7 y 8
- Sábado, domingo y festivos: no aplica

## Auditoría

Todas las operaciones críticas se registran en la tabla `auditoria_log`:
- Entradas y salidas de vehículos
- Registro de novedades
- Cancelaciones
- Login de usuarios

## Licencia

Este proyecto es académico y se desarrolla como parte de la Evidencia de Aprendizaje 1 de la asignatura Ingeniería de Software de la Universidad Digital de Antioquia.

## Autores

- Equipo de desarrollo de Ingeniería de Software - Semestre 6
- Universidad Digital de Antioquia

## Versión

v1.0.0-iteracion1
