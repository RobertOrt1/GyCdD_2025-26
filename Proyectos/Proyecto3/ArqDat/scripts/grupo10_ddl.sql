-- =============================================================
-- DDL: EnergiTech - Base de datos Grupo10
-- Servidor:  Spartan 172.20.48.70:3306
-- Base de datos: Grupo10
-- Usuario: Hugo.Lamo
-- Motor: MySQL 8 / InnoDB / UTF8MB4
-- Proyecto: P3 - Gestion de Datos Maestros y Arquitectura de Datos
-- Marco: UNE 0078 - ArqDat
-- Fecha: 2026-05-01
-- =============================================================

USE Grupo10;

-- =============================================================
-- TABLAS DE REFERENCIA (sin dependencias FK)
-- =============================================================

CREATE TABLE IF NOT EXISTS ref_tipo_cliente (
    codigo      VARCHAR(20)  NOT NULL,
    etiqueta    VARCHAR(50)  NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    CONSTRAINT pk_ref_tipo_cliente PRIMARY KEY (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Dominio controlado de tipos de cliente. Dom: {RES, IND, CRIT}';

INSERT INTO ref_tipo_cliente (codigo, etiqueta, descripcion) VALUES
    ('RES',  'Residencial', 'Persona fisica con suministro domestico. Potencia tipica <= 15 kW'),
    ('IND',  'Industrial',  'Persona juridica con actividad productiva. Potencia > 50 kW; tarifa 6.x TD'),
    ('CRIT', 'Critico',     'Cliente cuya interrupcion tendria impacto grave. SLA reforzado obligatorio');


CREATE TABLE IF NOT EXISTS ref_estado_cliente (
    codigo      VARCHAR(20)  NOT NULL,
    etiqueta    VARCHAR(50)  NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    CONSTRAINT pk_ref_estado_cliente PRIMARY KEY (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Estados posibles del registro maestro de cliente';

INSERT INTO ref_estado_cliente (codigo, etiqueta, descripcion) VALUES
    ('ACTIVO',     'Activo',     'Cliente con contrato vigente y suministro activo'),
    ('SUSPENDIDO', 'Suspendido', 'Suministro interrumpido temporalmente'),
    ('BAJA',       'Baja',       'Contrato rescindido; registro retenido por obligacion legal');


CREATE TABLE IF NOT EXISTS ref_calidad_lectura (
    codigo      VARCHAR(20)  NOT NULL,
    etiqueta    VARCHAR(50)  NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    CONSTRAINT pk_ref_calidad_lectura PRIMARY KEY (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Clasificacion de la calidad de cada lectura de consumo. Ref: DT-201-05 / G10-002';

INSERT INTO ref_calidad_lectura (codigo, etiqueta, descripcion) VALUES
    ('REAL',      'Real',      'Lectura directa del contador inteligente o SCADA. Objetivo >= 95%'),
    ('ESTIMADA',  'Estimada',  'Calculada por ausencia de lectura mediante interpolacion lineal'),
    ('CORREGIDA', 'Corregida', 'Ajustada manualmente tras validacion del Data Steward');


CREATE TABLE IF NOT EXISTS ref_estado_cups (
    codigo      VARCHAR(20)  NOT NULL,
    etiqueta    VARCHAR(50)  NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    CONSTRAINT pk_ref_estado_cups PRIMARY KEY (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Estados posibles de un punto de suministro';

INSERT INTO ref_estado_cups (codigo, etiqueta, descripcion) VALUES
    ('ACTIVO',     'Activo',        'Punto con contrato vigente y suministro activo'),
    ('BAJA',       'Baja',          'Punto dado de baja; CUPS liberado'),
    ('SUSPENSION', 'En suspension', 'Corte temporal del suministro');


CREATE TABLE IF NOT EXISTS ref_estado_matching (
    codigo      VARCHAR(30)  NOT NULL,
    etiqueta    VARCHAR(60)  NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    CONSTRAINT pk_ref_estado_matching PRIMARY KEY (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Resultado del proceso de matching MDM para cada ID legado';

INSERT INTO ref_estado_matching (codigo, etiqueta, descripcion) VALUES
    ('FUSION_AUTO',        'Fusion automatica',   'Match por RM-01 o RM-02; fusion sin intervencion manual'),
    ('REVISION_MANUAL',    'Revision manual',     'Match por RM-03 pendiente de validacion del Data Steward'),
    ('NUEVO_REGISTRO',     'Nuevo registro',      'Sin match; se crea un nuevo golden record'),
    ('DUPLICADO_POTENCIAL','Duplicado potencial',  'Score RM-03 < 85%; escalado al Data Steward');


-- =============================================================
-- DIMENSION: ZONA GEOGRAFICA
-- Sin FK, debe crearse antes que dim_punto_suministro
-- =============================================================

CREATE TABLE IF NOT EXISTS dim_zona_geografica (
    codigo_zona        VARCHAR(10)  NOT NULL COMMENT 'Formato ZN-[A-Z]{3}-[0-9]{3}',
    nombre             VARCHAR(100) NOT NULL COMMENT 'Nombre descriptivo de la zona',
    estacion_aemet_ref VARCHAR(10)      NULL COMMENT 'Codigo de estacion AEMET de referencia para datos meteorologicos',
    CONSTRAINT pk_dim_zona_geografica PRIMARY KEY (codigo_zona)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Dimension de zonas geograficas de distribucion. Ref: G10-020 / DT-101-06';


-- =============================================================
-- MDM: GOLDEN RECORD DE CLIENTE
-- =============================================================

CREATE TABLE IF NOT EXISTS maestro_cliente (
    id_cliente_maestro CHAR(36)     NOT NULL COMMENT 'UUID generado por MDM; inmutable. PK del golden record',
    id_nacional        VARCHAR(20)      NULL COMMENT 'DNI o NIE. Clave de matching RM-01. UNIQUE cuando no es NULL',
    id_cliente_token   VARCHAR(64)  NOT NULL COMMENT 'SHA256(id_cliente_maestro + salt). Circula en el pipeline analitico',
    nombre_normalizado VARCHAR(100) NOT NULL COMMENT 'Nombre canonico tras proceso de limpieza MDM',
    tipo_cliente       VARCHAR(20)  NOT NULL COMMENT 'FK -> ref_tipo_cliente. Dom: {RES, IND, CRIT}',
    sla_reforzado      TINYINT(1)   NOT NULL DEFAULT 0 COMMENT 'TRUE (1) si tipo_cliente = CRIT',
    estado             VARCHAR(20)  NOT NULL DEFAULT 'ACTIVO' COMMENT 'FK -> ref_estado_cliente',
    email_verificado   VARCHAR(150)     NULL COMMENT 'Email normalizado. Clave de matching RM-02',
    fecha_alta_maestra DATE         NOT NULL COMMENT 'Fecha de creacion del golden record',
    CONSTRAINT pk_maestro_cliente     PRIMARY KEY (id_cliente_maestro),
    CONSTRAINT uq_mc_token            UNIQUE (id_cliente_token),
    CONSTRAINT uq_mc_id_nacional      UNIQUE (id_nacional),
    CONSTRAINT fk_mc_tipo_cliente     FOREIGN KEY (tipo_cliente) REFERENCES ref_tipo_cliente(codigo),
    CONSTRAINT fk_mc_estado           FOREIGN KEY (estado)       REFERENCES ref_estado_cliente(codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Golden record MDM de la entidad Cliente. Ref: G10-003/004/005 / DT-101';


-- =============================================================
-- MDM: MAPEO DE IDs LEGADOS
-- =============================================================

CREATE TABLE IF NOT EXISTS mapeo_ids_legados (
    id_mapeo           BIGINT       NOT NULL AUTO_INCREMENT,
    id_cliente_maestro CHAR(36)     NOT NULL COMMENT 'FK -> maestro_cliente',
    sistema_origen     VARCHAR(30)  NOT NULL COMMENT 'CRM, SAP-ISU o ERP',
    id_legado          VARCHAR(30)  NOT NULL COMMENT 'ID original en el sistema fuente',
    estado_matching    VARCHAR(30)  NOT NULL COMMENT 'FK -> ref_estado_matching',
    ts_creacion        TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de la fusion',
    CONSTRAINT pk_mapeo_ids_legados   PRIMARY KEY (id_mapeo),
    CONSTRAINT uq_mapeo_sistema_id    UNIQUE (sistema_origen, id_legado),
    CONSTRAINT fk_mil_cliente_maestro FOREIGN KEY (id_cliente_maestro) REFERENCES maestro_cliente(id_cliente_maestro),
    CONSTRAINT fk_mil_estado_matching FOREIGN KEY (estado_matching)    REFERENCES ref_estado_matching(codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Trazabilidad de IDs de sistemas fuente hacia el golden record MDM';


-- =============================================================
-- DIMENSION: PUNTO DE SUMINISTRO
-- =============================================================

CREATE TABLE IF NOT EXISTS dim_punto_suministro (
    cups                VARCHAR(22)    NOT NULL COMMENT 'Formato ES[0-9]{16}[A-Z]{2}. Estandar REE',
    id_cliente_token    VARCHAR(64)    NOT NULL COMMENT 'FK -> maestro_cliente (campo token). Cliente titular seudonimizado',
    codigo_zona         VARCHAR(10)    NOT NULL COMMENT 'FK -> dim_zona_geografica',
    potencia_contratada DECIMAL(6,2)   NOT NULL COMMENT 'Potencia maxima en kW. > 0',
    fecha_alta          DATE           NOT NULL COMMENT 'Alta del punto de suministro',
    estado              VARCHAR(20)    NOT NULL DEFAULT 'ACTIVO' COMMENT 'FK -> ref_estado_cups',
    CONSTRAINT pk_dim_punto_suministro  PRIMARY KEY (cups),
    CONSTRAINT chk_cups_formato         CHECK (cups REGEXP '^ES[0-9]{16}[A-Z]{2}$'),
    CONSTRAINT chk_potencia_positiva    CHECK (potencia_contratada > 0),
    CONSTRAINT fk_dps_cliente_token     FOREIGN KEY (id_cliente_token) REFERENCES maestro_cliente(id_cliente_token),
    CONSTRAINT fk_dps_zona              FOREIGN KEY (codigo_zona)       REFERENCES dim_zona_geografica(codigo_zona),
    CONSTRAINT fk_dps_estado            FOREIGN KEY (estado)            REFERENCES ref_estado_cups(codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Dimension de puntos de suministro (CUPS). Ref: G10-015 / DT-101-04 / DT-101-06';


-- =============================================================
-- DIMENSION: VERSION DEL MODELO IA
-- =============================================================

CREATE TABLE IF NOT EXISTS version_modelo (
    version             VARCHAR(50)  NOT NULL COMMENT 'Identificador de version. Ej: ET-MOD-PRED-001-v1.0',
    fecha_entrenamiento TIMESTAMP    NOT NULL COMMENT 'Fecha y hora de entrenamiento',
    mape_validation     DECIMAL(5,2)     NULL COMMENT 'MAPE sobre conjunto de validacion. Si > 10, version invalida',
    hyperparameters     JSON             NULL COMMENT 'Hiperparametros de entrenamiento en formato clave-valor',
    CONSTRAINT pk_version_modelo PRIMARY KEY (version),
    CONSTRAINT chk_mape_valido   CHECK (mape_validation IS NULL OR mape_validation >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Versiones del modelo predictivo IA/ML. Ref: G10-012 / CT-601 / DT-601';


-- =============================================================
-- FACT: CONSUMO HORARIO
-- =============================================================

CREATE TABLE IF NOT EXISTS fact_consumo_horario (
    id_registro      BIGINT        NOT NULL AUTO_INCREMENT COMMENT 'PK autoincremental generada por SCADA',
    id_cliente_token VARCHAR(64)   NOT NULL COMMENT 'FK -> maestro_cliente. Cliente seudonimizado',
    cups             VARCHAR(22)   NOT NULL COMMENT 'FK -> dim_punto_suministro',
    ts_lectura       TIMESTAMP     NOT NULL COMMENT 'Marca de tiempo UTC. Granularidad horaria',
    consumo_kwh      DECIMAL(10,4) NOT NULL COMMENT 'Energia consumida en kWh. >= 0',
    calidad_lectura  VARCHAR(10)   NOT NULL COMMENT 'FK -> ref_calidad_lectura. Dom: {REAL, ESTIMADA, CORREGIDA}',
    CONSTRAINT pk_fact_consumo_horario   PRIMARY KEY (id_registro),
    CONSTRAINT uq_fch_token_ts_cups      UNIQUE (id_cliente_token, ts_lectura, cups),
    CONSTRAINT chk_consumo_no_negativo   CHECK (consumo_kwh >= 0),
    CONSTRAINT fk_fch_cliente_token      FOREIGN KEY (id_cliente_token) REFERENCES maestro_cliente(id_cliente_token),
    CONSTRAINT fk_fch_cups               FOREIGN KEY (cups)             REFERENCES dim_punto_suministro(cups),
    CONSTRAINT fk_fch_calidad_lectura    FOREIGN KEY (calidad_lectura)  REFERENCES ref_calidad_lectura(codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Fact table de lecturas horarias de consumo electrico. Ref: G10-006/007 / CT-201 / DT-201';


-- =============================================================
-- FACT: PREVISION DE DEMANDA
-- =============================================================

CREATE TABLE IF NOT EXISTS fact_prevision_demanda (
    id_prevision     BIGINT        NOT NULL AUTO_INCREMENT COMMENT 'PK autoincremental',
    id_cliente_token VARCHAR(64)   NOT NULL COMMENT 'FK -> maestro_cliente. Cliente seudonimizado',
    codigo_zona      VARCHAR(10)   NOT NULL COMMENT 'FK -> dim_zona_geografica',
    version_modelo   VARCHAR(50)   NOT NULL COMMENT 'FK -> version_modelo',
    mes_prevision    DATE          NOT NULL COMMENT 'Primer dia del mes previsto (ISO 8601)',
    demanda_kwh      DECIMAL(12,4) NOT NULL COMMENT 'Energia prevista para el mes en kWh. >= 0',
    mape_modelo      DECIMAL(5,2)      NULL COMMENT 'MAPE del modelo en esta ejecucion. Si > 10, registro invalido',
    CONSTRAINT pk_fact_prevision_demanda PRIMARY KEY (id_prevision),
    CONSTRAINT uq_fpd_token_zona_mes     UNIQUE (id_cliente_token, codigo_zona, mes_prevision),
    CONSTRAINT chk_demanda_no_negativa   CHECK (demanda_kwh >= 0),
    CONSTRAINT fk_fpd_cliente_token      FOREIGN KEY (id_cliente_token) REFERENCES maestro_cliente(id_cliente_token),
    CONSTRAINT fk_fpd_zona               FOREIGN KEY (codigo_zona)      REFERENCES dim_zona_geografica(codigo_zona),
    CONSTRAINT fk_fpd_version_modelo     FOREIGN KEY (version_modelo)   REFERENCES version_modelo(version)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Fact table de previsiones de demanda energetica. Ref: G10-014 / CT-701 / DT-701';


-- =============================================================
-- INDICES ADICIONALES PARA RENDIMIENTO
-- =============================================================

-- Busqueda por zona en consumo (filtros frecuentes en el modelo predictivo)
CREATE INDEX idx_fch_cups        ON fact_consumo_horario (cups);
CREATE INDEX idx_fch_ts_lectura  ON fact_consumo_horario (ts_lectura);

-- Busqueda por mes en prevision
CREATE INDEX idx_fpd_mes         ON fact_prevision_demanda (mes_prevision);
CREATE INDEX idx_fpd_zona        ON fact_prevision_demanda (codigo_zona);

-- Busqueda por tipo de cliente en maestro
CREATE INDEX idx_mc_tipo_cliente ON maestro_cliente (tipo_cliente);
CREATE INDEX idx_mc_estado       ON maestro_cliente (estado);
