# Diccionario de Datos

**Identificador:** ET-DIC-001 | **Versión:** 1.0 | **Fecha:** 2026-05-01
**Marco de referencia:** UNE 0087
**Proceso asociado:** ET-PN-001 - Previsión de la Demanda Energética

Especifica la implementación física a nivel de campo: tipos, restricciones y lógica de transformación. Los campos DT-301 a DT-701 están pendientes de validación con los equipos técnicos responsables de cada sistema.

---

## DT-101 - `dbo.clientes` (Maestro de Clientes)

**Catálogo:** CT-101 | **Sistema:** CRM Salesforce | **Clasificación:** Confidencial

| ID Campo | Columna | Tipo | Restricción | Lógica / Transformación | Ref. Glosario |
|:---|:---|:---|:---|:---|:---|
| **DT-101-01** | `id_cliente` | VARCHAR(20) | PK, NOT NULL | Formato `CL-{SERVICIO}-{NNNN}`. Nunca sale del perímetro CRM sin seudonimizar. | G10-005, G10-004 |
| **DT-101-02** | `id_cliente_token` | VARCHAR(64) | NOT NULL | `SHA256(id_cliente \|\| salt)`. Es el identificador que circula en el pipeline analítico. | G10-017 |
| **DT-101-03** | `tipo_cliente` | VARCHAR(20) | NOT NULL, Dom: {RES, IND, CRIT} | Asignado en alta comercial. RES = residencial, IND = industrial, CRIT = crítico. | G10-003, G10-004, G10-005 |
| **DT-101-04** | `cups` | VARCHAR(22) | UNIQUE, NOT NULL | Estándar REE: `ES[0-9]{16}[A-Z]{2}`. Unidad mínima de medición. | G10-015 |
| **DT-101-05** | `potencia_contratada` | DECIMAL(6,2) | > 0 | En kW. Extraída de SAP-ISU. Condiciona la tarifa aplicable. | G10-013 |
| **DT-101-06** | `zona_geografica` | VARCHAR(10) | NOT NULL | Formato `ZN-[A-Z]{3}-[0-9]{3}`. Determina los datos meteorológicos aplicables. | G10-020 |
| **DT-101-07** | `sla_reforzado` | BOOLEAN | NOT NULL, Default: FALSE | TRUE si `tipo_cliente = CRIT`. Activa protocolos de suministro ininterrumpido. | G10-018 |

---

## DT-201 - `fact_consumo_horario` (Transaccional de Consumo)

**Catálogo:** CT-201 | **Sistema:** SCADA / SAP-ISU | **Formato:** PostgreSQL | **Clasificación:** Confidencial

| ID Campo | Columna | Tipo | Restricción | Lógica / Transformación | Ref. Glosario |
|:---|:---|:---|:---|:---|:---|
| **DT-201-01** | `id_registro` | BIGINT | PK, Autoincremental | Generado por SCADA. | - |
| **DT-201-02** | `id_cliente_token` | VARCHAR(64) | FK → DT-101-02, NOT NULL | Vinculación con el maestro de clientes seudonimizado. | G10-017 |
| **DT-201-03** | `ts_lectura` | TIMESTAMP | NOT NULL | Normalización obligatoria a UTC. Granularidad horaria. | G10-007 |
| **DT-201-04** | `consumo_kwh` | DECIMAL(10,4) | ≥ 0 | Alerta si valor > 3× media histórica del punto de suministro. | G10-007 |
| **DT-201-05** | `calidad_lectura` | VARCHAR(10) | Dom: {REAL, ESTIMADA, CORREGIDA} | REAL = lectura directa; ESTIMADA = interpolada; CORREGIDA = ajustada tras validación. ≥ 95% deben ser REAL. | G10-002 |
| **DT-201-06** | `cups` | VARCHAR(22) | FK → DT-101-04, NOT NULL | Punto de suministro asociado a la lectura. | G10-015 |

---

## DT-301 - `aemet_observaciones`

**Catálogo:** CT-301 | **Sistema:** API AEMET | **Clasificación:** Público

| ID Campo | Columna | Tipo | Restricción | Lógica / Transformación | Ref. Glosario |
|:---|:---|:---|:---|:---|:---|
| **DT-301-01** | `estacion_id` | VARCHAR(10) | NOT NULL | Código de estación AEMET. | G10-008 |
| **DT-301-02** | `ts_observacion` | TIMESTAMP | NOT NULL | UTC. Retraso máximo admitido: 24 h. | G10-008 |
| **DT-301-03** | `temperatura_c` | DECIMAL(5,2) | - | Temperatura en °C. Variable explicativa del modelo. | G10-008 |
| **DT-301-04** | `humedad_pct` | DECIMAL(5,2) | 0–100 | Humedad relativa en %. | G10-008 |
| **DT-301-05** | `radiacion_wm2` | DECIMAL(8,2) | ≥ 0 | Radiación solar en W/m². | G10-008 |
| **DT-301-06** | `precipitacion_mm` | DECIMAL(6,2) | ≥ 0 | Precipitación acumulada en mm. | G10-008 |
| **DT-301-07** | `zona_geografica` | VARCHAR(10) | NOT NULL | Cruce con `DT-101-06` para asignar meteo por zona. | G10-020 |

---

## DT-401 - `dim_festivos_nacionales`

**Catálogo:** CT-401 | **Sistema:** BOE / API pública | **Clasificación:** Público

| ID Campo | Columna | Tipo | Restricción | Lógica / Transformación | Ref. Glosario |
|:---|:---|:---|:---|:---|:---|
| **DT-401-01** | `fecha` | DATE | PK | Fecha del festivo en formato ISO 8601. | G10-001 |
| **DT-401-02** | `ambito` | VARCHAR(20) | Dom: {NACIONAL, AUTONOMICO, LOCAL} | Ámbito de aplicación del festivo. | G10-001 |
| **DT-401-03** | `zona_geografica` | VARCHAR(10) | - | Código de zona aplicable. NULL para festivos nacionales. | G10-020 |
| **DT-401-04** | `descripcion` | VARCHAR(100) | - | Nombre del festivo. | G10-001 |

---

## DT-501 - OMIE / REE API (Tarifas)

**Catálogo:** CT-501 | **Sistema:** OMIE / REE | **Clasificación:** Público

| ID Campo | Campo JSON | Tipo | Restricción | Lógica / Transformación | Ref. Glosario |
|:---|:---|:---|:---|:---|:---|
| **DT-501-01** | `fecha` | DATE | NOT NULL | Fecha de aplicación de la tarifa. | G10-019 |
| **DT-501-02** | `hora` | INTEGER | 0–23 | Hora del día (mercado horario). | G10-019 |
| **DT-501-03** | `precio_mwh` | DECIMAL(8,4) | ≥ 0 | Precio en €/MWh. Actualización diaria desde OMIE. | G10-019 |
| **DT-501-04** | `mercado` | VARCHAR(10) | Dom: {SPOT, INTRADAY} | Tipo de mercado de origen. | G10-019 |

---

## DT-601 - `model_versions` (MLflow)

**Catálogo:** CT-601 | **Sistema:** MLflow | **Clasificación:** Restringido

| ID Campo | Campo YAML | Tipo | Restricción | Lógica / Transformación | Ref. Glosario |
|:---|:---|:---|:---|:---|:---|
| **DT-601-01** | `model_name` | STRING | NOT NULL | Identificador del modelo. Ej: `ET-MOD-PRED-001`. | G10-012 |
| **DT-601-02** | `version` | STRING | NOT NULL | Versión semántica del modelo. | G10-012 |
| **DT-601-03** | `hyperparameters` | MAP | NOT NULL | Hiperparámetros de entrenamiento en formato clave-valor. | G10-012 |
| **DT-601-04** | `mape_validation` | DECIMAL(5,2) | ≤ 10 | MAPE sobre conjunto de validación. Si > 10%, versión marcada como inválida. | G10-011 |
| **DT-601-05** | `fecha_entrenamiento` | TIMESTAMP | NOT NULL | Fecha y hora de entrenamiento del modelo. | G10-012 |

---

## DT-701 - `fact_prevision_demanda`

**Catálogo:** CT-701 | **Sistema:** Motor IA (salida) | **Clasificación:** Confidencial

| ID Campo | Columna | Tipo | Restricción | Lógica / Transformación | Ref. Glosario |
|:---|:---|:---|:---|:---|:---|
| **DT-701-01** | `id_prevision` | BIGINT | PK, Autoincremental | Generado por el motor de previsión. | - |
| **DT-701-02** | `id_cliente_token` | VARCHAR(64) | FK → DT-101-02, NOT NULL | Identificador seudonimizado del cliente. | G10-017 |
| **DT-701-03** | `mes_prevision` | DATE | NOT NULL | Primer día del mes previsto (formato ISO 8601). | G10-014 |
| **DT-701-04** | `demanda_kwh` | DECIMAL(12,4) | ≥ 0 | Energía prevista para el mes en kWh. | G10-014 |
| **DT-701-05** | `mape_modelo` | DECIMAL(5,2) | ≤ 10 | MAPE del modelo en la ejecución. Si > 10%, registro marcado como no válido. | G10-011 |
| **DT-701-06** | `version_modelo` | STRING | NOT NULL | Referencia a DT-601-02. Trazabilidad del modelo usado. | G10-012 |
| **DT-701-07** | `zona_geografica` | VARCHAR(10) | NOT NULL | Zona de distribución asociada a la previsión. | G10-020 |