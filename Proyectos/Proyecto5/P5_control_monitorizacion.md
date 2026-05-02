# Proyecto 5 — Control y Monitorización de la Calidad del Dato

**Identificador:** ET-CTRL-001 | **Versión:** 1.0 | **Fecha:** 2026-05-01
**Marco de referencia:** UNE 0079 — PlanDQ / CtrlDQ
**Proceso asociado:** ET-PN-001 — Previsión de la Demanda Energética

---

## 1. Contexto

El Proyecto 4 midió el estado actual de la calidad del dato en EnergiTech y reveló dos no conformidades:

- **M-COM-02 al 70%** — 3 de 10 clientes del golden record tienen atributos de matching NULL. Por debajo del umbral mínimo del 90%.
- **M-ACC-01 al 92.31%** — 2 lecturas anómalas en `fact_consumo_horario` (pico de 9999 kWh y consumo negativo). Por debajo del umbral del 98%.

Este proyecto traduce esas medidas en procedimientos formales de monitorización continua, siguiendo las tareas CtrlDQ.T1 a CtrlDQ.T4 de UNE 0079, y propone el entorno de control necesario para garantizar que el proceso ET-PN-001 opera con datos de calidad suficiente de forma sostenida.

---

## 2. Requisitos de calidad priorizados (CtrlDQ.T1)

Los requisitos proceden del catálogo del Proyecto 1 y de los resultados del Proyecto 4. Se ordenan por criticidad para el proceso ET-PN-001:

| Prioridad | Requisito | Medida P4 | Resultado | Estado |
|:---|:---|:---|:---|:---|
| 1 — Crítica | Completitud de registros en maestro_cliente | M-COM-02 | 70% | No conforme |
| 2 — Crítica | Exactitud del rango de consumo | M-ACC-01 | 92.31% | No conforme |
| 3 — Alta | Completitud de atributos en fact_consumo_horario | M-COM-01 | 100% | Conforme |
| 4 — Alta | Integridad referencial consumo → cliente | M-CON-01 | 100% | Conforme |
| 5 — Alta | Consistencia de formato del CUPS | M-CON-02 | 100% | Conforme |
| 6 — Alta | Exactitud del modelo predictivo (MAPE) | M-ACC-02 | 100% | Conforme |

---

## 3. Procedimientos de medición (CtrlDQ.T2)

Para cada medida se define un procedimiento completo que especifica quién mide, cuándo, cómo, con qué herramienta y qué se hace ante una no conformidad.

---

### PROC-COM-02 — Completitud de registros en maestro_cliente

| Campo | Detalle |
|:---|:---|
| Medida asociada | M-COM-02 |
| Característica | Completitud (Com-I-1) |
| Dataset | `maestro_cliente` — BD Grupo10, servidor Spartan |
| Responsable | Data Steward |
| Frecuencia | Mensual — primer día hábil del mes, antes de ejecutar ET-PN-001 |
| Herramienta | OpenMetadata (test de calidad) + DBeaver para validación manual |
| Umbral | ≥ 90% |

**Pasos del procedimiento:**

1. Conectar a la BD Grupo10 (Spartan 172.20.48.70:3306) con VPN activa.
2. Ejecutar la query M-COM-02 y registrar el resultado.
3. Evaluar el resultado contra el umbral:
   - ≥ 90% → conforme; registrar en el log de monitorización y continuar.
   - < 90% → no conforme; activar el plan de acción ACCION-COM-02.
4. Registrar resultado, fecha y responsable en la tabla de seguimiento.

**Plan de acción ante no conformidad (ACCION-COM-02):**
- Identificar los registros con `id_nacional` o `email_verificado` NULL mediante query de diagnóstico.
- Notificar al equipo del CRM Salesforce para completar los datos en el sistema origen.
- Bloquear la ejecución del proceso ET-PN-001 hasta que el umbral se recupere.
- Registrar la no conformidad con causa raíz, acciones tomadas y fecha de resolución.

```sql
-- Query de diagnóstico: identificar registros incompletos
SELECT id_cliente_maestro, nombre_normalizado,
       id_nacional, email_verificado, estado
FROM Grupo10.maestro_cliente
WHERE id_nacional IS NULL OR email_verificado IS NULL
   OR nombre_normalizado IS NULL OR tipo_cliente IS NULL;
```

---

### PROC-ACC-01 — Exactitud del rango de consumo

| Campo | Detalle |
|:---|:---|
| Medida asociada | M-ACC-01 |
| Característica | Exactitud (Acc-I-3) |
| Dataset | `fact_consumo_horario` — BD Grupo10, servidor Spartan |
| Responsable | Analista de Demanda |
| Frecuencia | Mensual — coincidiendo con la ingesta del mes antes de la validación ETL |
| Herramienta | OpenMetadata (test de calidad) + DBeaver para validación manual |
| Umbral | ≥ 98% |

**Pasos del procedimiento:**

1. Ejecutar la query M-ACC-01 sobre los registros del mes en curso.
2. Evaluar el resultado:
   - ≥ 98% → conforme; registrar y continuar al bloque de validación ETL (TV-02).
   - < 98% → no conforme; activar ACCION-ACC-01.
3. Registrar resultado, fecha, número de anomalías detectadas y responsable.

**Plan de acción ante no conformidad (ACCION-ACC-01):**
- Ejecutar la query de diagnóstico para listar los registros anómalos.
- Clasificar cada anomalía: error de sensor SCADA (escalar a equipo técnico) o error de transmisión (aplicar corrección con `calidad_lectura = 'CORREGIDA'`).
- Si el número de anomalías supera el 5% del lote, rechazar el lote completo (TV-01).
- Registrar la no conformidad con causa raíz y acciones tomadas.

```sql
-- Query de diagnóstico: lecturas anomalas del mes en curso
SELECT fch.id_registro, fch.cups, fch.ts_lectura,
       fch.consumo_kwh, media_hist.media,
       fch.consumo_kwh / media_hist.media AS ratio_vs_media
FROM Grupo10.fact_consumo_horario fch
JOIN (
    SELECT cups, AVG(consumo_kwh) AS media
    FROM Grupo10.fact_consumo_horario
    WHERE calidad_lectura = 'REAL'
    GROUP BY cups
) media_hist ON fch.cups = media_hist.cups
WHERE fch.consumo_kwh < 0
   OR fch.consumo_kwh > 3 * media_hist.media
ORDER BY fch.ts_lectura;
```

---

### PROC-COM-01 — Completitud de atributos en fact_consumo_horario

| Campo | Detalle |
|:---|:---|
| Medida asociada | M-COM-01 |
| Característica | Completitud (Com-I-2) |
| Dataset | `fact_consumo_horario` |
| Responsable | Analista de Demanda |
| Frecuencia | Mensual — durante la fase de ingesta (Actividad 1 del BPMN) |
| Herramienta | OpenMetadata + pipeline ETL (control TV-01) |
| Umbral | ≥ 95% |

**Pasos del procedimiento:** ejecutar M-COM-01 al finalizar la ingesta. Si el resultado es ≥ 95%, continuar. Si es < 95%, rechazar el lote y notificar al responsable de calidad — aplica TV-01 del pipeline ETL del Proyecto 2.

---

### PROC-CON-01 — Integridad referencial consumo → cliente

| Campo | Detalle |
|:---|:---|
| Medida asociada | M-CON-01 |
| Característica | Consistencia (Con-I-1) |
| Dataset | `fact_consumo_horario` → `maestro_cliente` |
| Responsable | DBA |
| Frecuencia | Mensual — tras la ejecución del MDM y antes de la validación ETL |
| Herramienta | Constraint FK en MySQL + OpenMetadata |
| Umbral | 100% (tolerancia cero) |

**Pasos del procedimiento:** el constraint FK de la BD actúa como primera línea de defensa. Ejecutar M-CON-01 como verificación adicional. Cualquier registro huérfano indica un fallo en el proceso MDM y bloquea el pipeline.

---

### PROC-CON-02 — Consistencia de formato del CUPS

| Campo | Detalle |
|:---|:---|
| Medida asociada | M-CON-02 |
| Característica | Consistencia (Con-I-2) |
| Dataset | `dim_punto_suministro` |
| Responsable | DBA |
| Frecuencia | Con cada alta o modificación de punto de suministro |
| Herramienta | Constraint CHECK en MySQL (`REGEXP '^ES[0-9]{16}[A-Z]{2}$'`) |
| Umbral | 100% (tolerancia cero) |

**Pasos del procedimiento:** el constraint CHECK de la BD bloquea la inserción de CUPS con formato incorrecto. Ejecutar M-CON-02 mensualmente como auditoría. Cualquier desviación indica que hay registros previos al constraint que deben corregirse en el sistema origen.

---

### PROC-ACC-02 — Exactitud del modelo predictivo (MAPE)

| Campo | Detalle |
|:---|:---|
| Medida asociada | M-ACC-02 |
| Característica | Exactitud (Acc-I-2) |
| Dataset | `fact_prevision_demanda` |
| Responsable | Analista de Demanda |
| Frecuencia | Mensual — tras la ejecución del modelo IA (Actividad 3 del BPMN) |
| Herramienta | MLflow (registro de métricas) + OpenMetadata |
| Umbral | 100% (tolerancia cero sobre registros publicados) |

**Pasos del procedimiento:** el modelo registra el MAPE en MLflow al finalizar cada ejecución. Si el MAPE supera el 10%, el resultado no se inserta en `fact_prevision_demanda` y se escala a revisión del equipo de Analítica. M-ACC-02 verifica que todos los registros publicados cumplen el umbral.

---

## 4. Cuadro de mandos de calidad (CtrlDQ.T3)

El cuadro de mandos consolida los resultados de las seis medidas en una vista única para la Dirección de Operaciones y el Data Steward. Se actualiza mensualmente tras cada ejecución de los procedimientos.

### Estado del último ciclo de medición (mayo 2026)

| Medida | Característica | Resultado | Umbral | Estado | Tendencia |
|:---|:---|:---|:---|:---|:---|
| M-COM-01 | Completitud atributos | 100% | ≥ 95% | ✅ Conforme | — |
| M-COM-02 | Completitud registros | 70% | ≥ 90% | ❌ No conforme | ↓ Acción requerida |
| M-CON-01 | Integridad referencial | 100% | 100% | ✅ Conforme | — |
| M-CON-02 | Formato CUPS | 100% | 100% | ✅ Conforme | — |
| M-ACC-01 | Rango consumo | 92.31% | ≥ 98% | ❌ No conforme | ↓ Acción requerida |
| M-ACC-02 | MAPE modelo | 100% | 100% | ✅ Conforme | — |

**Nivel global de calidad del ciclo:** 4 de 6 medidas conformes → **nivel 3 (Buena)** según escala UNE 0081. Por debajo del nivel mínimo exigido (nivel 4). El proceso ET-PN-001 no puede ejecutarse hasta resolver M-COM-02 y M-ACC-01.

### Herramienta de soporte

OpenMetadata permite configurar tests de calidad sobre las tablas del catálogo (CT-101, CT-201) y programar su ejecución periódica. Los resultados se visualizan en el panel de calidad de cada dataset, que actúa como cuadro de mandos nativo. La URL de la instancia del grupo es: http://172.20.48.127:8585

---

## 5. No conformidades y lecciones aprendidas (CtrlDQ.T4)

| ID | No conformidad | Causa raíz identificada | Acción correctora | Estado |
|:---|:---|:---|:---|:---|
| NC-001 | M-COM-02 al 70% | El proceso de alta de clientes en CRM no valida la presencia de DNI y email antes de sincronizar con el MDM | Añadir validación obligatoria de `id_nacional` y `email_verificado` en el formulario de alta del CRM | Pendiente |
| NC-002 | M-ACC-01 al 92.31% | El sistema SCADA no filtra lecturas fuera de rango antes de publicarlas en la tabla de consumo horario | Implementar el control TV-02 en la fase de ingesta para marcar automáticamente lecturas anómalas antes de persistir | Pendiente |

**Lección aprendida:** los problemas de calidad detectados en el P4 tienen su causa raíz en los sistemas de origen (CRM y SCADA), no en el pipeline analítico. Las correcciones deben aplicarse en el perímetro de ingesta para que sean efectivas de forma sostenida.
