# S20 - Evidencia de Aprendizaje 1. Diseño Sistema de Información – Iteración 1
## Sistema de Gestión de Parqueadero "Autos Colombia"

[![Java](https://img.shields.io/badge/Java-17%20LTS-orange.svg)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.5-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![MySQL](https://img.shields.io/badge/MySQL-8.0%20InnoDB-blue.svg)](https://www.mysql.com/)
[![Tests](https://img.shields.io/badge/Tests-56%20Passed%20(100%25)-success.svg)]()
[![JaCoCo](https://img.shields.io/badge/Coverage-%E2%89%A570%25-green.svg)]()

---

## 📋 Información Académica del Proyecto

* **Institución:** Institución Universitaria Digital de Antioquia (IU Digital)
* **Asignatura:** Ingeniería de Software
* **Actividad:** S20 - Evidencia de Aprendizaje 1. Diseño Sistema de Información – Iteración 1
* **Grupo:** [PREICA2602B020081](https://iudigital.instructure.com/courses/28333)
* **Profesor:** Esteban Montoya Molina
* **Fecha de Entrega y Ubicación:** Octubre 2026, Colombia, Antioquia, Medellín

### 👥 Equipo de Trabajo y Roles Asignados (4 Integrantes)

| Nº | Integrante / Estudiante | Rol en el Proyecto | Responsabilidades Principales | Estado |
|:---:|---|---|---|:---:|
| **1** | **Brayan Alejandro Durango Urrea** | **Arquitecto Líder de Diseño** | **UML, MER, arquitectura de software, mockups UI/UX y revisión técnica** | **Completado (100%)** |
| **2** | *Estudiante 2 (Asignado por equipo)* | Analista de Requerimientos | Requerimientos RF/RNF, historias de usuario y criterios de aceptación | En proceso por equipo |
| **3** | *Estudiante 3 (Asignado por equipo)* | Desarrollador Backend | Código fuente Java/Spring Boot, repositorio GitHub, endpoints API | En proceso por equipo |
| **4** | *Estudiante 4 (Asignado por equipo)* | Desarrollador Frontend / QA | Prototipos en Figma, interfaz web, pruebas de usuario y manuales | En proceso por equipo |

---

## 📖 Descripción del Sistema

**Autos Colombia** es una plataforma de software orientada a la gestión y control operativo de parqueaderos comerciales bajo modalidad de mensualidad y rotación. 

La **Iteración 1** se enfoca exclusivamente en el núcleo transaccional de **ENTRADA y SALIDA de vehículos**:
1. **Control de Acceso Seguro:** Autenticación de operadores y administradores mediante JSON Web Tokens (JWT) sin estado.
2. **Registro Ágil de Entrada:** Captura de placas, marcas y colores; validación automática de la normativa distrital de **Pico y Placa** (Bogotá D.C.); asignación automática de celda física por tipo de vehículo (`CARRO`, `MOTO`, `CAMIONETA`); y emisión de comprobante de ingreso con código QR en Base64.
3. **Registro de Salida y Liquidación:** Búsqueda rápida por placa, cálculo automático del tiempo de permanencia, liberación transaccional de la celda de parqueo y emisión de comprobante de salida.
4. **Gestión de Novedades e Incidencias:** Registro de daños previos, rayones o novedades en vehículos durante su estancia.
5. **Dashboard Operativo y Reportes:** Indicadores clave de ocupación en tiempo real y exportación de reportes en formato CSV.
6. **Auditoría Transversal:** Pista inmutable de auditoría para cada operación sensible realizada en garita.

---

## 🏛️ Entregables del Rol 1 (Arquitecto Líder de Diseño)

Toda la documentación técnica y de diseño elaborada para esta iteración se encuentra disponible en la carpeta [`docs/`](./docs/):

* 📐 **[01. Documento de Arquitectura de Software (SAD)](./docs/01_ARQUITECTURA_DEL_SISTEMA.md):**  
  Estilo arquitectónico en 4 capas, Modelo C4 (Contexto, Contenedores, Componentes, Despliegue), Atributos de Calidad (RNF) y Decisiones de Arquitectura (ADRs 01 a 06).
* 📊 **[02. Especificación de Diagramas UML](./docs/02_DIAGRAMAS_UML.md):**  
  Diagrama de Casos de Uso (CU-01 a CU-13), Diagrama de Clases UML del dominio, Diagramas de Secuencia (Login, Entrada, Salida, Novedades), Diagramas de Estados y Paquetes.
* 🗄️ **[03. Modelo Entidad-Relación (MER / DER) y Diccionario de Datos](./docs/03_MODELO_ENTIDAD_RELACION_MER.md):**  
  Diagrama DER en sintaxis Mermaid, cardinalidades conceptuales, diccionario exhaustivo de las 7 tablas (`usuario`, `vehiculo`, `celda`, `registro`, `novedad`, `comprobante`, `auditoria_log`) e integridad referencial.
* 🎨 **[04. Mockups y Arquitectura Visual de Interfaz](./docs/04_MOCKUPS_ARQUITECTURA_VISUAL.md):**  
  Arquitectura de información, guía de estilos (design system), mockups estructurados de las 6 pantallas clave y lineamientos de integración para el Desarrollador Frontend.
* 🔍 **[05. Revisión Técnica y Auditoría de Arquitectura](./docs/05_REVISION_TECNICA_ARQUITECTURA.md):**  
  Auditoría de código, corrección de deuda técnica (desacoplamiento de dependencia circular de Spring Security y ciclo de vida JPA `@Builder.Default`/`@PrePersist`), principios SOLID y Matriz de Trazabilidad Técnica (RF vs Código vs BD vs Tests).

---

## 📂 Estructura del Proyecto

```
Ingenieria - Evidencia de aprendizaje 1/
├── docs/                                  # Entregables de Arquitectura y Diseño
│   ├── 01_ARQUITECTURA_DEL_SISTEMA.md     # Documento de Arquitectura (C4, ADRs)
│   ├── 02_DIAGRAMAS_UML.md                # Diagramas UML (Clases, Secuencia, Casos de Uso)
│   ├── 03_MODELO_ENTIDAD_RELACION_MER.md  # DER, MER y Diccionario de Datos
│   ├── 04_MOCKUPS_ARQUITECTURA_VISUAL.md  # Wireframes y Mockups de Interfaz
│   ├── 05_REVISION_TECNICA_ARQUITECTURA.md# Auditoría de código y matriz de trazabilidad
│   └── postman/                           # Colección de pruebas de API REST
│       └── autos-colombia.postman_collection.json
├── src/
│   ├── main/
│   │   ├── java/com/autoscolombia/
│   │   │   ├── domain/                    # Capa de Dominio y Negocio
│   │   │   │   ├── enums/                 # Enumeraciones (Estados, Tipos)
│   │   │   │   ├── model/                 # Entidades JPA (Usuario, Vehiculo, etc.)
│   │   │   │   └── service/               # Servicios de Lógica de Negocio
│   │   │   ├── infrastructure/            # Capa de Infraestructura
│   │   │   │   ├── repository/            # Repositorios Spring Data JPA
│   │   │   │   └── exception/             # Manejadores y Excepciones Globales
│   │   │   ├── presentation/              # Capa de Presentación
│   │   │   │   ├── controllers/           # Controladores REST API
│   │   │   │   ├── dto/                   # Data Transfer Objects con validación
│   │   │   │   └── config/                # Seguridad, CORS y PasswordEncoder
│   │   │   ├── util/                      # Utilidades de Tokens JWT (JwtUtil)
│   │   │   └── AutosColombiaApplication.java
│   │   └── resources/
│   │       ├── db/migration/              # Scripts Flyway (V1__schema_inicial.sql)
│   │       ├── application.yml            # Configuración general
│   │       ├── application-dev.yml        # Perfil local / Docker
│   │       └── application-test.yml       # Perfil de pruebas H2 en memoria
│   └── test/java/com/autoscolombia/       # Suite de 56 Pruebas Automatizadas
│       ├── integration/                   # Pruebas de integración de controladores
│       └── service/                       # Pruebas unitarias con Mockito
├── .github/workflows/                     # Pipeline de CI/CD (GitHub Actions)
├── docker-compose.yml                     # Orquestación de contenedores (App + MySQL)
├── Dockerfile                             # Empaquetado de imagen de producción
├── pom.xml                                # Dependencias Maven y configuración JaCoCo
└── README.md                              # Documentación general del proyecto
```

---

## 🛠️ Stack Tecnológico

| Capa / Componente | Tecnología | Versión / Detalle |
|---|---|---|
| **Lenguaje** | Java (OpenJDK) | 17 LTS |
| **Framework Backend** | Spring Boot | 3.2.5 |
| **Seguridad** | Spring Security 6 + JWT | JJWT 0.12.6 (Stateless) |
| **Persistencia** | Spring Data JPA / Hibernate | Jakarta Persistence 3.1 |
| **Base de Datos** | MySQL Server | 8.0 (Motor InnoDB, utf8mb4) |
| **Migraciones BD** | Flyway | Integrado con Spring Boot |
| **Códigos QR** | Google ZXing | 3.5.2 |
| **Documentación API**| Springdoc OpenAPI (Swagger) | 2.5.0 |
| **Pruebas Automatizadas**| JUnit 5 + Mockito + JaCoCo | 56 pruebas con cobertura $\ge 70\%$ |
| **Contenedores** | Docker & Docker Compose | Contenedores para API y MySQL |

---

## 🚀 Guía de Instalación y Ejecución

### Opción 1: Ejecución con Docker Compose (Recomendada)

1. Clonar el repositorio y acceder al directorio:
   ```bash
   git clone https://github.com/brayandurango-lgtm/Ingenieria-1-disenio-del-sistema.git
   cd "Ingenieria - Evidencia de aprendizaje 1"
   ```
2. Levantar los servicios de base de datos y backend:
   ```bash
   docker-compose up --build
   ```
3. El sistema estará disponible en:
   * **API REST:** `http://localhost:8080`
   * **Documentación Swagger UI:** `http://localhost:8080/swagger-ui.html`
   * **OpenAPI Docs (JSON):** `http://localhost:8080/v3/api-docs`

---

### Opción 2: Ejecución Local con Maven y MySQL

1. Crear la base de datos en MySQL local:
   ```sql
   CREATE DATABASE autos_colombia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
2. Configurar variables de entorno (o usar las predeterminadas):
   ```bash
   export DB_HOST=localhost
   export DB_PORT=3306
   export DB_USER=root
   export DB_PASSWORD=tu_password
   export JWT_SECRET=autos-colombia-secret-key-2026-muy-largo-y-seguro-para-firma-HS256
   ```
3. Compilar el proyecto y ejecutar la aplicación:
   ```bash
   mvn clean spring-boot:run
   ```

---

## 🔐 Credenciales de Prueba (Semilla)

El script inicial de Flyway pre-carga dos usuarios con contraseñas encriptadas mediante BCrypt:

| Rol | Correo Electrónico | Contraseña | Permisos |
|---|---|---|---|
| **Administrador** | `admin@autoscolombia.com` | `clave123` | Acceso total, dashboard, reportes CSV y auditoría |
| **Operador** | `operador@autoscolombia.com` | `clave123` | Registro de entrada, salida, novedades y celdas |

---

## 📡 Endpoints Principales de la API REST

### 🔑 Autenticación
* `POST /api/v1/auth/login` - Inicio de sesión y expedición de Token JWT.
* `GET  /api/v1/auth/me` - Consulta de datos del usuario autenticado actual.

### 🚗 Registros de Entrada y Salida
* `POST /api/v1/registros/entrada` - Admisión de vehículo, validación de Pico y Placa, asignación de celda y ticket QR.
* `PUT  /api/v1/registros/salida/{placa}` - Cierre de estancia, cálculo de permanencia, liberación de celda y ticket salida.
* `GET  /api/v1/registros/activos` - Listado de vehículos actualmente dentro del parqueadero.
* `GET  /api/v1/registros/ultimos` - Consulta de los últimos ingresos registrados.
* `DELETE /api/v1/registros/{id}` - Cancelación de un registro activo erróneo.

### 🅿️ Celdas y Vehículos
* `GET  /api/v1/celdas` - Consulta del estado de todas las bahías de parqueo.
* `GET  /api/v1/celdas/disponibles` - Filtrado de celdas libres por tipo de vehículo.
* `GET  /api/v1/vehiculos` - Búsqueda de vehículos por placa, propietario o tipo.

### ⚠️ Novedades e Incidentes
* `POST /api/v1/novedades` - Reporte de novedad o daño en vehículo con soporte de evidencia.
* `GET  /api/v1/novedades/pendientes` - Listado de novedades abiertas para seguimiento.

### 📊 Reportes y Dashboard
* `GET  /api/v1/reportes/dashboard` - Métricas consolidadas de ocupación y porcentaje de celdas.
* `GET  /api/v1/reportes/ocupacion` - Descarga de reporte operacional consolidado en formato CSV.

---

## 🧪 Ejecución de Pruebas Automatizadas

El proyecto cuenta con una suite completa de pruebas unitarias y de integración que valida el 100% de los servicios, repositorios y controladores:

```bash
# Ejecutar todas las pruebas unitarias y de integración
mvn clean test

# Generar reporte de cobertura de código con JaCoCo
mvn jacoco:report
```

> **Resultado actual:** **56 pruebas ejecutadas exitosamente (0 fallos, 0 errores, 0 omitidas)**. El informe de cobertura generado por JaCoCo puede consultarse abriendo en el navegador el archivo `target/site/jacoco/index.html`.

---

## 📄 Licencia y Derechos

Proyecto desarrollado con fines académicos en la **Institución Universitaria Digital de Antioquia (IU Digital)** como parte del programa de Ingeniería de Software (Semestre 6).  
**Medellín, Antioquia, Colombia - Octubre 2026.**
