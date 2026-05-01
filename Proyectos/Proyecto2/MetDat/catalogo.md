# Catálogo de Datos

**Identificador:** ET-CAT-001 | **Versión:** 1.0 | **Fecha:** 2026-05-01
**Marco de referencia:** UNE 0087
**Proceso asociado:** ET-PN-001 - Previsión de la Demanda Energética

El catálogo vincula los conceptos del glosario con los activos físicos de datos. Los identificadores de dataset (DS-xxx) mantienen continuidad con el Proyecto 1.

---

## Inventario de activos

| ID | Dataset (P1) | Concepto vinculado | Sistema fuente | Tabla / Endpoint | Formato | Clasificación | Diccionario |
|:---|:---|:---|:---|:---|:---|:---|:---|
| CT-101 | DS-CLIENTES-CRM | G10-003, G10-004, G10-005, G10-013, G10-015, G10-017, G10-018 | CRM Salesforce | `dbo.clientes` | SQL | Confidencial | DT-101 |
| CT-201 | DS-CONSUMO-HIST | G10-002, G10-006, G10-007 | SCADA / SAP-ISU | `fact_consumo_horario` | PostgreSQL | Confidencial | DT-201 |
| CT-301 | DS-METEO-AEMET | G10-008 | API AEMET | `aemet_observaciones` | JSON | Público | DT-301 |
| CT-401 | DS-CALENDARIO | G10-001 | BOE / API | `dim_festivos_nacionales` | CSV | Público | DT-401 |
| CT-501 | DS-TARIFAS-OMIE | G10-019 | OMIE / REE API | Endpoint REST OMIE | JSON | Público | DT-501 |
| CT-601 | - | G10-011, G10-012 | MLflow | `model_versions` | YAML | Restringido | DT-601 |
| CT-701 | - | G10-010, G10-014 | Motor IA (salida) | `fact_prevision_demanda` | CSV | Confidencial | DT-701 |

---

## Detalle por activo

**CT-101 - `dbo.clientes`** (CRM Salesforce, Confidencial)
Maestro de clientes. Responsable: Dirección Comercial / DPO. Extracción semanal vía API REST. La seudonimización SHA-256 del `id_cliente` es obligatoria antes de que el registro salga del perímetro CRM hacia cualquier entorno analítico. Retención: vigencia del contrato + 5 años (RGPD). Acceso: RBAC con log obligatorio.

**CT-201 - `fact_consumo_horario`** (SCADA / SAP-ISU, Confidencial)
Transaccional de consumo. Responsable: Dirección Técnica. Ingesta en streaming vía Kafka con granularidad horaria. Se requieren mínimo 24 meses de histórico. Almacenamiento en PostgreSQL. Retención: 7 años (capa Bronze).

**CT-301 - `aemet_observaciones`** (API AEMET, Público)
Variables meteorológicas. Responsable: Dirección de Datos. Pull diario; retraso máximo admitido de 24 h antes de que el control TV-05 bloquee el modelo. Retención: 5 años (capa Silver). Autenticación por API key corporativa.

**CT-401 - `dim_festivos_nacionales`** (BOE / API, Público)
Calendario de festivos por zona. Responsable: Dirección de Operaciones. Actualización anual. Dato estático sin restricción de acceso.

**CT-501 - Endpoint REST OMIE** (OMIE / REE, Público)
Tarifas energéticas horarias. Responsable: Dirección de Datos. Actualización diaria. Retención: 5 años. Autenticación por API key corporativa.

**CT-601 - `model_versions`** (MLflow, Restringido)
Versiones y hiperparámetros del modelo predictivo. Responsable: Dirección de Analítica. Se actualiza con cada nuevo entrenamiento. Retención indefinida (versionado de modelos). Acceso restringido a Analista de Demanda y equipo IA.

**CT-701 - `fact_prevision_demanda`** (Motor IA - salida, Confidencial)
Resultado del proceso ET-PN-001. Responsable: Dirección de Operaciones. Generación mensual. Retención: 3 años (capa Gold). Acceso: Dirección de Operaciones y perfiles autorizados.