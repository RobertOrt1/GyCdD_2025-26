# MDM - Datos de Referencia

**Identificador:** ET-REF-001 | **Version:** 1.0 | **Fecha:** 2026-05-01
**Marco de referencia:** UNE 0078 - MDM

> Los datos de referencia son dominios controlados que garantizan la integridad semantica del modelo. Cada valor tiene un codigo tecnico (usado en base de datos) y una etiqueta de negocio (usada en interfaces y reportes). Son coherentes con los dominios definidos en el diccionario P2.

---

## REF-01 - Tipo de Cliente

**Campo:** `tipo_cliente` | **Tabla:** `maestro_cliente`, `dim_cliente` | **Ref. P2:** DT-101-03

| Codigo | Etiqueta | Descripcion | Glosario P2 |
| :--- | :--- | :--- | :--- |
| `RES` | Residencial | Persona fisica con suministro para uso domestico. Potencia tipica <= 15 kW | G10-005 |
| `IND` | Industrial | Persona juridica con actividad productiva. Potencia > 50 kW; tarifa 6.x TD | G10-004 |
| `CRIT` | Critico | Cliente cuya interrupcion tendria impacto grave. Tiene SLA reforzado | G10-003 |

> **Pendiente de validacion:** El borrador inicial incluia `PYME` como cuarto valor. No figura en DT-101-03 ni en OpenMetadata. Requiere decision de Direccion Comercial antes de incorporarlo.

---

## REF-02 - Estado del Cliente

**Campo:** `estado` | **Tabla:** `maestro_cliente`

| Codigo | Etiqueta | Descripcion |
| :--- | :--- | :--- |
| `ACTIVO` | Activo | Cliente con contrato vigente y suministro activo |
| `SUSPENDIDO` | Suspendido | Suministro interrumpido temporalmente (impago, solicitud) |
| `BAJA` | Baja | Contrato rescindido; registro retenido por obligacion legal |

---

## REF-03 - Calidad de Lectura

**Campo:** `calidad_lectura` | **Tabla:** `fact_consumo_horario` | **Ref. P2:** DT-201-05, G10-002

| Codigo | Etiqueta | Descripcion | Objetivo |
| :--- | :--- | :--- | :--- |
| `REAL` | Real | Lectura directa del contador inteligente o SCADA | >= 95% de registros |
| `ESTIMADA` | Estimada | Calculada por ausencia de lectura (interpolacion lineal) | < 5% |
| `CORREGIDA` | Corregida | Ajustada manualmente tras validacion del Data Steward | Excepcional |

---

## REF-04 - Estado del Punto de Suministro

**Campo:** `estado` | **Tabla:** `dim_punto_suministro`

| Codigo | Etiqueta | Descripcion |
| :--- | :--- | :--- |
| `ACTIVO` | Activo | Punto de suministro con contrato vigente |
| `BAJA` | Baja | Punto dado de baja; CUPS liberado |
| `SUSPENSION` | En suspension | Corte temporal del suministro |

---

## REF-05 - Ambito de Festivo

**Campo:** `ambito` | **Tabla:** `dim_festivos_nacionales` | **Ref. P2:** DT-401-02

| Codigo | Etiqueta | Descripcion |
| :--- | :--- | :--- |
| `NACIONAL` | Nacional | Festivo valido en todo el territorio espanol |
| `AUTONOMICO` | Autonomico | Festivo valido en una comunidad autonoma concreta |
| `LOCAL` | Local | Festivo valido en un municipio o zona especifica |

---

## REF-06 - Mercado de Tarifa

**Campo:** `mercado` | **Tabla:** `fact_tarifas_omie` | **Ref. P2:** DT-501-04

| Codigo | Etiqueta | Descripcion |
| :--- | :--- | :--- |
| `SPOT` | Mercado diario | Precio fijado en el mercado diario de OMIE |
| `INTRADAY` | Mercado intradiario | Precio fijado en sesiones de ajuste intradiario |

---

## REF-07 - Estado del Matching MDM

**Campo:** `estado_matching` | **Tabla:** `mapeo_ids_legados`

| Codigo | Etiqueta | Descripcion |
| :--- | :--- | :--- |
| `FUSION_AUTO` | Fusion automatica | Match por RM-01 o RM-02; fusion sin intervencion manual |
| `REVISION_MANUAL` | Revision manual | Match por RM-03 pendiente de validacion por Data Steward |
| `NUEVO_REGISTRO` | Nuevo registro | Sin match; se crea un nuevo golden record |
| `DUPLICADO_POTENCIAL` | Duplicado potencial | Score RM-03 < 85%; escalado al Data Steward |
