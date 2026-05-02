# Medición - Métodos de Medición de la Calidad del Dato

**Identificador:** ET-DQ-MED-001 | **Versión:** 1.0 | **Fecha:** 2026-05-01
**Marco de referencia:** UNE 0081 - Propiedades medibles Com-I, Con-I, Acc-I
**Base de datos:** Grupo10 | **Servidor:** Spartan 172.20.48.70:3306

Ver modelo de calidad, umbrales y apetito de riesgo en [ModeloCalidad/modelo_calidad.md](../ModeloCalidad/modelo_calidad.md).

---

## 1. Completitud

**Definición:** grado en el que los registros contienen valores para todos los atributos obligatorios necesarios para que el proceso pueda ejecutarse correctamente.

**Propiedades medibles aplicadas:** Completitud de registros (Com-I-1) y Completitud de atributos (Com-I-2).

**Datasets afectados:** `fact_consumo_horario` (CT-201), `maestro_cliente` (CT-101).

### M-COM-01 - Completitud de atributos en fact_consumo_horario

| Campo | Detalle |
| :--- | :--- |
| Propiedad | Completitud de atributos (Com-I-2) |
| Entidad | `fact_consumo_horario` |
| Atributos obligatorios | `id_cliente_token`, `cups`, `ts_lectura`, `consumo_kwh`, `calidad_lectura` |
| Metodo de medición | Proporcion de filas sin ningún NULL en atributos obligatorios |
| Función de cálculo | `M = 1 - (filas_con_null / total_filas)` |
| Escala | Ratio [0, 1] expresado en % |
| Umbral EnergiTech | >= 0,95 (95%) - nivel 4 |
| Control vinculado | TV-01 del pipeline ETL (Proyecto 2) |

```sql
-- M-COM-01: Completitud de atributos en fact_consumo_horario
-- Devuelve un ratio [0,1]; umbral mínimo: 0.95
SELECT
    1 - (
        COUNT(CASE
                WHEN id_cliente_token IS NULL
                  OR cups             IS NULL
                  OR ts_lectura       IS NULL
                  OR consumo_kwh      IS NULL
                  OR calidad_lectura  IS NULL
                THEN 1
              END)
        / COUNT(*)
    ) AS M_COM_01_completitud_atributos
FROM Grupo10.fact_consumo_horario;
```

### M-COM-02 - Completitud de registros en maestro_cliente

| Campo | Detalle |
| :--- | :--- |
| Propiedad | Completitud de registros (Com-I-1) |
| Entidad | `maestro_cliente` |
| Atributos obligatorios | `id_nacional`, `nombre_normalizado`, `tipo_cliente`, `email_verificado` |
| Función de cálculo | `M = registros_completos / total_registros` |
| Umbral EnergiTech | >= 0,90 (90%) - nivel 4 |
| Justificación del umbral | El matching MDM requiere al menos `id_nacional` o `email_verificado` para operar con RM-01/RM-02; sin ellos el golden record no puede reconciliarse con los sistemas fuente |
| Control vinculado | TV-03 del pipeline ETL (Proyecto 2) |

```sql
-- M-COM-02: Completitud de registros en maestro_cliente
-- Devuelve un ratio [0,1]; umbral mínimo: 0.90
SELECT
    SUM(CASE
            WHEN id_nacional        IS NOT NULL
             AND nombre_normalizado IS NOT NULL
             AND tipo_cliente       IS NOT NULL
             AND email_verificado   IS NOT NULL
            THEN 1 ELSE 0
          END)
    / COUNT(*) AS M_COM_02_completitud_registros
FROM Grupo10.maestro_cliente;
```

---

## 2. Consistencia

**Definición:** grado en el que los datos no presentan contradicciones entre distintos sistemas o tablas, ni incumplen las reglas de formato o dominio definidas.

**Propiedades medibles aplicadas:** Integridad referencial (Con-I-1) y Consistencia del formato de datos (Con-I-2).

**Datasets afectados:** `maestro_cliente` (CT-101), `fact_consumo_horario` (CT-201), `dim_punto_suministro`.

### M-CON-01 - Integridad referencial entre consumo y cliente

| Campo | Detalle |
| :--- | :--- |
| Propiedad | Integridad referencial (Con-I-1) |
| Entidad | `fact_consumo_horario` |
| Regla | Todo `id_cliente_token` en `fact_consumo_horario` debe existir en `maestro_cliente` |
| Función de cálculo | `M = 1 - (registros_huerfanos / total_registros)` |
| Umbral EnergiTech | = 1,00 (100%) - tolerancia cero |
| Justificación | Un registro de consumo sin cliente asociado en el MDM no puede asignarse a ningún segmento ni zona, lo que invalida directamente la previsión de demanda |
| Control vinculado | TV-04 del pipeline ETL (Proyecto 2) |

```sql
-- M-CON-01: Integridad referencial fact_consumo_horario -> maestro_cliente
-- Resultado esperado: 1.0000 (tolerancia cero)
SELECT
    1 - (
        COUNT(fch.id_registro)
        / (SELECT COUNT(*) FROM Grupo10.fact_consumo_horario)
    ) AS M_CON_01_integridad_referencial
FROM Grupo10.fact_consumo_horario fch
LEFT JOIN Grupo10.maestro_cliente mc
       ON fch.id_cliente_token = mc.id_cliente_token
WHERE mc.id_cliente_token IS NULL;
```

### M-CON-02 - Consistencia de formato del CUPS

| Campo | Detalle |
| :--- | :--- |
| Propiedad | Consistencia del formato de datos (Con-I-2) |
| Entidad | `dim_punto_suministro` |
| Regla | El campo `cups` debe cumplir el formato `ES[0-9]{16}[A-Z]{2}` (estandar REE) |
| Función de cálculo | `M = registros_con_formato_correcto / total_registros` |
| Umbral EnergiTech | = 1,00 (100%) - tolerancia cero |
| Justificación | El CUPS es la clave de cruce entre cliente y consumo; un formato incorrecto impide la vinculación y rompe el pipeline ETL |
| Control vinculado | TV-01 del pipeline ETL (Proyecto 2) |

```sql
-- M-CON-02: Consistencia del formato CUPS (estandar REE ES + 16 digitos + 2 letras)
-- Resultado esperado: 1.0000 (tolerancia cero)
SELECT
    SUM(CASE WHEN cups REGEXP '^ES[0-9]{16}[A-Z]{2}$' THEN 1 ELSE 0 END)
    / COUNT(*) AS M_CON_02_consistencia_formato_cups
FROM Grupo10.dim_punto_suministro;
```

---

## 3. Exactitud

**Definición:** grado en que los datos representan correctamente los valores del mundo real, tanto en terminos de rango admisible como de coherencia semántica con la realidad del negocio.

**Propiedades medibles aplicadas:** Exactitud semántica (Acc-I-2) y Rango de exactitud (Acc-I-3).

**Datasets afectados:** `fact_consumo_horario` (CT-201), `fact_previsión_demanda` (CT-701).

### M-ACC-01 - Exactitud del rango de consumo

| Campo | Detalle |
| :--- | :--- |
| Propiedad | Rango de exactitud (Acc-I-3) |
| Entidad | `fact_consumo_horario` |
| Regla | `consumo_kwh` debe ser >= 0 y no superar 3x la media histórica del punto de suministro |
| Función de cálculo | `M = 1 - (lecturas_anómalas / total_lecturas)` |
| Umbral EnergiTech | >= 0,98 (98%) - nivel 4; coherente con RC-02 del Proyecto 1 |
| Control vinculado | TV-02 del pipeline ETL (lecturas anómalas marcadas como `ESTIMADA`) |

```sql
-- M-ACC-01: Exactitud del rango de consumo por punto de suministro
-- Umbral mínimo: 0.98; lecturas < 0 o > 3x la media histórica se consideran anómalas
SELECT
    1 - (
        SUM(CASE
                WHEN fch.consumo_kwh < 0
                  OR fch.consumo_kwh > 3 * media_hist.media
                THEN 1 ELSE 0
              END)
        / COUNT(*)
    ) AS M_ACC_01_exactitud_rango_consumo
FROM Grupo10.fact_consumo_horario fch
JOIN (
    -- Media histórica calculada solo sobre lecturas reales validadas
    SELECT cups, AVG(consumo_kwh) AS media
    FROM Grupo10.fact_consumo_horario
    WHERE calidad_lectura = 'REAL'
    GROUP BY cups
) media_hist ON fch.cups = media_hist.cups;
```

### M-ACC-02 - Exactitud del modelo predictivo (MAPE)

| Campo | Detalle |
| :--- | :--- |
| Propiedad | Exactitud semántica (Acc-I-2) |
| Entidad | `fact_previsión_demanda` |
| Regla | El campo `mape_modelo` debe ser <= 10% para que el resultado sea valido |
| Función de cálculo | `M = registros_con_mape_valido / total_registros` |
| Umbral EnergiTech | = 1,00 (100%) de los registros publicados deben tener MAPE <= 10% |
| Justificación | RN-03 del Proyecto 1 establece MAPE <= 10% como requisito crítico de negocio; un resultado fuera de umbral no se publica y se escala a revisión |
| Control vinculado | TV-05 del pipeline ETL (Proyecto 2) |

```sql
-- M-ACC-02: Proporcion de previsiónes publicadas con MAPE <= 10%
-- Resultado esperado: 1.0000 (tolerancia cero sobre registros publicados)
SELECT
    SUM(CASE WHEN mape_modelo <= 10 THEN 1 ELSE 0 END)
    / COUNT(*) AS M_ACC_02_exactitud_modelo_mape
FROM Grupo10.fact_previsión_demanda;
```