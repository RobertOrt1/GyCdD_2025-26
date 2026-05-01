# ProcDat — Descripción del Proceso de Negocio

**Identificador:** ET-PN-001 | **Versión:** 1.0
**Proceso:** Cálculo de la Previsión de la Demanda Energética
**Marco de referencia:** UNE 0078 — ProcDat.T1 / ProcDat.T2

---

## Objetivo

Generar mensualmente una previsión de la demanda energética para los próximos 3 meses, con atención especial a clientes críticos (hospitales, industrias clave), de modo que la Dirección de Operaciones pueda tomar decisiones de distribución fundamentadas y trazables.

---

## Actores implicados

| Actor | Rol |
|:---|:---|
| Analista de Datos | Ejecuta el proceso completo: ingesta, validación, cálculo e informe |
| Sistema SCADA / ERP | Fuente de datos de consumo |
| CRM corporativo | Fuente de datos de clientes |
| AEMET (API externa) | Fuente de datos meteorológicos |
| OMIE / BOE | Fuente de precios de mercado y calendario laboral |
| Modelo IA/ML | Ejecuta el cálculo predictivo |
| Dirección de Operaciones | Receptor del informe de previsión |

---

## Diagrama BPMN

![BPMN Previsión de Demanda Energética](figuras/bpmn_prevision_demanda_v1.0.svg)



---

## Descripción detallada del proceso

El proceso arranca el primer día hábil de cada mes mediante un evento temporizador.

### Actividad 1 - Ingesta de datos

El analista lanza en paralelo cuatro extracciones desde los sistemas fuente:

- **SCADA/ERP** (`DS-CONSUMO-HIST`): series temporales horarias/diarias de los últimos 24 meses mínimo, estructuradas por `ID_Cliente`, `Fecha` y `Punto_Suministro`, en formato CSV.
- **CRM corporativo** (`DS-CLIENTES-CRM`): extracción semanal en JSON con atributos de segmentación (tipo de cliente, zona geográfica, tarifa contratada). Los datos personales se seudonimizarán antes de entrar al pipeline (RGPD).
- **AEMET API** (`DS-METEO-AEMET`): temperatura, humedad y radiación solar para el horizonte de predicción, en JSON, con retraso máximo de 24 horas.
- **OMIE / BOE** (`DS-CALENDARIO`, `DS-TARIFAS-OMIE`): festivos por zona y precios de mercado actualizados diariamente.

Una vez completadas las cuatro ramas, se aplica la seudonimización de los datos de clientes antes de continuar.

### Actividad 2 - Validación y control de calidad

Antes de alimentar el modelo se ejecutan, en secuencia, tres controles:

- **Completitud y unicidad:** cobertura ≥ 95% en campos obligatorios y cero duplicados por clave `(ID_Cliente, Fecha, Punto_Suministro)`.
- **Consistencia entre sistemas:** cruce de IDs de cliente entre CRM, ERP y SCADA. Cualquier conflicto bloquea el proceso y genera una alerta al responsable de calidad.
- **Coherencia temporal:** gaps en series temporales ≤ 48h se resuelven con interpolación lineal; los mayores de 48h escalan a revisión manual.

Si algún criterio crítico falla, el proceso se interrumpe con un evento de error. En caso de superarse, se produce un dataset validado y un informe de calidad con las métricas y anomalías detectadas.

### Actividad 3 - Ejecución del modelo predictivo

Con los datos validados, el analista lanza el modelo de predicción (`ET-MOD-PRED-001`):

1. Carga de la versión activa y sus hiperparámetros documentados.
2. Ejecución del modelo sobre los datasets validados.
3. Generación de predicciones para los próximos 3 meses, segmentadas por cliente crítico y zona geográfica.
4. Evaluación del MAPE sobre el periodo de validación histórica. Si supera el 10%, el resultado se marca como no válido y se escala.
5. Registro del log de ejecución (`ET-LOG-EXEC`): fecha, versión del modelo, métricas y hash de los datasets de entrada.

### Actividad 4 - Generación del informe

El analista genera el informe formal (`ET-INF-PREV-YYYYMM`) con:

- Previsión agregada por zona y segmento de cliente.
- Detalle de clientes críticos con previsiones individuales.
- Comparativa con el periodo anterior.
- Alertas de riesgo (zonas con alta incertidumbre o demanda anómala).

El informe se almacena en el repositorio documental corporativo con control de acceso restringido a Dirección de Operaciones y perfiles autorizados.

### Actividad 5 - Comunicación y cierre

El analista entrega el informe a Dirección de Operaciones mediante canal corporativo cifrado. Se registra la entrega con sello de tiempo y confirmación de recepción. El proceso cierra con la actualización de la tabla de versiones de artefactos.


## Resumen de entradas y salidas

| Elemento | Tipo | Descripción |
|:---|:---|:---|
| `DS-CONSUMO-HIST` | Entrada | Histórico de consumo ≥ 24 meses |
| `DS-CLIENTES-CRM` | Entrada | Datos de clientes seudonimizados |
| `DS-METEO-AEMET` | Entrada | Previsión meteorológica |
| `DS-CALENDARIO` | Entrada | Festivos por zona |
| `DS-TARIFAS-OMIE` | Entrada | Precios de mercado |
| Dataset validado | Producto intermedio | Salida de la actividad de validación |
| Informe de calidad | Producto intermedio | Métricas y anomalías detectadas |
| Predicciones de demanda | Salida | Por cliente crítico y zona geográfica |
| `ET-LOG-EXEC` | Salida | Log de ejecución del modelo |
| `ET-INF-PREV-YYYYMM` | Salida principal | Informe entregado a Dirección de Operaciones |