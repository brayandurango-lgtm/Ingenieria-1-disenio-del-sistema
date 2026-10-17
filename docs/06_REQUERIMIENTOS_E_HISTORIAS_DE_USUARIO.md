# Requerimientos e Historias de Usuario (RF, RNF y HU)
## Sistema de Información "Autos Colombia" – Iteración 1
**Actividad:** S20 - Evidencia de Aprendizaje 1. Diseño Sistema de Información – Iteración 1  
**Institución:** Institución Universitaria Digital de Antioquia (IU Digital)  
**Asignatura:** Ingeniería de Software  
**Grupo:** [PREICA2602B020081](https://iudigital.instructure.com/courses/28333)  
**Profesor:** Esteban Montoya Molina  
**Estudiante:** Brayan Alejandro Durango Urrea (Arquitecto Líder de Diseño)  
**Fecha y Ubicación:** Octubre 2026, Medellín, Antioquia, Colombia  

---

## 1. Requerimientos Funcionales (RF) – Iteración 1 (Entrada y Salida)

| Código | Nombre del Requerimiento | Actor | Descripción Detallada | Criterio de Éxito / Regla de Negocio |
|---|---|---|---|---|
| **RF-01** | Autenticación y Control de Acceso | Operador, Admin | El sistema debe permitir a los usuarios identificarse con correo electrónico y contraseña encriptada, generando un token JWT para la sesión. | Token JWT válido por 8 horas emitido. Bloqueo de cuenta tras 3 intentos fallidos por 15 minutos. |
| **RF-02** | Registro de Entrada Vehicular | Operador | El sistema debe capturar la placa, tipo, marca, modelo, color y datos del propietario (opcional) al ingresar un vehículo a las instalaciones. | Formato de placa validado (colombiano: `ABC123` o `AB123C`). Creación de registro en estado `ACTIVO`. |
| **RF-03** | Validación de Pico y Placa | Sistema | El sistema debe verificar en tiempo real si el vehículo tiene restricción de circulación según la normativa distrital de Bogotá D.C. | Verifica el último dígito numérico según día hábil de la semana. Notifica al operador si tiene restricción. |
| **RF-04** | Asignación Automática de Celda | Sistema | El sistema debe buscar la primera celda física disponible adecuada para la tipología del vehículo (`CARRO`, `MOTO`, `CAMIONETA`) y asignarla atómicamente. | La celda pasa a estado `OCUPADA`. Si no hay celdas disponibles, rechaza el ingreso con error descriptivo. |
| **RF-05** | Emisión de Comprobante de Entrada (QR) | Sistema | El sistema debe generar un comprobante digital/imprimible con código alfanumérico único, datos de estancia y un código QR en Base64. | Código QR escaneable que contiene id de registro, placa, celda asignada y fecha/hora exacta. |
| **RF-06** | Registro de Salida Vehicular | Operador | El sistema debe permitir registrar el egreso del vehículo buscando por su número de placa activa, cerrando el ciclo de estancia. | El registro pasa de `ACTIVO` a `CERRADO`. Se guarda la fecha/hora de salida y se calcula el tiempo total de permanencia. |
| **RF-07** | Liberación Automática de Celda | Sistema | Al confirmarse la salida del vehículo, el sistema debe cambiar el estado de la celda asociada para que vuelva a estar libre. | La celda pasa inmediatamente a estado `DISPONIBLE` para recibir nuevos vehículos. |
| **RF-08** | Emisión de Comprobante de Salida (QR) | Sistema | El sistema debe generar un comprobante final de salida con código QR que detalle el tiempo total de estancia y las observaciones de retiro. | Código QR de salida generado y almacenado en la tabla `comprobante`. |
| **RF-09** | Consulta y Búsqueda de Vehículos | Operador, Admin | El sistema debe permitir consultar vehículos registrados filtrando por placa, nombre o documento del propietario y tipo de vehículo. | Retorna coincidencias parciales o exactas con paginación y ordenamiento. |
| **RF-10** | Registro y Gestión de Novedades | Operador | El sistema debe permitir reportar daños, rayones, fugas mecánicas u objetos dejados en el vehículo durante su estancia. | Novedad tipificada (`RAYON`, `DANO_MECANICO`, etc.), con descripción obligatoria y URL de soporte fotográfico. |
| **RF-11** | Cancelación de Registro Erróneo | Operador, Admin | El sistema debe permitir anular un registro activo en caso de equivocación de placa o cancelación inmediata del servicio. | El registro pasa a `CANCELADO`, la celda se libera a `DISPONIBLE` y se registra el motivo de anulación. |
| **RF-12** | Dashboard Operativo en Tiempo Real | Admin, Operador | El sistema debe consolidar las métricas de capacidad: total celdas, celdas disponibles, celdas ocupadas y porcentaje de ocupación global y por tipo. | Indicadores calculados al instante mediante consultas optimizadas a base de datos. |
| **RF-13** | Exportación de Reporte de Ocupación | Administrador | El sistema debe generar y descargar un archivo en formato plano CSV con el historial de vehículos atendidos y tiempos de permanencia. | Archivo CSV estructurado con cabeceras y codificación UTF-8 compatible con Microsoft Excel. |
| **RF-14** | Trazabilidad y Auditoría Transversal | Sistema | El sistema debe registrar cada operación sensible (login, entrada, salida, cancelación, novedad) con IP, usuario, timestamp y resultado. | Registros inmutables en la tabla `auditoria_log` para supervisión operativa y de seguridad. |

---

## 2. Requerimientos No Funcionales (RNF)

| Código | Categoría | Requerimiento No Funcional | Métrica / Estándar de Conformidad |
|---|---|---|---|
| **RNF-01** | **Seguridad** | Cifrado criptográfico de contraseñas de usuarios. | Algoritmo BCrypt con factor de costo 10. Prohibido texto plano. |
| **RNF-02** | **Seguridad** | Autenticación basada en tokens sin estado (stateless). | Tokens JWT firmados con algoritmo HMAC-SHA256, expiración a 8 horas. |
| **RNF-03** | **Seguridad** | Autorización y control de acceso basado en roles (RBAC). | Roles `ADMINISTRADOR` y `OPERADOR` validados en cada endpoint con Spring Security. |
| **RNF-04** | **Rendimiento** | Tiempo de respuesta en operaciones transaccionales de garita. | Menor a 500 ms en el percentil 95 ($P_{95}$) para registrar entrada o salida. |
| **RNF-05** | **Concurrencia** | Manejo de transacciones atómicas y prevención de condiciones de carrera. | Transacciones `@Transactional` en aislamiento por defecto y bloqueo en asignación de celdas. |
| **RNF-06** | **Disponibilidad** | Persistencia relacional ACID y recuperación ante fallos. | Motor MySQL 8.0 InnoDB con soporte de transacciones seguras y volumen Docker persistente. |
| **RNF-07** | **Mantenibilidad** | Código fuente modular, desacoplado y arquitectura en capas. | Principios SOLID, separación estricta en 4 capas (Presentación, Dominio, Infraestructura, Datos). |
| **RNF-08** | **Portabilidad** | Despliegue agnóstico del sistema operativo subyacente. | Contenedorización mediante Docker y Docker Compose (Java 17 OpenJDK + MySQL 8.0). |
| **RNF-09** | **Calidad de Código** | Pruebas automatizadas de cobertura y regresión. | Cobertura de pruebas unitarias e integración superior al 70% verificada con JaCoCo. |
| **RNF-10** | **Usabilidad** | Diseño de interfaces ágil y optimizado para garita de parqueo. | Registro de entrada completable en menos de 3 clics y 10 segundos por vehículo. |

---

## 3. Historias de Usuario (HU) Asociadas

### HU-01: Autenticación de Operador y Administrador
* **ID:** `HU-01` | **Requerimiento Asociado:** `RF-01` | **Prioridad:** Alta  
* **Como:** Operador o Administrador del parqueadero  
* **Quiero:** Iniciar sesión con mi correo corporativo y contraseña en la plataforma  
* **Para:** Acceder a las funciones de control de parqueo correspondientes a mi rol con seguridad  
* **Criterios de Aceptación:**
  * **Dado** que ingreso credenciales registradas y correctas, **cuando** presiono "Ingresar", **entonces** el sistema me otorga un token JWT y me redirige al Dashboard principal.
  * **Dado** que ingreso una contraseña incorrecta, **cuando** intento acceder, **entonces** el sistema rechaza el intento con código 401 y aumenta el contador de fallos.
  * **Dado** que se acumulan 3 intentos fallidos consecutivos en la misma cuenta, **cuando** se intenta un cuarto acceso, **entonces** la cuenta se bloquea por 15 minutos.

---

### HU-02: Registro de Entrada Vehicular y Asignación de Celda
* **ID:** `HU-02` | **Requerimiento Asociado:** `RF-02`, `RF-04` | **Prioridad:** Alta  
* **Como:** Operador de garita  
* **Quiero:** Digitar la placa y características de un vehículo que llega a la entrada  
* **Para:** Registrar formalmente su ingreso y asignarle automáticamente una celda libre  
* **Criterios de Aceptación:**
  * **Dado** que el vehículo no está dentro del parqueadero, **cuando** el operador ingresa la placa válida y el tipo de vehículo, **entonces** el sistema busca la primera celda libre de esa tipología, cambia la celda a `OCUPADA` y crea un registro `ACTIVO`.
  * **Dado** que el vehículo ya tiene una entrada activa sin salida registrada, **cuando** se intenta registrar de nuevo, **entonces** el sistema bloquea la operación con un error 409 Conflict.
  * **Dado** que no hay celdas libres para ese tipo de vehículo, **cuando** se solicita el ingreso, **entonces** el sistema emite un aviso de "No hay celdas disponibles para esta categoría".

---

### HU-03: Validación Automática de Pico y Placa
* **ID:** `HU-03` | **Requerimiento Asociado:** `RF-03` | **Prioridad:** Media-Alta  
* **Como:** Operador de parqueadero  
* **Quiero:** Que el sistema verifique si la placa ingresada tiene restricción de Pico y Placa en Bogotá  
* **Para:** Advertir al usuario o cumplir con las políticas de control vial antes de admitirlo  
* **Criterios de Aceptación:**
  * **Dado** un día lunes hábil y una placa terminada en 6 o 9, **cuando** se valida la placa, **entonces** el sistema alerta que aplica restricción de Pico y Placa.
  * **Dado** un día sábado, domingo o festivo, **cuando** ingresa cualquier vehículo, **entonces** el sistema certifica que no aplica restricción.

---

### HU-04: Emisión de Comprobante de Entrada con Código QR
* **ID:** `HU-04` | **Requerimiento Asociado:** `RF-05` | **Prioridad:** Alta  
* **Como:** Conductor / Usuario del parqueadero  
* **Quiero:** Recibir un ticket impreso o digital con los datos de mi estancia y un código QR  
* **Para:** Tener soporte de recepción de mi vehículo y facilitar mi salida ágil  
* **Criterios de Aceptación:**
  * **Dado** un registro de entrada exitoso, **cuando** se guarda la transacción, **entonces** el sistema genera un ticket con código alfanumérico único y la imagen del código QR codificada en Base64.
  * **Dado** el código QR generado, **cuando** es escaneado por un dispositivo óptico, **entonces** se extrae el identificador del ticket y la placa asociada.

---

### HU-05: Registro de Salida y Liberación de Celda
* **ID:** `HU-05` | **Requerimiento Asociado:** `RF-06`, `RF-07`, `RF-08` | **Prioridad:** Alta  
* **Como:** Operador de garita  
* **Quiero:** Buscar la placa de un vehículo que se retira del parqueadero y confirmar su salida  
* **Para:** Cerrar la estancia, liquidar los minutos de permanencia y liberar la celda para otro cliente  
* **Criterios de Aceptación:**
  * **Dado** un vehículo con registro activo, **cuando** el operador busca su placa y confirma la salida, **entonces** el registro pasa a estado `CERRADO`, la celda asignada pasa inmediatamente a `DISPONIBLE` y se calcula la duración exacta.
  * **Dado** una placa que no tiene estancia activa, **cuando** se intenta registrar la salida, **entonces** el sistema informa un error 404 de "Registro no encontrado".
  * **Dado** el cierre de estancia, **cuando** finaliza la transacción, **entonces** se genera el comprobante de salida correspondiente.

---

### HU-06: Registro de Novedades e Incidentes en Vehículos
* **ID:** `HU-06` | **Requerimiento Asociado:** `RF-10` | **Prioridad:** Media  
* **Como:** Operador de garita o supervisor  
* **Quiero:** Registrar cualquier daño, golpe o eventualidad ocurrida a un vehículo estacionado  
* **Para:** Dejar constancia legal y pericial respaldada con descripción y fotos  
* **Criterios de Aceptación:**
  * **Dado** un registro activo, **cuando** el operador detecta un daño (rayón, golpe), **entonces** diligencia el formulario con el tipo de novedad, descripción y enlace a foto de evidencia.
  * **Dado** el envío del formulario, **cuando** se procesa la solicitud, **entonces** la novedad queda permanentemente ligada al registro y se audita al usuario que la reportó.

---

### HU-07: Monitoreo de Celdas y Ocupación en Dashboard
* **ID:** `HU-07` | **Requerimiento Asociado:** `RF-12` | **Prioridad:** Media  
* **Como:** Administrador o Jefe de Patio  
* **Quiero:** Visualizar en un panel central los porcentajes de ocupación y celdas libres por piso y tipo  
* **Para:** Tomar decisiones sobre el flujo de vehículos y optimizar la capacidad instalada  
* **Criterios de Aceptación:**
  * **Dado** el ingreso al sistema, **cuando** se carga el Dashboard, **entonces** se presentan tarjetas con el total de celdas, celdas ocupadas, celdas disponibles y barras de progreso por tipo (`CARRO`, `MOTO`, `CAMIONETA`).
  * **Dado** el ingreso o salida de un vehículo en garita, **cuando** se consulta el Dashboard, **entonces** las cifras reflejan el cambio en tiempo real.

---

### HU-08: Exportación de Reportes Operacionales en Formato CSV
* **ID:** `HU-08` | **Requerimiento Asociado:** `RF-13` | **Prioridad:** Media  
* **Como:** Administrador del parqueadero  
* **Quiero:** Descargar un reporte consolidado de ocupación y estancias en archivo CSV  
* **Para:** Analizar las horas pico, calcular ingresos potenciales y realizar conciliaciones contables en Excel  
* **Criterios de Aceptación:**
  * **Dado** un usuario con rol `ADMINISTRADOR`, **cuando** solicita la exportación a través de `/api/v1/reportes/ocupacion`, **entonces** el sistema genera un archivo `reporte_ocupacion.csv` con cabeceras formateadas y registros ordenados cronológicamente.
  * **Dado** un usuario con rol `OPERADOR`, **cuando** intenta descargar el reporte, **entonces** el sistema restringe el acceso con un error 403 Forbidden.
