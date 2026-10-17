CREATE TABLE usuario (
    id              BIGINT       NOT NULL AUTO_INCREMENT,
    nombre          VARCHAR(80)  NOT NULL,
    apellido        VARCHAR(80)  NOT NULL,
    documento       VARCHAR(20)  NOT NULL,
    correo          VARCHAR(120) NOT NULL,
    telefono        VARCHAR(20)  NULL,
    clave_hash      VARCHAR(255) NOT NULL,
    tipo            ENUM('ADMINISTRADOR','OPERADOR') NOT NULL DEFAULT 'OPERADOR',
    activo          BOOLEAN      NOT NULL DEFAULT TRUE,
    fecha_registro  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_usuario PRIMARY KEY (id),
    CONSTRAINT uk_usuario_documento UNIQUE (documento),
    CONSTRAINT uk_usuario_correo    UNIQUE (correo)
) ENGINE=InnoDB;

CREATE TABLE vehiculo (
    id                       BIGINT       NOT NULL AUTO_INCREMENT,
    placa                    VARCHAR(10)  NOT NULL,
    marca                    VARCHAR(50)  NOT NULL,
    modelo                   VARCHAR(50)  NOT NULL,
    color                    VARCHAR(30)  NOT NULL,
    tipo                     ENUM('CARRO','MOTO','CAMIONETA') NOT NULL DEFAULT 'CARRO',
    propietario_documento    VARCHAR(20)  NULL,
    propietario_nombre       VARCHAR(120) NULL,
    propietario_telefono     VARCHAR(20)  NULL,
    fecha_registro           DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_vehiculo PRIMARY KEY (id),
    CONSTRAINT uk_vehiculo_placa UNIQUE (placa)
) ENGINE=InnoDB;

CREATE TABLE celda (
    id            BIGINT      NOT NULL AUTO_INCREMENT,
    numero        VARCHAR(10) NOT NULL,
    piso          INT         NOT NULL,
    tipo_vehiculo ENUM('CARRO','MOTO','CAMIONETA') NOT NULL DEFAULT 'CARRO',
    estado        ENUM('DISPONIBLE','OCUPADA','MANTENIMIENTO') NOT NULL DEFAULT 'DISPONIBLE',
    observaciones VARCHAR(255) NULL,
    CONSTRAINT pk_celda PRIMARY KEY (id),
    CONSTRAINT uk_celda_numero UNIQUE (numero)
) ENGINE=InnoDB;

CREATE TABLE registro (
    id                 BIGINT   NOT NULL AUTO_INCREMENT,
    vehiculo_id        BIGINT   NOT NULL,
    celda_id           BIGINT   NOT NULL,
    usuario_entrada_id BIGINT   NOT NULL,
    usuario_salida_id  BIGINT   NULL,
    fecha_hora_entrada DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_hora_salida  DATETIME NULL,
    estado             ENUM('ACTIVO','CERRADO','CANCELADO') NOT NULL DEFAULT 'ACTIVO',
    observaciones      TEXT     NULL,
    CONSTRAINT pk_registro PRIMARY KEY (id),
    CONSTRAINT fk_registro_vehiculo        FOREIGN KEY (vehiculo_id)        REFERENCES vehiculo (id),
    CONSTRAINT fk_registro_celda           FOREIGN KEY (celda_id)           REFERENCES celda (id),
    CONSTRAINT fk_registro_usuario_entrada FOREIGN KEY (usuario_entrada_id) REFERENCES usuario (id),
    CONSTRAINT fk_registro_usuario_salida  FOREIGN KEY (usuario_salida_id)  REFERENCES usuario (id),
    CONSTRAINT chk_registro_salida CHECK (estado = 'ACTIVO' OR fecha_hora_salida IS NOT NULL)
) ENGINE=InnoDB;

CREATE INDEX idx_registro_vehiculo ON registro (vehiculo_id);
CREATE INDEX idx_registro_celda    ON registro (celda_id);
CREATE INDEX idx_registro_estado   ON registro (estado);

CREATE TABLE novedad (
    id               BIGINT       NOT NULL AUTO_INCREMENT,
    registro_id      BIGINT       NOT NULL,
    tipo             ENUM('RAYON','DANO_MECANICO','OBJETO_CAIDO','ROBO_PARCIAL','OTRO') NOT NULL,
    descripcion      TEXT         NOT NULL,
    fecha_hora       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reportado_por_id BIGINT       NOT NULL,
    evidencia_url    VARCHAR(255) NULL,
    CONSTRAINT pk_novedad PRIMARY KEY (id),
    CONSTRAINT fk_novedad_registro FOREIGN KEY (registro_id)      REFERENCES registro (id),
    CONSTRAINT fk_novedad_usuario  FOREIGN KEY (reportado_por_id) REFERENCES usuario (id)
) ENGINE=InnoDB;

CREATE INDEX idx_novedad_registro ON novedad (registro_id);

CREATE TABLE comprobante (
    id               BIGINT       NOT NULL AUTO_INCREMENT,
    registro_id      BIGINT       NOT NULL,
    codigo           VARCHAR(40)  NOT NULL,
    tipo             ENUM('ENTRADA','SALIDA') NOT NULL,
    fecha_generacion DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    qr_base64        TEXT         NULL,
    CONSTRAINT pk_comprobante PRIMARY KEY (id),
    CONSTRAINT uk_comprobante_codigo UNIQUE (codigo),
    CONSTRAINT fk_comprobante_registro FOREIGN KEY (registro_id) REFERENCES registro (id)
) ENGINE=InnoDB;

CREATE INDEX idx_comprobante_registro ON comprobante (registro_id);

CREATE TABLE auditoria_log (
    id              BIGINT       NOT NULL AUTO_INCREMENT,
    usuario_id      BIGINT       NULL,
    operacion       VARCHAR(50)  NOT NULL,
    entidad_afectada VARCHAR(50) NULL,
    registro_id     BIGINT       NULL,
    ip_origen       VARCHAR(45)  NULL,
    resultado       VARCHAR(20)  NOT NULL,
    fecha_hora      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    detalle         TEXT         NULL,
    CONSTRAINT pk_auditoria PRIMARY KEY (id),
    CONSTRAINT fk_auditoria_usuario FOREIGN KEY (usuario_id) REFERENCES usuario (id)
) ENGINE=InnoDB;

CREATE INDEX idx_auditoria_fecha ON auditoria_log (fecha_hora);

-- Datos semilla
INSERT INTO usuario (nombre, apellido, documento, correo, telefono, clave_hash, tipo) VALUES
('Carlos', 'Ramírez', '101840001', 'admin@autoscolombia.com', '3001112222',
 '$2a$10$N9qo8uLOickgx2ZMRZoMy.Mrq4VfXFKDvPJhjKkJ0nU8RkO5.J9jq', 'ADMINISTRADOR'),
('María', 'López', '52399001', 'operador@autoscolombia.com', '3003334444',
 '$2a$10$N9qo8uLOickgx2ZMRZoMy.Mrq4VfXFKDvPJhjKkJ0nU8RkO5.J9jq', 'OPERADOR');

INSERT INTO celda (numero, piso, tipo_vehiculo, estado) VALUES
('A-01', 1, 'CARRO', 'DISPONIBLE'), ('A-02', 1, 'CARRO', 'DISPONIBLE'),
('A-03', 1, 'CARRO', 'DISPONIBLE'), ('A-04', 1, 'CARRO', 'DISPONIBLE'),
('A-05', 1, 'CARRO', 'DISPONIBLE'), ('A-06', 1, 'CARRO', 'DISPONIBLE'),
('A-07', 1, 'CARRO', 'DISPONIBLE'), ('A-08', 1, 'CARRO', 'DISPONIBLE'),
('B-01', 2, 'MOTO', 'DISPONIBLE'), ('B-02', 2, 'MOTO', 'DISPONIBLE'),
('B-03', 2, 'MOTO', 'DISPONIBLE'), ('B-04', 2, 'MOTO', 'DISPONIBLE'),
('C-01', 3, 'CAMIONETA', 'DISPONIBLE'), ('C-02', 3, 'CAMIONETA', 'DISPONIBLE'),
('C-03', 3, 'CAMIONETA', 'DISPONIBLE'), ('C-04', 3, 'CAMIONETA', 'DISPONIBLE');
